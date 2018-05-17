//
//  AddFriendViewController.m
//  testhuanxin
//
//  Created by gyh on 16/5/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AddFriendViewController.h"
#import "ADOrderTopToolView.h"

@interface AddFriendViewController ()
@property (nonatomic , weak) UITextField *addfield;

@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *addfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 30)];
    addfield.placeholder = @"添加好友";
    [self.view addSubview:addfield];
    self.addfield = addfield;
    
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(10, CGRectGetMaxY(addfield.frame)+20, self.view.frame.size.width-40, 40);
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(addhaoyou) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    [self setUpNavTopView];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"添加好友")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    [self.view bringSubviewToFront:topToolView];
}

- (void)addhaoyou
{
    NSString *str = [[EMClient sharedClient] currentUsername];
    NSString *msg = [str stringByAppendingString:@"要加你为好友"];
    EMError *error = [[EMClient sharedClient].contactManager addContact:self.addfield.text message:msg];
    if (!error) {
        NSLog(@"添加好友成功");
        [MBProgressHUD showSuccess:@"添加好友成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"添加好友失败,%@",error);
        [MBProgressHUD showSuccess:@"添加好友失败"];
    }
}


@end
