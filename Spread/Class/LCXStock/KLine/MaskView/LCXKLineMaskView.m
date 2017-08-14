//
//  LCXKLineMaskView.m
//  LCXStock
//
//  Created by user on 17/5/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLineMaskView.h"
#import "UIColor+LCXStock.h"
#import "LCXStockChartConstant.h"
#import "LCXTool.h"
#import "NSDate+Helper.h"

@implementation LCXKLineMaskView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (!self.kLineModel || !self.kLinePositionModel) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, LCXStockChartLongPressVerticalViewWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor longPressLineColor].CGColor);
    
    CGFloat x = self.stockScrollView.frame.origin.x + self.kLinePositionModel.closePoint.x - self.stockScrollView.contentOffset.x;
    //绘制横线
    CGContextMoveToPoint(context, self.stockScrollView.frame.origin.x, self.stockScrollView.frame.origin.y + self.kLinePositionModel.closePoint.y + LCXStockChartKLineSelectedDateHeight);
    CGContextAddLineToPoint(context, self.stockScrollView.frame.origin.x + self.stockScrollView.frame.size.width, self.stockScrollView.frame.origin.y + self.kLinePositionModel.closePoint.y + LCXStockChartKLineSelectedDateHeight);
    
    //绘制竖线
    CGContextMoveToPoint(context, x, self.stockScrollView.frame.origin.y + LCXStockChartKLineSelectedDateHeight);
    CGContextAddLineToPoint(context, x, self.stockScrollView.frame.origin.y + self.stockScrollView.bounds.size.height  + LCXStockChartKLineSelectedDateHeight);
    CGContextStrokePath(context);
    
    //绘制选中日期
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSDate *date = [NSDate dateFromString:self.kLineModel.timestamp withFormat:@"yyyyMMddHHmmss"];
    NSString *dayText = [date stringWithFormat:@"yyyy-MM-dd"];
    if (self.kLineType == LCXStockChartKLineTypeOneMinute || self.kLineType == LCXStockChartKLineTypeFiveMinute) {
        dayText = [date stringWithFormat:@"MM-dd HH:mm"];
    }
    CGSize daySzie = [LCXTool rectOfNSString:dayText attribute:attribute].size;
    
    if ((x - (daySzie.width / 2 + LCXStockChartTextPadding)) < self.stockScrollView.frame.origin.x) {
        CGContextSetFillColorWithColor(context, [UIColor mainTextColor].CGColor);
        CGContextFillRect(context, CGRectMake(0, self.stockScrollView.frame.origin.y, daySzie.width + LCXStockChartTextPadding * 2, daySzie.height));
        [dayText drawAtPoint:CGPointMake(LCXStockChartTextPadding, self.stockScrollView.frame.origin.y) withAttributes:attribute];
    } else if ((x + daySzie.width / 2 + LCXStockChartTextPadding) > self.stockScrollView.frame.size.width) {
        CGContextSetFillColorWithColor(context, [UIColor mainTextColor].CGColor);
        CGContextFillRect(context, CGRectMake(self.stockScrollView.frame.size.width - LCXStockChartTextPadding * 2 - daySzie.width, self.stockScrollView.frame.origin.y, daySzie.width + LCXStockChartTextPadding * 2, daySzie.height));
        [dayText drawAtPoint:CGPointMake(self.stockScrollView.frame.size.width - LCXStockChartTextPadding - daySzie.width, self.stockScrollView.frame.origin.y) withAttributes:attribute];
    } else {
        CGContextSetFillColorWithColor(context, [UIColor mainTextColor].CGColor);
        CGContextFillRect(context, CGRectMake(x - daySzie.width / 2, self.stockScrollView.frame.origin.y, daySzie.width + LCXStockChartTextPadding * 2, daySzie.height));
        [dayText drawAtPoint:CGPointMake(x - daySzie.width / 2 + LCXStockChartTextPadding, self.stockScrollView.frame.origin.y) withAttributes:attribute];
    }
    
    //绘制选中价格
    NSString *priceText = [NSString stringWithFormat:@"%.3f", [self.kLineModel.preclose floatValue] / 1000];
    CGSize priceSize = [LCXTool rectOfNSString:priceText attribute:attribute].size;
    CGContextSetFillColorWithColor(context, [UIColor mainTextColor].CGColor);
    CGContextFillRect(context, CGRectMake(self.stockScrollView.frame.origin.x, self.stockScrollView.frame.origin.y + self.kLinePositionModel.closePoint.y - priceSize.height / 2 + LCXStockChartKLineSelectedDateHeight, priceSize.width + LCXStockChartTextPadding * 2, priceSize.height));
    [priceText drawAtPoint:CGPointMake(LCXStockChartTextPadding, self.stockScrollView.frame.origin.y + self.kLinePositionModel.closePoint.y - priceSize.height / 2 + LCXStockChartKLineSelectedDateHeight) withAttributes:attribute];
    
    // 绘制MA
    [self drawMA:context];
}

- (void)drawMA:(CGContextRef)context {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor ma20Color],NSBackgroundColorAttributeName:[UIColor whiteColor]};
    NSString *drawText = [NSString stringWithFormat:@"•M20 %.f", self.kLineModel.MA20];
    switch (self.place) {
        case 1:
            drawText = [NSString stringWithFormat:@"•M20 %.1f", self.kLineModel.MA20 / pow(10, self.place)];
            break;
        case 2:
            drawText = [NSString stringWithFormat:@"•M20 %.2f", self.kLineModel.MA20 / pow(10, self.place)];
            break;
        case 3:
            drawText = [NSString stringWithFormat:@"•M20 %.3f", self.kLineModel.MA20 / pow(10, self.place)];
            break;
        case 4:
            drawText = [NSString stringWithFormat:@"•M20 %.4f", self.kLineModel.MA20 / pow(10, self.place)];
            break;
            
        default:
            break;
    }
    CGSize MA20Size = [LCXTool rectOfNSString:drawText attribute:attribute].size;
    [drawText drawAtPoint:CGPointMake(self.stockScrollView.frame.size.width - MA20Size.width - LCXStockChartTextPadding, LCXStockChartKLineSelectedDateHeight + LCXStockChartTopBottomDrawMargin) withAttributes:attribute];
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor ma10Color],NSBackgroundColorAttributeName:[UIColor whiteColor]};
    drawText = [NSString stringWithFormat:@"•M10 %.f", self.kLineModel.MA10];
    switch (self.place) {
        case 1:
            drawText = [NSString stringWithFormat:@"•M10 %.1f", self.kLineModel.MA10 / pow(10, self.place)];
            break;
        case 2:
            drawText = [NSString stringWithFormat:@"•M10 %.2f", self.kLineModel.MA10 / pow(10, self.place)];
            break;
        case 3:
            drawText = [NSString stringWithFormat:@"•M10 %.3f", self.kLineModel.MA10 / pow(10, self.place)];
            break;
        case 4:
            drawText = [NSString stringWithFormat:@"•M10 %.4f", self.kLineModel.MA10 / pow(10, self.place)];
            break;
            
        default:
            break;
    }
    CGSize MA10Size = [LCXTool rectOfNSString:drawText attribute:attribute].size;
    [drawText drawAtPoint:CGPointMake(self.stockScrollView.frame.size.width - MA20Size.width - MA10Size.width - LCXStockChartTextPadding * 2, LCXStockChartKLineSelectedDateHeight + LCXStockChartTopBottomDrawMargin) withAttributes:attribute];
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor ma5Color],NSBackgroundColorAttributeName:[UIColor whiteColor]};
    drawText = [NSString stringWithFormat:@"•MA5 %.f", self.kLineModel.MA5];
    switch (self.place) {
        case 1:
            drawText = [NSString stringWithFormat:@"•MA5 %.1f", self.kLineModel.MA5 / pow(10, self.place)];
            break;
        case 2:
            drawText = [NSString stringWithFormat:@"•MA5 %.2f", self.kLineModel.MA5 / pow(10, self.place)];
            break;
        case 3:
            drawText = [NSString stringWithFormat:@"•MA5 %.3f", self.kLineModel.MA5 / pow(10, self.place)];
            break;
        case 4:
            drawText = [NSString stringWithFormat:@"•MA5 %.4f", self.kLineModel.MA5 / pow(10, self.place)];
            break;
            
        default:
            break;
    }
    CGSize MA5Size = [LCXTool rectOfNSString:drawText attribute:attribute].size;
    [drawText drawAtPoint:CGPointMake(self.stockScrollView.frame.size.width - MA20Size.width - MA10Size.width - MA5Size.width - LCXStockChartTextPadding * 3, LCXStockChartKLineSelectedDateHeight + LCXStockChartTopBottomDrawMargin) withAttributes:attribute];
}

- (void)drawMaskView {
    NSAssert(self.kLineModel && self.kLinePositionModel, @"kLineModel和kLinePositionModel不能为空!");
    [self setNeedsDisplay];
}

@end
