//
//  DCTabBarController.h
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLTabBarController.h"

@interface DCTabBarController : CYLTabBarController

+ (instancetype)sharedTabBarVC;//单例模式，直接取出可用

-(void)goToSelectedViewControllerWith:(NSInteger)index;

@end
