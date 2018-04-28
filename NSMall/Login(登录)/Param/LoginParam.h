//
//  LoginParam.h
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    参见在线接口文档
    http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface LoginParam : NSObject

@property (nonatomic,copy)NSString *loginAccount;//用户名/手机号【登录方式=0时，该参数只能是手机号】
@property (nonatomic,copy)NSString *password;//密码【登录方式=1时必填】
@property (nonatomic,copy)NSString *smsCode;//短信验证码【登录方式=0时必填】
@property (nonatomic,copy)NSString *loginType;//登录方式【0=短信验证码，1=密码】
@property (nonatomic,copy)NSString *verifyCode;//图片验证码【登录失败次数大于3次必填】

@end
