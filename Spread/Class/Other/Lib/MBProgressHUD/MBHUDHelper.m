//
//  MBHUDHelper.m
//  iplaza
//
//  Created by Rush.D.Xzj on 4/27/13.
//  Copyright (c) 2013 Wanda Inc. All rights reserved.
//

#import "MBHUDHelper.h"
#import "MBProgressHUD.h"

@implementation MBHUDHelper

+ (void)showWarningWithText:(NSString *)text
{
    [MBHUDHelper showWarningWithText:text delegate:nil];
}

+ (void)showWarningWithText:(NSString *)text toView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.color = [UIColor colorWithHexString:@"6a6a6a" alpha:0.9];
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.dimBackground = NO;
    [hud hide:YES afterDelay:1.5];
}

+ (void)showWarningWithText:(NSString *)text delegate:(id<MBProgressHUDDelegate>)delegate
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.color = [UIColor colorWithHexString:@"6a6a6a" alpha:0.9];
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.delegate = delegate;
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    hud.dimBackground = NO;
    [hud hide:YES afterDelay:1.5];
}
@end
