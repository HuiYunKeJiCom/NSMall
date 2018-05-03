//
//  GetVcodeParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface GetVcodeParam : NSObject
@property (nonatomic,copy)NSString *mobile;//手机号
@property (nonatomic,copy)NSString *type;//验证类型【0=注册，1=登录，2=绑定手机/更换手机号，3=重置密码/忘记密码】
@end
