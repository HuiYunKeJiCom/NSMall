//
//  NSPayOrderParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/1.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPayOrderParam : NSObject
/*
 参照在线API接口
 http://doc.huist.cn/index.php?s=/10&page_id=289
 */

@property (nonatomic,copy)NSString *orderId;//订单ID【多个ID用逗号分隔】
@property (nonatomic,copy)NSString *walletId;//钱包ID
@property (nonatomic,copy)NSString *tradePassword;//交易密码
@end
