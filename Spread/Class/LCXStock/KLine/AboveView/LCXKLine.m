//
//  LCXKLine.m
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLine.h"
#import "UIColor+LCXStock.h"
#import "LCXStockChartGloablVariable.h"
#import "NSDate+Helper.h"
#import "LCXTool.h"

@interface LCXKLine ()

@property (nonatomic, assign) CGContextRef context;

@property (nonatomic, strong) UIColor *strokeColor;

@end

@implementation LCXKLine

#pragma mark 根据context初始化
- (instancetype)initWithContext:(CGContextRef)context {
    self = [super init];
    if (self) {
        _context = context;
    }
    return self;
}

#pragma mark 绘制K线
- (UIColor *)draw {
    //如果没有数据，直接返回
    if (!self.kLineModel || !self.context || !self.kLinePositionModel) {
        return nil;
    }
    
    //画日期
    [self drawDate:self.context];
    //画K线
    UIColor *strokeColor = [self drawKLine:self.context];
    
    return strokeColor;
}

- (void)drawDate:(CGContextRef)context {
    if (self.kLineModel.isDrawDate) {
        NSDate *date = [NSDate dateFromString:self.kLineModel.timestamp withFormat:@"yyyyMMddHHmmss"];
        NSString *dateString;
        switch (self.kLineType) {
            case LCXStockChartKLineTypeDay:
                dateString = [date stringWithFormat:@"yyyy-MM"];
                break;
            case LCXStockChartKLineTypeOneMinute:
            case LCXStockChartKLineTypeFiveMinute:
                dateString = [date stringWithFormat:@"HH:mm"];
                break;
                
            default:
                dateString = [date stringWithFormat:@"yyyy-MM-dd HH:mm"];
                break;
        }
        
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor mainTextColor]};
        CGSize dateSize = [LCXTool rectOfNSString:dateString attribute:attribute].size;
        
        CGFloat drawDatePointX = self.kLinePositionModel.highPoint.x - dateSize.width / 2;
        if (drawDatePointX < 0) {
            drawDatePointX = 0;
        } else if (self.kLinePositionModel.highPoint.x + dateSize.width / 2 > self.maxX) {
            drawDatePointX = self.maxX - dateSize.width;
        }
        CGPoint drawDatePoint = CGPointMake(drawDatePointX, self.maxY);
        
        // 画日K线
        [dateString drawAtPoint:drawDatePoint withAttributes:attribute];
        // 画虚线
        [self drawVerticalDashLine:context];
    }
}

#pragma mark - 画垂直虚线
- (void)drawVerticalDashLine:(CGContextRef)context {
    CGContextSetLineWidth(context, LCXStockChartTimeLineLineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor timeLineCuttingLineColor].CGColor);
    CGFloat lengths[] = {5, 2};
    CGContextSetLineDash(context, 0, lengths, 2);
    
    const CGPoint points[] = {CGPointMake(self.kLinePositionModel.highPoint.x, 0),CGPointMake(self.kLinePositionModel.highPoint.x, self.maxY)};
    CGContextStrokeLineSegments(context, points, 2);
}

#pragma mark - 画K线
- (UIColor *)drawKLine:(CGContextRef)context {
    CGContextSetLineDash(context, 0, nil, 0);


    if ([self.kLineModel.preclose floatValue] < [self.kLineModel.openp floatValue]) {
        self.strokeColor = [UIColor decreaseColor];
    } else if ([self.kLineModel.preclose floatValue] > [self.kLineModel.openp floatValue]) {
        self.strokeColor = [UIColor increaseColor];
    } else if ([self.kLineModel.changeFromLastClose floatValue] < 0.f) {
        //减少的
        self.strokeColor = [UIColor decreaseColor];
    } else {
        //增长的
        self.strokeColor = [UIColor increaseColor];
    }
    
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    //画中间的开收盘线
    //设置开收盘线的宽度
    CGContextSetLineWidth(context, [LCXStockChartGloablVariable kLineWidth]);
    //画实体线
    const CGPoint solidPoints[] = {self.kLinePositionModel.openPoint,self.kLinePositionModel.closePoint};
    CGContextStrokeLineSegments(context, solidPoints, 2);
    
    //画上影线和下影线
    //设置上影线和下影线的线的宽度
    CGContextSetLineWidth(context, [self shadowLineWidth]);
    //画出上下影线
    const CGPoint shadowPoints[] = {self.kLinePositionModel.highPoint,self.kLinePositionModel.lowPoint};
    CGContextStrokeLineSegments(context, shadowPoints, 2);
    
    return self.strokeColor;
}

/**
 *  影线的宽度
 */
- (CGFloat)shadowLineWidth {
    return 1.0f;
}

@end
