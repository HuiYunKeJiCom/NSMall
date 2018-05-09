//
//  MyAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdatePwdParam.h"
#import "CertificationParam.h"
#import "GetListParam.h"
#import "NSProductListModel.h"
#import "NSStoreListModel.h"
#import "ProductListModel.h"


@interface MyAPI : NSObject
/*
 退出登录
 */
+ (void)logout:(NSDictionary *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 修改密码
 */
+ (void)updatePwdWithParam:(UpdatePwdParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 提交实名认证信息
 */
+ (void)submitCertificationWithParam:(CertificationParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

/*
 获取我的商品列表
 */
+ (void)getMyProductList:(GetListParam *_Nullable)param success:(void (^)(NSProductListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
 获取我的店铺列表
 */
+ (void)getMyStoreList:(GetListParam *_Nullable)param success:(void (^)(NSStoreListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
 我的收藏商品列表
 */
+ (void)getCollectProductList:(GetListParam *_Nullable)param success:(void (^)(ProductListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

@end
