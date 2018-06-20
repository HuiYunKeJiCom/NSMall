//
//  UserPageVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import "UserPageVC.h"
#import "UserPageAPI.h"
#import "UserPageModel.h"

@interface UserPageVC ()
@property(nonatomic,strong)UserPageModel *userPageM;/* 个人页面模型 */
@property(nonatomic,strong)UIView *headerV;/* 头部View */
@property(nonatomic,strong)UIView *btnV;/* 按钮View */
@property(nonatomic,strong)UIView * identificateV;/* 实名认证View */
@end

@implementation UserPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self setUpData];
    
}

-(void)createUI{
    self.headerV = [[UIView alloc]init];
    [self.view addSubview:self.headerV];
    
    self.btnV = [[UIView alloc]init];
    [self.view addSubview:self.btnV];
    
    self.identificateV = [[UIView alloc]init];
    [self.view addSubview:self.identificateV];
}

-(void)setUpData{
    UserModel *userModel = [UserModel modelFromUnarchive];
    [UserPageAPI getUserById:userModel.user_id success:^(UserPageModel * _Nullable result) {
        DLog(@"获取指定用户信息成功");
        self.userPageM = result;
    } faulre:^(NSError *error) {
        DLog(@"获取指定用户信息失败");
    }];
}

- (void)makeConstraints {
    
    WEAKSELF
    [self.headerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).with.offset(GetScaleWidth(19));
        make.top.equalTo(weakSelf.contentView).with.offset(GetScaleWidth(12));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(20), GetScaleWidth(20)));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
