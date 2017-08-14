//
//  LCXTimeLineGroupModel.h
//  LCXStock
//
//  Created by user on 17/5/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCXTimeLineModel.h"

@interface LCXTimeLineGroupModel : NSObject

/**
 存储分时数据LCXTimeLineModel
 */
@property (nonatomic, strong) NSArray *timeModels;

/**
 昨日收盘价
 */
@property (nonatomic, strong) NSString *preclose;

/**
 时间分割
 */
@property (nonatomic, strong) NSArray *timeaxistext;

/**
 时间分割位置
 */
@property (nonatomic, strong) NSArray *timeaxisindex;

/**
 总交易时间
 */
@property (nonatomic, strong) NSString *scount;

/**
 小数点位数
 */
@property (nonatomic, strong) NSString *place;

/**
 是否画均价
 */
@property (nonatomic, assign) BOOL isDrawAvg;

@end
