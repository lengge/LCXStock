//
//  LCXStockChartConstant.m
//  LCXStock
//
//  Created by user on 17/5/22.
//  Copyright © 2017年 user. All rights reserved.
//

#ifndef __LCXStockChartConstant__M__
#define __LCXStockChartConstant__M__
#import <UIKit/UIKit.h>

/**
 *  K线图需要加载更多数据的通知
 */
NSString * const LCXStockChartKLineNeedLoadMoreDataNotification = @"LCXStockChartKLineNeedLoadMoreDataNotification";

/**
 *  K线图Y的View的宽度
 */
CGFloat const LCXStockChartKLinePriceViewWidth = 50;

/**
 *  K线图的X的View的高度
 */
CGFloat const LCXStockChartKLineTimeViewHeight = 12;

/**
 *  绘图开始的上下内边距
 */
CGFloat const LCXStockChartTopBottomDrawMargin = 5;

/**
 *  K线最大的宽度
 */
CGFloat const LCXStockChartKLineMaxWidth = 27;

/**
 *  K线图最小的宽度
 */
CGFloat const LCXStockChartKLineMinWidth = 2;

/**
 *  K线图缩放界限
 */
CGFloat const LCXStockChartScaleBound = 0.03;

/**
 *  K线的缩放因子
 */
CGFloat const LCXStockChartScaleFactor = 0.03;

/**
 *  UIScrollView的contentOffset属性
 */
NSString * const LCXStockChartContentOffsetKey = @"contentOffset";

/**
 *  时分线的宽度
 */
CGFloat const LCXStockChartTimeLineLineWidth = 0.5;

/**
 *  时分线图的Above上最小的X
 */
CGFloat const LCXStockChartTimeLineAboveViewMinX = 0.0;

/**
 *  分时线的timeLabelView的高度
 */
CGFloat const LCXStockChartTimeLineTimeLabelViewHeight = 12;

/**
 *  时分线的成交量的线宽
 */
CGFloat const LCXStockChartTimeLineVolumeLineWidth = 0.5;

/**
 *  长按时的线的宽度
 */
CGFloat const LCXStockChartLongPressVerticalViewWidth = 0.5;

/**
 *  K线选中的日期高度
 */
CGFloat const LCXStockChartKLineSelectedDateHeight = 11;

/**
 *  文字内边距
 */
CGFloat const LCXStockChartTextPadding = 2;

/**
 *  MA线的宽度
 */
CGFloat const LCXStockChartMALineWidth = 1;


/**
 *  所有profileView的高度
 */
CGFloat const LCXStockChartProfileViewHeight = 50;


#endif
