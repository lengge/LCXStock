//
//  LCXStockChartConstant.h
//  LCXStock
//
//  Created by user on 17/5/22.
//  Copyright © 2017年 user. All rights reserved.
//

#ifndef __LCXStockChartConstant__H__
#define __LCXStockChartConstant__H__
#import <UIKit/UIKit.h>

/**
 *  K线图需要加载更多数据的通知
 */
extern NSString * const LCXStockChartKLineNeedLoadMoreDataNotification;

/**
 *  K线图Price的View的宽度
 */
extern CGFloat const LCXStockChartKLinePriceViewWidth;

/**
 *  K线图的Time的View的高度
 */
extern CGFloat const LCXStockChartKLineTimeViewHeight;

/**
 *  绘图开始的上下内边距
 */
extern CGFloat const LCXStockChartTopBottomDrawMargin;

/**
 *  K线最大的宽度
 */
extern CGFloat const LCXStockChartKLineMaxWidth;

/**
 *  K线图最小的宽度
 */
extern CGFloat const LCXStockChartKLineMinWidth;

/**
 *  UIScrollView的contentOffset属性
 */
extern NSString * const LCXStockChartContentOffsetKey;

/**
 *  K线图缩放界限
 */
extern CGFloat const LCXStockChartScaleBound;

/**
 *  K线的缩放因子
 */
extern CGFloat const LCXStockChartScaleFactor;

/**
 *  K线图上可画区域最小的Y
 */
#define LCXStockChartKLineAboveViewMinY 20

/**
 *  K线图上可画区域最大的Y
 */
#define LCXStockChartKLineAboveViewMaxY (self.frame.size.height-LCXStockChartKLineTimeViewHeight)

/**
 *  K线图的成交量上最小的Y
 */
#define LCXStockChartKLineBelowViewMinY 0

/**
 *  K线图的成交量最大的Y
 */
#define LCXStockChartKLineBelowViewMaxY (self.frame.size.height)


/**
 *  时分线图的Above上最小的Y
 */
#define LCXStockChartTimeLineAboveViewMinY 0

/**
 *  时分线图的Above上最大的Y
 */
#define LCXStockChartTimeLineAboveViewMaxY (self.frame.size.height-LCXStockChartTimeLineTimeLabelViewHeight)

/**
 *  时分线图的Above上最小的X
 */
extern CGFloat const LCXStockChartTimeLineAboveViewMinX;

/**
 *  时分线的宽度
 */
extern CGFloat const LCXStockChartTimeLineLineWidth;

/**
 *  时分线图的Above上最大的Y
 */
#define LCXStockChartTimeLineAboveViewMaxX (self.frame.size.width)

/**
 *  时分线图的Below上最小的Y
 */
#define LCXStockChartTimeLineBelowViewMinY 0

/**
 *  时分线图的Below上最大的Y
 */
#define LCXStockChartTimeLineBelowViewMaxY (self.frame.size.height)

/**
 *  时分线图的Below最大的X
 */
#define LCXStockChartTimeLineBelowViewMaxX (self.frame.size.width)

/**
 * 时分线图的Below最小的X
 */
#define LCXStockChartTimeLineBelowViewMinX 0

/**
 *  时分线的成交量的线宽
 */
extern CGFloat const LCXStockChartTimeLineVolumeLineWidth;

/**
 *  分时线的timeLabelView的高度
 */
extern CGFloat const LCXStockChartTimeLineTimeLabelViewHeight;

/**
 *  长按时的线的宽度
 */
extern CGFloat const LCXStockChartLongPressVerticalViewWidth;

/**
 *  K线选中的日期高度
 */
extern CGFloat const LCXStockChartKLineSelectedDateHeight;

/**
 *  文字内边距
 */
extern CGFloat const LCXStockChartTextPadding;

/**
 *  MA线的宽度
 */
extern CGFloat const LCXStockChartMALineWidth;

/**
 *  所有profileView的高度
 */
extern CGFloat const LCXStockChartProfileViewHeight;

//枚举
typedef NS_ENUM(NSUInteger, LCXStockChartKLineType){
    LCXStockChartKLineTypeDay = 1,      //日K线
    LCXStockChartKLineTypeOneMinute,    //一分钟K线
    LCXStockChartKLineTypeFiveMinute    //五分钟K线
};

typedef NS_ENUM(NSInteger, LCXStocLineType) {
    LCXStocLineTypeKLine = 1,  //K线
    LCXStocLineTypeTimeLine,   //分时图
    LCXStocLineTypeOther
};

//Accessory指标种类
typedef NS_ENUM(NSInteger, LCXStockTargetLineStatus) {
    LCXStockTargetLineStatusMACD = 100,    //MACD线
    LCXStockTargetLineStatusKDJ,    //KDJ线
    LCXStockTargetLineStatusAccessoryClose,    //关闭Accessory线
    LCXStockTargetLineStatusMA , //MA线
    LCXStockTargetLineStatusEMA,  //EMA线
    LCXStockTargetLineStatusCloseMA  //MA关闭线
};

#endif
