//
//  LGNavigationViewController.m
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGNavigationViewController.h"
#import <UIImage+YYAdd.h>


@interface LGNavigationViewController ()<UINavigationControllerDelegate>

@end

@implementation LGNavigationViewController

+ (void)initialize {
    if (self == [LGNavigationViewController class]) {
        // 设置导航条的标题
        [self setupNavBarTitle];
        // 设置导航条的按钮
        [self setupNavBarButton];
    }
}

+ (void)setupNavBarTitle {
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[LGNavigationViewController class], nil];
    // 设置返回箭头的颜色
    navBar.tintColor = [UIColor colorWithHexString:@"#d3bf8d"];
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#212124" alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    // 设置导航栏中间标题文字的字体、颜色
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#d3bf8d"]};
    [navBar setTitleTextAttributes:attributes];
}

+ (void)setupNavBarButton {
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedIn:[LGNavigationViewController class], nil];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#d3bf8d"]};
    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weak_self;
        self.delegate = weak_self;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.childViewControllers.count) {
        // 不是根控制器
        [viewController setHidesBottomBarWhenPushed:YES];
        // 添加返回按钮
        UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_bar_left"] style:UIBarButtonItemStylePlain target:self action:@selector(event_backButtonClick)];
        viewController.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 移除系统的tabBarButton
    UITabBarController *tabBarVC = (UITabBarController *)kKeyWindow.rootViewController;
    for (UIView *tabBarButton in tabBarVC.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButton removeFromSuperview];
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController == [self.childViewControllers firstObject]) {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = NO;
        }
    } else {
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

// 点击返回按钮式调用
- (void)event_backButtonClick {
    [self popViewControllerAnimated:YES];
}

@end
