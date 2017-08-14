//
//  LCXTimeLine.m
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXTimeLine.h"
#import "LCXStockChartConstant.h"
#import "UIColor+LCXStock.h"

@interface LCXTimeLine ()

@property (nonatomic, assign) CGContextRef context;

@end

@implementation LCXTimeLine

- (instancetype)initWithContext:(CGContextRef)context {
    self = [super init];
    if (self) {
        self.context = context;
    }
    return self;
}

- (void)draw {
    NSAssert(self.context && self.positionModels, @"context或者positionModel不能为空!");
    NSInteger count = self.positionModels.count;
    NSArray *positionModels = self.positionModels;
    
    CGContextSetLineWidth(self.context, LCXStockChartTimeLineLineWidth);
    CGContextSetLineDash(self.context, 0, nil, 0);
    for (NSInteger index = 0; index < count; index++) {
        LCXTimeLineAbovePositionModel *positionModel = positionModels[index];
        // 画分时线
        CGContextSetStrokeColorWithColor(self.context, [UIColor timeLineLineColor].CGColor);
        if (isnan(positionModel.currentPoint.x) || isnan(positionModel.currentPoint.y)) {
            continue;
        }
        NSAssert(!isnan(positionModel.currentPoint.x) && !isnan(positionModel.currentPoint.y) && !isinf(positionModel.currentPoint.x) && !isinf(positionModel.currentPoint.y), @"不符合要求的点！");
        CGContextMoveToPoint(self.context, positionModel.currentPoint.x, positionModel.currentPoint.y);
        if (index + 1 < count) {
            LCXTimeLineAbovePositionModel *nextPositionModel = positionModels[index + 1];
            CGContextAddLineToPoint(self.context, nextPositionModel.currentPoint.x, nextPositionModel.currentPoint.y);
        }
        CGContextStrokePath(self.context);
        
        // 画均价
        if (positionModel.isDrawAvg) {
            CGContextSetStrokeColorWithColor(self.context, [UIColor avgLineColor].CGColor);
            if (isnan(positionModel.avgPoint.x) || isnan(positionModel.avgPoint.y)) {
                continue;
            }
            NSAssert(!isnan(positionModel.avgPoint.x) && !isnan(positionModel.avgPoint.y) && !isinf(positionModel.avgPoint.x) && !isinf(positionModel.avgPoint.y), @"不符合要求的点！");
            CGContextMoveToPoint(self.context, positionModel.avgPoint.x, positionModel.avgPoint.y);
            if (index + 1 < count) {
                LCXTimeLineAbovePositionModel *nextPositionModel = positionModels[index + 1];
                CGContextAddLineToPoint(self.context, nextPositionModel.avgPoint.x, nextPositionModel.avgPoint.y);
            }
            CGContextStrokePath(self.context);
        }
    }
}

@end
