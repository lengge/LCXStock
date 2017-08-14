//
//  LCXTimeLineModel.m
//  LCXStock
//
//  Created by user on 17/5/22.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXTimeLineModel.h"

@implementation LCXTimeLineModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"currentPrice" : @"curp",
             @"currentTime" : @"times",
             @"currentVolume" : @"curvolume",
             @"changeFromPreClose" : @"updown",
             @"percentChangeFromPreClose" : @"updownrate",
             @"currentAmount" : @"curvalue"};
}

- (void)calculationAvgPrice:(NSArray *)timeLineModels {
    if (!timeLineModels.count) {
        return;
    }
    NSInteger index = [timeLineModels indexOfObject:self];
    NSArray *tmpArray = [timeLineModels subarrayWithRange:NSMakeRange(0, index + 1)];
    CGFloat amountSum = [[[tmpArray valueForKeyPath:@"currentAmount"] valueForKeyPath:@"@sum.floatValue"] floatValue];
    CGFloat volumeSum = [[[tmpArray valueForKeyPath:@"currentVolume"] valueForKeyPath:@"@sum.floatValue"] floatValue];
    self.avgPrice = amountSum / volumeSum;
}

@end
