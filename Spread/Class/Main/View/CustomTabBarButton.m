//
//  CustomTabBarButton.m
//  GuMu
//
//  Created by user on 17/2/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import "CustomTabBarButton.h"
#import "CustomBadgeView.h"

#define SJImageRidio 0.7

@interface CustomTabBarButton ()

@property (nonatomic, weak) CustomBadgeView *badgeView;

@end

@implementation CustomTabBarButton

// 重写setHighlighted，取消高亮做的事情
- (void)setHighlighted:(BOOL)highlighted{}
// 懒加载badgeView
- (CustomBadgeView *)badgeView {
    if (_badgeView == nil) {
        CustomBadgeView *button = [CustomBadgeView buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        _badgeView = button;
    }
    return _badgeView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置字体颜色
        [self setTitleColor:[UIColor colorWithHexString:@"#333333" alpha:1] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"#d1ad61" alpha:1] forState:UIControlStateSelected];
        // 图片居中
        self.imageView.contentMode = UIViewContentModeCenter;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 设置文字字体
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}
// 传递UITabBarItem给tabBarButton,给tabBarButton内容赋值
- (void)setItem:(UITabBarItem *)item {
    _item = item;
    
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    // KVO：时刻监听一个对象的属性有没有改变
    [item addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
}

// 只要监听的属性一有新值，就会调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self setTitle:_item.title forState:UIControlStateNormal];
    [self setImage:_item.image forState:UIControlStateNormal];
    [self setImage:_item.selectedImage forState:UIControlStateSelected];
    // 设置badgeValue
    self.badgeView.badgeValue = _item.badgeValue;
    
    // 根据badgeValue的值改变badgeView的大小
    if (_item.badgeValue.length != 0 || ![_item.badgeValue isEqualToString:@"0"]) {
        CGFloat badgeW = 16;
        if ([_item.badgeValue integerValue] > 99) {
            badgeW = 23;
        }
        self.badgeView.width = badgeW;
    }
}

// 修改按钮内部子控件的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1.imageView
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = self.bounds.size.width;
    CGFloat imageH = self.bounds.size.height * SJImageRidio;
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    // 2.title
    CGFloat titleX = 0;
    CGFloat titleY = imageH - 3;
    CGFloat titleW = self.bounds.size.width;
    CGFloat titleH = self.bounds.size.height - titleY;
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    // 3.badgeView
    self.badgeView.left = ceil(0.6 * self.width);
    self.badgeView.top = ceil(0.05 * self.height);
    self.badgeView.height = 16;
    self.badgeView.layer.cornerRadius = self.badgeView.height / 2;
    self.badgeView.layer.masksToBounds = YES;
}

@end
