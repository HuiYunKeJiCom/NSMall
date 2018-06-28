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
@property (nonatomic,copy)NSString *user_number;//用户编码
@property (nonatomic,copy)NSString *regeist_time;//注册时间
@property (nonatomic,copy)NSString *regeist_day;//注册天数（带单位：天）
@property (nonatomic,copy)NSString *login_name;//登录名
@property (nonatomic,copy)NSString *user_name;//昵称
@property (nonatomic,copy)NSString *real_name;//真实姓名
@property (nonatomic,assign)NSInteger is_certification;//是否已实名认证【0=否，1=是】
@property (nonatomic,copy)NSString *idcard;//身份证号码
@property (nonatomic,copy)NSString *pic_img;//头像路径
@property (nonatomic,copy)NSString *birthday;//生日
@property (nonatomic,assign)NSInteger sex;//性别【0=保密，1=男，2=女】
@property (nonatomic,assign)NSInteger age;//年龄
@property (nonatomic,assign)NSInteger status;//账号状态【0=禁用，1=正常】
@property (nonatomic,copy)NSString *telephone;//电话号码
@property (nonatomic,copy)NSString *email;//邮箱地址
@property (nonatomic,assign)NSInteger email_is_active;//邮箱激活【0=未激活，1=已激活】
@property (nonatomic,copy)NSString *last_login_time;//最后登录时间
@property (nonatomic,copy)NSString *last_login_ip;//最后登录IP
@property (nonatomic,assign)NSInteger login_number;//登录次数
@property (nonatomic,copy)NSString *app_token;//app登录密钥
@property (nonatomic,copy)NSString *has_wallet;//是否绑定了钱包【0=否，1=是】
@property (nonatomic,copy)NSString *hx_user_name;//环信用户名
@property (nonatomic,copy)NSString *hx_password;//环信密码

+ (instancetype)userModel;//供全局使用的userModel，如果为空则从硬盘中归档导出，如果硬盘中没有则返回为空
+ (instancetype)modelFromUnarchive;//从硬盘归档出模型数据（全局可取出）
- (BOOL)archive;//将数据归档到硬盘
+ (BOOL)removeArchive;//移除硬盘上的归档

@end
