//
//  LCXKLineBelowBox.h
//  LCXStock
//
//  Created by user on 17/5/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCXKLineBelowBox : UIView

@property (nonatomic, assign) CGFloat maxVolume;

/**
 画BelowBox
 */
- (void)drawBelowBox;

@end
