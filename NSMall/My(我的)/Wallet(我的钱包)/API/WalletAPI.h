//
//  WalletAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSWalletModel.h"
#import "NSBindWalletParam.h"
#import "NSUnbindWalletParam.h"

@interface WalletAPI : NSObject
/*
 获取已绑定的钱包列表
 */
+ (void)getWalletListWithParam:(nullable id)param success:(void (^)(NSWalletModel *walletModel))success faulre:(void (^)(NSError *))failure;

/*
 绑定钱包
 */
+ (void)bindWalletWithParam:(NSBindWalletParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 设置默认收款钱包
 */
+ (void)setDefaultWalletWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 解绑钱包
 */
+ (void)unbindWalletWithParam:(NSUnbindWalletParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *error))failure;
@end
