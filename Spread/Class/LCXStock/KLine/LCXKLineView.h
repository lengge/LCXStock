//
//  LCXKLineView.h
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCXStockChartConstant.h"
#import "LCXStockLongPressProtocol.h"
#import "LCXKLineGroupModel.h"

/************************展示K线图和数据更新的View************************/
@interface LCXKLineView : UIView

@property (nonatomic, strong) LCXKLineGroupModel *kLineGroupModel;

/**
 *  上面那个view所占的比例
 */
@property (nonatomic, assign) CGFloat aboveViewRatio;

/**
 *  K线类型
 */
@property (nonatomic, assign) LCXStockChartKLineType kLineType;

/**
 代理
 */
@property (nonatomic, weak) id<LCXStockLongPressProtocol> delegate;

/**
 *  重绘
 */
- (void)reDraw;

@end
