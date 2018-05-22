//
//  GoodsPublishParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsPublishParam : NSObject
/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@property (nonatomic,copy,nonnull)NSString *productName;//商品名称
@property (nonatomic,copy,nonnull)NSString *introduce;//商品简介描述
@property (nonatomic,copy,nonnull)NSString *imagePath;//商品路径【多个路径用逗号分隔】
@property (nonatomic,copy,nonnull)NSString *categoryId;//商品分类ID
@property (nonatomic,copy)NSString *labelId;//标签ID
@property (nonatomic,copy,nonnull)NSString *price;//展示价格
@property (nonatomic,copy)NSString *stock;//商品库存【商品无规格时填写，不传默认为-1，代表无限库存】
@property (nonatomic,copy)NSString *limitNum;//商品最大购买量【商品无规格时填写，不传默认为-1，代表不限制】
@property (nonatomic,copy,nonnull)NSString *shipPrice;//运费
@property (nonatomic,copy)NSString *isShelve;//是否提交后就上架商品【-1=只保存（默认值），1=保存且上架】
@property (nonatomic,copy,nonnull)NSString *hasSpec;//商品是否为有规格【0=否，1=是】
@property (nonatomic,copy)NSString *productSpec;//商品规格数据【商品有规格时必填，格式为json字符串，详细看下面描述】

@end
