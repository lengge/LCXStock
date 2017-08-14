//
//  LCXKLineModel.m
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLineModel.h"

@implementation LCXKLineModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"changeFromLastClose" : @"updown",
             @"percentChangeFromLastClose" : @"updownrate"};
}

- (void)updateMA:(NSArray *)kLineModels {
    NSInteger index = [kLineModels indexOfObject:self];
    
    if (index >= 4) {
        NSArray *array = [kLineModels subarrayWithRange:NSMakeRange(index - 4, 5)];
        CGFloat average = [[[array valueForKeyPath:@"preclose"] valueForKeyPath:@"@avg.floatValue"] floatValue];
        _MA5 = average;
    } else {
        _MA5 = 0.0;
    }
    
    if (index >= 9) {
        NSArray *array = [kLineModels subarrayWithRange:NSMakeRange(index - 9, 10)];
        CGFloat average = [[[array valueForKeyPath:@"preclose"] valueForKeyPath:@"@avg.floatValue"] floatValue];
        _MA10 = average;
    } else {
        _MA10 = 0.0;
    }
    
    if (index >= 19) {
        NSArray *array = [kLineModels subarrayWithRange:NSMakeRange(index - 19, 20)];
        CGFloat average = [[[array valueForKeyPath:@"preclose"] valueForKeyPath:@"@avg.floatValue"] floatValue];
        _MA20 = average;
    } else {
        _MA20 = 0.0;
    }
}

@end
