//
//  GoodsPublishAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "GoodsPublishAPI.h"

@implementation GoodsPublishAPI

/*
 商品图片上传
 */
+ (void)uploadGoodsPicWithParam:(NSDictionary *)params success:(void (^)(NSString *path))success faulre:(void (^)(NSError *))failure{
    [Net uploadDataWithPost:params function:kUploadProductImageAPI success:^(NSDictionary *result) {
        DLog(@"商品图片上传result = %@",result);
        NSString* imageUrl = result[@"data"][@"imagePaths"];
        success?success(imageUrl):nil;
    } failure:^(NSError *error) {
        failure?failure(error):nil;
    }];
}

/*
 *商品发布
 */
+ (void)createProductWithParam:(GoodsPublishParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kCreateProductAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        DLog(@"商品发布result = %@",resultObj);
        //        NSString *isShelve = resultObj[@"is_shelve"];
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}

/*
 *上/下架商品
 */
+ (void)shelveProductWithParam:(ShelveProductParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kShelveProductAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        DLog(@"上/下架商品result = %@",resultObj);
//        NSString *isShelve = resultObj[@"is_shelve"];
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}
@end
