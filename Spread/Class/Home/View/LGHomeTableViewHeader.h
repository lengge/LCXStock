//
//  LGHomeTableViewHeader.h
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LGHomeTableViewHeaderDelegate;
@interface LGHomeTableViewHeader : UIView

@property (nonatomic, weak) id<LGHomeTableViewHeaderDelegate>delegate;

@end

@protocol LGHomeTableViewHeaderDelegate <NSObject>

@optional
- (void)lg_header:(LGHomeTableViewHeader *)header buttonPressed:(UIButton *)button;

@end
