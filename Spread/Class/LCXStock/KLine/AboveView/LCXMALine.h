//
//  LCXMALine.h
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HYMAType){
    HYMA5Type = 0,
    HYMA10Type,
    HYMA20Type
};

/************************画均线的画笔************************/
@interface LCXMALine : NSObject

@property (nonatomic, strong) NSArray *MAPositions;

@property (nonatomic, assign) HYMAType MAType;

/**
 *  根据context初始化均线画笔
 */
- (instancetype)initWitContext:(CGContextRef)context;

- (void)draw;

@end
