//
//  LCXStockChartGloablVariable.m
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXStockChartGloablVariable.h"
#import "LCXStockChartConstant.h"

/**
 *  K线图的宽度，默认20
 */
static CGFloat HYStockChartKLineWidth = 5;

/**
 *  K线图的间隔，默认1
 */
static CGFloat HYStockChartKLineGap = 1;

static NSString *HYStockChartStockChineseName = nil;
static NSString *HYStockChartStockSymbol = nil;
static HYStockType HYStockChartStockType;

@implementation LCXStockChartGloablVariable

/**
 *  K线图的宽度，默认20
 */
+ (CGFloat)kLineWidth {
    return HYStockChartKLineWidth;
}

+ (void)setkLineWith:(CGFloat)kLineWidth {
    if (kLineWidth > LCXStockChartKLineMaxWidth) {
        kLineWidth = LCXStockChartKLineMaxWidth;
    } else if (kLineWidth < LCXStockChartKLineMinWidth){
        kLineWidth = LCXStockChartKLineMinWidth;
    }
    HYStockChartKLineWidth = kLineWidth;
}

/**
 *  K线图的间隔，默认1
 */
+ (CGFloat)kLineGap {
    return HYStockChartKLineGap;
}

+ (void)setkLineGap:(CGFloat)kLineGap {
    HYStockChartKLineGap = kLineGap;
}

/**
 *  股票中文名
 */
+(NSString *)stockChineseName {
    return HYStockChartStockChineseName;
}

+(void)setStockChineseName:(NSString *)chineseName {
    HYStockChartStockChineseName = chineseName;
}

/**
 *  股票代号
 */
+(NSString *)stockSymbol {
    return HYStockChartStockSymbol;
}

+(void)setStockSymbol:(NSString *)symbol {
    HYStockChartStockSymbol = symbol;
}

/**
 *  股票类型
 */
+(void)setStockType:(HYStockType)stockType {
    HYStockChartStockType = stockType;
}

+(HYStockType)stockType {
    return HYStockChartStockType;
}

@end
