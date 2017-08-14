//
//  LCXTimeLineVolume.m
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXTimeLineVolume.h"
#import "UIColor+LCXStock.h"
#import "LCXStockChartConstant.h"
#import "LCXTimeLineBelowPositionModel.h"

@interface LCXTimeLineVolume ()

@property (nonatomic, assign) CGContextRef context;

@end

@implementation LCXTimeLineVolume

- (instancetype)initWithContext:(CGContextRef)context {
    self = [super init];
    if (self) {
        _context = context;
    }
    return self;
}

- (void)draw {
    NSAssert(self.timeLineVolumnPositionModels && self.context, @"timeLineVolumnPositionModels不能为空！");
    
    CGContextSetLineWidth(self.context, LCXStockChartTimeLineVolumeLineWidth);
    for (LCXTimeLineBelowPositionModel *positionModel in self.timeLineVolumnPositionModels) {
        const CGPoint points[] = {positionModel.startPoint,positionModel.endPoint};
        switch (positionModel.colorType) {
            case LCXStockTimeLineColorTypeIncrease:
                CGContextSetStrokeColorWithColor(self.context, [UIColor increaseColor].CGColor);
                break;
            case LCXStockTimeLineColorTypeDecrease:
                CGContextSetStrokeColorWithColor(self.context, [UIColor decreaseColor].CGColor);
                break;
                
            default:
                break;
        }
        CGContextStrokeLineSegments(self.context, points, 2);
    }
}

@end
