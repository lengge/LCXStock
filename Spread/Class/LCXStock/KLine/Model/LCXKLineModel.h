//
//  LCXKLineModel.h
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCXKLineModel : NSObject
/**
 日期
 */
@property (nonatomic, strong) NSString *timestamp;
/**
 最高价
 */
@property (nonatomic, strong) NSString *highp;
/**
 开盘价
 */
@property (nonatomic, strong) NSString *openp;
/**
 最低价
 */
@property (nonatomic, strong) NSString *lowp;
/**
 收盘价
 */
@property (nonatomic, strong) NSString *preclose;
/**
 现价
 */
@property (nonatomic, strong) NSString *nowv;

/**
 当前成交量
 */
@property (nonatomic, strong) NSString *curvol;
/**
 涨跌
 */
@property (nonatomic, strong) NSString *changeFromLastClose;
/**
 涨跌幅
 */
@property (nonatomic, strong) NSString *percentChangeFromLastClose;
/**
 5日平均线
 */
@property (nonatomic, assign) CGFloat MA5;
/**
 10日平均线
 */
@property (nonatomic, assign) CGFloat MA10;
/**
 20日平均线
 */
@property (nonatomic, assign) CGFloat MA20;

/**
 *  是否画日期
 */
@property (nonatomic, assign) BOOL isDrawDate;

/**
 计算MA5 MA10 MA20

 @param kLineModels K线模型数组
 */
- (void)updateMA:(NSArray *)kLineModels;

@end
