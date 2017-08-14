//
//  LCXStockChartView.h
//  LCXStock
//
//  Created by user on 17/5/31.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCXStockChartConstant.h"

@class LCXStockDetailModel;
@protocol LCXStockChartViewDataSource;
@interface LCXStockChartView : UIView

@property (nonatomic, strong) NSArray *itemModels;

/**
 *  数据源
 */
@property (nonatomic, weak) id<LCXStockChartViewDataSource>dataSource;

/**
 *  选中的索引
 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;

/**
 *  股票简介模型
 */
@property (nonatomic, strong) LCXStockDetailModel *stockDetailModel;

@property (nonatomic, assign) LCXStockChartKLineType kLineType;

/**
 *  重新加载数据
 */
- (void)reloadData;

@end

/************************数据源************************/
@protocol LCXStockChartViewDataSource <NSObject>

@required
/**
 *  某个index指定的数据
 */
- (id)stockDatasWithIndex:(NSInteger)index;

@end

/************************ItemModel类************************/
@interface LCXStockChartViewItemModel : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) LCXStocLineType lineType;

+ (instancetype)itemModelWithTitle:(NSString *)title lineType:(LCXStocLineType)lineType;

@end
