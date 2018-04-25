//
//  NSPersonInfoViewController.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSPersonInfoViewController.h"
#import "ADLMyInfoTableView.h"
#import "ADOrderTopToolView.h"//自定义导航栏

@interface NSPersonInfoViewController ()<ADLMyInfoTableViewDelegate>
@property (strong, nonatomic) ADLMyInfoTableView   *otherTableView;

@end

@implementation NSPersonInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpData];
    [self.view addSubview:self.otherTableView];
    [self setUpBase];
    [self makeConstraints];
    
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
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"头像") imageName:@"my_ico_wallet" num:nil]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"昵称") imageName:@"my_ico_goods" num:@"Peter"]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"性别") imageName:@"my_ico_shop" num:@"男"]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"手机号") imageName:@"my_ico_order" num:@"13765432108"]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"实名认证") imageName:@"my_ico_fav" num:@"未认证"]];
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
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"性别") imageName:@"my_ico_shop" num:@"男"]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"手机号") imageName:@"my_ico_order" num:@"13765432108"]];
    [self.otherTableView.data addObject:[[ADLMyInfoModel alloc] initWithTitle:KLocalizableStr(@"实名认证") imageName:@"my_ico_fav" num:@"未认证"]];
    switch (index) {
        case 0:{
            NSLog(@"点击了头像");
        }
            break;
        case 1:{
            NSLog(@"点击了昵称");
        }
            break;
        case 2:{
            NSLog(@"点击了性别");
        }
            break;
        case 3:{
            NSLog(@"点击了手机号");
        }
            break;
        case 4:{
            NSLog(@"点击了实名认证");
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
