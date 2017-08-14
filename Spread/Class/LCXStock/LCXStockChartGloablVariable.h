//
//  LCXStockChartGloablVariable.h
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HYStockType)
{
    HYStockTypeUSA,   //美股
    HYStockTypeA,     //A股
    HYStockTypeHK,    //港股
};

@interface LCXStockChartGloablVariable : NSObject

/**
 *  K线图的宽度，默认20
 */
+ (CGFloat)kLineWidth;
+ (void)setkLineWith:(CGFloat)kLineWidth;

/**
 *  K线图的间隔，默认1
 */
+ (CGFloat)kLineGap;
+ (void)setkLineGap:(CGFloat)kLineGap;

/**
 *  股票中文名
 */
+ (NSString *)stockChineseName;
+ (void)setStockChineseName:(NSString *)chineseName;

/**
 *  股票代号
 */
+ (NSString *)stockSymbol;
+ (void)setStockSymbol:(NSString *)symbol;

/**
 *  股票类型
 */
+ (HYStockType)stockType;
+ (void)setStockType:(HYStockType)stockType;

@end
