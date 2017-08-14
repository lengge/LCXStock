//
//  LCXKLinePositionModel.h
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/************************K线数据模型************************/
@interface LCXKLinePositionModel : NSObject

/**
 *  开盘点
 */
@property (nonatomic, assign) CGPoint openPoint;

/**
 *  收盘点
 */
@property (nonatomic, assign) CGPoint closePoint;

/**
 *  最高点
 */
@property (nonatomic, assign) CGPoint highPoint;

/**
 *  最低点
 */
@property (nonatomic, assign) CGPoint lowPoint;


/**
 *  根据属性创建模型的工厂方法
 */
+ (instancetype)modelWithOpen:(CGPoint)openPoint
                        close:(CGPoint)closePoint
                         high:(CGPoint)highPoint
                          low:(CGPoint)lowPoint;

@end
