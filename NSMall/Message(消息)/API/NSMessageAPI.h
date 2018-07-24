//
//  NSMessageAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSFriendListModel.h"

@interface NSMessageAPI : NSObject

/*
 同意添加好友
 */
+ (void)acceptFriendWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 删除好友（双方删除）
 */
+ (void)deleteFriendWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 获取好友列表
 */
+ (void)getFriendList:(nullable NSString *)param success:(void (^)(NSFriendListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

@end
