//
//  UpdateUserParam.h
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

@interface UpdateUserParam : NSObject
@property (nonatomic,copy)NSString *loginName;//用户名【用于登录】
@property (nonatomic,copy)NSString *userName;//昵称
@property (nonatomic,copy)NSString *trueName;//真实姓名
@property (nonatomic,copy)NSString *birthday;//生日
@property (nonatomic,copy)NSString *email;//昵称
@property (nonatomic,copy)NSString *sex;//性别【0=保密，1=男，2=女】
@property (nonatomic,copy)NSString *age;//年龄
@end
