//
//  NSMyProductListItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/17.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMyProductListItemModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *product_id;//商品id
@property (nonatomic,copy)NSString *name;//商品名称
@property (nonatomic,copy)NSString *introduce;//商品简介描述
@property (nonatomic)NSInteger is_shelve;//商品状态【-1=未发布，0=下架，1=上架】
@property (nonatomic,copy)NSString *product_imge;//商品主图片
@end
