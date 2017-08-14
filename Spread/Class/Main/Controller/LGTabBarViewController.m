//
//  LGTabBarViewController.m
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGTabBarViewController.h"
#import "LGNavigationViewController.h"
#import "LGHomeViewController.h"
#import "LGTradeViewController.h"
#import "LGProfileViewController.h"
#import "CustomTabBar.h"
#import "UIImage+LGAdd.h"

@interface LGTabBarViewController ()<CustomTabBarDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, weak) CustomTabBar *customTabBar;

@end

@implementation LGTabBarViewController

+ (void)initialize {
    UITabBar *tabBar = [UITabBar appearanceWhenContainedIn:self, nil];
    [tabBar setShadowImage:[UIImage new]];
    [tabBar setBackgroundImage:[UIImage new]];
}

- (NSMutableArray *)items {
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有子控制器
    [self setUpAllChildViewController];
    // 自定义tabBar
    [self setUpTabBar];
    // KVO监控
    [self addObserver:self forKeyPath:@"selectedViewController" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 移除系统的tabBarButton
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton removeFromSuperview];
        }
    }
}

#pragma mark - 设置自定义TabBar
- (void)setUpTabBar {
    CustomTabBar *customTabBar = [[CustomTabBar alloc] initWithFrame:self.tabBar.bounds];
    self.customTabBar = customTabBar;
    customTabBar.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    customTabBar.delegate = self;
    customTabBar.items = self.items;
    [self.tabBar addSubview:customTabBar];
}

#pragma mark - 添加所有的子控制器
- (void)setUpAllChildViewController{
    LGHomeViewController *home = [[LGHomeViewController alloc] init];
    [self setUpOneChildViewController:home image:[UIImage imageWithOriginalName:@"tabel"] selectedImage:[UIImage imageWithOriginalName:@"hover-12"] title:@"首页"];
    
    LGTradeViewController *trade = [[LGTradeViewController alloc] init];
    [self setUpOneChildViewController:trade image:[UIImage imageWithOriginalName:@"tabel-13"] selectedImage:[UIImage imageWithOriginalName:@"hover"] title:@"交易"];
    
    LGProfileViewController *profile = [[LGProfileViewController alloc] init];
    [self setUpOneChildViewController:profile image:[UIImage imageWithOriginalName:@"tabel-14"] selectedImage:[UIImage imageWithOriginalName:@"hover-my"] title:@"我的"];
}

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
    // 保存tabBarItem模型到数组
    [self.items addObject:vc.tabBarItem];
    
    LGNavigationViewController *nav = [[LGNavigationViewController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self.customTabBar setupSelectedWhichOneButton:self.selectedIndex];
}

#pragma mark - TabBarDelegate
- (void)tabBar:(CustomTabBar *)tabBar didClickButton:(NSInteger)index {
    self.selectedIndex = index;
}

/**
 是否允许自动转屏
 
 @return BOOL
 */
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
