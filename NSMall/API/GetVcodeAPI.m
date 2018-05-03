//
//  GetVcodeAPI.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import "GetVcodeAPI.h"

@implementation GetVcodeAPI
+ (void)getVcodeWithParam:(GetVcodeParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithPost:param function:kGetVcodeAPI showHUD:NetNullStr resultClass:[NSDictionary class] success:^(id  _Nullable resultObj) {
        success?success():nil;
    } failure:^(NSError * _Nullable error) {
        failure?failure(error):nil;
    }];
}
@end
