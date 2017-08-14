//
//  UIImage+LGAdd.m
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "UIImage+LGAdd.h"

@implementation UIImage (LGAdd)

+ (instancetype)imageWithOriginalName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
