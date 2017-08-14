//
//  LGStopLossChooseBox.h
//  Spread
//
//  Created by user on 17/6/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGStopLossChooseBox : UIView

@property (nonatomic, assign) CGFloat stopLoss;

@property (nonatomic, copy) void(^selectedStopLossBlock)(NSString *);

@end
