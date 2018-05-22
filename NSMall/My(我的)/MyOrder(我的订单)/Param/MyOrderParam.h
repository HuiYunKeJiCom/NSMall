//
//  MyOrderParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderParam : NSObject
/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@property (nonatomic,copy,nonnull)NSString *type;//订单类型【0=我买到的，1=我卖出的】
@property (nonatomic,copy)NSString *orderStatus;//订单状态【””/null=全部订单，1=待支付，2=待发货，3=待收货，4=已完成，11=已取消】
@property (nonatomic,copy)NSString *currentPage;//当前页数（不传默认第一页）
@property (nonatomic,copy) NSString * pageSize;//显示个数（不传默认20个）
@property (nonatomic,copy)NSString *keyword;//查询关键字【订单编号、商品名、商品简介】

@end
