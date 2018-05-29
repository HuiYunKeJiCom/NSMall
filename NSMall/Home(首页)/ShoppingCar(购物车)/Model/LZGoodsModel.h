//
//  LZGoodsModel.h
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LZGoodsModel : NSObject<YYModel>

@property (nonatomic,assign) BOOL select;

@property (copy,nonatomic)NSString *cart_id;/* 购物车ItemID */
@property (copy,nonatomic)NSString *product_id;/* 商品ID */
@property (copy,nonatomic)NSString *product_name;/* 商品名称 */
@property (copy,nonatomic)NSString *product_image;/* 商品主图片 */
@property (nonatomic)NSInteger is_shelve;/* 商品是否上架【0=下架，1=上架】(前台要判断该参数，如果是下架商品就不能进行结算和增减数量) */
@property (nonatomic)double ship_price;/* 运费（诺一股） */
@property (nonatomic)double ship_score;/* 运费（人民币） */
@property (nonatomic)double price;/* 商品单价（诺一股） */
@property (nonatomic)double total_price;/* 商品总价（诺一股） */
@property (nonatomic)double score;/* 商品单价（人民币） */
@property (nonatomic)double total_score;/* 商品总价（人民币） */
@property (nonatomic)NSInteger stock;/* 库存【前台要判断用户增加商品数量不能大于库存】 */
@property (nonatomic)NSInteger limit_num;/* 最大购买量 */
@property (nonatomic)NSInteger buy_number;/* 商品数量 */
@property(nonatomic,copy)NSString *spec_name;/* 规格 */

@property (nonatomic)double product_spec_number;/* 商品规格编码 */
@end
