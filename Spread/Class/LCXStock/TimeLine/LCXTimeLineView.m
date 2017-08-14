//
//  LCXTimeLineView.m
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXTimeLineView.h"
#import "LCXTimeLineAboveView.h"
#import "LCXTimeLineBelowView.h"
#import "LCXTimeLineAbovePositionModel.h"
#import "LCXTimeLineModel.h"
#import "NSDate+Helper.h"
#import "LCXTimeLineMaskView.h"


@interface LCXTimeLineView ()<LCXTimeLineAboveViewDelegate>

@property (nonatomic, strong) LCXTimeLineAboveView *aboveView;

@property (nonatomic, strong) LCXTimeLineBelowView *belowView;

@property (nonatomic, strong) LCXTimeLineMaskView *maskView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) NSArray *timeLineModels;

@end

@implementation LCXTimeLineView

- (LCXTimeLineAboveView *)aboveView {
    if (!_aboveView) {
        _aboveView = [LCXTimeLineAboveView new];
        _aboveView.delegate = self;
        [self.containerView addSubview:_aboveView];
        [_aboveView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.containerView);
            make.height.mas_equalTo(self.containerView).multipliedBy(self.aboveViewRatio);
        }];
    }
    return _aboveView;
}

- (LCXTimeLineBelowView *)belowView {
    if (!_belowView) {
        _belowView = [LCXTimeLineBelowView new];
        [self.containerView addSubview:_belowView];
        [_belowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.aboveView.mas_bottom);
            make.left.right.mas_equalTo(self.containerView);
            make.height.mas_equalTo(self.containerView).multipliedBy(1 - self.aboveViewRatio);
        }];
    }
    return _belowView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        [self addAllEvent];
        [self addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(self);
        }];
    }
    return _containerView;
}

- (LCXTimeLineMaskView *)maskView {
    if (!_maskView) {
        _maskView = [LCXTimeLineMaskView new];
        _maskView.hidden = YES;
        [self addSubview:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(-LCXStockChartKLineSelectedDateHeight);
        }];
    }
    return _maskView;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.aboveViewRatio = 0.7;
        self.aboveView.backgroundColor = [UIColor clearColor];
        self.belowView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - 模型设置方法
#pragma mark aboveViewRatio设置方法
- (void)setAboveViewRatio:(CGFloat)aboveViewRatio {
    _aboveViewRatio = aboveViewRatio;
    
    [self.aboveView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self).multipliedBy(self.aboveViewRatio);
    }];
    [self.belowView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self).multipliedBy(1 - self.aboveViewRatio);
    }];
}

#pragma mark timeLineModels的设置方法
- (void)setTimeLineGroupModel:(LCXTimeLineGroupModel *)timeLineGroupModel {
    if (!timeLineGroupModel) {
        return;
    }
    
    _timeLineGroupModel = timeLineGroupModel;
    
    self.timeLineModels = timeLineGroupModel.timeModels;
    self.aboveView.groupModel = timeLineGroupModel;
    self.belowView.groupModel = timeLineGroupModel;
    [self.aboveView drawAboveView];
    
    //异步计算均价
    [self calculationAvgPrice:self.timeLineModels];
}

- (void)calculationAvgPrice:(NSArray *)timeLineModels {
    WS(weakSelf);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //计算均价
        [timeLineModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LCXTimeLineModel *timeLineModel = (LCXTimeLineModel *)obj;
            [timeLineModel calculationAvgPrice:timeLineModels];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.timeLineGroupModel.timeModels = timeLineModels;
            weakSelf.timeLineGroupModel.isDrawAvg = YES;
            
            weakSelf.timeLineModels = timeLineModels;
            weakSelf.aboveView.groupModel = weakSelf.timeLineGroupModel;
            weakSelf.belowView.groupModel = weakSelf.timeLineGroupModel;
            [weakSelf.aboveView drawAboveView];
        });
    });
}

#pragma mark - 长按事件
- (void)addAllEvent {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(event_longPressMethod:)];
    [self.containerView addGestureRecognizer:longPress];
}

#pragma mark - 公共方法
#pragma mark 重绘
- (void)reDraw {
    [self.aboveView drawAboveView];
}

#pragma mark 长按执行方法
- (void)event_longPressMethod:(UILongPressGestureRecognizer *)longPress {
    CGPoint pressPosition = [longPress locationInView:self.aboveView];
    if (UIGestureRecognizerStateBegan == longPress.state ||
        UIGestureRecognizerStateChanged == longPress.state) {
        //改变线的位置
        CGPoint position = [self.aboveView getRightXPositionWithOriginXPosition:pressPosition.x];
        
        if (CGPointEqualToPoint(position, CGPointZero)) {
            // 没有找到的合适的位置
            return;
        }
        
        self.maskView.timeLinePosition = position;
        self.maskView.hidden = NO;
        [self.maskView drawMaskView];

    } else {
        self.maskView.hidden = YES;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(longPressEnd)]) {
            [self.delegate longPressEnd];
        }
    }
}

#pragma mark - LCXTimeLineAboveViewDelegate代理方法
- (void)timeLineAboveView:(UIView *)timeLineAboveView positionModels:(NSArray *)positionModels {
    NSMutableArray *xPositionArr = [NSMutableArray array];
    for (LCXTimeLineAbovePositionModel *positionModel in positionModels) {
        [xPositionArr addObject:[NSNumber numberWithFloat:positionModel.currentPoint.x]];
    }
    self.belowView.xPositionArray = xPositionArr;
    [self.belowView drawBelowView];
}

- (void)timeLineAboveView:(UIView *)timeLineAboveView longPressTimeLineModel:(LCXTimeLineModel *)timeLineModel {
    self.maskView.timeLineModel = timeLineModel;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(longPressBeganAndChangedWithLineModel:lineType:)]) {
        [self.delegate longPressBeganAndChangedWithLineModel:timeLineModel lineType:LCXStocLineTypeTimeLine];
    }
}

@end
