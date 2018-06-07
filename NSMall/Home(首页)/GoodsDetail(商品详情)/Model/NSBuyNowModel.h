//
//  NSBuyNowModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/6.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAddressItemModel.h"

@interface NSBuyNowModel : NSObject
/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (copy,nonatomic)NSString *user_id;/* 卖家用户id */
@property (copy,nonatomic)NSString *user_name;/* 卖家昵称 */
@property (copy,nonatomic)NSString *user_avatar;/* 卖家头像路径 */
@property (copy,nonatomic)NSString *product_id;/* 商品ID */
@property (copy,nonatomic)NSString *product_name;/* 商品名称 */
@property (copy,nonatomic)NSString *product_image;/* 商品主图片 */
@property (nonatomic)NSInteger is_shelve;/* 商品是否上架【0=下架，1=上架】(前台要判断该参数，如果是下架商品就不能进行结算和增减数量) */
@property (nonatomic)long product_spec_number;/* 商品规格编码 */
@property (nonatomic)double ship_price;/* 运费（诺一股） */
@property (nonatomic)double ship_score;/* 运费（人民币） */
@property (nonatomic)double price;/* 商品单价（诺一股） */
@property (nonatomic)double total_price;/* 商品总价（诺一股） */
@property (nonatomic)double payment_price;//订单总金额（诺一股）【包含运费】
@property (nonatomic)double payment_score;//订单总金额（人民币）【包含运费】
@property (nonatomic)double score;/* 商品单价（人民币） */
@property (nonatomic)double total_score;/* 商品总价（人民币） */
@property (nonatomic)NSInteger stock;/* 库存【前台要判断用户增加商品数量不能大于库存】 */
@property (nonatomic)NSInteger limit_num;/* 最大购买量 */
@property (nonatomic)NSInteger buy_number;/* 商品数量 */
@property(nonatomic,copy)NSString *spec_name;/* 规格 */
@property (nonatomic,strong)NSAddressItemModel *defaultAddress;//默认收货地址数据

@end
