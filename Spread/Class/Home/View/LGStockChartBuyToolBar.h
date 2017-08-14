//
//  LGStockChartBuyToolBar.h
//  Spread
//
//  Created by user on 17/6/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCXStockDetailModel;
@protocol LGStockChartBuyToolBarDelegate;
@interface LGStockChartBuyToolBar : UIView

@property (nonatomic, strong) LCXStockDetailModel *stockDetailModel;

@property (nonatomic, weak) id<LGStockChartBuyToolBarDelegate>delegate;

@end

@protocol LGStockChartBuyToolBarDelegate <NSObject>

@optional
- (void)buyToolBar:(LGStockChartBuyToolBar *)buyToolBar buyButtonClicked:(UIButton *)button;

@end
