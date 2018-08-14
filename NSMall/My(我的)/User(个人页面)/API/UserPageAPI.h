//
//  UserPageAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserPageModel.h"
#import "NSUserCommentParam.h"
#import "NSCommentListModel.h"

@interface UserPageAPI : NSObject

/*
 获取指定用户信息
 */
+ (void)getUserById:(NSString *)param success:(void (^)(UserPageModel * _Nullable result))success faulre:(void (^)(NSError *error))failure;

/*
 获取指定用户评论列表
 */
+ (void)getCommentByUser:(NSUserCommentParam *)param success:(void (^)(NSCommentListModel * _Nullable result))success faulre:(void (^)(NSError *error))failure;

@end
