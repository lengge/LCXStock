//
//  LCXKLineVolumePositionModel.h
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

/************************成交量位置模型************************/
@interface LCXKLineVolumePositionModel : NSObject

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGPoint endPoint;

+ (instancetype)volumePositionModelWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
