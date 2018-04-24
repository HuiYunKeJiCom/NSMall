//
//  BaseViewCtrl.m
//  Economic
//
//  Created by occ on 15/8/3.
//  Copyright (c) 2015年 occ. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "UIView+Frame.h"

#define kFFVenueNoDataPromptMessage  KLocalizableStr(@"没有数据喽,点击重新刷新~")


@interface BaseViewCtrl ()

@end

@implementation BaseViewCtrl

- (void)dealloc {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBACKGROUNDCOLOR;
    [self.view addSubview:self.noDataView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  IOS7隐藏状态栏
 *
 *  @return 状态栏属性
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO; // 是否隐藏状态栏
}

#pragma mark - getter

-(FFLoadFailView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [[FFLoadFailView alloc]initWithFrame:self.view.frame title:kFFVenueNoDataPromptMessage];
        
//        WEAKSELF
        _noDataView.requestDataBlock = ^(void) {
//            [weak_self reloadDataSource];
        };
        
        [_noDataView setHidden:YES];
    }
    return _noDataView;
}

- (MBProgressHUD *)hud {
    
    if (!_hud) {
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:true];
        _hud.hidden = YES;
    }
    
    return _hud;
}

@end
