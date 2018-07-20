//
//  NSPayParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/19.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPayParam : NSObject
/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@property (nonatomic,copy)NSString *userId;//收款人ID
@property (nonatomic,copy)NSString *walletId;//钱包ID
@property (nonatomic,copy)NSString *amount;//付款金额
@property (nonatomic,copy)NSString *tradePassword;//交易密码


@end
