//
//  LCXTimeLineBelowView.m
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXTimeLineBelowView.h"
#import "LCXTimeLineModel.h"
#import "LCXStockChartConstant.h"
#import "LCXTimeLineBelowPositionModel.h"
#import "LCXTimeLineVolume.h"
#import "LCXTimeLineGroupModel.h"

@interface LCXTimeLineBelowView ()

@property (nonatomic, strong) NSArray *positionModels;
/**
 *  成交量最大值
 */
@property (nonatomic, assign) CGFloat volumeMaxValue;
/**
 *  成交量最小值
 */
@property (nonatomic, assign) CGFloat volumeMinValue;

@end

@implementation LCXTimeLineBelowView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _positionModels = nil;
        self.layer.borderColor = [UIColor timeLineCuttingLineColor].CGColor;
        self.layer.borderWidth = 0.5f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (!self.positionModels) {
        return;
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor mainTextColor]};
    NSString *text = [NSString stringWithFormat:@"%.f手", self.volumeMaxValue];
    [text drawAtPoint:CGPointMake(LCXStockChartTextPadding, 0) withAttributes:attribute];
    
    LCXTimeLineVolume *timeLineVolumn = [[LCXTimeLineVolume alloc] initWithContext:UIGraphicsGetCurrentContext()];
    timeLineVolumn.timeLineVolumnPositionModels = self.positionModels;
    [timeLineVolumn draw];
}

- (void)drawBelowView {
    [self private_convertTimeLineModelsPositionModels];
    NSAssert(self.positionModels, @"positionModels不能为空");
    [self setNeedsDisplay];
}

#pragma mark - 私有方法
#pragma mark 将分时线的模型数组转换成Y坐标的
- (NSArray *)private_convertTimeLineModelsPositionModels {
    NSAssert(self.groupModel && self.xPositionArray && self.groupModel.timeModels.count == self.xPositionArray.count, @"timeLineModels不能为空!");
    
    //1.算y轴的单元值
    self.volumeMaxValue = CGFLOAT_MIN;
    self.volumeMinValue = CGFLOAT_MAX;
    [self.groupModel.timeModels enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        LCXTimeLineModel *timeLineModel = (LCXTimeLineModel *)obj;
        if ([timeLineModel.currentVolume floatValue] < self.volumeMinValue) {
            self.volumeMinValue = [timeLineModel.currentVolume floatValue];
        }
        if ([timeLineModel.currentVolume floatValue] > self.volumeMaxValue) {
            self.volumeMaxValue = [timeLineModel.currentVolume floatValue];
        }
    }];
    CGFloat minY = LCXStockChartTimeLineBelowViewMinY;
    CGFloat maxY = LCXStockChartTimeLineBelowViewMaxY;
    CGFloat yUnitValue = (self.volumeMaxValue - self.volumeMinValue)/(maxY - minY);
    
    NSMutableArray *positionArray = [NSMutableArray array];
    
    NSInteger index = 0;
    for (LCXTimeLineModel *timeLineModel in self.groupModel.timeModels) {
        CGFloat xPosition = [self.xPositionArray[index] floatValue];
        CGFloat yPosition = maxY - ([timeLineModel.currentVolume floatValue] - self.volumeMinValue) / yUnitValue;
        
        LCXTimeLineBelowPositionModel *positionModel = [LCXTimeLineBelowPositionModel new];
        positionModel.startPoint = CGPointMake(xPosition, maxY);
        positionModel.endPoint = CGPointMake(xPosition, yPosition);
        [positionArray addObject:positionModel];
        
        if (index == 0) {
            if ([timeLineModel.currentPrice floatValue] >= [self.groupModel.preclose floatValue]) {
                positionModel.colorType = LCXStockTimeLineColorTypeIncrease;
            } else {
                positionModel.colorType = LCXStockTimeLineColorTypeDecrease;
            }
        } else {
            LCXTimeLineModel *lastTimeModel = self.groupModel.timeModels[index - 1];
            if ([timeLineModel.currentPrice floatValue] > [lastTimeModel.currentPrice floatValue]) {
                positionModel.colorType = LCXStockTimeLineColorTypeIncrease;
            } else if ([timeLineModel.currentPrice floatValue] < [lastTimeModel.currentPrice floatValue]) {
                positionModel.colorType = LCXStockTimeLineColorTypeDecrease;
            } else {
                positionModel.colorType = LCXStockTimeLineColorTypeOther;
            }
        }
        
        index++;
    }
    _positionModels = positionArray;
    return positionArray;
}

@end
