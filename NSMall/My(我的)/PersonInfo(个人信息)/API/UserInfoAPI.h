//
//  UserInfoAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChangeMobileParam.h"
#import "HeaderModel.h"
#import "UpdateUserParam.h"
#import "NSCommonParam.h"
#import "ProductListModel.h"
#import "NSMyProductListModel.h"
#import "NSShopListModel.h"

@interface UserInfoAPI : NSObject
/** 获取用户信息 */
+ (void)getUserInfo:(nullable id)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
/** 更换手机号 */
+ (void)changeMobileWithParam:(ChangeMobileParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
/** 上传用户头像 */
+ (void)uploadHeaderWithParam:(NSDictionary *)params success:(void (^)(NSString *path))success faulre:(void (^)(NSError *))failure;
/** 修改用户信息 */
+ (void)updateUserWithParam:(UpdateUserParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;
/** 上传身份证照片 */
+ (void)uploadIDCardWithParam:(NSDictionary *)params success:(void (^)(NSString *path))success faulre:(void (^)(NSError *))failure;
/** 提交实名认证信息 */
+ (void)certificationWithParam:(NSDictionary *)param success:(void (^)(NSString *message))success faulre:(void (^)(NSError *))failure;

/*
 获取我的商品列表
 */
+ (void)getMyProductList:(nullable NSCommonParam *)param success:(void (^)(NSMyProductListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
 获取我的收藏
 */
+ (void)getMyCollectionList:(nullable NSCommonParam *)param success:(void (^)(ProductListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;

/*
 获取我的店铺
 */
+ (void)getMyShopList:(nullable NSCommonParam *)param success:(void (^)(NSShopListModel * _Nullable result))success failure:(void (^)(NSError *error))failure;
@end
