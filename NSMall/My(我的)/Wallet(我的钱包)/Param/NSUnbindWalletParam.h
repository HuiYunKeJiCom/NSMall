//
//  NSUnbindWalletParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/15.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUnbindWalletParam : NSObject

@property (copy,nonatomic)NSString *walletId;/* 钱包ID */
@property (copy,nonatomic)NSString *tradePassword;/* 交易密码 */

@end
