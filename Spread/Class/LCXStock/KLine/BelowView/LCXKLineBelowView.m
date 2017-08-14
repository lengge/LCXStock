//
//  LCXKLineBelowView.m
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLineBelowView.h"
#import "LCXKLineVolumePositionModel.h"
#import "LCXKLineVolume.h"
#import "LCXStockChartConstant.h"
#import "LCXKLineModel.h"
#import "LCXKLinePositionModel.h"

@interface LCXKLineBelowView ()

/**
 *  需要绘制的成交量的位置模型数组
 */
@property (nonatomic, strong) NSArray *needDrawKLineVolumePositionModels;

@end

@implementation LCXKLineBelowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.needDrawKLineVolumePositionModels) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    LCXKLineVolume *kLineVolume = [[LCXKLineVolume alloc] initWithContext:context];
    [self.needDrawKLineVolumePositionModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LCXKLineVolumePositionModel *volumePositionModel = (LCXKLineVolumePositionModel *)obj;
        kLineVolume.positionModel = volumePositionModel;
        kLineVolume.kLineModel = self.needDrawKLineModels[idx];
        kLineVolume.lineColor = self.kLineColors[idx];
        [kLineVolume draw];
    }];
}

#pragma mark - 公有方法
#pragma mark 绘制BelowView方法
- (void)drawBelowView {
    NSInteger kLineModelCount = self.needDrawKLineModels.count;
    NSInteger kLinePositionModelCount = self.needDrawKLinePositionModels.count;
    NSInteger kLineColorCount = self.kLineColors.count;

    NSAssert(self.needDrawKLineModels && self.needDrawKLinePositionModels && self.kLineColors && kLineColorCount == kLineModelCount && kLinePositionModelCount == kLineModelCount, @"条件不符合，不能绘制BelowView!");
    self.needDrawKLineVolumePositionModels = [self private_convertToKLinePositionModelWithKLineModels:self.needDrawKLineModels];
    [self setNeedsDisplay];
}

#pragma mark - 私有方法
#pragma mark 根据KLineMoel转换成Position数组
- (NSArray *)private_convertToKLinePositionModelWithKLineModels:(NSArray *)kLineModels{
    CGFloat minY = LCXStockChartKLineBelowViewMinY;
    CGFloat maxY = LCXStockChartKLineBelowViewMaxY;
    __block CGFloat minVolume = CGFLOAT_MAX;
    __block CGFloat maxVolume = CGFLOAT_MIN;
    // 找最大值和最小值
    [kLineModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LCXKLineModel *kLineModel = (LCXKLineModel *)obj;
        if ([kLineModel.curvol floatValue] < minVolume) {
            minVolume = [kLineModel.curvol floatValue];
        }
        if ([kLineModel.curvol floatValue] > maxVolume) {
            maxVolume = [kLineModel.curvol floatValue];
        }
    }];
    CGFloat unitValue = (maxVolume - minVolume) / (maxY - minY);
    NSMutableArray *volumePositionModels = [NSMutableArray array];
    [kLineModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LCXKLineModel *kLineModel = (LCXKLineModel *)obj;
        LCXKLinePositionModel *kLinePositionModel = self.needDrawKLinePositionModels[idx];
        CGFloat xPosition = kLinePositionModel.highPoint.x;
        CGFloat yPosition = ABS(maxY - (([kLineModel.curvol floatValue] - minVolume) / unitValue));
        if (ABS(yPosition - LCXStockChartKLineBelowViewMaxY) < 0.5) {
            //这里写错了容易导致成交量很少的时候画图不准确，不应该是1，而应该是HYStockChartKLineBelowViewMaxY-1
            yPosition = LCXStockChartKLineBelowViewMaxY - 1;
        }
        CGPoint startPoint = CGPointMake(xPosition, yPosition);
        CGPoint endPoint = CGPointMake(xPosition, LCXStockChartKLineBelowViewMaxY);
        LCXKLineVolumePositionModel *volumePositionModel = [LCXKLineVolumePositionModel volumePositionModelWithStartPoint:startPoint endPoint:endPoint];
        [volumePositionModels addObject:volumePositionModel];
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(kLineBelowViewCurrentMaxVolume:minVolume:)]) {
        [self.delegate kLineBelowViewCurrentMaxVolume:maxVolume minVolume:minVolume];
    }
    return volumePositionModels;
}

@end
