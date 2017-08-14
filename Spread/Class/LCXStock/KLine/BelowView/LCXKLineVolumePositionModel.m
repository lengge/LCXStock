//
//  LCXKLineVolumePositionModel.m
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLineVolumePositionModel.h"

@implementation LCXKLineVolumePositionModel

+ (instancetype)volumePositionModelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    LCXKLineVolumePositionModel *volumePosition = [LCXKLineVolumePositionModel new];
    volumePosition.startPoint = startPoint;
    volumePosition.endPoint = endPoint;
    return volumePosition;
}

@end
