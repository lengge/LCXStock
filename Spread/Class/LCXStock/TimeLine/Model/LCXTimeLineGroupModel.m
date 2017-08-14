//
//  LCXTimeLineGroupModel.m
//  LCXStock
//
//  Created by user on 17/5/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXTimeLineGroupModel.h"

@implementation LCXTimeLineGroupModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"timeModels" :@"timedata"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"timeModels" :[LCXTimeLineModel class]};
}

@end
