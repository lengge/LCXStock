//
//  LCXStockViewMaskView.h
//  LCXStock
//
//  Created by user on 17/5/26.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCXKLineModel.h"
#import "LCXTimeLineModel.h"
#import "LCXStockChartConstant.h"


/************************显示选中的详细K线信息************************/
@interface LCXStockViewMaskView : UIView

/**
 当前选择的K线模型
 */
@property (nonatomic, strong) LCXKLineModel *kLineModel;

/**
 当前选择的分时线模型
 */
@property (nonatomic, strong) LCXTimeLineModel *timeLineModel;

/**
 线的类型
 */
@property (nonatomic, assign) LCXStocLineType stockLineType;

/**
 小数点位数
 */
@property (nonatomic, assign) NSInteger place;

@end
