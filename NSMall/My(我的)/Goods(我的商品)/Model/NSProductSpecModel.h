//
//  NSProductSpecModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSProductSpecModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *product_spec_id;//商品规格ID
@property (nonatomic)NSInteger product_spec_number;//商品规格编码
@property (nonatomic,copy)NSString *spec_name;//商品规格名称
@property (nonatomic)NSInteger stock;//商品规格库存【-1代表无限库存】
@property (nonatomic)NSInteger limit_num;//商品规格最大购买量【-1代表不限制购买量】
@property (nonatomic)double price;//商品规格价格（诺一股）

@end
