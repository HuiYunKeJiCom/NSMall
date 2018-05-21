//
//  NSShopListItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/18.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSShopListItemModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *store_id;//店铺id
@property (nonatomic,copy)NSString *name;//店铺名称
@property (nonatomic,copy)NSString *introduce;//店铺简介描述
@property (nonatomic,copy)NSString *store_imge;//店铺主图片
@end
