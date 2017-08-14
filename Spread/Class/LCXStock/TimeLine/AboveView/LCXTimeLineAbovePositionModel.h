//
//  LCXTimeLineAbovePositionModel.h
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/************************分时线上面的view的位置模型************************/
@interface LCXTimeLineAbovePositionModel : NSObject

@property (nonatomic, assign) CGPoint currentPoint;

@property (nonatomic, assign) CGPoint avgPoint;

@property (nonatomic, assign) BOOL isDrawAvg;

@end
