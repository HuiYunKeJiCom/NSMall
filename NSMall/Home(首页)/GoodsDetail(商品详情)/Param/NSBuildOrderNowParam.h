//
//  NSBuildOrderNowParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/5.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBuildOrderNowParam : NSObject
/*
 参照在线API接口
 http://doc.huist.cn/index.php?s=/10&page_id=289
 */

@property (nonatomic,copy)NSString *productSpecNumber;//商品所选规格编码
@property (nonatomic,copy)NSString *buyNumber;//商品购买数量
@property (nonatomic,copy)NSString *addressId;//收货地址ID

@end
