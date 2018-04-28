//
//  LoginAPI.m
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "LoginAPI.h"

@implementation LoginAPI

+ (void)loginWithParam:(LoginParam *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure{
    [Net requestWithGet:param function:<#(nullable NSString *)#> showHUD:<#(nullable NSString *)#> resultClass:<#(nullable Class)#> success:<#^(id  _Nullable resultObj)success#> failure:<#^(NSError * _Nullable error)failure#>];
}

@end
