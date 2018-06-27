//
//  NSODItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSODItemModel : NSObject
@property (nonatomic,copy)NSString *product_id;//商品id
@property (nonatomic,copy)NSString *name;//商品名称
@property (nonatomic,copy)NSString *introduce;//商品简介描述
@property (nonatomic,copy)NSString *product_imge;//商品主图片
@property (nonatomic,copy)NSString *product_spec_name;//商品规格
@property (nonatomic,assign)NSInteger buy_number;//商品数量
@property (nonatomic,assign)double product_amount;//商品总价（诺一股）
@property (nonatomic,assign)double product_score;//商品总价（人民币）
@property (nonatomic,assign)double price;//商品单价（诺一股）
@property (nonatomic,assign)double score;//商品单价（人民币）
@property (nonatomic,assign)NSInteger refund_status;//商品退换状态【0=没申请退换，1=买家申请退换，2=卖家同意退换，3=卖家拒绝退换，4=买家已发货，5=卖家确认收货（待退款/待发货），6=已完成退换】
@end
