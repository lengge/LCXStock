//
//  LGHTTPRequestTool.h
//  Spread
//
//  Created by user on 17/5/31.
//  Copyright © 2017年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGHTTPRequestTool : NSObject

/**
 请求网络
 
 @param path     地址
 @param paramers 参数
 @param success  成功回调
 @param failure  失败回调
 
 @return 一次请求任务
 */
+ (NSURLSessionDataTask *)GET:(NSString *)path
                     paramers:(id)paramers
                      success:(void(^)(id respose))success
                      failure:(void(^)(NSError *error))failure;
/**
 请求网络
 
 @param path     地址
 @param paramers 参数
 @param success  成功回调
 @param failure  失败回调
 
 @return 一次请求任务
 */
+ (NSURLSessionDataTask *)POST:(NSString *)path
                      paramers:(id)paramers
                       success:(void(^)(id respose))success
                       failure:(void(^)(NSError *error))failure;

@end
