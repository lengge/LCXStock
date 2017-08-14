//
//  LGHomeTableViewHeader.m
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGHomeTableViewHeader.h"
#import "LGVerticalLayoutButton.h"

@implementation LGHomeTableViewHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupOneCustomButtonWithImage:[UIImage imageNamed:@"icon"] tag:101 title:@"模拟交易"];
        [self setupOneCustomButtonWithImage:[UIImage imageNamed:@"icon-2"] tag:102 title:@"新手学堂"];
        [self setupOneCustomButtonWithImage:[UIImage imageNamed:@"icon-3"] tag:103 title:@"客服咨询"];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat w = self.width / self.subviews.count;
    for (UIButton *button in self.subviews) {
        NSInteger index = [self.subviews indexOfObject:button];
        button.frame = CGRectMake(index * w, 0, w, self.height);
    }
}

- (void)setupOneCustomButtonWithImage:(UIImage *)image tag:(NSInteger)tag title:(NSString *)title {
    LGVerticalLayoutButton *button = [LGVerticalLayoutButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.tag = tag;
    [button addTarget:self action:@selector(customButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)customButtonPressed:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(lg_header:buttonPressed:)]) {
        [self.delegate lg_header:self buttonPressed:button];
    }
}

@end
