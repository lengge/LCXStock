//
//  LCXKLineGroupModel.h
//  Spread
//
//  Created by user on 17/6/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCXKLineModel.h"

@interface LCXKLineGroupModel : NSObject

/**
 小数点位数
 */
@property (nonatomic, strong) NSString *place;

@property (nonatomic, strong) NSArray *kLineModels;

@end
