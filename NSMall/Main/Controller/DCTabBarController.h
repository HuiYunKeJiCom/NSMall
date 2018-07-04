//
//  DCTabBarController.h
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYLTabBarController.h"
#import "NSNearbyViewController.h"//附近
#import "NSMyCenterViewController.h"//我的
#import "NSHomePageVC.h"//新首页
#import "ConversationListController.h"//新消息
#import <UserNotifications/UserNotifications.h>

@interface DCTabBarController : CYLTabBarController

//@property (nonatomic, strong) NSHomePageVC *homeVC;
//@property (nonatomic, strong) NSNearbyViewController *nearbyVC;
@property (nonatomic, weak) ConversationListController *chatListVC;
//@property (nonatomic, strong) NSMyCenterViewController *myCenterVC;

+ (instancetype)sharedTabBarVC;//单例模式，直接取出可用

-(void)goToSelectedViewControllerWith:(NSInteger)index;

- (void)jumpToChatList;

//- (void)setupUntreatedApplyCount;

- (void)setupUnreadMessageCount;

- (void)networkChanged:(EMConnectionState)connectionState;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)didReceiveUserNotification:(UNNotification *)notification;

- (void)playSoundAndVibration;

- (void)showNotificationWithMessage:(EMMessage *)message;

@end
