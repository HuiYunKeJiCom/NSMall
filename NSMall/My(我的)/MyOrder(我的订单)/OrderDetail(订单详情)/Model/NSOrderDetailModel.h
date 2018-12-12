//
//  NSOrderDetailModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSODItemModel.h"

@interface NSOrderDetailModel : NSObject<YYModel>
/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (nonatomic,copy)NSString *type;//订单类型【0=我买到的，1=我卖出的】
@property (nonatomic,copy)NSString *order_id;//订单ID
@property (nonatomic,assign)long order_number;//订单编号
@property (nonatomic,copy)NSString *create_time;//下单时间
@property (nonatomic,assign)double commision;//平台收取佣金【卖家订单才显示】
@property (nonatomic,assign)double pay_amount;//订单总金额（诺一股）【包含运费】
@property (nonatomic,assign)double pay_score;//订单总金额（人民币）【包含运费】
@property (nonatomic,assign)double order_amount;//订单金额（诺一股）【不含运费】
@property (nonatomic,assign)double order_score;//订单金额（人民币）【不含运费】
@property (nonatomic,assign)double ship_amount;//运费（诺一股）
@property (nonatomic,assign)double ship_score;//运费（人民币）
@property (nonatomic,assign)NSInteger total_number;//订单商品总数量
@property (nonatomic,copy)NSString *ship_number;//快递单号
@property (nonatomic,copy)NSString *ship_code;//快递标识
@property (nonatomic,copy)NSString *ship_name;//快递公司
@property (nonatomic,copy)NSString *ship_time;//发货时间
@property (nonatomic,copy)NSString *recipient_name;//收货人
@property (nonatomic,copy)NSString *recipient_phone;//收货人电话
@property (nonatomic,copy)NSString *recipient_address;//收货地址
@property (nonatomic,copy)NSString *user_zipcode;//邮编
@property (nonatomic,assign)int order_status;//订单状态【1=待支付，2=待发货，3=待收货，4=已完成（待评价），10=交易完成（交易结束，不可评价和退换货），11=已取消（手动），12=已取消（超时自动取消）】
@property (nonatomic,copy)NSString *user_id;//卖家ID【订单类型为1时，该参数为买家ID】
@property (nonatomic,copy)NSString *user_name;//卖家昵称【订单类型为1时，该参数为买家昵称】
@property (nonatomic,copy)NSString *user_avatar;//卖家头像【订单类型为1时，该参数为买家头像】
@property (nonatomic,assign)NSInteger level;//用户VIP等级
@property (strong,nonatomic)NSMutableArray <NSODItemModel *> *productList;
@end
