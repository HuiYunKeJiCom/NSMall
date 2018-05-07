//
//  NSHomePageVC.m
//  NSMall
//
//  Created by apple on 2018/4/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSHomePageVC.h"
#import "LoginAPI.h"
#import "HomePageAPI.h"

@interface NSHomePageVC ()

@property (nonatomic,strong)UITableView *tableView;//


@end

@implementation NSHomePageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self buildUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutUI];
    
//    LoginParam *param = [LoginParam new];
//    param.loginAccount = @"test4";
//    param.password = @"123456";
//    param.loginType = @"1";
//    [LoginAPI loginWithParam:param success:^{
//        DLog(@"登录成功");
//
//        [HomePageAPI getProductList:nil success:^(ProductListModel *result) {
//            DLog(@"result : %@",result);
//        } failure:^(NSError *error) {
//
//        }];
//
//    } faulre:^(NSError *error) {
//        DLog(@"登录失败");
//    }];
    
}

- (void)buildUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
}

- (void)layoutUI{
    _tableView.size = CGSizeMake(AppWidth, AppHeight - TopBarHeight - TabBarHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
