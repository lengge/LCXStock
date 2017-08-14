//
//  UIColor+LCXStock.m
//  LCXStock
//
//  Created by user on 17/5/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import "UIColor+LCXStock.h"

@implementation UIColor (LCXStock)

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

#pragma mark 所有图表的背景颜色
+(UIColor *)backgroundColor
{
    return [UIColor colorWithRGBHex:0xffffff];
}

#pragma mark 辅助背景色
+(UIColor *)assistBackgroundColor
{
    return [UIColor colorWithRGBHex:0x1d2227];
}

#pragma mark 涨的颜色
+(UIColor *)increaseColor
{
    return [UIColor colorWithRGBHex:0xff5353];
}

#pragma mark 跌的颜色
+(UIColor *)decreaseColor
{
    return [UIColor colorWithRGBHex:0x00b07c];
}

#pragma mark 主文字颜色
+(UIColor *)mainTextColor
{
    return [UIColor colorWithRGBHex:0x999999];
}

#pragma mark 辅助文字颜色
+(UIColor *)assistTextColor
{
    return [UIColor colorWithRGBHex:0x565a64];
}

#pragma mark 分时线下面的成交量线的颜色
+(UIColor *)timeLineVolumeLineColor
{
    return [UIColor colorWithRGBHex:0x2d333a];
}

#pragma mark 分时线界面线的颜色
+(UIColor *)timeLineLineColor
{
    return [UIColor colorWithRGBHex:0x49a5ff];
}

#pragma mark 分时线分割颜色
+(UIColor *)timeLineCuttingLineColor {
    return [UIColor colorWithRGBHex:0xe3e3e3];
}

#pragma mark 长按时线的颜色
+(UIColor *)longPressLineColor
{
    return [UIColor colorWithRGBHex:0x444444];
}

#pragma mark ma5的颜色
+(UIColor *)ma5Color
{
    return [UIColor colorWithRGBHex:0xff783c];
}

#pragma mark ma10的颜色
+(UIColor *)ma10Color
{
    return [UIColor colorWithRGBHex:0x49a5ff];
}

#pragma mark ma20颜色
+(UIColor *)ma20Color
{
    return [UIColor colorWithRGBHex:0xffbf43];
}

#pragma mark ma30颜色
+(UIColor *)ma30Color
{
    return [UIColor colorWithRGBHex:0x49a5ff];
}

+(UIColor *)maskTextColor {
    return [UIColor colorWithRGBHex:0x444444];
}

+(UIColor *)avgLineColor {
    return [UIColor colorWithRGBHex:0xff9900];
}

+(UIColor *)segmentTitleColor {
    return [UIColor colorWithRGBHex:0x4e66a9];
}

@end
