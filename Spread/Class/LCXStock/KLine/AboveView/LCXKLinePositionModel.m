//
//  LCXKLinePositionModel.m
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LCXKLinePositionModel.h"

@implementation LCXKLinePositionModel

+ (instancetype)modelWithOpen:(CGPoint)openPoint close:(CGPoint)closePoint high:(CGPoint)highPoint low:(CGPoint)lowPoint {
    LCXKLinePositionModel *model = [LCXKLinePositionModel new];
    model.openPoint = openPoint;
    model.closePoint = closePoint;
    model.highPoint = highPoint;
    model.lowPoint = lowPoint;
    return model;
}

@end
