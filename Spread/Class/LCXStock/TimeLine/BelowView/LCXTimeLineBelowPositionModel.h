//
//  LCXTimeLineBelowPositionModel.h
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LCXStockTimeLineColorType){
    LCXStockTimeLineColorTypeIncrease = 1,   //上涨（红色）
    LCXStockTimeLineColorTypeDecrease,       //下降（绿色）
    LCXStockTimeLineColorTypeOther           //其他
};

@interface LCXTimeLineBelowPositionModel : NSObject

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, assign) LCXStockTimeLineColorType colorType;

@end
