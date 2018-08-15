//
//  WalletAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import "WalletAPI.h"

@implementation WalletAPI
/*
 获取已绑定的钱包列表
 */
+ (void)getWalletListWithParam:(nullable id)param success:(void (^)(NSWalletModel *walletModel))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kWalletListAPI showHUD:NetNullStr resultClass:[NSWalletModel class] success:^(NSWalletModel  *_Nullable resultObj) {
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
    
}

/*
 绑定钱包
 */
+ (void)bindWalletWithParam:(NSBindWalletParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kBindWalletAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 设置默认收款钱包
 */
+ (void)setDefaultWalletWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:@{@"walletId":param} function:kSetWalletAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 解绑钱包
 */
+ (void)unbindWalletWithParam:(NSUnbindWalletParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *error))failure{
    [Net requestWithPost:param function:kUnbindWalletAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}
@end
