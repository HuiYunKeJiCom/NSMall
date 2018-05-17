//
//  TDBaseViewController.h
//  Trade
//
//  Created by FeiFan on 2017/9/4.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TDBaseViewControllerDelegate <NSObject>

@optional

/**
 左标题按钮的点击事件处理;

 @param viewController 当前视图控制器;
 @param leftBarItem 左按钮;
 */
- (void) viewController:(UIViewController*)viewController clickedLeftBarItem:(UIBarButtonItem*)leftBarItem;

@end

@interface TDBaseViewController : UIViewController

@property (nonatomic, weak) id<TDBaseViewControllerDelegate> tdDelegate;

// 初始化数据(子类需要重载，无需调用viewDidLoad)
- (void) setupDatas;

// 初始化子视图(子类需要重载，无需调用viewDidLoad)
- (void) setupViews;

@end
