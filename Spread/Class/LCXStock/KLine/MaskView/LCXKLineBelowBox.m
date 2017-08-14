//
//  LCXKLineBelowBox.m
//  LCXStock
//
//  Created by user on 17/5/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLineBelowBox.h"
#import "UIColor+LCXStock.h"
#import "LCXStockChartConstant.h"
#import "LCXStockMacro.h"
#import "LCXTool.h"

@implementation LCXKLineBelowBox

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
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9], NSForegroundColorAttributeName:[UIColor mainTextColor]};
    NSString *drawText = [NSString stringWithFormat:@"%.f", self.maxVolume];
    
    NSString *unitText = @"手";
    CGSize unitSize = [LCXTool rectOfNSString:unitText attribute:attribute].size;
    
    //尝试转为万手
    CGFloat wVolume = self.maxVolume / 10000.f;
    if (wVolume > 1) {
        //尝试转为亿手
        CGFloat yVolume = wVolume / 10000.f;
        if (yVolume > 1) {
            drawText = [NSString stringWithFormat:@"%.2f", yVolume];
            unitText = @"亿手";
        } else {
            drawText = [NSString stringWithFormat:@"%.2f", wVolume];
            unitText = @"万手";
        }
    }
    
    [drawText drawAtPoint:CGPointMake(LCXStockChartTextPadding, 0) withAttributes:attribute];
    [unitText drawAtPoint:CGPointMake(LCXStockChartTextPadding, self.height - unitSize.height) withAttributes:attribute];
}

- (void)drawVerticalLine:(CGContextRef)context {
    CGContextSetLineWidth(context, LCXStockChartTimeLineLineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor timeLineCuttingLineColor].CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, self.height);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, self.width, 0);
    CGContextAddLineToPoint(context, self.width, self.height);
    CGContextStrokePath(context);
}

- (void)drawHorizontalLine:(CGContextRef)context {
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.width, 0);
    CGContextStrokePath(context);
    
    CGContextMoveToPoint(context, 0, self.height);
    CGContextAddLineToPoint(context, self.width, self.height);
    CGContextStrokePath(context);
}

- (void)drawBelowBox {
    [self setNeedsDisplay];
}

@end
