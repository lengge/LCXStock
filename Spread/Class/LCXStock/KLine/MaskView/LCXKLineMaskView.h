//
//  LCXKLineMaskView.h
//  LCXStock
//
//  Created by user on 17/5/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCXKLinePositionModel.h"
#import "LCXKLineModel.h"
#import "LCXStockChartConstant.h"

@interface LCXKLineMaskView : UIView

/**
 当前选中的K线模型
 */
@property (nonatomic, strong) LCXKLineModel *kLineModel;

/**
 当前选中的位置模型
 */
@property (nonatomic, strong) LCXKLinePositionModel *kLinePositionModel;

/**
 *  K线类型
 */
@property (nonatomic, assign) LCXStockChartKLineType kLineType;

/**
 当前的滑动scrollview
 */
@property (nonatomic, strong) UIScrollView *stockScrollView;

/**
 小数点位数
 */
@property (nonatomic, assign) NSInteger place;

- (void)drawMaskView;

@end
