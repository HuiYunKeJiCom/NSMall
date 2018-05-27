//
//  NSAddCartParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/27.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAddCartParam : NSObject
/*
 参照在线API接口
 http://doc.huist.cn/index.php?s=/10&page_id=289
 */

@property (nonatomic,copy)NSString *productId;//商品ID
@property (nonatomic,copy)NSString *buyNumber;//商品数量
@property (nonatomic,copy)NSString *specId;//商品规格ID【商品有规格时必填】
@end
