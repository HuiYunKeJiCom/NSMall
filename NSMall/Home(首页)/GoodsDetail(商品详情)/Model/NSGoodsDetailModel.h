//
//  NSGoodsDetailModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDetailItemModel.h"

@interface NSGoodsDetailModel : NSObject<YYModel>

/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (nonatomic,copy)NSString *product_id;//商品id
@property (nonatomic,copy)NSString *name;//商品名称
@property (nonatomic)double show_price;//商品价格（诺一股）
@property (nonatomic)double show_score;//商品人民币价格（根据诺一股汇率换算）
@property (nonatomic)double ship_price;//运费
@property (nonatomic,copy)NSString *introduce;//商品简介描述
@property (nonatomic,copy)NSString *label_name;//商品标签
@property (nonatomic,copy)NSString *update_time;//创建/更新时间
@property (nonatomic,copy)NSString *week;//商品创建/更新时间所属周数
@property (nonatomic)NSInteger show_in_shelve;//商品是否上架【0=下架，1=上架】
@property (nonatomic)NSInteger is_collect;//商品是否被当前登录用户收藏过【0=否，1=是】
@property (nonatomic)NSInteger store_number;//卖家店铺数量
@property (nonatomic)NSInteger product_number;//卖家上架商品数量
@property (nonatomic)NSInteger comment_number;//卖家被评价数量
@property (nonatomic,copy)NSString *user_id;//卖家ID
@property (nonatomic,copy)NSString *user_name;//卖家昵称
@property (nonatomic,copy)NSString *user_avatar;//卖家头像
@property (nonatomic)NSInteger is_certification;//卖家是否已实名【0=否，1=是】
@property (nonatomic,assign)NSArray *productImageList;//商品图片
@property (nonatomic)double price;//商品真实价格（诺一股），结算时用的是该值
@property (nonatomic)double score;//商品真实人民币价格（根据诺一股汇率换算）
@property (nonatomic)NSInteger stock;//商品库存【-1代表无限库存】
@property (nonatomic)NSInteger limit_num;//商品最大购买量【-1代表不限制购买量】
@property (nonatomic,strong)NSArray<NSDetailItemModel *> *productSpecList;//商品规格参数
@end
