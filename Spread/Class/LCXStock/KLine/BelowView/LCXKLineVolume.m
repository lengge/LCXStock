//
//  LCXKLineVolume.m
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLineVolume.h"
#import "LCXStockChartGloablVariable.h"

@interface LCXKLineVolume ()

@property (nonatomic, assign) CGContextRef context;

@end

@implementation LCXKLineVolume

#pragma mark 根据context初始化模型
- (instancetype)initWithContext:(CGContextRef)context {
    self = [super init];
    if (self) {
        _context = context;
    }
    return self;
}

#pragma mark 绘图方法
- (void)draw {
    if (!self.kLineModel || !self.positionModel || !self.context || !self.lineColor) {
        return;
    }
    
    CGContextSetStrokeColorWithColor(self.context, self.lineColor.CGColor);
    CGContextSetLineWidth(self.context, [LCXStockChartGloablVariable kLineWidth]);
    //画实体线
    const CGPoint solidPoints[] = {self.positionModel.startPoint, self.positionModel.endPoint};
    CGContextStrokeLineSegments(self.context, solidPoints, 2);
}

@end
