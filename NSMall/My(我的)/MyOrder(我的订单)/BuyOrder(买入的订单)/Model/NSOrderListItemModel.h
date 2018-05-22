//
//  NSOrderListItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSOrderProductItemModel.h"

@interface NSOrderListItemModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *order_id;//订单ID
@property (nonatomic,copy)NSString *order_number;//订单编号
@property (nonatomic,copy)NSString *type;//订单类型【0=我买到的，1=我卖出的】
@property (nonatomic)double pay_amount;//订单总金额（诺一股）
@property (nonatomic)double order_score;//订单总金额（人民币）
@property (nonatomic)NSInteger buy_number;//订单商品总数量
@property (nonatomic)NSInteger order_status;//商品退换状态【1=待支付，2=待发货，3=待收货，4=已完成（待评价），10=已完成（已结束，不可评价和退换货），11=已取消（手动），12=已取消（超时自动取消）】
@property (nonatomic,copy)NSString *user_id;//卖家ID【订单类型为1时，该参数为买家ID】
@property (nonatomic,copy)NSString *user_name;//卖家昵称【订单类型为1时，该参数为买家昵称】
@property (nonatomic,copy)NSString *user_avatar;//卖家头像【订单类型为1时，该参数为买家头像】
@property (nonatomic,strong)NSArray<NSOrderProductItemModel *> *productList;
@end
