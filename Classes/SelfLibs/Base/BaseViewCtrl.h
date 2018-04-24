//
//  BaseViewCtrl.h
//  Economic
//
//  Created by occ on 15/8/3.
//  Copyright (c) 2015年 occ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFLoadFailView.h"
#import <MBProgressHUD.h>

@interface BaseViewCtrl : UIViewController

@property(nonatomic,strong) UIView *topbar;
@property(nonatomic,strong) UILabel *titleLB;
@property(nonatomic,strong) FFLoadFailView *noDataView;
@property (nonatomic, strong) MBProgressHUD *hud;

@property(nonatomic,assign) BOOL isInform;     /** 模态*/  
@property(nonatomic,strong) NSArray *menuItems;  /** 菜单*/

@end
