//
//  LGTradeFormView.h
//  Spread
//
//  Created by user on 17/6/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LGTradeFormType) {
    LGTradeFormTypeIncrease = 1, // 买涨
    LGTradeFormTypeDecrease,     // 买跌
};

@interface LGTradeFormView : UIView

@property (nonatomic, assign) LGTradeFormType tradeFormType;

@end
