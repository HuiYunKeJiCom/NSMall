//
//  NSMessageAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMessageAPI.h"

@implementation NSMessageAPI

/*
 同意添加好友
 */
+ (void)acceptFriendWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:@{@"friendName":param} function:kAcceptFriendAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

@end
