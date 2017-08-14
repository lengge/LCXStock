//
//  LCXTimeLineVolume.h
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/************************分时线上成交量的画笔************************/
@interface LCXTimeLineVolume : NSObject

@property (nonatomic, strong) NSArray *timeLineVolumnPositionModels;

- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;

@end
