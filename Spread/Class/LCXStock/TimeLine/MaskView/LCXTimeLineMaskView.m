//
//  LCXTimeLineMaskView.m
//  LCXStock
//
//  Created by user on 17/5/26.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXTimeLineMaskView.h"
#import "UIColor+LCXStock.h"
#import "LCXStockChartConstant.h"
#import "LCXTool.h"
#import "NSDate+Helper.h"

@implementation LCXTimeLineMaskView

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
    
    if (!self.timeLineModel) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, LCXStockChartLongPressVerticalViewWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor longPressLineColor].CGColor);
    
    //绘制横线
    CGContextMoveToPoint(context, 0, self.timeLinePosition.y + LCXStockChartKLineSelectedDateHeight);
    CGContextAddLineToPoint(context, self.width, self.timeLinePosition.y + LCXStockChartKLineSelectedDateHeight);
    
    //绘制竖线
    CGContextMoveToPoint(context, self.timeLinePosition.x, LCXStockChartKLineSelectedDateHeight);
    CGContextAddLineToPoint(context, self.timeLinePosition.x, self.height);
    CGContextStrokePath(context);
    
    //绘制选中时间
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSDate *date = [NSDate dateFromString:self.timeLineModel.currentTime withFormat:@"yyyyMMddHHmmss"];
    NSString *timeText = [date stringWithFormat:@"HH:mm"];
    CGSize timeSzie = [LCXTool rectOfNSString:timeText attribute:attribute].size;

    if (self.timeLinePosition.x - (timeSzie.width / 2 + LCXStockChartTextPadding) < 0) {
        CGContextSetFillColorWithColor(context, [UIColor mainTextColor].CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, timeSzie.width + LCXStockChartTextPadding * 2, timeSzie.height));
        [timeText drawAtPoint:CGPointMake(LCXStockChartTextPadding, 0) withAttributes:attribute];
    } else if (self.timeLinePosition.x + timeSzie.width / 2 + LCXStockChartTextPadding > self.width) {
        CGContextSetFillColorWithColor(context, [UIColor mainTextColor].CGColor);
        CGContextFillRect(context, CGRectMake(self.width - LCXStockChartTextPadding * 2 - timeSzie.width, 0, timeSzie.width + LCXStockChartTextPadding * 2, timeSzie.height));
        [timeText drawAtPoint:CGPointMake(self.width - LCXStockChartTextPadding - timeSzie.width, 0) withAttributes:attribute];
    } else {
        CGContextSetFillColorWithColor(context, [UIColor mainTextColor].CGColor);
        CGContextFillRect(context, CGRectMake(self.timeLinePosition.x - timeSzie.width / 2, 0, timeSzie.width + LCXStockChartTextPadding * 2, timeSzie.height));
        [timeText drawAtPoint:CGPointMake(self.timeLinePosition.x - timeSzie.width / 2 + LCXStockChartTextPadding, 0) withAttributes:attribute];
    }
    
    //绘制选中价格
    NSString *priceText = [NSString stringWithFormat:@"%.3f", [self.timeLineModel.currentPrice floatValue] / 1000];
    CGSize priceSize = [LCXTool rectOfNSString:priceText attribute:attribute].size;
    CGContextSetFillColorWithColor(context, [UIColor mainTextColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, self.timeLinePosition.y - priceSize.height / 2 + LCXStockChartKLineSelectedDateHeight, priceSize.width + LCXStockChartTextPadding * 2, priceSize.height));
    [priceText drawAtPoint:CGPointMake(LCXStockChartTextPadding, self.timeLinePosition.y - priceSize.height / 2 + LCXStockChartKLineSelectedDateHeight) withAttributes:attribute];
}

- (void)drawMaskView {
    NSAssert(self.timeLineModel, @"timeLineModel不能为空!");
    [self setNeedsDisplay];
}

@end
