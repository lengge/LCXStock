//
//  LCXKLineGroupModel.m
//  Spread
//
//  Created by user on 17/6/1.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLineGroupModel.h"

@implementation LCXKLineGroupModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"kLineModels" :@"timedata"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"kLineModels" :[LCXKLineModel class]};
}

@end
