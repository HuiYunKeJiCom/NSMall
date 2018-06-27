//
//  NSAddWalletVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSAddWalletVC.h"
#import "ADOrderTopToolView.h"
#import "NSBindWalletParam.h"
#import "WalletAPI.h"

@interface NSAddWalletVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *nameTF;/* 钱包名称 */
@property(nonatomic,strong)UITextField *accountTF;/* 钱包账号 */
@property(nonatomic,strong)UITextField *loginPwTF;/* 钱包登录密码 */
@property(nonatomic,strong)UITextField *tradePwTF;/* 钱包交易密码 */
@end

@implementation NSAddWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGCOLOR;
    [self setUpNavTopView];
    [self buildUI];
}

-(void)buildUI{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, TopBarHeight+1, kScreenWidth, (24+17)*4)];
    bgView.backgroundColor = kWhiteColor;
    [self.view addSubview:bgView];
    
    UILabel *nameTitle = [[UILabel alloc]init];
    nameTitle.font = UISystemFontSize(14);
    nameTitle.textColor = kBlackColor;
    nameTitle.x = 19;
    nameTitle.y = 12;
    nameTitle.text = @"钱包名称:";
    [nameTitle sizeToFit];
    [bgView addSubview:nameTitle];
    
    self.nameTF = [[UITextField alloc]init];
    self.nameTF.x = CGRectGetMaxX(nameTitle.frame);
    self.nameTF.y = 12;
    self.nameTF.size = CGSizeMake(kScreenWidth-self.nameTF.x, GetScaleWidth(17));
    self.nameTF.font = [UIFont systemFontOfSize:14];
    self.nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTF.placeholder = @"点击输入文本";
    self.nameTF.textColor = kGreyColor;
    self.nameTF.backgroundColor = kWhiteColor;
    self.nameTF.delegate = self;
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, GetScaleWidth(17))];
    self.nameTF.leftView = paddingView;
    self.nameTF.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:self.nameTF];
    
    UILabel *accountTitle = [[UILabel alloc]init];
    accountTitle.font = UISystemFontSize(14);
    accountTitle.textColor = kBlackColor;
    accountTitle.x = 19;
    accountTitle.y = CGRectGetMaxY(nameTitle.frame)+24;
    accountTitle.text = @"钱包账号:";
    [accountTitle sizeToFit];
    [bgView addSubview:accountTitle];
    
    self.accountTF = [[UITextField alloc]init];
    self.accountTF.x = CGRectGetMaxX(nameTitle.frame);
    self.accountTF.y = CGRectGetMaxY(nameTitle.frame)+24;
    self.accountTF.size = CGSizeMake(kScreenWidth-self.accountTF.x, GetScaleWidth(17));
    self.accountTF.font = [UIFont systemFontOfSize:14];
    self.accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.accountTF.placeholder = @"请输入钱包账号";
    self.accountTF.textColor = kGreyColor;
    self.accountTF.backgroundColor = kWhiteColor;
    self.accountTF.delegate = self;
    UIView *paddingView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, GetScaleWidth(17))];
    self.accountTF.leftView = paddingView1;
    self.accountTF.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:self.accountTF];
    
    UILabel *loginPw = [[UILabel alloc]init];
    loginPw.font = UISystemFontSize(14);
    loginPw.textColor = kBlackColor;
    loginPw.x = 19;
    loginPw.y = CGRectGetMaxY(accountTitle.frame)+24;
    loginPw.text = @"登录密码:";
    [loginPw sizeToFit];
    [bgView addSubview:loginPw];
    
    self.loginPwTF = [[UITextField alloc]init];
    self.loginPwTF.x = CGRectGetMaxX(nameTitle.frame);
    self.loginPwTF.y = CGRectGetMaxY(accountTitle.frame)+24;
    self.loginPwTF.size = CGSizeMake(kScreenWidth-self.loginPwTF.x, GetScaleWidth(17));
    self.loginPwTF.font = [UIFont systemFontOfSize:14];
    self.loginPwTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.loginPwTF.placeholder = @"请输入钱包登录密码";
    self.loginPwTF.textColor = kGreyColor;
    self.loginPwTF.secureTextEntry = YES;
    self.loginPwTF.backgroundColor = kWhiteColor;
    self.loginPwTF.delegate = self;
    UIView *paddingView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, GetScaleWidth(17))];
    self.loginPwTF.leftView = paddingView2;
    self.loginPwTF.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:self.loginPwTF];
    
    UILabel *tradePw = [[UILabel alloc]init];
    tradePw.font = UISystemFontSize(14);
    tradePw.textColor = kBlackColor;
    tradePw.x = 19;
    tradePw.y = CGRectGetMaxY(loginPw.frame)+24;
    tradePw.text = @"交易密码:";
    [tradePw sizeToFit];
    [bgView addSubview:tradePw];
    
    self.tradePwTF = [[UITextField alloc]init];
    self.tradePwTF.x = CGRectGetMaxX(nameTitle.frame);
    self.tradePwTF.y = CGRectGetMaxY(loginPw.frame)+24;
    self.tradePwTF.size = CGSizeMake(kScreenWidth-self.tradePwTF.x, GetScaleWidth(17));
    self.tradePwTF.font = [UIFont systemFontOfSize:14];
    self.tradePwTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.tradePwTF.placeholder = @"请输入6位钱包交易密码";
    self.tradePwTF.secureTextEntry = YES;
    self.tradePwTF.textColor = kGreyColor;
    self.tradePwTF.backgroundColor = kWhiteColor;
    self.tradePwTF.delegate = self;
    UIView *paddingView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, GetScaleWidth(17))];
    self.tradePwTF.leftView = paddingView3;
    self.tradePwTF.leftViewMode = UITextFieldViewModeAlways;
    [bgView addSubview:self.tradePwTF];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = KMainColor;
    btn.x = 18;
    btn.y = CGRectGetMaxY(bgView.frame)+63;
    btn.size = CGSizeMake(kScreenWidth-36, 44);
    [btn setTitle:@"确认添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addWalletAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.layer.cornerRadius = 5;//设置那个圆角的有多圆
    btn.layer.masksToBounds = YES;//设为NO去试试
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.hidden = NO;
    topToolView.backgroundColor = [UIColor whiteColor];
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"添加钱包")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];// 使当前文本框失去第一响应者的特权，就会回收键盘了
    return YES;
}

-(void)addWalletAction{
    NSBindWalletParam *param = [NSBindWalletParam new];
    param.walletName = self.nameTF.text;
    param.account = self.accountTF.text;
    param.loginPassword = self.loginPwTF.text;
    param.tradePassword = self.tradePwTF.text;
    
    if (param.walletName.length == 0) {
        [Common AppShowToast:@"请输入钱包名称!"];
        return;
    } else if (param.account.length == 0) {
        [Common AppShowToast:@"请输入钱包账号!"];
        return;
    } else if (param.loginPassword.length == 0) {
        [Common AppShowToast:@"请输入钱包登录密码!"];
        return;
    }else if (param.tradePassword.length == 0) {
        [Common AppShowToast:@"请输入钱包交易密码!"];
        return;
    }
    
    [WalletAPI bindWalletWithParam:param success:^{
        DLog(@"绑定钱包成功");
        [self.navigationController popViewControllerAnimated:YES];
    } faulre:^(NSError *error) {
        DLog(@"绑定钱包失败");
    }];
}

@end
