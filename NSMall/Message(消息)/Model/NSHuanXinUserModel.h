//
//  NSHuanXinUserModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUserModel.h"
#import "NSFriendItemModel.h"

@interface NSHuanXinUserModel : NSObject<IUserModel>
/** @brief 好友环信id(用户环信id) */
@property (strong, nonatomic, readonly) NSString *buddy;
/** @brief 用户昵称 */
@property (strong, nonatomic) NSString *nickname;
/** @brief 用户头像url */
@property (strong, nonatomic) NSString *avatarURLPath;
/** @brief 用户头像 */
@property (strong, nonatomic) UIImage *avatarImage;

@property(nonatomic,strong)NSString *user_id;/* 好友用户id */
@property(nonatomic,strong)NSString *nick_name;/* 好友昵称 */
@property(nonatomic,strong)NSString *hx_user_name;/* 好友环信用户名 */
@property(nonatomic,strong)NSString *user_avatar;/* 好友头像路径 */
@property(nonatomic)NSInteger is_blocked;/* 好友是否被拉黑【0=否，1=是】 */


/*!
 @method
 @brief 初始化用户模型
 @param buddy     好友环信id(用户环信id)
 @return 用户模型
 */
- (instancetype)initWithBuddy:(NSString *)buddy;

-(void)getInformationWith:(NSMutableArray <NSFriendItemModel *>*)array;

@end
