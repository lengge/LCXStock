//
//  UIColor+LCXStock.h
//  LCXStock
//
//  Created by user on 17/5/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LCXStock)

/**
 *  根据十六进制转换成UIColor
 *
 *  @param hex UIColor的十六进制
 *
 *  @return 转换后的结果
 */
+(UIColor *)colorWithRGBHex:(UInt32)hex;


/**
 *  所有图表的背景颜色
 */
+(UIColor *)backgroundColor;

/**
 *  辅助背景色
 */
+(UIColor *)assistBackgroundColor;

/**
 *  涨的颜色
 */
+(UIColor *)increaseColor;


/**
 *  跌的颜色
 */
+(UIColor *)decreaseColor;

/**
 *  主文字颜色
 */
+(UIColor *)mainTextColor;

/**
 *  辅助文字颜色
 */
+(UIColor *)assistTextColor;

/**
 *  分时线下面的成交量线的颜色
 */
+(UIColor *)timeLineVolumeLineColor;

/**
 *  分时线分割线颜色
 */
+(UIColor *)timeLineCuttingLineColor;

/**
 *  分时线界面线的颜色
 */
+(UIColor *)timeLineLineColor;

/**
 *  长按时线的颜色
 */
+(UIColor *)longPressLineColor;

/**
 *  ma5的颜色
 */
+(UIColor *)ma5Color;

/**
 *  ma10的颜色
 */
+(UIColor *)ma10Color;

/**
 *  ma20颜色
 */
+(UIColor *)ma20Color;

/**
 *  ma30颜色
 */
+(UIColor *)ma30Color;

/**
 *  遮罩字体颜色
 */
+(UIColor *)maskTextColor;

/**
 *  均线颜色
 */
+(UIColor *)avgLineColor;

/**
 *  选择器标题颜色
 */
+(UIColor *)segmentTitleColor;

@end
