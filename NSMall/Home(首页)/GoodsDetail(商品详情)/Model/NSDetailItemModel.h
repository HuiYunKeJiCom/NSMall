//
//  NSDetailItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDetailItemModel : NSObject<YYModel>

/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (nonatomic,copy)NSString *product_spec_id;//商品规格ID
@property (nonatomic,copy)NSString *spec_name;//商品规格名称
@property (nonatomic)double price;//商品真实价格（诺一股），结算时用的是该值
@property (nonatomic)double score;//商品真实人民币价格（根据诺一股汇率换算）
@property (nonatomic)NSInteger stock;//商品库存【-1代表无限库存】
@property (nonatomic)NSInteger limit_num;//商品最大购买量【-1代表不限制购买量】

@end
