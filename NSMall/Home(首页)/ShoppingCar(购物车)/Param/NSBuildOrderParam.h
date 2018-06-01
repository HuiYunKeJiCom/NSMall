//
//  NSBuildOrderParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBuildOrderParam : NSObject
/*
 参照在线API接口
 http://doc.huist.cn/index.php?s=/10&page_id=289
 */

@property (nonatomic,copy)NSString *cartIds;//购物车ID【多个ID用逗号分隔】
@property (nonatomic,copy)NSString *addressId;//地址ID
@end
