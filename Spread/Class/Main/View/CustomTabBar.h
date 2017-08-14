//
//  CustomTabBar.h
//  GuMu
//
//  Created by user on 17/2/20.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTabBar;
@protocol CustomTabBarDelegate <NSObject>

@optional
- (void)tabBar:(CustomTabBar *)tabBar didClickButton:(NSInteger)index;

@end

@interface CustomTabBar : UIView

/**
 items:保存每一个按钮对应tabBarItem模型
 */
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, weak) id<CustomTabBarDelegate>delegate;

- (void)setupSelectedWhichOneButton:(NSInteger)index;

@end
