//
//  LGTool.h
//  Spread
//
//  Created by user on 17/5/27.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LGTool : NSObject

+ (instancetype)sharedTool;

+ (CGRect)rectOfString:(NSString *)string attributes:(NSDictionary *)attributes;

@end
