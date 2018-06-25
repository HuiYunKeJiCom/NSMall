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
#import "UserHeaderV.h"
#import "ADOrderTopToolView.h"
#import "UIButton+Bootstrap.h"


@interface UserPageVC ()
@property(nonatomic,strong)UserPageModel *userPageM;/* 个人页面模型 */
@property(nonatomic,strong)UserHeaderV *headerV;/* 头部View */
@property(nonatomic,strong)UIView *btnV;/* 按钮View */
@property(nonatomic,strong)UIView * identificateV;/* 实名认证View */
@property(nonatomic,strong)UIButton *classifyBtn;/* 发起聊天 按钮 */
@property(nonatomic,strong)UIButton *shopCartBtn;/* 加为好友 按钮 */
@property(nonatomic,strong)UIButton *QRBtn;/* 二维码 按钮 */
@end

@implementation UserPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KBGCOLOR;
    [self createUI];
    [self setUpData];
    [self setUpNavTopView];
    [self makeConstraints];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"个人中心")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

-(void)createUI{
    self.headerV = [[UserHeaderV alloc]init];
    self.headerV.backgroundColor = kWhiteColor;
    [self.view addSubview:self.headerV];
    
    self.headerV.editBtnClickBlock = ^{
        DLog(@"点击编辑");
    };
    self.headerV.shareBtnClickBlock = ^{
        DLog(@"点击分享");
    };
    
    self.btnV = [[UIView alloc]init];
    self.btnV.backgroundColor = kWhiteColor;
    [self.view addSubview:self.btnV];
    
    float itemWidth = GetScaleWidth(70);
    float spaceWidth = (kScreenWidth-3*GetScaleWidth(70))/4.0;
    self.classifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.classifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.classifyBtn setImageWithTitle:IMAGE(@"home_ico_category")
                              withTitle:@"发起聊天" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.btnV addSubview:self.classifyBtn];
    
    self.classifyBtn.x = spaceWidth;
    self.classifyBtn.y = -GetScaleWidth(10);
    self.classifyBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.classifyBtn addTarget:self action:@selector(classifyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.shopCartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shopCartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shopCartBtn setImageWithTitle:IMAGE(@"home_ico_buycar")
                              withTitle:@"加为好友" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.btnV addSubview:self.shopCartBtn];
    self.shopCartBtn.x = itemWidth+2*spaceWidth;
    self.shopCartBtn.y = -GetScaleWidth(10);
    self.shopCartBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.shopCartBtn addTarget:self action:@selector(shopCartButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.QRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.QRBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.QRBtn setImageWithTitle:IMAGE(@"home_ico_qrcode")
                        withTitle:@"二维码" position:@"top" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.btnV addSubview:self.QRBtn];
    self.QRBtn.x = itemWidth*2+3*spaceWidth;
    self.QRBtn.y = -GetScaleWidth(10);
    self.QRBtn.size = CGSizeMake(itemWidth, GetScaleWidth(112));
    [self.QRBtn addTarget:self action:@selector(QRButtonClick) forControlEvents:UIControlEventTouchUpInside];

    self.identificateV = [[UIView alloc]init];
    self.identificateV.backgroundColor = kWhiteColor;
    [self.view addSubview:self.identificateV];
    
    UIImageView *certificationIV = [[UIImageView alloc]init];
    certificationIV.backgroundColor = [UIColor purpleColor];
    [self.identificateV addSubview:certificationIV];
    certificationIV.x = GetScaleWidth(18);
    certificationIV.y = GetScaleWidth(15);
    certificationIV.size = CGSizeMake(GetScaleWidth(23), GetScaleWidth(19));
    
    UILabel *certificationL = [[UILabel alloc]init];
    certificationL.textColor = kBlackColor;
    certificationL.font = UISystemFontSize(14);
    certificationL.text = @"实名认证";
    [self.identificateV addSubview:certificationL];
    certificationL.x = GetScaleWidth(48);
    certificationL.y = GetScaleWidth(18);
    certificationL.size = CGSizeMake(GetScaleWidth(53), GetScaleWidth(13));
    
    UIImageView *arrowIV = [[UIImageView alloc]init];
    arrowIV.image = IMAGE(@"my_ico_right_arrow");
    [self.identificateV addSubview:arrowIV];
    arrowIV.x = kScreenWidth - GetScaleWidth(19)-GetScaleWidth(9);
    arrowIV.y = GetScaleWidth(19);
    arrowIV.size = CGSizeMake(GetScaleWidth(5), GetScaleWidth(9));
}

-(void)setUpData{
    UserModel *userModel = [UserModel modelFromUnarchive];
    [UserPageAPI getUserById:userModel.user_id success:^(UserPageModel * _Nullable result) {
        DLog(@"获取指定用户信息成功");
        self.userPageM = result;
        self.headerV.userPageM = self.userPageM;
    } faulre:^(NSError *error) {
        DLog(@"获取指定用户信息失败");
    }];
}

- (void)makeConstraints {
    
    WEAKSELF
    [self.headerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(TopBarHeight);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(184)));
    }];
    
    [self.btnV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.self.headerV.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(90)));
    }];
    
    [self.identificateV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.self.btnV.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(48)));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)classifyButtonClick {
    DLog(@"点击发起聊天");
}

- (void)shopCartButtonClick {
    DLog(@"点击加为好友");
}

- (void)QRButtonClick {
    DLog(@"点击二维码");
}

@end
