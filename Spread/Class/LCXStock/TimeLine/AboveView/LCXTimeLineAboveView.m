//
//  LCXTimeLineAboveView.m
//  LCXStock
//
//  Created by user on 17/5/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXTimeLineAboveView.h"
#import "LCXTimeLineGroupModel.h"
#import "LCXStockMacro.h"
#import "LCXTimeLineModel.h"
#import "LCXTimeLineAbovePositionModel.h"
#import "LCXTimeLine.h"
#import "LCXTool.h"

@interface LCXTimeLineAboveView ()

@property (nonatomic, strong) NSArray *positionModels;

@property (nonatomic, strong) NSArray *timeLineModels;
/**
 *  价格最大值
 */
@property (nonatomic, assign) CGFloat priceMaxValue;
/**
 *  价格最小值
 */
@property (nonatomic, assign) CGFloat priceMinValue;
/**
 *  幅度最大值
 */
@property (nonatomic, assign) CGFloat changeFromPreCloseMaxValue;
/**
 *  幅度最小值
 */
@property (nonatomic, assign) CGFloat changeFromPreCloseMinValue;

@end

@implementation LCXTimeLineAboveView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _positionModels = nil;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 画垂直背景线
    [self drawVerticalLine:context];
    // 画水平背景线
    [self drawHorizontalLine:context];

    if (!self.groupModel || !self.timeLineModels) {
        return;
    }
    
    LCXTimeLine *timeLine = [[LCXTimeLine alloc] initWithContext:context];
    timeLine.positionModels = [self private_convertTimeLineModlesToPositionModel];
    [timeLine draw];
    
    // 画最大值最小值
    [self drawMaxAndMinValue:context];
    
    [super drawRect:rect];
}

- (void)drawMaxAndMinValue:(CGContextRef)context {
    // 最大价格
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor increaseColor]};
    NSInteger place = [self.groupModel.place integerValue];
    NSString *text = [NSString stringWithFormat:@"%.f", self.priceMaxValue];
    switch (place) {
        case 1:
            text = [NSString stringWithFormat:@"%.1f", self.priceMaxValue / pow(10, place)];
            break;
        case 2:
            text = [NSString stringWithFormat:@"%.2f", self.priceMaxValue / pow(10, place)];
            break;
        case 3:
            text = [NSString stringWithFormat:@"%.3f", self.priceMaxValue / pow(10, place)];
            break;
        case 4:
            text = [NSString stringWithFormat:@"%.4f", self.priceMaxValue / pow(10, place)];
            break;
            
        default:
            break;
    }
    [text drawAtPoint:CGPointMake(LCXStockChartTextPadding, LCXStockChartTopBottomDrawMargin) withAttributes:attribute];
    // 最大涨幅
    text = [NSString stringWithFormat:@"%.2f%@", self.changeFromPreCloseMaxValue, @"%"];
    CGSize textSize = [LCXTool rectOfNSString:text attribute:attribute].size;
    [text drawAtPoint:CGPointMake(self.width - textSize.width - LCXStockChartTextPadding, LCXStockChartTopBottomDrawMargin) withAttributes:attribute];
    // 最小价格
    attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor decreaseColor]};
    text = [NSString stringWithFormat:@"%.f", self.priceMinValue];
    switch (place) {
        case 1:
            text = [NSString stringWithFormat:@"%.1f", self.priceMinValue / pow(10, place)];
            break;
        case 2:
            text = [NSString stringWithFormat:@"%.2f", self.priceMinValue / pow(10, place)];
            break;
        case 3:
            text = [NSString stringWithFormat:@"%.3f", self.priceMinValue / pow(10, place)];
            break;
        case 4:
            text = [NSString stringWithFormat:@"%.4f", self.priceMinValue / pow(10, place)];
            break;
            
        default:
            break;
    }
    textSize = [LCXTool rectOfNSString:text attribute:attribute].size;
    [text drawAtPoint:CGPointMake(LCXStockChartTextPadding, LCXStockChartTimeLineAboveViewMaxY - LCXStockChartTopBottomDrawMargin - textSize.height) withAttributes:attribute];
    // 最小涨幅
    text = [NSString stringWithFormat:@"%.2f%@", self.changeFromPreCloseMinValue, @"%"];
    textSize = [LCXTool rectOfNSString:text attribute:attribute].size;
    [text drawAtPoint:CGPointMake(self.width - textSize.width - LCXStockChartTextPadding, LCXStockChartTimeLineAboveViewMaxY - LCXStockChartTopBottomDrawMargin - textSize.height) withAttributes:attribute];
}

- (void)drawVerticalLine:(CGContextRef)context {
    // 画左右边框线
    CGContextSetLineWidth(context, LCXStockChartTimeLineLineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor timeLineCuttingLineColor].CGColor);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0, self.height - LCXStockChartTimeLineTimeLabelViewHeight);
    
    CGContextMoveToPoint(context, self.width, 0);
    CGContextAddLineToPoint(context, self.width, self.height - LCXStockChartTimeLineTimeLabelViewHeight);
    CGContextStrokePath(context);
    
    // 如果时间存在，画时间和时间线
    if (!self.groupModel.timeaxisindex) {
        return;
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor mainTextColor]};
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    CGPoint timePosition = CGPointZero;
    CGFloat percent = self.width / [self.groupModel.scount integerValue];
    
    for (int i = 0; i < self.groupModel.timeaxisindex.count; i++) {
        NSString *text = self.groupModel.timeaxistext[i];
        CGSize textSize = [LCXTool rectOfNSString:text attribute:attribute].size;
        if (i == 0) {
            timePosition = CGPointMake(0, self.height - LCXStockChartTimeLineTimeLabelViewHeight);
            [text drawAtPoint:timePosition withAttributes:attribute];
        } else if (i == self.groupModel.timeaxisindex.count - 1) {
            timePosition = CGPointMake(self.width - textSize.width, self.height - LCXStockChartTimeLineTimeLabelViewHeight);
            [text drawAtPoint:timePosition withAttributes:attribute];
        } else {
            CGContextSetStrokeColorWithColor(context, [UIColor timeLineCuttingLineColor].CGColor);
            startPoint = CGPointMake([self.groupModel.timeaxisindex[i] integerValue] * percent, 0);
            endPoint = CGPointMake([self.groupModel.timeaxisindex[i] integerValue] * percent, self.height - LCXStockChartTimeLineTimeLabelViewHeight);
            CGFloat lengths[] = {5, 2};
            CGContextSetLineDash(context, 0, lengths, 2);
            const CGPoint points[] = {startPoint, endPoint};
            CGContextStrokeLineSegments(context, points, 2);
            
            timePosition = CGPointMake(startPoint.x - textSize.width / 2, self.height - LCXStockChartTimeLineTimeLabelViewHeight);
            [text drawAtPoint:timePosition withAttributes:attribute];
        }
    }
}

- (void)drawHorizontalLine:(CGContextRef)context {
    CGContextSetStrokeColorWithColor(context, [UIColor timeLineCuttingLineColor].CGColor);
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

#pragma mark groupModel的set方法
- (void)setGroupModel:(LCXTimeLineGroupModel *)groupModel {
    _groupModel = groupModel;
    
    self.timeLineModels = groupModel.timeModels;
}

#pragma mark - 公有方法
#pragma mark 画时分线的方法
- (void)drawAboveView {
    NSAssert(self.timeLineModels, @"timeLineModels不能为空!");
    [self setNeedsDisplay];
}

#pragma mark 长按的时候根据原始的x的位置获得精确的X的位置
- (CGPoint)getRightXPositionWithOriginXPosition:(CGFloat)originXPosition {
    NSAssert(_positionModels, @"位置数组不能为空!");
    CGFloat gap = 0.6;
    if (self.positionModels.count > 1) {
        LCXTimeLineAbovePositionModel *firstModel = [self.positionModels firstObject];
        LCXTimeLineAbovePositionModel *secondModel = self.positionModels[1];
        gap = (secondModel.currentPoint.x - firstModel.currentPoint.x) / 2;
    }
    NSInteger idx = 0;
    for (LCXTimeLineAbovePositionModel *positionModel in self.positionModels) {
        if (originXPosition < positionModel.currentPoint.x + gap && originXPosition > positionModel.currentPoint.x - gap) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(timeLineAboveView:longPressTimeLineModel:)]) {
                [self.delegate timeLineAboveView:self longPressTimeLineModel:self.timeLineModels[idx]];
            }
            return positionModel.currentPoint;
        }
        idx++;
    }
    //这里必须为负数，没有找到的合适的位置，竖线就返回这个位置。
    return CGPointZero;
}

#pragma mark - 私有方法
#pragma mark 将LCXTimeLineModel转换成对应的position模型
- (NSArray *)private_convertTimeLineModlesToPositionModel {
    NSAssert(self.timeLineModels, @"timeLineModels不能为空!");
    //1.算y轴的单元值
    self.priceMaxValue = CGFLOAT_MIN;
    self.priceMinValue = CGFLOAT_MAX;
    self.changeFromPreCloseMaxValue = CGFLOAT_MIN;
    self.changeFromPreCloseMinValue = CGFLOAT_MAX;
    [self.timeLineModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LCXTimeLineModel *timeLineModel = (LCXTimeLineModel *)obj;
        // 价格的最大值和最小值
        if ([timeLineModel.currentPrice floatValue] < self.priceMinValue) {
            self.priceMinValue = [timeLineModel.currentPrice floatValue];
        }
        if ([timeLineModel.currentPrice floatValue] > self.priceMaxValue) {
            self.priceMaxValue = [timeLineModel.currentPrice floatValue];
        }
        // 涨幅的最大值和最小值
        if ([timeLineModel.percentChangeFromPreClose floatValue] > self.changeFromPreCloseMaxValue ) {
            self.changeFromPreCloseMaxValue = [timeLineModel.percentChangeFromPreClose floatValue];
        }
        if ([timeLineModel.percentChangeFromPreClose floatValue] < self.changeFromPreCloseMinValue) {
            self.changeFromPreCloseMinValue = [timeLineModel.percentChangeFromPreClose floatValue];
        }
    }];
    //改变最大值和最小值
    [self changeMaxAndMinValue];
    
    CGFloat minY = LCXStockChartTopBottomDrawMargin;
    CGFloat maxY = LCXStockChartTimeLineAboveViewMaxY - LCXStockChartTopBottomDrawMargin;
    CGFloat yUnitValue = (self.priceMaxValue - self.priceMinValue) / (maxY - minY);
    
    //2.算出x轴的单元值
    CGFloat xUnitValue = LCXStockChartTimeLineAboveViewMaxX / [self.groupModel.scount integerValue];
    
    //转换成posisiton的模型
    NSMutableArray *positionArray = [NSMutableArray array];
    
    CGFloat xPosition = 0;
    CGFloat yPosition = 0;
    CGFloat avgPositionY = 0;
    NSInteger idx = 0;
    for (LCXTimeLineModel *timeLineModel in self.timeLineModels) {
        //每分钟一次数据
        xPosition = xUnitValue * idx;
        yPosition = maxY - ([timeLineModel.currentPrice floatValue] - self.priceMinValue) / yUnitValue;
        
        NSAssert(!isnan(xPosition)&&!isnan(yPosition), @"x或y出现NAN值!");
        
        LCXTimeLineAbovePositionModel *positionModel = [LCXTimeLineAbovePositionModel new];
        positionModel.currentPoint = CGPointMake(xPosition, yPosition);
        [positionArray addObject:positionModel];
        
        if (self.groupModel.isDrawAvg) {
            avgPositionY = maxY - (timeLineModel.avgPrice - self.priceMinValue) / yUnitValue;
            positionModel.avgPoint = CGPointMake(xPosition, avgPositionY);
            positionModel.isDrawAvg = self.groupModel.isDrawAvg;
        }
        
        idx++;
    }
    _positionModels = positionArray;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeLineAboveView:positionModels:)]) {
        [self.delegate timeLineAboveView:self positionModels:positionArray];
    }
    return positionArray;
}

#pragma mark - 改变最大值和最小值
- (void)changeMaxAndMinValue {
    CGFloat average = [self.groupModel.preclose floatValue] * pow(10, [self.groupModel.place integerValue]);
    if (self.priceMaxValue == self.priceMinValue && self.priceMaxValue == average) {
        //处理特殊情况
        if (self.priceMaxValue == 0) {
            self.priceMaxValue = 0.00001;
            self.priceMinValue = -0.00001;
        } else {
            self.priceMaxValue = self.priceMaxValue * 2;
            self.priceMinValue = 0.01;
        }
    } else {
        if (ABS(self.priceMaxValue - average) >= ABS(average - self.priceMinValue)) {
            self.priceMinValue = 2 * average - self.priceMaxValue;
        }
        if (ABS(self.priceMaxValue - average) < ABS(average - self.priceMinValue)) {
            self.priceMaxValue = 2 * average - self.priceMinValue;
        }
    }
    
    if (ABS(self.changeFromPreCloseMaxValue) > ABS(self.changeFromPreCloseMinValue)) {
        self.changeFromPreCloseMinValue = -self.changeFromPreCloseMaxValue;
    } else {
        self.changeFromPreCloseMaxValue = -self.changeFromPreCloseMinValue;
    }
}

@end
