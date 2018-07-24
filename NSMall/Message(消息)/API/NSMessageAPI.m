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

/*
 删除好友（双方删除）
 */
+ (void)deleteFriendWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:@{@"friendName":param} function:kDeleteFriendAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 获取好友列表
 */
+ (void)getFriendList:(nullable NSString *)param success:(void (^)(NSFriendListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kFriendListAPI showHUD:nil resultClass:[NSFriendListModel class] success:^(NSFriendListModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

@end
