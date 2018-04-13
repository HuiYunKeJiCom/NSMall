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
    [MBProgressHUD showHUDAddedTo:AppWindow animated:YES].label.text = title;
}

+ (void)AppHideHUD{
    [MBProgressHUD hideHUDForView:AppWindow animated:YES];
}

+ (void)AppShowToast:(NSString *)mess{
    [AppWindow makeToast:mess];
}

@end
