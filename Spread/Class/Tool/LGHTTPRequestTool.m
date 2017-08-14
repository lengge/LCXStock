//
//  LGHTTPRequestTool.m
//  Spread
//
//  Created by user on 17/5/31.
//  Copyright © 2017年 user. All rights reserved.
//

#import "LGHTTPRequestTool.h"
#import "AFNetworking.h"

@implementation LGHTTPRequestTool

+ (NSURLSessionDataTask *)GET:(NSString *)path
                     paramers:(id)paramers
                      success:(void(^)(id respose))success
                      failure:(void(^)(NSError *error))failure {
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10.0];
    
    NSURLSessionDataTask *task = [manager GET:path parameters:paramers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    
    return task;
}

+ (NSURLSessionDataTask *)POST:(NSString *)path
                      paramers:(id)paramers
                       success:(void(^)(id respose))success
                       failure:(void(^)(NSError *error))failure {
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10.0];
    
    NSURLSessionDataTask *task = [manager POST:path parameters:paramers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
    
    return task;
}

@end
