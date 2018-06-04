//
//  AppDelegate.h
//  NSMall
//
//  Created by 张锐凌 on 2018/4/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMapAPI_Base/BMKMapManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    BMKMapManager *_mapManager;
}

@property (strong, nonatomic) UIWindow *window;

//用来替代以往的 NSString 方法
-(NSString *)showText:(NSString *)key;
- (void)setUpRootVC;
-(void)comeBackToRootVC;
@end

