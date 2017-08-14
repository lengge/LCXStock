//
//  UIView+LGAdd.m
//  Spread
//
//  Created by user on 17/6/2.
//  Copyright © 2017年 user. All rights reserved.
//

#import "UIView+LGAdd.h"

@implementation UIView (LGAdd)

- (UIViewController*)viewController {
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

@end
