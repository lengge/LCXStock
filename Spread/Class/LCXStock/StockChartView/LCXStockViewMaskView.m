//
//  LCXStockViewMaskView.m
//  LCXStock
//
//  Created by user on 17/5/26.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXStockViewMaskView.h"
#import "UIColor+LCXStock.h"
#import "LCXTool.h"

@interface LCXStockViewMaskView ()

@end

@implementation LCXStockViewMaskView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    //绘制背景
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
    //绘制底部线条
    CGContextSetStrokeColorWithColor(context, [UIColor timeLineCuttingLineColor].CGColor);
    const CGPoint point[] = {CGPointMake(0, rect.size.height), CGPointMake(rect.size.width, rect.size.height)};
    CGContextStrokeLineSegments(context, point, 2);
    
    switch (self.stockLineType) {
        case LCXStocLineTypeKLine:
            if (!self.kLineModel) {
                return;
            }
            [self drawKLineMask:context rect:rect];
            break;
        case LCXStocLineTypeTimeLine:
            if (!self.timeLineModel) {
                return;
            }
            [self drawTimeLineMask:context rect:rect];
            break;
            
        default:
            break;
    }
}

#pragma mark - 画K线遮罩
- (void)drawKLineMask:(CGContextRef)context rect:(CGRect)rect {
    CGFloat x = 0;

    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor maskTextColor]};
    NSString *drawText = [NSString stringWithFormat:@"开 %.f  高 %.f  低 %.f  收 %.f  涨跌", [self.kLineModel.openp floatValue], [self.kLineModel.highp floatValue], [self.kLineModel.lowp floatValue], [self.kLineModel.preclose floatValue]];
    
    switch (self.place) {
        case 1:
            drawText = [NSString stringWithFormat:@"开 %.1f  高 %.1f  低 %.1f  收 %.1f  涨跌", [self.kLineModel.openp floatValue]/pow(10, self.place), [self.kLineModel.highp floatValue]/pow(10, self.place), [self.kLineModel.lowp floatValue]/pow(10, self.place), [self.kLineModel.preclose floatValue]/pow(10, self.place)];
            break;
        case 2:
            drawText = [NSString stringWithFormat:@"开 %.2f  高 %.2f  低 %.2f  收 %.2f  涨跌", [self.kLineModel.openp floatValue]/pow(10, self.place), [self.kLineModel.highp floatValue]/pow(10, self.place), [self.kLineModel.lowp floatValue]/pow(10, self.place), [self.kLineModel.preclose floatValue]/pow(10, self.place)];
            break;
        case 3:
            drawText = [NSString stringWithFormat:@"开 %.3f  高 %.3f  低 %.3f  收 %.3f  涨跌", [self.kLineModel.openp floatValue]/pow(10, self.place), [self.kLineModel.highp floatValue]/pow(10, self.place), [self.kLineModel.lowp floatValue]/pow(10, self.place), [self.kLineModel.preclose floatValue]/pow(10, self.place)];
            break;
        case 4:
            drawText = [NSString stringWithFormat:@"开 %.4f  高 %.4f  低 %.4f  收 %.4f  涨跌", [self.kLineModel.openp floatValue]/pow(10, self.place), [self.kLineModel.highp floatValue]/pow(10, self.place), [self.kLineModel.lowp floatValue]/pow(10, self.place), [self.kLineModel.preclose floatValue]/pow(10, self.place)];
            break;
            
        default:
            break;
    }
    CGSize textSize = [LCXTool rectOfNSString:drawText attribute:attribute].size;
    [drawText drawAtPoint:CGPointMake(x, (rect.size.height - textSize.height) / 2) withAttributes:attribute];
    x = textSize.width;
    
    if ([self.kLineModel.changeFromLastClose floatValue] < 0.f) {
        attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor decreaseColor]};
    } else {
        attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor increaseColor]};
    }
    drawText = [NSString stringWithFormat:@"(%@ %@)", self.kLineModel.changeFromLastClose, self.kLineModel.percentChangeFromLastClose];
    textSize = [LCXTool rectOfNSString:drawText attribute:attribute].size;
    [drawText drawAtPoint:CGPointMake(x, (rect.size.height - textSize.height) / 2) withAttributes:attribute];
}

#pragma mark - 画分时线遮罩
- (void)drawTimeLineMask:(CGContextRef)context rect:(CGRect)rect {
    CGFloat x = 0;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor maskTextColor]};
    NSString *drawText = [NSString stringWithFormat:@"%.f", [self.timeLineModel.currentPrice floatValue]];
    switch (self.place) {
        case 1:
            drawText = [NSString stringWithFormat:@"%.3f", [self.timeLineModel.currentPrice floatValue]/pow(10, self.place)];
            break;
        case 2:
            drawText = [NSString stringWithFormat:@"%.3f", [self.timeLineModel.currentPrice floatValue]/pow(10, self.place)];
            break;
        case 3:
            drawText = [NSString stringWithFormat:@"%.3f", [self.timeLineModel.currentPrice floatValue]/pow(10, self.place)];
            break;
        case 4:
            drawText = [NSString stringWithFormat:@"%.3f", [self.timeLineModel.currentPrice floatValue]/pow(10, self.place)];
            break;
            
        default:
            break;
    }
    CGSize textSize = [LCXTool rectOfNSString:drawText attribute:attribute].size;
    [drawText drawAtPoint:CGPointMake(0, (rect.size.height - textSize.height) / 2) withAttributes:attribute];
    x += textSize.width;
    
    if ([self.timeLineModel.changeFromPreClose floatValue] < 0.f) {
        attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor decreaseColor]};
    } else {
        attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor increaseColor]};
    }
    drawText = [NSString stringWithFormat:@"(%@ %@)", self.timeLineModel.changeFromPreClose, self.timeLineModel.percentChangeFromPreClose];
    textSize = [LCXTool rectOfNSString:drawText attribute:attribute].size;
    [drawText drawAtPoint:CGPointMake(x, (rect.size.height - textSize.height) / 2) withAttributes:attribute];
    x += textSize.width;
    
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor maskTextColor]};
    drawText = [NSString stringWithFormat:@"  均价 %.f  成交量", self.timeLineModel.avgPrice];
    switch (self.place) {
        case 1:
            drawText = [NSString stringWithFormat:@"  均价 %.3f  成交量", self.timeLineModel.avgPrice / pow(10, self.place)];
            break;
        case 2:
            drawText = [NSString stringWithFormat:@"  均价 %.3f  成交量", self.timeLineModel.avgPrice / pow(10, self.place)];
            break;
        case 3:
            drawText = [NSString stringWithFormat:@"  均价 %.3f  成交量", self.timeLineModel.avgPrice / pow(10, self.place)];
            break;
        case 4:
            drawText = [NSString stringWithFormat:@"  均价 %.3f  成交量", self.timeLineModel.avgPrice / pow(10, self.place)];
            break;
            
        default:
            break;
    }
    textSize = [LCXTool rectOfNSString:drawText attribute:attribute].size;
    [drawText drawAtPoint:CGPointMake(x, (rect.size.height - textSize.height) / 2) withAttributes:attribute];
    x += textSize.width;
    
    if ([self.timeLineModel.changeFromPreClose floatValue] < 0.f) {
        attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor decreaseColor]};
    } else {
        attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:10],NSForegroundColorAttributeName:[UIColor increaseColor]};
    }
    drawText = self.timeLineModel.currentVolume;
    textSize = [LCXTool rectOfNSString:drawText attribute:attribute].size;
    [drawText drawAtPoint:CGPointMake(x, (rect.size.height - textSize.height) / 2) withAttributes:attribute];
}

@end
