//
//  UserInfoAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import "UserInfoAPI.h"

@implementation UserInfoAPI
+ (void)getUserInfo:(nullable id)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithGet:param function:kGetInfoAPI showHUD:NetNullStr resultClass:[UserModel class] success:^(UserModel *userModel) {
        [userModel archive];
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

+ (void)changeMobileWithParam:(ChangeMobileParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kChangeMobileAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

+ (void)uploadHeaderWithParam:(NSDictionary *)params success:(void (^)(NSString *path))success faulre:(void (^)(NSError *))failure{
    [Net uploadDataWithPost:params function:kUploadHeaderAPI success:^(NSDictionary *result) {
        DLog(@"上传头像result = %@",result);
        NSString* imageUrl = result[@"data"][@"path"];
        success?success(imageUrl):nil;
    } failure:^(NSError *error) {
        failure?failure(error):nil;
    }];
}

+ (void)uploadIDCardWithParam:(NSDictionary *)params success:(void (^)(NSString *path))success faulre:(void (^)(NSError *))failure{
    [Net uploadDataWithPost:params function:kUploadIDCardAPI success:^(NSDictionary *result) {
        DLog(@"上传身份证result = %@",result);
        NSString* imageUrl = result[@"data"][@"imagePaths"];
        success?success(imageUrl):nil;
    } failure:^(NSError *error) {
        failure?failure(error):nil;
    }];
}

+ (void)updateUserWithParam:(UpdateUserParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kUpdateUserAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}



+ (void)certificationWithParam:(NSDictionary *)param success:(void (^)(NSString *message))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kCertificationAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        DLog(@"认证信息result = %@",resultObj);
        NSString *message = resultObj[@"message"];
        success?success(message):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 获取我的商品列表
 */
+ (void)getMyProductList:(nullable NSCommonParam *)param success:(void (^)(NSMyProductListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kMyProductListAPI showHUD:NetNullStr resultClass:[NSMyProductListModel class] success:^(NSMyProductListModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 获取我的收藏
 */
+ (void)getMyCollectionList:(nullable NSCommonParam *)param success:(void (^)(ProductListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kCollectionListAPI showHUD:NetNullStr resultClass:[ProductListModel class] success:^(ProductListModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 获取我的店铺
 */
+ (void)getMyShopList:(nullable NSCommonParam *)param success:(void (^)(NSShopListModel * _Nullable result))success failure:(void (^)(NSError *error))failure{
    [Net requestWithGet:param function:kMyStoreListAPI showHUD:NetNullStr resultClass:[NSShopListModel class] success:^(NSShopListModel  * _Nullable  resultObj){
        success?success(resultObj):nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}
@end
