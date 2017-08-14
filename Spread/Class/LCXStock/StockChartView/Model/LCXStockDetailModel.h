//
//  LCXStockDetailModel.h
//  LCXStock
//
//  Created by user on 17/5/31.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCXStockDetailModel : NSObject

@property (nonatomic, copy) NSString *symbolname;

@property (nonatomic, copy) NSString *symbol;

@property (nonatomic, copy) NSString *lasttradingdate;

@property (nonatomic, copy) NSString *tradestatustext;

@property (nonatomic, copy) NSString *nowv;

@property (nonatomic, copy) NSString *updown;

@property (nonatomic, copy) NSString *updownrate;

@property (nonatomic, copy) NSString *highp;

@property (nonatomic, copy) NSString *openp;

@property (nonatomic, copy) NSString *lowp;

@property (nonatomic, copy) NSString *preclose;

/**
 波动
 */
@property (nonatomic, copy) NSString *fluctuate;

/**
 涨速
 */
@property (nonatomic, copy) NSString *changespeed;

/**
 买卖涨量
 */
@property (nonatomic, copy) NSString *bids;

/**
 买卖跌量
 */
@property (nonatomic, copy) NSString *asks;

@end
