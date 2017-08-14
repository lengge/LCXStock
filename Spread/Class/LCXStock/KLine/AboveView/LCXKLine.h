//
//  LCXKLine.h
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCXKLinePositionModel.h"
#import "LCXKLineModel.h"
#import "LCXStockChartConstant.h"

/************************K线的画笔************************/
@interface LCXKLine : NSObject

/**
 *  K线模型
 */
@property (nonatomic, strong) LCXKLinePositionModel *kLinePositionModel;

/**
 *  kLineModel模型
 */
@property (nonatomic, strong) LCXKLineModel *kLineModel;

/**
 *  最大的Y
 */
@property (nonatomic, assign) CGFloat maxY;

/**
 *  K线类型
 */
@property (nonatomic, assign) LCXStockChartKLineType kLineType;

/**
 *  最大的X
 */
@property (nonatomic, assign) CGFloat maxX;

/**
 *  根据context初始化
 */
- (instancetype)initWithContext:(CGContextRef)context;

/**
 *  绘制K线
 */
- (UIColor *)draw;

@end
