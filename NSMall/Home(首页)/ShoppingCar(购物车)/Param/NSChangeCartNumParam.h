//
//  NSChangeCartNumParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSChangeCartNumParam : NSObject

/*
 参照在线API接口
 http://doc.huist.cn/index.php?s=/10&page_id=289
 */

@property (nonatomic,copy)NSString *cartId;//购物车ID
@property (nonatomic,copy)NSString *buyNumber;//商品数量

@end
