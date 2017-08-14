//
//  LCXKLineAboveBox.m
//  LCXStock
//
//  Created by user on 17/5/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLineAboveBox.h"
#import "UIColor+LCXStock.h"
#import "LCXStockChartConstant.h"
#import "LCXStockMacro.h"
#import "LCXTool.h"

@implementation LCXKLineAboveBox

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 画垂直背景线
    [self drawVerticalLine:context];
    // 画水平背景线
    [self drawHorizontalLine:context];
    
    // 画MA
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9], NSForegroundColorAttributeName:[UIColor mainTextColor]};
    NSString *drawText = @"MA(5.10.20)";
    CGSize size = [LCXTool rectOfNSString:drawText attribute:attribute].size;
    [drawText drawAtPoint:CGPointMake(self.width - size.width - LCXStockChartTextPadding, LCXStockChartTopBottomDrawMargin) withAttributes:attribute];
    
    if (self.maxPrice > 0.f) {
        // 最大价格
        drawText = [NSString stringWithFormat:@"%.f", self.maxPrice];
        switch (self.place) {
            case 1:
                drawText = [NSString stringWithFormat:@"%.1f", self.maxPrice / pow(10, self.place)];
                break;
            case 2:
                drawText = [NSString stringWithFormat:@"%.2f", self.maxPrice / pow(10, self.place)];
                break;
            case 3:
                drawText = [NSString stringWithFormat:@"%.3f", self.maxPrice / pow(10, self.place)];
                break;
            case 4:
                drawText = [NSString stringWithFormat:@"%.4f", self.maxPrice / pow(10, self.place)];
                break;
                
            default:
                break;
        }
        [drawText drawAtPoint:CGPointMake(LCXStockChartTextPadding, LCXStockChartTopBottomDrawMargin) withAttributes:attribute];
    }
    
    if (self.minPrice > 0.f) {
        // 最小价格
        drawText = [NSString stringWithFormat:@"%.f", self.minPrice];
        switch (self.place) {
            case 1:
                drawText = [NSString stringWithFormat:@"%.1f", self.minPrice / pow(10, self.place)];
                break;
            case 2:
                drawText = [NSString stringWithFormat:@"%.2f", self.minPrice / pow(10, self.place)];
                break;
            case 3:
                drawText = [NSString stringWithFormat:@"%.3f", self.minPrice / pow(10, self.place)];
                break;
            case 4:
                drawText = [NSString stringWithFormat:@"%.4f", self.minPrice / pow(10, self.place)];
                break;
                
            default:
                break;
        }
        size = [LCXTool rectOfNSString:drawText attribute:attribute].size;
        [drawText drawAtPoint:CGPointMake(LCXStockChartTextPadding, self.height - LCXStockChartTimeLineTimeLabelViewHeight - LCXStockChartTopBottomDrawMargin - size.height) withAttributes:attribute];
    }
}

- (void)drawVerticalLine:(CGContextRef)context {
    CGContextSetLineWidth(context, LCXStockChartTimeLineLineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor timeLineCuttingLineColor].CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, self.height - LCXStockChartTimeLineTimeLabelViewHeight);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, self.width, 0);
    CGContextAddLineToPoint(context, self.width, self.height - LCXStockChartTimeLineTimeLabelViewHeight);
    CGContextStrokePath(context);
}

- (void)drawHorizontalLine:(CGContextRef)context {
    CGContextSetLineDash(context, 0, nil, 0);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.width, 0);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0, self.height - LCXStockChartTimeLineTimeLabelViewHeight);
    CGContextAddLineToPoint(context, self.width, self.height - LCXStockChartTimeLineTimeLabelViewHeight);
    CGContextStrokePath(context);
    
    CGFloat lengths[] = {5, 2};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, LCXStockChartTopBottomDrawMargin);
    CGContextAddLineToPoint(context, self.width, LCXStockChartTopBottomDrawMargin);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0, self.height - LCXStockChartTimeLineTimeLabelViewHeight - LCXStockChartTopBottomDrawMargin);
    CGContextAddLineToPoint(context, self.width, self.height - LCXStockChartTimeLineTimeLabelViewHeight - LCXStockChartTopBottomDrawMargin);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0, (self.height - LCXStockChartTimeLineTimeLabelViewHeight) / 2);
    CGContextAddLineToPoint(context, self.width, (self.height - LCXStockChartTimeLineTimeLabelViewHeight) / 2);
    CGContextStrokePath(context);
}

- (void)drawAboveBox {
    [self setNeedsDisplay];
}

@end
