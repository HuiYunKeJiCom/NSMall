//
//  HeaderModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 登录接口的返回值，参见在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface HeaderModel : NSObject
@property (nonatomic,copy)NSString *path;//用户头像路径
@end
