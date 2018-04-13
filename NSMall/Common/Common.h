//
//  Common.h
//  NSMall
//
//  Created by apple on 2018/4/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (void)AppShowHUD:(NSString *)title;
+ (void)AppHideHUD;

+ (void)AppShowToast:(NSString *)mess;

@end
