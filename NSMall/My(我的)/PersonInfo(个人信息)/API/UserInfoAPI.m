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

+ (void)uploadHeaderWithParam:(NSDictionary *)param success:(void (^)(NSString *path))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kUploadHeaderAPI showHUD:NetNullStr resultClass:nil success:^(NSDictionary *resultObj) {
        success?success([resultObj.allValues firstObject]):nil;
    } failure:^(NSError * _Nullable error) {
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
@end
