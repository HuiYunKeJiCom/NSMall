//
//  NSMyCenterViewController.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMyCenterViewController.h"
//#import "NSPersonInfoViewController.h"
#import "ADLMyInfoTableView.h"
#import "ADLUpdateUserInformCtrl.h"
#import "UserInfoAPI.h"

@interface NSMyCenterViewController ()<ADLMyInfoTableViewDelegate>
@property (strong, nonatomic) ADLMyInfoTableView   *otherTableView;

@end

@implementation NSMyCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpData];
    [self.view addSubview:self.otherTableView];
    [self setUpBase];
    [self makeConstraints];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UserInfoAPI getUserInfo:nil success:^{
        NSLog(@"获取用户信息");
        self.otherTableView.userModel = [UserModel modelFromUnarchive];
        
    } faulre:^(NSError *error) {
        NSLog(@"获取用户信息失败");
    }];
}

- (void)makeConstraints {
    WEAKSELF
    [self.otherTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.view);
        make.bottom.mas_equalTo(weakSelf.view).with.offset(-50);
        make.left.right.mas_equalTo(weakSelf.view);
    }];
}

#pragma mark - 获取数据
- (void)setUpData
{
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"我的钱包") imageName:@"my_ico_wallet" num:nil]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"我的商品") imageName:@"my_ico_goods" num:nil]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"我的店铺") imageName:@"my_ico_shop" num:nil]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"我的订单") imageName:@"my_ico_order" num:nil]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"我的收藏") imageName:@"my_ico_fav" num:nil]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"设置") imageName:@"my_ico_setting" num:nil]];
}

#pragma mark - initialize
- (void)setUpBase {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.otherTableView.tableFooterView = [UIView new]; //去除多余分割线
}

#pragma mark - LazyLoad
- (ADLMyInfoTableView *)otherTableView {
    if (!_otherTableView) {
        _otherTableView = [[ADLMyInfoTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _otherTableView.backgroundColor = UIColorFromRGB(0xf4f5f9);;
        _otherTableView.bounces = NO;
        _otherTableView.tbDelegate = self;
        _otherTableView.isRefresh = NO;
        _otherTableView.isLoadMore = NO;
        if (@available(iOS 11.0, *)) {
            _otherTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _otherTableView;
}

#pragma mark - ADLMyInfoTableViewDelegate

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.section;
    
    switch (index) {
        case 0:{
            NSLog(@"点击了头像");
        }
            break;
        case 1:{
            NSLog(@"点击了我的钱包");
        }
            break;
        case 2:{
            NSLog(@"点击了我的商品");
        }
            break;
        case 3:{
            NSLog(@"点击了我的店铺");
        }
            break;
        case 4:{
            NSLog(@"点击了我的订单");
        }
            break;
        case 5:{
            NSLog(@"点击了我的收藏");
        }
            break;
        case 6:{
            NSLog(@"点击了设置");
            //跳转至个人信息
//            NSPersonInfoViewController *personInfoVC = [[NSPersonInfoViewController alloc]init];
            ADLUpdateUserInformCtrl *userInfoVC = [ADLUpdateUserInformCtrl new];
            [self.navigationController pushViewController:userInfoVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
