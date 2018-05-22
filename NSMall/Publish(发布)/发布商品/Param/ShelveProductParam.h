//
//  ShelveProductParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShelveProductParam : NSObject
/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@property (nonatomic,copy,nonnull)NSString *productId;//商品ID
@property (nonatomic,copy,nonnull)NSString *isShelve;//操作类型【0=下架，1=上架】
@end
