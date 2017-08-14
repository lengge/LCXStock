//
//  SJBadgeView.m
//  CaiShiJie
//
//  Created by user on 16/12/1.
//  Copyright © 2016年 user. All rights reserved.
//

#import "CustomBadgeView.h"

#define SJBadgeViewFont [UIFont systemFontOfSize:9]

@implementation CustomBadgeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        [self setBackgroundColor:[UIColor colorWithHexString:@"#d33d3e" alpha:1]];
        // 设置字体大小
        self.titleLabel.font = SJBadgeViewFont;
        [self sizeToFit];
    }
    return self;
}

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    // 判断badgeValue是否有内容
    if (badgeValue.length == 0 || [badgeValue isEqualToString:@"0"]) {
        // 没有内容或者空字符串,等于0
        self.hidden = YES;
    } else {
        self.hidden = NO;
    }
    
    /*
    CGSize size = [badgeValue sizeWithAttributes:@{NSFontAttributeName:SJBadgeViewFont}];
    if (size.width > self.width) {
        // 文字的尺寸大于控件的宽度
    } else {
        
    }*/
    if ([badgeValue integerValue] > 99) {
        [self setTitle:@"99+" forState:UIControlStateNormal];
    } else {
        [self setTitle:badgeValue forState:UIControlStateNormal];
    }
}

@end
