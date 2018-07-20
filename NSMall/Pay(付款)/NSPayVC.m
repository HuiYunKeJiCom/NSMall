//
//  NSPayVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/19.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSPayVC.h"
#import "ADOrderTopToolView.h"
#import "UserPageAPI.h"
#import "WalletAPI.h"
#import "NSPayView.h"
#import "NSInputPwView.h"
#import "NSPayParam.h"
#import "ReceivableRecordAPI.h"
#import "NSPaySuccessVC.h"

@interface NSPayVC ()<NSInputPwViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIView *payeeV;/* 收款人View */
@property(nonatomic,strong)UILabel *payeeLab;/* 收款人 */
@property(nonatomic,strong)UIImageView *payeeHeaderIV;/* 收款人头像 */
@property(nonatomic,strong)UIView *amountV;/* 付款金额View */
@property(nonatomic,strong)UILabel *amountTitlelab;/* 金额 */
@property(nonatomic,strong)UILabel *unitLab;/* 金额单位 */
@property(nonatomic,strong)UITextField *amountTF;/* 金额输入框 */
@property(nonatomic,strong)UIView *lineView;/* 变颜色的线 */
@property(nonatomic,strong)UIButton *payBtn;/* 付款按钮 */
@property(nonatomic,strong)UserPageModel *userPageM;/* 个人页面模型 */
@property(nonatomic,copy)NSString *walletID;/* 购物车Id */
@property(nonatomic,strong)NSString *userId;/* 查询的userId */
@end

@implementation NSPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KBGCOLOR;
    [self buildUI];
    [self setUpNavTopView];
    [self makeConstraints];
}

-(void)buildUI{
    
    [self.view addSubview:self.payeeV];
    [self.payeeV addSubview:self.payeeLab];
    [self.payeeV addSubview:self.payeeHeaderIV];
    [self.view addSubview:self.amountV];
    [self.amountV addSubview:self.amountTitlelab];
    [self.amountV addSubview:self.unitLab];
    [self.amountV addSubview:self.amountTF];
    [self.amountV addSubview:self.lineView];
    [self.amountV addSubview:self.payBtn];
}

-(void)setUpData:(UserPageModel *)model{
    
    self.payeeLab.text = [NSString stringWithFormat:@"付款给%@",model.nick_name];
    [self.payeeHeaderIV sd_setImageWithURL:[NSURL URLWithString:model.pic_img]];
    self.amountTitlelab.text = @"金额";
    self.unitLab.text = @"N";
    [self.payBtn setTitle:@"付款" forState:UIControlStateNormal];
}

-(void)setUpDataWithUserId:(NSString *)userId{

    self.userId = userId;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    [UserPageAPI getUserById:userId success:^(UserPageModel * _Nullable result) {
        DLog(@"获取指定用户信息成功");
        self.userPageM = result;
        dispatch_group_leave(group);
    } faulre:^(NSError *error) {
        DLog(@"获取指定用户信息失败");
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        //请求完成后的处理、
        NSLog(@"完成");
        [self setUpData:self.userPageM];
    });
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    [self.navigationController setNavigationBarHidden:YES];
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"付款")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
        //        [self delayPop];
    };
    [self.view addSubview:topToolView];
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.payeeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(19);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-19);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(93);
            make.height.mas_equalTo(62);
    }];
    
    [self.payeeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.payeeV.mas_left).with.offset(19);
        make.centerY.equalTo(weakSelf.payeeV.mas_centerY);
    }];

    [self.payeeHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.payeeV.mas_right).with.offset(-14);
        make.top.equalTo(weakSelf.payeeV.mas_top).with.offset(11);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    [self.amountV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(19);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-19);
        make.top.equalTo(weakSelf.payeeV.mas_bottom);
        make.height.mas_equalTo(190);
    }];
    
    [self.amountTitlelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.amountV.mas_left).with.offset(19);
        make.top.equalTo(weakSelf.amountV.mas_top).with.offset(14);
    }];

    [self.unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.amountV.mas_left).with.offset(19);
        make.top.equalTo(weakSelf.amountTitlelab.mas_bottom).with.offset(20);
    }];
    
    [self.amountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.unitLab.mas_right);
        make.top.equalTo(weakSelf.amountTitlelab.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(300, 19));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.amountV.mas_left).with.offset(19);
        make.top.equalTo(weakSelf.unitLab.mas_bottom).with.offset(20);
        make.right.equalTo(weakSelf.amountV.mas_right).with.offset(-19);
        make.height.mas_equalTo(1);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.amountV.mas_left).with.offset(26);
        make.bottom.equalTo(weakSelf.amountV.mas_bottom).with.offset(-23);
        make.right.equalTo(weakSelf.amountV.mas_right).with.offset(-26);
        make.height.mas_equalTo(41);
    }];
    
}

- (UIView *)payeeV {
    if (!_payeeV) {
        _payeeV = [[UIView alloc] initWithFrame:CGRectZero];
        _payeeV.backgroundColor = UIColorFromRGB(0xfafafa);
//        _payeeV.layer.borderColor = [UIColor redColor].CGColor;//边框颜色
//        _payeeV.layer.borderWidth = 1;
//        _payeeV.layer.masksToBounds = YES;
//        _payeeV.layer.cornerRadius = 5;
    }
    return _payeeV;
}

- (UILabel *)payeeLab {
    if (!_payeeLab) {
        _payeeLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:kBlackColor];
    }
    return _payeeLab;
}

-(UIImageView *)payeeHeaderIV{
    if (!_payeeHeaderIV) {
        _payeeHeaderIV = [[UIImageView alloc] init];
        [_payeeHeaderIV setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _payeeHeaderIV;
}

- (UIView *)amountV {
    if (!_amountV) {
        _amountV = [[UIView alloc] initWithFrame:CGRectZero];
        _amountV.backgroundColor = kWhiteColor;
        //        _payeeV.layer.borderColor = [UIColor redColor].CGColor;//边框颜色
        //        _payeeV.layer.borderWidth = 1;
//        _amountV.layer.masksToBounds = YES;
//        _amountV.layer.cornerRadius = 5;
    }
    return _amountV;
}

- (UILabel *)amountTitlelab {
    if (!_amountTitlelab) {
        _amountTitlelab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor lightGrayColor]];
    }
    return _amountTitlelab;
}

- (UILabel *)unitLab {
    if (!_unitLab) {
        _unitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum17 TextColor:kBlackColor];
        _unitLab.font = [UIFont boldSystemFontOfSize:15];
    }
    return _unitLab;
}

- (UITextField *)amountTF {
    if (!_amountTF) {
        _amountTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _amountTF.font = [UIFont systemFontOfSize:16];
//        _amountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _amountTF.textColor = kBlackColor;
        _amountTF.backgroundColor = kWhiteColor;
        _amountTF.font = [UIFont boldSystemFontOfSize:15];
        _amountTF.delegate = self;
        
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 19)];
        _amountTF.leftView = paddingView;
        _amountTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _amountTF;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = kBlackColor;
    }
    return _lineView;
}

-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.showsTouchWhenHighlighted = YES;
        _payBtn.backgroundColor = KMainColor;
        [_payBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _payBtn.titleLabel.font = UISystemFontSize(14);
        _amountV.layer.masksToBounds = YES;
        _amountV.layer.cornerRadius = 10;

        [_payBtn addTarget:self action:@selector(payView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)payView{

    [WalletAPI getWalletListWithParam:nil success:^(NSWalletModel *walletModel) {
        NSLog(@"获取钱包列表成功");

        NSPayView *payView = [[NSPayView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
        payView.userInteractionEnabled = YES;
        payView.payString = [NSString stringWithFormat:@"N%.2f",[self.amountTF.text floatValue]];
        payView.walletNameArr = [NSMutableArray arrayWithArray:walletModel.walletList];
        __weak typeof(payView) PayView = payView;
        payView.confirmClickBlock = ^{
            [PayView removeView];
            [self showInputPwView:PayView.walletId];
        };
        [payView showInView:self.navigationController.view];
    } faulre:^(NSError *error) {
        NSLog(@"获取钱包列表失败");
    }];

}

-(void)showInputPwView:(NSString *)walletID{
    self.walletID = walletID;
    NSInputPwView *inputView = [[NSInputPwView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
    inputView.tbDelegate = self;
    __weak typeof(inputView) InputView = inputView;
    inputView.backClickBlock = ^{
        [InputView removeView];
        [self payView];
    };
    [inputView showInView:self.navigationController.view];
}

-(void)payOrder:(NSString *)tradePw{
    
    NSPayParam *param = [NSPayParam new];
    param.userId = self.userId;
    param.walletId = self.walletID;
    param.amount = self.amountTF.text;
    param.tradePassword = tradePw;
    
    [ReceivableRecordAPI tradeWithParam:param success:^{
        [Common AppShowToast:@"支付成功"];
        [self delayPop];
        //跳转到成功页面
    } faulre:^(NSError *error) {
        DLog(@"支付失败");
    }];

}

- (void)delayPop {
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        NSPaySuccessVC *paySuccessVC = [NSPaySuccessVC new];
        [paySuccessVC setUpDataWithModel:self.userPageM andAmount:self.amountTF.text];
        [weakSelf.navigationController pushViewController:paySuccessVC animated:YES];
    });
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.lineView.backgroundColor = KMainColor;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.amountTF resignFirstResponder];// 使当前文本框失去第一响应者的特权，就会回收键盘了
    
    return YES;
}

@end
