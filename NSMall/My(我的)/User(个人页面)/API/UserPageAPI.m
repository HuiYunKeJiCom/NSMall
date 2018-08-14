//
//  UserPageAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import "UserPageAPI.h"


@implementation UserPageAPI

/*
 获取指定用户信息
 */
+ (void)getUserById:(NSString *)param success:(void (^)(UserPageModel * _Nullable result))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:@{@"userId":param} function:kGetUserAPI showHUD:NetNullStr resultClass:[UserPageModel class] success:^(UserPageModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 获取指定用户评论列表
 */
+ (void)getCommentByUser:(NSUserCommentParam *)param success:(void (^)(NSCommentListModel * _Nullable result))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:param function:kGetCommentByUserAPI showHUD:NetNullStr resultClass:[NSCommentListModel class] success:^(NSCommentListModel * _Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

@end
