//
//  NSShopPublishAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSShopPublishAPI.h"

@implementation NSShopPublishAPI

/*
 店铺图片上传
 */
+ (void)uploadStorePicWithParam:(NSDictionary *)params success:(void (^)(NSString *path))success faulre:(void (^)(NSError *))failure{
    [Net uploadDataWithPost:params function:kUploadStoreImageAPI success:^(NSDictionary *result) {
        DLog(@"店铺图片上传result = %@",result);
        NSString* imageUrl = result[@"data"][@"imagePaths"];
        success?success(imageUrl):nil;
    } failure:^(NSError *error) {
        failure?failure(error):nil;
    }];
}

/*
 *店铺发布
 */
+ (void)createShopWithParam:(ShopPublishParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kCreateStoreAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        DLog(@"店铺发布result = %@",resultObj);
        //        NSString *isShelve = resultObj[@"is_shelve"];
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}


@end
