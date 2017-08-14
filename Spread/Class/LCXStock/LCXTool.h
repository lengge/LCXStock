//
//  LCXTool.h
//  LCXStock
//
//  Created by user on 17/5/24.
//  Copyright © 2017年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCXTool : NSObject

+ (instancetype)sharedTool;

+ (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute;

@end
