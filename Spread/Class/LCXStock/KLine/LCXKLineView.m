//
//  LCXKLineView.m
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLineView.h"
#import "LCXLineAboveView.h"
#import "LCXKLineBelowView.h"
#import "LCXStockChartGloablVariable.h"
#import "LCXStockMacro.h"
#import "LCXKLineModel.h"
#import "NSDate+Helper.h"
#import "LCXKLineAboveBox.h"
#import "LCXKLineBelowBox.h"
#import "LCXKLineMaskView.h"

#define KVerticalAndHorizontalLabelW 50
#define KVerticalAndHorizontalLabelH 10

@interface LCXKLineView ()<UIScrollViewDelegate, LCXLineAboveViewDelegate, LCXKLineBelowViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) LCXLineAboveView *kLineAboveView;

@property (nonatomic, strong) LCXKLineBelowView *kLineBelowView;

@property (nonatomic, strong) LCXKLineAboveBox *aboveBox;

@property (nonatomic, strong) LCXKLineBelowBox *belowBox;

@property (nonatomic, strong) LCXKLineMaskView *maskView;

@property (nonatomic, assign) CGFloat oldRightOffset;

@property (nonatomic, strong) NSArray *kLineModels;

@end

@implementation LCXKLineView

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.minimumZoomScale = 1.0f;
        _scrollView.maximumZoomScale = 1.0f;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.delegate = self;
        
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(event_pinchMethod:)];
        [_scrollView addGestureRecognizer:pinchGesture];
        //长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(event_longPressMethod:)];
        [_scrollView addGestureRecognizer:longPressGesture];
        [self insertSubview:_scrollView atIndex:0];
        WS(weakSelf);
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakSelf);
            make.right.mas_equalTo(weakSelf);
            make.left.mas_equalTo(weakSelf);
            make.bottom.mas_equalTo(weakSelf);
        }];
        //现在直接更新约束，省的后面要需要scrollView的宽度
        [self layoutIfNeeded];
    }
    return _scrollView;
}

- (LCXLineAboveView *)kLineAboveView {
    if (!_kLineAboveView && self) {
        _kLineAboveView = [LCXLineAboveView new];
        _kLineAboveView.delegate = self;
        [self.scrollView addSubview:_kLineAboveView];
        WS(weakSelf);
        [_kLineAboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(weakSelf.scrollView);
            make.height.equalTo(weakSelf.scrollView.mas_height).multipliedBy(weakSelf.aboveViewRatio);
            make.width.equalTo(@0);
        }];
    }
    return _kLineAboveView;
}

- (LCXKLineBelowView *)kLineBelowView {
    if (!_kLineBelowView) {
        _kLineBelowView = [LCXKLineBelowView new];
        _kLineBelowView.delegate = self;
        [self.scrollView addSubview:_kLineBelowView];
        WS(weakSelf);
        [_kLineBelowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakSelf.kLineAboveView);
            make.top.mas_equalTo(weakSelf.kLineAboveView.mas_bottom);
            make.width.mas_equalTo(weakSelf.kLineAboveView.mas_width);
            make.height.mas_equalTo(weakSelf.scrollView.mas_height).multipliedBy(1 - weakSelf.aboveViewRatio);
        }];
        [self layoutIfNeeded];
    }
    return _kLineBelowView;
}

- (LCXKLineAboveBox *)aboveBox {
    if (!_aboveBox) {
        _aboveBox = [LCXKLineAboveBox new];
        [self addSubview:_aboveBox];
        WS(weakSelf);
        [_aboveBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.equalTo(weakSelf.scrollView.mas_height).multipliedBy(weakSelf.aboveViewRatio);
        }];
    }
    return _aboveBox;
}

- (LCXKLineBelowBox *)belowBox {
    if (!_belowBox) {
        _belowBox = [LCXKLineBelowBox new];
        [self addSubview:_belowBox];
        WS(weakSelf);
        [_belowBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(weakSelf.aboveBox.mas_bottom);
            make.height.equalTo(weakSelf.scrollView.mas_height).multipliedBy(1 - weakSelf.aboveViewRatio);
        }];
    }
    return _belowBox;
}

- (LCXKLineMaskView *)maskView {
    if (!_maskView) {
        _maskView = [LCXKLineMaskView new];
        _maskView.kLineType = self.kLineType;
        _maskView.hidden = YES;
        [self addSubview:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(-LCXStockChartKLineSelectedDateHeight);
        }];
    }
    return _maskView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.aboveViewRatio = 0.7;
        self.oldRightOffset = -1.0f;
        self.aboveBox.backgroundColor = [UIColor clearColor];
        self.belowBox.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setKLineGroupModel:(LCXKLineGroupModel *)kLineGroupModel {
    if (!kLineGroupModel) {
        return;
    }
    
    _kLineGroupModel = kLineGroupModel;
    self.kLineModels = kLineGroupModel.kLineModels;
    
    //画图
    [self private_drawKLineAboveView];
    //设置contentOffset
    CGFloat contentOffsetX = self.oldRightOffset < 0 ? self.kLineAboveView.frame.size.width - self.scrollView.frame.size.width : self.kLineAboveView.frame.size.width - self.oldRightOffset;
    [self.scrollView setContentOffset:CGPointMake(contentOffsetX, 0)];
}

#pragma mark - 事件处理方法
#pragma mark 缩放执行的方法
- (void)event_pinchMethod:(UIPinchGestureRecognizer *)pinch {
    static CGFloat oldScale = 1.0f;
    CGFloat difValue = pinch.scale - oldScale;
    if (ABS(difValue) > LCXStockChartScaleBound) {
        CGFloat oldKLineWidth = [LCXStockChartGloablVariable kLineWidth];
        [LCXStockChartGloablVariable setkLineWith:oldKLineWidth * (difValue > 0 ? (1 + LCXStockChartScaleFactor) : (1 - LCXStockChartScaleFactor))];
        oldScale = pinch.scale;
        //更新AboveView的宽度
        [self.kLineAboveView updateAboveViewWidth];
        [self.kLineAboveView drawAboveView];
    }
}

#pragma mark 长按手势执行方法
- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress {
    static CGFloat oldPositionX = 0;
    if (UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        CGPoint location = [longPress locationInView:self.scrollView];
        if (ABS(oldPositionX - location.x) < ([LCXStockChartGloablVariable kLineWidth] + [LCXStockChartGloablVariable kLineGap]) / 2) {
            return;
        }
        
        //让scrollView的scrollEnabled不可用
        self.scrollView.scrollEnabled = NO;
        oldPositionX = location.x;
        
        //改变线的位置
        CGPoint position = [self.kLineAboveView getRightXPositionWithOriginXPosition:location.x];
        
        if (CGPointEqualToPoint(position, CGPointZero)) {
            // 没有找到的合适的位置
            return;
        }
        
        self.maskView.hidden = NO;
    }
    
    if (UIGestureRecognizerStateEnded == longPress.state) {
        //让scrollView的scrollEnabled可用
        self.scrollView.scrollEnabled = YES;
        oldPositionX = 0;
        
        self.maskView.hidden = YES;
        // 执行代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(longPressEnd)]) {
            [self.delegate longPressEnd];
        }
    }
}

#pragma mark - 私有方法
#pragma mark 画KLineAboveView
- (void)private_drawKLineAboveView {
    NSAssert(self.kLineAboveView != nil, @"画kLineAboveView之前，kLineAboveView不能为空");
    self.kLineAboveView.kLineModels = self.kLineModels;
    [self.kLineAboveView drawAboveView];
}

#pragma mark 画KLineBelowView
- (void)private_drawKLineBelowView {
    NSAssert(self.kLineBelowView != nil, @"画kLineBelowView之前，kLineBelowView不能为空");
    //因为belowView的宽度和aboveView的宽度是一致的，所以只需要更新约束就可以了
    [self.kLineBelowView layoutIfNeeded];
    [self.kLineBelowView drawBelowView];
}

- (void)setKLineType:(LCXStockChartKLineType)kLineType {
    _kLineType = kLineType;
    self.kLineAboveView.kLineType = kLineType;
}

#pragma mark - 公有方法
#pragma mark 重绘
- (void)reDraw {
    [self.kLineAboveView drawAboveView];
}

#pragma mark - LCXLineAboveViewDelegate的代理方法
#pragma mark 长按时选中的LCXKLinePositionModel模型
- (void)kLineAboveViewLongPressKLinePositionModel:(LCXKLinePositionModel *)kLinePositionModel kLineModel:(LCXKLineModel *)kLineModel {
    self.maskView.kLineModel = kLineModel;
    self.maskView.kLinePositionModel = kLinePositionModel;
    self.maskView.stockScrollView = self.scrollView;
    self.maskView.place = [self.kLineGroupModel.place integerValue];
    [self.maskView drawMaskView];
    
    // 执行代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(longPressBeganAndChangedWithLineModel:lineType:)]) {
        [self.delegate longPressBeganAndChangedWithLineModel:kLineModel lineType:LCXStocLineTypeKLine];
    }
}

#pragma mark LCXKLAboveView的当前最大股价和最小股价
- (void)kLineAboveViewCurrentMaxPrice:(CGFloat)maxPrice minPrice:(CGFloat)minPrice {
    self.aboveBox.maxPrice = maxPrice;
    self.aboveBox.minPrice = minPrice;
    self.aboveBox.place = [self.kLineGroupModel.place integerValue];
    [self.aboveBox drawAboveBox];
}

#pragma mark 当前需要绘制的K线模型数组
- (void)kLineAboveViewCurrentNeedDrawKLineModels:(NSArray *)needDrawKLineModels {
    self.kLineBelowView.needDrawKLineModels = needDrawKLineModels;
}

#pragma mark 当前需要绘制的K线位置模型数组
- (void)kLineAboveViewCurrentNeedDrawKLinePositionModels:(NSArray *)needDrawKLinePositionModels {
    self.kLineBelowView.needDrawKLinePositionModels = needDrawKLinePositionModels;
}

#pragma mark 当前需要绘制的K线的颜色数组
- (void)kLineAboveViewCurrentNeedDrawKLineColors:(NSArray *)kLineColors {
    self.kLineBelowView.kLineColors = kLineColors;
    [self private_drawKLineBelowView];
}

#pragma mark - LCXKLineBelowViewDelegate的代理方法
- (void)kLineBelowViewCurrentMaxVolume:(CGFloat)maxVolume minVolume:(CGFloat)minVolume {
    self.belowBox.maxVolume = maxVolume;
    [self.belowBox drawBelowBox];
}

#pragma mark - 释放资源方法
#pragma mark dealloc方法
-(void)dealloc {
    [self.kLineAboveView removeAllObserver];
    NSLog(@"%s", __func__);
}

@end
