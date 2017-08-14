//
//  LCXTimeLineBelowView.h
//  LCXStock
//
//  Created by user on 17/5/23.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCXTimeLineGroupModel;
/************************分时线下面的view************************/
@interface LCXTimeLineBelowView : UIView

@property (nonatomic, strong) LCXTimeLineGroupModel *groupModel;

@property (nonatomic, strong) NSArray *xPositionArray;

/**
 *  画下面的view
 */
- (void)drawBelowView;

@end
