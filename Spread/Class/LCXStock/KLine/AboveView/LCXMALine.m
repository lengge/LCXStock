//
//  LCXMALine.m
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXMALine.h"
#import "LCXKLineModel.h"
#import "UIColor+LCXStock.h"
#import "LCXStockChartConstant.h"

@interface LCXMALine ()

@property (nonatomic, assign) CGContextRef context;

@end

@implementation LCXMALine

/**
 *  根据context初始化均线画笔
 */
- (instancetype)initWitContext:(CGContextRef)context {
    self = [super init];
    if (self) {
        self.context = context;
    }
    return self;
}

- (void)draw {
    if (!self.context || !self.MAPositions) {
        return;
    }
    UIColor *lineColor = nil;
    switch (self.MAType) {
        case HYMA5Type:
            lineColor = [UIColor ma5Color];
            break;
        case HYMA10Type:
            lineColor = [UIColor ma10Color];
            break;
        case HYMA20Type:
            lineColor = [UIColor ma20Color];
            break;
            
        default:
            break;
    }
    
    CGContextSetStrokeColorWithColor(self.context, lineColor.CGColor);
    CGContextSetLineWidth(self.context, LCXStockChartMALineWidth);
    
    NSInteger count = self.MAPositions.count;
    CGPoint point = [[self.MAPositions firstObject] CGPointValue];
    NSAssert(!isnan(point.x) && !isnan(point.y), @"画MA线的时候出现NAN");
    CGContextMoveToPoint(self.context, point.x, point.y);
    for (NSInteger idx = 1; idx < count; idx++) {
        CGPoint point = [self.MAPositions[idx] CGPointValue];
        CGContextAddLineToPoint(self.context, point.x, point.y);
    }
    CGContextStrokePath(self.context);
}

@end
