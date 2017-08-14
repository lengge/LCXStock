//
//  LCXTimeLineModel.h
//  LCXStock
//
//  Created by user on 17/5/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCXStockMacro.h"

@interface LCXTimeLineModel : NSObject

/**
 当前价格
 */
@property (nonatomic, copy) NSString *currentPrice;
/**
 当前时间
 */
@property (nonatomic, copy) NSString *currentTime;
/**
 当前成交量
 */
@property (nonatomic, copy) NSString *currentVolume;
/**
 当前成交总额
 */
@property (nonatomic, copy) NSString *currentAmount;
/**
 涨跌
 */
@property (nonatomic, copy) NSString *changeFromPreClose;
/**
 涨跌幅
 */
@property (nonatomic, copy) NSString *percentChangeFromPreClose;

/**
 均价
 */
@property (nonatomic, assign) CGFloat avgPrice;

/**
 计算均价

 @param timeLineModels 分时数组
 */
- (void)calculationAvgPrice:(NSArray *)timeLineModels;

@end
