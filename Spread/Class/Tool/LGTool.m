//
//  LGTool.m
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGTool.h"

static id _instance = nil;

@implementation LGTool

+ (instancetype)sharedTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [LGTool new];
    });
    return _instance;
}

#pragma mark - 计算文字大小
+ (CGRect)rectOfString:(NSString *)string attributes:(NSDictionary *)attributes {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attributes
                                       context:nil];
    return rect;
}

@end
