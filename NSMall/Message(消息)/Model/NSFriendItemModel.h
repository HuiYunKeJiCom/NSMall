//
//  NSFriendItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFriendItemModel : NSObject

/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *user_id;//好友用户id
@property (nonatomic,copy)NSString *nick_name;//好友昵称
@property (nonatomic,copy)NSString *hx_user_name;//好友环信用户名
@property (nonatomic,copy)NSString *user_avatar;//好友头像路径
@property (nonatomic)NSInteger is_blocked;//好友是否被拉黑【0=否，1=是】

@end
