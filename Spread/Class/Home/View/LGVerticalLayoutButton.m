//
//  LGVerticalLayoutButton.m
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGVerticalLayoutButton.h"

@implementation LGVerticalLayoutButton

- (void)setHighlighted:(BOOL)highlighted{}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeBottom;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat totalHeight = self.imageView.frame.size.height + self.titleLabel.frame.size.height + 10;
    CGFloat imageX = 0;
    CGFloat imageY = (self.bounds.size.height - totalHeight) / 2;
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = self.imageView.frame.size.height;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    CGFloat titleX = 0;
    CGFloat titleY = CGRectGetMaxY(self.imageView.frame) + 10;
    CGFloat titleW = self.bounds.size.width;
    CGFloat titleH = self.titleLabel.frame.size.height;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
}

@end
