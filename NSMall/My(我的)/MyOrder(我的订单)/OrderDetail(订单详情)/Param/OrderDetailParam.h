//
//  OrderDetailParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDetailParam : NSObject
/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@property (nonatomic,copy)NSString *type;//订单类型【0=我买到的，1=我卖出的】
@property (nonatomic,copy)NSString *orderId;//订单ID

@end
