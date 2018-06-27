//
//  ProductListItemModel.h
//  NSMall
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@interface ProductListItemModel : NSObject<YYModel>

@property (nonatomic,copy)NSString *product_id;//商品id
@property (nonatomic,copy)NSString *name;//商品名称
@property (nonatomic,copy)NSString *show_price;//商品价格（诺一股）
@property (nonatomic,copy)NSString *show_score;//商品人民币价格（根据诺一股汇率换算）
@property (nonatomic,copy)NSString *introduce;//商品简介描述
@property (nonatomic,copy)NSString *label_name;//商品标签
@property (nonatomic,copy)NSString *update_time;//创建/更新时间
@property (nonatomic,assign)NSInteger is_like;//商品是否被当前登录用户点赞过【0=否，1=是】
@property (nonatomic,assign)NSInteger like_number;//商品点赞人数
@property (nonatomic,assign)NSInteger favorite_number;//商品收藏人数
@property (nonatomic,assign)NSInteger comment_number;//商品评论数
@property (nonatomic,copy)NSString *user_id;//卖家ID
@property (nonatomic,copy)NSString *user_name;//卖家昵称
@property (nonatomic,copy)NSString *user_avatar;//卖家头像
@property (nonatomic,copy)NSString *week;//商品创建/更新时间所属周数
@property (nonatomic,strong)NSArray<NSString *> *productImageList;//商品图片

@end
