//
//  TDBaseViewController.m
//  Trade
//
//  Created by FeiFan on 2017/9/4.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDBaseViewController.h"

@interface TDBaseViewController ()

@end

@implementation TDBaseViewController


# pragma mark - IBActions

- (IBAction) clickedLeftBarItem:(id)sender {
    // delegate有自定义回退事件就用自定义的，否则直接回退
    if (self.tdDelegate && [self.tdDelegate respondsToSelector:@selector(viewController:clickedLeftBarItem:)]) {
        [self.tdDelegate viewController:self clickedLeftBarItem:self.navigationItem.leftBarButtonItem];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

# pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDatas];
    [self setupViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) setupDatas {
    self.view.backgroundColor = kBACKGROUNDCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void) setupViews {
//    UIBarButtonItem* leftBar = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back_unselected"] style:UIBarButtonItemStylePlain target:self action:@selector(clickedLeftBarItem:)];
//    UIBarButtonItem* fixBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    fixBar.width = sysVersion < 11.0 ? -10 : -20;
//    self.navigationItem.leftBarButtonItems = @[fixBar, leftBar];
    
    UIButton* backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"icon_back_unselected"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [backBtn addTarget:self action:@selector(clickedLeftBarItem:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(clickedLeftBarItem:)];
}

@end
