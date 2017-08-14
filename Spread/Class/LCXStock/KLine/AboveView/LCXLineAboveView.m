//
//  LCXLineAboveView.m
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXLineAboveView.h"
#import "LCXStockMacro.h"
#import "LCXKLine.h"
#import "LCXMALine.h"
#import "LCXStockChartGloablVariable.h"

@interface LCXLineAboveView ()

@property (nonatomic, strong) NSMutableArray *needDrawKLineModels;

@property (nonatomic, strong) NSMutableArray *needDrawKLinePositionModels;

@property (nonatomic, assign) NSUInteger needDrawStartIndex;

@property (nonatomic, assign, readonly) CGFloat startXPosition;

@property (nonatomic, assign) CGFloat oldContentOffsetX;

@property (nonatomic, strong) NSMutableArray *MA5Positions;

@property (nonatomic, strong) NSMutableArray *MA10Positions;

@property (nonatomic, strong) NSMutableArray *MA20Positions;

@end

@implementation LCXLineAboveView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.needDrawKLinePositionModels = [NSMutableArray array];
        self.needDrawKLineModels = [NSMutableArray array];
        self.MA5Positions = [NSMutableArray array];
        self.MA10Positions = [NSMutableArray array];
        self.MA20Positions = [NSMutableArray array];
        _needDrawStartIndex = 0;
        self.oldContentOffsetX = 0;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.kLineModels) {
        return;
    }
    
    NSMutableArray *kLineColors = [NSMutableArray array];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    LCXKLine *kLine = [[LCXKLine alloc] initWithContext:context];
    kLine.kLineType = self.kLineType;
    kLine.maxX = self.width;
    kLine.maxY = LCXStockChartKLineAboveViewMaxY;
    NSInteger idx = 0;
    NSArray *kLinePositioinModels = self.needDrawKLinePositionModels;
    for (LCXKLinePositionModel *kLinePositionModel in kLinePositioinModels) {
        kLine.kLinePositionModel = kLinePositionModel;
        kLine.kLineModel = self.needDrawKLineModels[idx];
        UIColor *kLineColor = [kLine draw];
        [kLineColors addObject:kLineColor];
        idx++;
    }
    
    LCXMALine *MALine = [[LCXMALine alloc] initWitContext:context];
    //1.画MA5线
    MALine.MAType = HYMA5Type;
    MALine.MAPositions = self.MA5Positions;
    [MALine draw];
    
    //2.画MA10线
    MALine.MAType = HYMA10Type;
    MALine.MAPositions = self.MA10Positions;
    [MALine draw];
    
    //3.画MA20线
    MALine.MAType = HYMA20Type;
    MALine.MAPositions = self.MA20Positions;
    [MALine draw];
    
    if (self.delegate && kLineColors.count > 0) {
        if ([self.delegate respondsToSelector:@selector(kLineAboveViewCurrentNeedDrawKLineColors:)]) {
            [self.delegate kLineAboveViewCurrentNeedDrawKLineColors:kLineColors];
        }
    }
}

- (void)setKLineModels:(NSArray *)kLineModels {
    _kLineModels = kLineModels;
    [self updateAboveViewWidth];
}

#pragma mark - 公有方法
#pragma mark 更新自身view的宽度
- (void)updateAboveViewWidth {
    //根据stockModels个数和间隙以及K线的宽度算出self的宽度,设置contentSize
    CGFloat kLineViewWidth = self.kLineModels.count * [LCXStockChartGloablVariable kLineWidth] + (self.kLineModels.count + 1) * [LCXStockChartGloablVariable kLineGap] + 5;
    if (kLineViewWidth < [UIScreen mainScreen].bounds.size.width) {
        kLineViewWidth = [UIScreen mainScreen].bounds.size.width;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(kLineViewWidth));
    }];
    [self layoutIfNeeded];
    //更新scrollView的contentSize
    self.scrollView.contentSize = CGSizeMake(kLineViewWidth, self.scrollView.contentSize.height);
}

#pragma mark 根据原始的x的位置获得精确的X的位置
- (CGPoint)getRightXPositionWithOriginXPosition:(CGFloat)originXPosition {
    CGFloat xPositionInAboveView = originXPosition;
    NSInteger startIndex = (NSInteger)((xPositionInAboveView - self.startXPosition) / ([LCXStockChartGloablVariable kLineGap] + [LCXStockChartGloablVariable kLineWidth]));
    NSInteger arrCount = self.needDrawKLinePositionModels.count;
    for (NSInteger index = startIndex > 0 ? startIndex - 1 : 0; index < arrCount; ++index) {
        LCXKLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[index];
        CGFloat minX = kLinePositionModel.highPoint.x - ([LCXStockChartGloablVariable kLineGap]+[LCXStockChartGloablVariable kLineWidth]) / 2;
        CGFloat maxX = kLinePositionModel.highPoint.x + ([LCXStockChartGloablVariable kLineGap]+[LCXStockChartGloablVariable kLineWidth]) / 2;
        if (xPositionInAboveView > minX && xPositionInAboveView < maxX) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(kLineAboveViewLongPressKLinePositionModel:kLineModel:)]) {
                [self.delegate kLineAboveViewLongPressKLinePositionModel:self.needDrawKLinePositionModels[index] kLineModel:self.needDrawKLineModels[index]];
            }
            CGPoint resultPoint = CGPointMake(kLinePositionModel.highPoint.x, kLinePositionModel.closePoint.y);
            return resultPoint;
        }
    }
    return CGPointZero;
}

#pragma mark 重新设置相关变量，然后绘图
- (void)drawAboveView {
    NSAssert(self.kLineModels, @"kLineModels不能为空!");
    //先提取需要展示的kLineModel
    [self private_extractNeedDrawModels];
    //将stockModel转换成坐标模型
    [self private_convertToKLinePositionModelWithKLineModels];
    //间接调用drawRect方法
    [self setNeedsDisplay];
}

#pragma mark - 私有方法
#pragma mark 提取需要绘制的数组
- (NSArray *)private_extractNeedDrawModels {
    CGFloat lineGap = [LCXStockChartGloablVariable kLineGap];
    CGFloat lineWidth = [LCXStockChartGloablVariable kLineWidth];
    
    //数组个数
    CGFloat scrollViewWidth = self.scrollView.frame.size.width;
    NSInteger needDrawKLineCount = (scrollViewWidth - lineGap) / (lineGap + lineWidth);
    
    //起始位置
    NSInteger needDrawKLineStartIndex = self.needDrawStartIndex;
 
    [self.needDrawKLineModels removeAllObjects];
    if ((needDrawKLineStartIndex + needDrawKLineCount) < self.kLineModels.count) {
        [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, needDrawKLineCount)]];
    } else {
        [self.needDrawKLineModels addObjectsFromArray:[self.kLineModels subarrayWithRange:NSMakeRange(needDrawKLineStartIndex, self.kLineModels.count - needDrawKLineStartIndex)]];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(kLineAboveViewCurrentNeedDrawKLineModels:)]) {
        [self.delegate kLineAboveViewCurrentNeedDrawKLineModels:self.needDrawKLineModels];
    }
    return self.needDrawKLineModels;
}

#pragma mark 将stockModel模型转换成KLine模型
- (NSArray *)private_convertToKLinePositionModelWithKLineModels {
    if (!self.needDrawKLineModels) {
        return nil;
    }
    NSArray *kLineModels = self.needDrawKLineModels;
    
    //更新最大值最小值-价格
    CGFloat max =  [[[self.needDrawKLineModels valueForKeyPath:@"highp"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat ma5max = [[[self.needDrawKLineModels valueForKeyPath:@"MA5"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat ma10max = [[[self.needDrawKLineModels valueForKeyPath:@"MA10"] valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat ma20max = [[[self.needDrawKLineModels valueForKeyPath:@"MA20"] valueForKeyPath:@"@max.floatValue"] floatValue];

    __block CGFloat min =  [[[self.needDrawKLineModels valueForKeyPath:@"lowp"] valueForKeyPath:@"@min.floatValue"] floatValue];
    [self.needDrawKLineModels enumerateObjectsUsingBlock:^(LCXKLineModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ( obj.MA5 > 0 && obj.MA5 < min ) min = obj.MA5;
        if ( obj.MA10 > 0 && obj.MA10 < min ) min = obj.MA10;
        if ( obj.MA20 > 0 && obj.MA20 < min ) min = obj.MA20;
    }];
    
    max = MAX(MAX(MAX(ma5max, ma10max), ma20max), max);
    
    CGFloat average = (max + min) / 2;
    CGFloat maxAssert = max;
    CGFloat minAssert = average * 2 - maxAssert;
    
    //算得最小单位
    CGFloat minY = LCXStockChartTopBottomDrawMargin;
    CGFloat maxY = LCXStockChartKLineAboveViewMaxY - LCXStockChartTopBottomDrawMargin - LCXStockChartKLineMinWidth;
    CGFloat unitValue = (maxAssert - minAssert)/(maxY - minY);
    
    [self.needDrawKLinePositionModels removeAllObjects];
    [self.MA5Positions removeAllObjects];
    [self.MA10Positions removeAllObjects];
    [self.MA20Positions removeAllObjects];
    
    NSInteger kLineModelsCount = kLineModels.count;
    for (NSInteger idx = 0; idx < kLineModelsCount; ++idx) {
        //1.转换K线位置代码
        LCXKLineModel *kLineModel = kLineModels[idx];
        CGFloat xPosition = self.startXPosition + idx * ([LCXStockChartGloablVariable kLineWidth]+[LCXStockChartGloablVariable kLineGap]);
        CGPoint openPoint = CGPointMake(xPosition, ABS(maxY - ([kLineModel.openp floatValue] - minAssert)/unitValue));
        
        CGFloat closePointY = ABS(maxY - ([kLineModel.preclose floatValue] - minAssert) / unitValue);
        if (ABS(closePointY - openPoint.y) < LCXStockChartKLineMinWidth) {
            if (openPoint.y > closePointY) {
                openPoint.y = closePointY + LCXStockChartKLineMinWidth;
            } else if (openPoint.y < closePointY) {
                closePointY = openPoint.y + LCXStockChartKLineMinWidth;
            } else {
                if (idx > 0) {
                    LCXKLineModel *preKLineModel = kLineModels[idx - 1];;
                    if ([kLineModel.openp floatValue] > [preKLineModel.preclose floatValue]) {
                        openPoint.y = closePointY + LCXStockChartKLineMinWidth;
                    } else {
                        closePointY = openPoint.y + LCXStockChartKLineMinWidth;
                    }
                } else if (idx + 1 < kLineModelsCount) {
                    LCXKLineModel *subKLineModel = kLineModels[idx + 1];;
                    if ([kLineModel.preclose floatValue] < [subKLineModel.openp floatValue]) {
                        openPoint.y = closePointY + LCXStockChartKLineMinWidth;
                    } else {
                        closePointY = openPoint.y + LCXStockChartKLineMinWidth;
                    }
                }
            }
        }
        
        CGPoint closePoint = CGPointMake(xPosition, closePointY);
        CGPoint highPoint = CGPointMake(xPosition, ABS(maxY- ([kLineModel.highp floatValue] - minAssert) / unitValue));
        CGPoint lowPoint = CGPointMake(xPosition, ABS(maxY - ([kLineModel.lowp floatValue] - minAssert) / unitValue));
        LCXKLinePositionModel *kLinePositionModel = [LCXKLinePositionModel modelWithOpen:openPoint close:closePoint high:highPoint low:lowPoint];
        [self.needDrawKLinePositionModels addObject:kLinePositionModel];
    
        //2.转换成MA的代码
        if (kLineModel.MA5 > 0.0f) {
            CGPoint ma5Point = CGPointMake(xPosition, maxY - (kLineModel.MA5 - minAssert)/unitValue);
            [self.MA5Positions addObject:[NSValue valueWithCGPoint:ma5Point]];
        }
        if (kLineModel.MA10 > 0.0f) {
            CGPoint ma10Point = CGPointMake(xPosition, maxY - (kLineModel.MA10 - minAssert)/unitValue);
            [self.MA10Positions addObject:[NSValue valueWithCGPoint:ma10Point]];
        }
        if (kLineModel.MA20 > 0.0f) {
            CGPoint ma20Point = CGPointMake(xPosition, maxY - (kLineModel.MA20 - minAssert)/unitValue);
            [self.MA20Positions addObject:[NSValue valueWithCGPoint:ma20Point]];
        }
    }
    //执行代理方法
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(kLineAboveViewCurrentMaxPrice:minPrice:)]) {
            [self.delegate kLineAboveViewCurrentMaxPrice:maxAssert minPrice:minAssert];
        }
        if ([self.delegate respondsToSelector:@selector(kLineAboveViewCurrentNeedDrawKLinePositionModels:)]) {
            [self.delegate kLineAboveViewCurrentNeedDrawKLinePositionModels:self.needDrawKLinePositionModels];
        }
    }
    return self.needDrawKLinePositionModels;
}

- (CGFloat)startXPosition {
    CGFloat lineGap = [LCXStockChartGloablVariable kLineGap];
    CGFloat lineWidth = [LCXStockChartGloablVariable kLineWidth];
    NSInteger leftArrCount = self.needDrawStartIndex;
    CGFloat startXPosition = (leftArrCount + 1) * lineGap + leftArrCount * lineWidth + lineWidth / 2;
    return startXPosition;
}

- (NSUInteger)needDrawStartIndex {
    CGFloat lineGap = [LCXStockChartGloablVariable kLineGap];
    CGFloat lineWidth = [LCXStockChartGloablVariable kLineWidth];
    CGFloat scrollViewOffsetX = self.scrollView.contentOffset.x < 0 ? 0 : self.scrollView.contentOffset.x;
    NSUInteger leftArrCount = ABS(scrollViewOffsetX - lineGap) / (lineGap + lineWidth);
    _needDrawStartIndex = leftArrCount;
    return _needDrawStartIndex;
}

static char *observerContext = NULL;
#pragma mark 添加所有事件监听的方法
- (void)private_addAllEventListenr {
    //用KVO监听scrollView的状态改变
    [_scrollView addObserver:self forKeyPath:LCXStockChartContentOffsetKey options:NSKeyValueObservingOptionNew context:observerContext];
}

#pragma mark - 系统方法
#pragma mark 已经添加到父view的方法
- (void)didMoveToSuperview{
    _scrollView = (UIScrollView *)self.superview;
    [self private_addAllEventListenr];
    [super didMoveToSuperview];
}

#pragma mark KVO监听实现的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:LCXStockChartContentOffsetKey]) {
        CGFloat difValue = ABS(self.scrollView.contentOffset.x - self.oldContentOffsetX);
        if (difValue >= ([LCXStockChartGloablVariable kLineGap] + [LCXStockChartGloablVariable kLineWidth])) {
            self.oldContentOffsetX = self.scrollView.contentOffset.x;
            [self drawAboveView];
        }
    }
}

#pragma mark - 垃圾回收方法
#pragma mark 移除所有监听
- (void)removeAllObserver {
    [_scrollView removeObserver:self forKeyPath:LCXStockChartContentOffsetKey context:observerContext];
}

#pragma mark dealloc方法
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
