//
//  Common.m
//  NSMall
//
//  Created by apple on 2018/4/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (void)AppShowHUD:(NSString *)title{
    [MBProgressHUD showHUDAddedTo:AppWindow animated:YES].labelText = title;
}

+ (void)AppHideHUD{
    [MBProgressHUD hideHUDForView:AppWindow animated:YES];
}

+ (void)AppShowToast:(NSString *)mess{
    [AppWindow makeToast:mess duration:1 position:@"CSToastPositionCenter"];
}

extern YYImageDecoder *commonImageDecoder = nil;//
extern YYImageEncoder *commonImageEncoder = nil;//

+ (YYImageDecoder *)imageDecoder{
    if (!commonImageDecoder) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            commonImageDecoder = [[YYImageDecoder alloc]init];
        });
    }
    return commonImageDecoder;
}

+ (YYImageEncoder *)imageEncoder{
    if (!commonImageEncoder) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
//            commonImageEncoder = [YYImageEncoder new];
        });
    }
    return commonImageEncoder;
}

@end
