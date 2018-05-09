//
//  UpdatePwdParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface UpdatePwdParam : NSObject
@property (nonatomic,copy)NSString *oldPassword;//旧密码
@property (nonatomic,copy)NSString *password;//新密码
@end
