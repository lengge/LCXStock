//
//  LCXTimeLine.h
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCXTimeLineAbovePositionModel.h"

/************************用于画分时线的画笔************************/
@interface LCXTimeLine : NSObject

@property (nonatomic, strong) NSArray *positionModels;

- (instancetype)initWithContext:(CGContextRef)context;

- (void)draw;

@end
