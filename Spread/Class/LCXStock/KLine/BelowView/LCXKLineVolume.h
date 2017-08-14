//
//  LCXKLineVolume.h
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCXKLineVolumePositionModel.h"
#import "LCXKLineModel.h"

/************************画成交量线的画笔************************/
@interface LCXKLineVolume : NSObject

/**
 *  位置模型
 */
@property (nonatomic, strong) LCXKLineVolumePositionModel *positionModel;

/**
 *  K线模型，里面包含成交量
 */
@property (nonatomic, strong) LCXKLineModel *kLineModel;

@property (nonatomic, strong) UIColor *lineColor;

- (instancetype)initWithContext:(CGContextRef)context;

/**
 *  绘制成交量
 */
- (void)draw;

@end
