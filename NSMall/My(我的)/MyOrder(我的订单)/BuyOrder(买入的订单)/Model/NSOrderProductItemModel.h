//
//  NSOrderProductItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOrderProductItemModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *product_id;//商品id
@property (nonatomic,copy)NSString *name;//商品名称
@property (nonatomic,copy)NSString *introduce;//商品简介描述
@property (nonatomic,copy)NSString *product_imge;//商品主图片
@property (nonatomic)NSInteger refund_status;//商品退换状态【0=没申请退换，1=买家申请退换，2=卖家同意退换，3=卖家拒绝退换，4=买家已发货，5=卖家确认收货（待退款/待发货），6=已完成退换】

@end
