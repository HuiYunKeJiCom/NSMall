//
//  NSBindWalletParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBindWalletParam : NSObject
@property (copy,nonatomic)NSString *walletName;/* 钱包名称（自定义） */
@property (copy,nonatomic)NSString *account;/* 钱包账号 */
@property (copy,nonatomic)NSString *loginPassword;/* 钱包登录密码 */
@property (copy,nonatomic)NSString *tradePassword;/* 交易密码 */
@end
