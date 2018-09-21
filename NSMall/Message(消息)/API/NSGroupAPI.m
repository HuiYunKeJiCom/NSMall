//
//  NSGroupAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/22.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGroupAPI.h"

@implementation NSGroupAPI

///*
// 创建群组
// */
//+ (void)createGroupWithParam:(NSCreateGroupParam *)param success:(void (^)(NSString *groupId))success faulre:(void (^)(NSError *error))failure{
//    [Net requestWithPost:param function:kCreateGroupAPI showHUD:NetNullStr resultClass:[NSString class] success:^(NSString  *_Nullable groupId) {
//        success?success(groupId):nil;
//    } failure:^(NSError * _Nullable error) {
//        failure?failure(error):nil;
//    }];
//}

/*
 创建群组
 */
+ (void)createGroupWithParam:(NSMutableDictionary *)param success:(void (^)(NSDictionary *groupId))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:param function:kCreateGroupAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(NSDictionary  *_Nullable groupId) {
//        DLog(@"groupId = %@",groupId);
        success?success(groupId):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 获取当前用户群组列表
 */
+ (void)getUserGroupListWithParam:(nullable id)param success:(void (^)(NSGroupListModel *groupModel))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:param function:kGroupListAPI showHUD:NetNullStr resultClass:[NSGroupListModel class] success:^(NSGroupListModel  *_Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
    
}

/*
 编辑群组信息
 */
+ (void)updateGroupWithParam:(NSMutableDictionary *)param success:(void (^)(NSDictionary *groupId))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:param function:kUpdateGroupAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(NSDictionary  *_Nullable groupId) {
//                DLog(@"groupId = %@",groupId);
        success?success(groupId):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 获取群组信息
 */
+ (void)getGroupWithParam:(NSString *)param success:(void (^)(NSGroupModel *groupModel))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:@{@"groupId":param} function:kGetGroupByIdAPI showHUD:nil resultClass:[NSGroupModel class] success:^(NSGroupModel  *_Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
    
}

/*
 删除群组信息
 */
+ (void)deleteGroupWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:@{@"groupId":param} function:kDeleteGroupByIdAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 发送群组邀请确认消息
 */
+ (void)sendInviteConfirmWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:@{@"paramJson":param} function:kSendInviteConfirmAPI showHUD:nil resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
    
}


@end
