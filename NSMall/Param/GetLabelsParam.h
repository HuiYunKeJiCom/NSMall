//
//  GetLabelsParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface GetLabelsParam : NSObject
@property (nonatomic,copy)NSString *type;//标签类型【0=商品，1=店铺】
@end
