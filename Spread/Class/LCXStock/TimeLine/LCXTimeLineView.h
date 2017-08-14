//
//  LCXTimeLineView.h
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCXTimeLineGroupModel.h"
#import "LCXStockMacro.h"
#import "LCXStockChartConstant.h"
#import "LCXStockLongPressProtocol.h"

@interface LCXTimeLineView : UIView

@property (nonatomic, strong) LCXTimeLineGroupModel *timeLineGroupModel;

@property (nonatomic, assign) CGFloat aboveViewRatio;

@property (nonatomic, weak) id<LCXStockLongPressProtocol>delegate;

/**
 *  重绘
 */
-(void)reDraw;

@end
