//
//  ChangeMobileParam.h
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

@interface ChangeMobileParam : NSObject

@property (nonatomic,copy)NSString *mobile;//新手机号
@property (nonatomic,copy)NSString *smsVerifyCode;//短信验证码
@end
