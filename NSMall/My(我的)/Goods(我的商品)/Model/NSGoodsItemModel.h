//
//  NSGoodsItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSGoodsItemModel : NSObject<YYModel>
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *product_id;//商品id
@property (nonatomic,copy)NSString *name;//商品名称
@property (nonatomic)double show_price;//商品展示价格（诺一股）
@property (nonatomic)double ship_price;//运费
@property (nonatomic,copy)NSString *introduce;//商品简介描述

@property (nonatomic,copy)NSString *category_id;//商品分类ID
@property (nonatomic,copy)NSString *category_name;//商品分类名称
@property (nonatomic,copy)NSString *label_id;//商品标签ID
@property (nonatomic,copy)NSString *label_name;//商品标签
@property (nonatomic,assign)NSArray *productImageList;//商品图片
@property (nonatomic)NSInteger stock;//运费
@property (nonatomic)NSInteger limit_num;//运费
@property (nonatomic,copy)NSString *stock;//商品id
@property (nonatomic,copy)NSString *name;//商品名称













@end
