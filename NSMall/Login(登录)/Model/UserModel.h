//
//  UserModel.h
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    登录接口的返回值，参见在线文档
    http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface UserModel : NSObject

@property (nonatomic,copy)NSString *user_id;//用户ID
@property (nonatomic,copy)NSString *user_number;//用户序号
@property (nonatomic,copy)NSString *regeist_time;//注册时间
@property (nonatomic,copy)NSString *login_name;//登录名
@property (nonatomic,copy)NSString *user_name;//昵称
@property (nonatomic,copy)NSString *real_name;//真实姓名
@property (nonatomic,assign)NSInteger is_certification;//
@property (nonatomic,copy)NSString *idcard;//身份证号码
@property (nonatomic,copy)NSString *pic_img;//头像url路径
@property (nonatomic,copy)NSString *birthday;//出生日期
@property (nonatomic,assign)NSInteger sex;//性别
@property (nonatomic,assign)NSInteger age;//年龄
@property (nonatomic,assign)NSInteger status;//
@property (nonatomic,copy)NSString *telephone;//电话号码
@property (nonatomic,copy)NSString *email;//电子邮箱
@property (nonatomic,assign)NSInteger email_is_active;//
@property (nonatomic,copy)NSString *last_login_time;//上次登录时间
@property (nonatomic,copy)NSString *last_login_ip;//上次登录IP
@property (nonatomic,assign)NSInteger login_number;//登录号
@property (nonatomic,copy)NSString *app_token;//登录token？

- (BOOL)archive;//将数据归档到硬盘
+ (BOOL)removeArchive;//移除硬盘上的归档

@end
