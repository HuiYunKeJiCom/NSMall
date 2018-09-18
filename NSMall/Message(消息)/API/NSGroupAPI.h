//
//  NSGroupAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/22.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "NSCreateGroupParam.h"
#import "NSGroupModel.h"
#import "NSGroupListModel.h"

@interface NSGroupAPI : NSObject

///*
// 创建群组
// */
//+ (void)createGroupWithParam:(NSCreateGroupParam *)param success:(void (^)(NSString *groupId))success faulre:(void (^)(NSError *error))failure;

/*
 创建群组
 */
+ (void)createGroupWithParam:(NSMutableDictionary *)param success:(void (^)(NSDictionary *groupId))success faulre:(void (^)(NSError *error))failure;

/*
 获取当前用户群组列表
 */
+ (void)getUserGroupListWithParam:(nullable id)param success:(void (^)(NSGroupListModel *groupModel))success faulre:(void (^)(NSError *error))failure;

/*
 编辑群组信息
 */
+ (void)updateGroupWithParam:(NSMutableDictionary *)param success:(void (^)(NSDictionary *groupId))success faulre:(void (^)(NSError *error))failure;

/*
 获取群组信息
 */
+ (void)getGroupWithParam:(NSString *)param success:(void (^)(NSGroupModel *groupModel))success faulre:(void (^)(NSError *error))failure;

/*
 删除群组信息
 */
+ (void)deleteGroupWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *error))failure;

@end
