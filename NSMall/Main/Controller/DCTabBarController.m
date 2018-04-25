//
//  DCTabBarController.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCTabBarController.h"

// Controllers
#import "DCNavigationController.h"
#import "NSHomePageViewController.h"//首页
#import "NSNearbyViewController.h"//附近
#import "NSMyCenterViewController.h"//我的
#import "NSMessageViewController.h"//消息
//#import "NSPublishViewController.h"//发布

#import "XWPopMenuController.h"//发布
// Views
#import "DCTabBadgeView.h"
// Vendors

// Categories

// Others

@interface DCTabBarController ()<UITabBarControllerDelegate>

//消息
@property (nonatomic, weak) NSMessageViewController *beautyMsgVc;

@property (nonatomic, strong) NSMutableArray *tabBarItems;
//给item加上badge
@property (nonatomic, weak) UITabBarItem *item;

@end

@implementation DCTabBarController

#pragma mark - LazyLoad
- (NSMutableArray *)tabBarItems {
    
    if (_tabBarItems == nil) {
        _tabBarItems = [NSMutableArray array];
    }
    
    return _tabBarItems;
}

#pragma mark - LifeCyle

//- (void)viewWillAppear:(BOOL)animated {
//
//    [super viewWillAppear:animated];
//
////    // 添加通知观察者
////    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeValue) name:DCMESSAGECOUNTCHANGE object:nil];
//
//    // 添加badgeView
//    [self addBadgeViewOnTabBarButtons];
//
//     self.selectedViewController = [self.viewControllers objectAtIndex:0]; //默认选择商城index为1
//}

-(void)goToSelectedViewControllerWith:(NSInteger)index{
    self.selectedViewController = [self.viewControllers objectAtIndex:index];
}

#pragma mark - initialize
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加badgeView
    [self addBadgeViewOnTabBarButtons];
    self.delegate = self;
    
    [self addDcChildViewContorller];
}


#pragma mark - 添加子控制器
- (void)addDcChildViewContorller
{
    NSArray *childArray = @[
                            @{MallClassKey  : @"NSHomePageViewController",
                              MallTitleKey  : @"首页",
                              MallImgKey    : @"main_ico_home",
                              MallSelImgKey : @"main_ico_home_selected"},

                            @{MallClassKey  : @"NSNearbyViewController",
                              MallTitleKey  : @"附近",
                              MallImgKey    : @"main_ico_nearby",
                              MallSelImgKey : @"main_ico_nearby_selected"},

                            @{MallClassKey  : @"XWPopMenuController",
                              MallTitleKey  : @"发布",
                              MallImgKey    : @"main_ico_add",
                              MallSelImgKey : @"main_ico_add"},
                            
                            @{MallClassKey  : @"NSMessageViewController",
                              MallTitleKey  : @"消息",
                              MallImgKey    : @"main_ico_message",
                              MallSelImgKey : @"main_ico_message_selected"},
                            
                            @{MallClassKey  : @"NSMyCenterViewController",
                              MallTitleKey  : @"我的",
                              MallImgKey    : @"main_ico_myinfo",
                              MallSelImgKey : @"main_ico_myinfo_selected"},
                            
                            ];
    [childArray enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIViewController *vc = [NSClassFromString(dict[MallClassKey]) new];
        DCNavigationController *nav = [[DCNavigationController alloc] initWithRootViewController:vc];
        
        if([dict[MallTitleKey] isEqualToString:@"发布"]){
            UITabBarItem *item = nav.tabBarItem;
            item.image = [UIImage imageNamed:dict[MallImgKey]];
            item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.selectedImage = [[UIImage imageNamed:dict[MallSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.title = dict[MallTitleKey];
            item.imageInsets = UIEdgeInsetsMake(-40, 0,0, 0);//（当只有图片的时候）需要自动调整
            [item setTitlePositionAdjustment:UIOffsetMake(0,0)];
        }else{
            UITabBarItem *item = nav.tabBarItem;
            item.image = [UIImage imageNamed:dict[MallImgKey]];
            item.image = [item.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.selectedImage = [[UIImage imageNamed:dict[MallSelImgKey]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            item.title = dict[MallTitleKey];
//            if([item.title isEqualToString:@"发布"]){
//                item.imageInsets = UIEdgeInsetsMake(-40, 0,0, 0);//（当只有图片的时候）需要自动调整
//            }else{
                item.imageInsets = UIEdgeInsetsMake(-4, 0,0, 0);//（当只有图片的时候）需要自动调整
//            }
            [item setTitlePositionAdjustment:UIOffsetMake(0,0)];
        }
        
        [self addChildViewController:nav];
//        WEAKSELF
//        if ([dict[MallTitleKey] isEqualToString:@"我的"]) {
////            weakSelf.beautyMsgVc = (ADMyCenterViewController *)vc; //给美信赋值
//            NSLog(@"weakSelf.beautyMsgVc = %@",weakSelf.beautyMsgVc);
//        }
        
        // 添加tabBarItem至数组
        [self.tabBarItems addObject:vc.tabBarItem];
    }];
}

#pragma mark - 控制器跳转拦截
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
//    if(viewController == [tabBarController.viewControllers objectAtIndex:4]){
    
//        if (![[DCObjManager dc_readUserDataForKey:@"isLogin"] isEqualToString:@"1"]) {
//
//            DCLoginMeViewController *dcLoginVc = [DCLoginMeViewController new];
//            [self presentViewController:dcLoginVc animated:YES completion:nil];
//            return NO;
//        }
//    }
    return YES;
}

#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
//    NSLog(@"viewController = %@",[[(DCNavigationController *)viewController topViewController] className]);
    
    
    
    //点击tabBarItem动画
    [self tabBarButtonClick:[self getTabBarButton]];
//    if ([self.childViewControllers.firstObject isEqual:viewController]) { //根据tabBar的内存地址找到美信发通知jump
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"jump" object:nil];
//    }

}
- (UIControl *)getTabBarButton{
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc]initWithCapacity:0];

    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            [tabBarButtons addObject:tabBarButton];
        }
    }
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}

#pragma mark - 点击动画
- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    NSLog(@"点击了tabBarButton = %.2f",tabBarButton.x);
    for (UIView *imageView in tabBarButton.subviews) {
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据自己需求改动
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //添加动画
            [imageView.layer addAnimation:animation forKey:nil];
        }
    }
    
}


#pragma mark - 更新badgeView
- (void)updateBadgeValue
{
//    _beautyMsgVc.tabBarItem.badgeValue = [DCObjManager dc_readUserDataForKey:@"isLogin"];
}


#pragma mark - 添加所有badgeView
- (void)addBadgeViewOnTabBarButtons {
    
    // 设置初始的badegValue
//    _beautyMsgVc.tabBarItem.badgeValue = [DCObjManager dc_readUserDataForKey:@"isLogin"];
    
//    int i = 0;
//    for (UITabBarItem *item in self.tabBarItems) {
    
//    NSLog(@"self.tabBarItems.count = %lu",self.tabBarItems.count);
        if (self.tabBarItems.count > 0) {
            UITabBarItem *item = self.tabBarItems[3];
            // 只在消息上添加
            [self addBadgeViewWithBadgeValue:item.badgeValue atIndex:3];
            // 监听item的变化情况
            [item addObserver:self forKeyPath:@"badgeValue" options:NSKeyValueObservingOptionNew context:nil];
            _item = item;
        }
//        i++;
//    }
}

- (void)addBadgeViewWithBadgeValue:(NSString *)badgeValue atIndex:(NSInteger)index {
    
    DCTabBadgeView *badgeView = [DCTabBadgeView buttonWithType:UIButtonTypeCustom];
    
//    CGFloat tabBarButtonWidth = self.tabBar.dc_width / self.tabBarItems.count;
//    CGFloat tabBarButtonWidth = 45;
//
//    badgeView.dc_centerX = index * (tabBarButtonWidth + (kScreenWidth-4*45)/5.0);
    
    CGFloat tabBarButtonWidth = self.tabBar.dc_width / self.tabBarItems.count;
    
    badgeView.dc_centerX = index * tabBarButtonWidth + 40;
    
    badgeView.tag = index + 1;
    
    badgeView.badgeValue = badgeValue;
    
    [self.tabBar addSubview:badgeView];
}

#pragma mark - 只要监听的item的属性一有新值，就会调用该方法重新给属性赋值
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    for (UIView *subView in self.tabBar.subviews) {
        if ([subView isKindOfClass:[DCTabBadgeView class]]) {
            if (subView.tag == 1) {
                DCTabBadgeView *badgeView = (DCTabBadgeView *)subView;
                badgeView.badgeValue = _beautyMsgVc.tabBarItem.badgeValue;
            }
        }
    }
    
}


#pragma mark - 移除通知
- (void)dealloc {
    [_item removeObserver:self forKeyPath:@"badgeValue"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 禁止屏幕旋转
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//只支持这一个方向(正常的方向)
}

@end
