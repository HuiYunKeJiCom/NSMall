//
//  UserPageModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPageModel : NSObject

/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (nonatomic,copy)NSString *user_id;//用户id
@property (nonatomic,copy)NSString *regeist_time;//注册时间
@property (nonatomic,copy)NSString *regeist_day;//注册天数（带单位：天）
@property (nonatomic,copy)NSString *nick_name;//昵称
@property (nonatomic,copy)NSString *hx_user_name;//环信用户名
@property (nonatomic)int is_certification;//是否已实名认证【0=否，1=是】
@property (nonatomic,copy)NSString *pic_img;//头像路径
@property (nonatomic,assign)NSInteger level;//用户VIP等级
@property (nonatomic)int sex;//性别【0=保密，1=男，2=女】
@property (nonatomic,copy)NSString *telephone;//手机号
@property (nonatomic)int product_number;//商品数
@property (nonatomic)int store_number;//店铺数
@property (nonatomic)int comment_number;//评论数
@end
