//
//  LCXKLineAboveBox.h
//  LCXStock
//
//  Created by user on 17/5/25.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCXKLineAboveBox : UIView

@property (nonatomic, assign) CGFloat maxPrice;

@property (nonatomic, assign) CGFloat minPrice;

/**
 小数点位数
 */
@property (nonatomic, assign) NSInteger place;

/**
 画AboveBox
 */
- (void)drawAboveBox;

@end
