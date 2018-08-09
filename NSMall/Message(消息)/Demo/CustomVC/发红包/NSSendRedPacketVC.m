//
//  NSSendRedPacketVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSSendRedPacketVC.h"
#import "ADOrderTopToolView.h"
#import "WalletAPI.h"
#import "NSPayView.h"
#import "NSInputPwView.h"

@interface NSSendRedPacketVC ()<UITextFieldDelegate,NSInputPwViewDelegate>
@property(nonatomic,strong)UITextField *amountTF;/* 金额 */
@property(nonatomic,strong)UITextField *messageTF;/* 留言 */
@property(nonatomic,strong)UILabel *amountLab;/* 金额label */
@property(nonatomic,strong)UIButton *sendBtn;/* 发送按钮 */
@end

@implementation NSSendRedPacketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = KBGCOLOR;
    [self buildUI];
    [self setUpNavTopView];
    [self makeConstraints];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buildUI{
    
    [self.view addSubview:self.amountTF];
    [self.view addSubview:self.messageTF];
    [self.view addSubview:self.amountLab];
    [self.view addSubview:self.sendBtn];
    
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    [self.navigationController setNavigationBarHidden:YES];
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:@"发红包"];
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
    
    [self.amountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(20+TopBarHeight);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-40, 50));
    }];
    
    [self.messageTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.top.equalTo(weakSelf.amountTF.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-40, 50));
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.view.mas_left).with.offset(20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth-40, 50));
    }];
    
    [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.bottom.equalTo(weakSelf.sendBtn.mas_top).with.offset(-55);
    }];
}

- (UITextField *)amountTF {
    if (!_amountTF) {
        _amountTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _amountTF.font = [UIFont systemFontOfSize:14];
        //        _amountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _amountTF.textColor = [UIColor grayColor];
        _amountTF.backgroundColor = kWhiteColor;
        _amountTF.font = [UIFont boldSystemFontOfSize:14];
        _amountTF.delegate = self;
        [_amountTF.layer setMasksToBounds:YES];
        [_amountTF.layer setCornerRadius:10.0];
        _amountTF.textAlignment = NSTextAlignmentRight;
        _amountTF.placeholder = @"0.00";
        
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(00, 0, 60, 50)];
//        paddingView.backgroundColor = kRedColor;
        UILabel *sumLab = [[UILabel alloc]init];
        sumLab.frame = CGRectMake(20, 0, 45, 50);
        sumLab.text = @"金额";
        sumLab.textColor = kBlackColor;
        sumLab.font = [UIFont systemFontOfSize:14];
        [paddingView addSubview:sumLab];
        _amountTF.leftView = paddingView;
        _amountTF.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 50)];
        //        paddingView.backgroundColor = kRedColor;
        UILabel *unitLab = [[UILabel alloc]init];
        unitLab.frame = CGRectMake(10, 0, 20, 50);
        unitLab.text = @"N";
        unitLab.textColor = kBlackColor;
        unitLab.font = [UIFont systemFontOfSize:14];
        [rightView addSubview:unitLab];
        _amountTF.rightView = rightView;
        _amountTF.rightViewMode = UITextFieldViewModeAlways;
        
        
        [_amountTF addTarget:self action:@selector(amountTFTextChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _amountTF;
}

- (UITextField *)messageTF {
    if (!_messageTF) {
        _messageTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _messageTF.font = [UIFont systemFontOfSize:14];
        //        _amountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _messageTF.textColor = [UIColor grayColor];
        _messageTF.backgroundColor = kWhiteColor;
        _messageTF.font = [UIFont boldSystemFontOfSize:14];
        _messageTF.delegate = self;
        [_messageTF.layer setMasksToBounds:YES];
        [_messageTF.layer setCornerRadius:10.0];
        _messageTF.textAlignment = NSTextAlignmentRight;
        _messageTF.placeholder = @"恭喜发财,大吉大利";
        
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 50)];
        //        paddingView.backgroundColor = kRedColor;
        UILabel *sumLab = [[UILabel alloc]init];
        sumLab.frame = CGRectMake(20, 0, 45, 50);
        sumLab.text = @"留言";
        sumLab.textColor = kBlackColor;
        sumLab.font = [UIFont systemFontOfSize:14];
        [paddingView addSubview:sumLab];
        _messageTF.leftView = paddingView;
        _messageTF.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 50)];
        _messageTF.rightView = rightView;
        _messageTF.rightViewMode = UITextFieldViewModeAlways;
    }
    return _messageTF;
}

- (UILabel *)amountLab {
    if (!_amountLab) {
        _amountLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:20 TextColor:kBlackColor];
        _amountLab.textAlignment = NSTextAlignmentCenter;
        _amountLab.font = [UIFont boldSystemFontOfSize:40];
        NSString *text = @"N 0.00";
        
        NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
        NSRange rang = [text rangeOfString:@"N"];
        [LZString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
        [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rang];
        [LZString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:rang];
        _amountLab.attributedText = LZString;
    }
    return _amountLab;
}

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.showsTouchWhenHighlighted = YES;
        [_sendBtn setTitle:@"塞钱进红包" forState:UIControlStateNormal];
        _sendBtn.backgroundColor = kRedColor;
        [_sendBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = UISystemFontSize(14);
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 10;
        
        [_sendBtn addTarget:self action:@selector(payView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];// 使当前文本框失去第一响应者的特权，就会回收键盘了
    return YES;
}


-(void)amountTFTextChange:(UITextField *)textField{
//    NSLog(@"金额数值变化");
    NSString *text = [NSString stringWithFormat:@"N %.2f",[textField.text floatValue]];
    
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"N"];
    [LZString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:rang];
    _amountLab.attributedText = LZString;
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
//    self.walletID = walletID;
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
    
//    NSPayParam *param = [NSPayParam new];
//    param.userId = self.userId;
//    param.walletId = self.walletID;
//    param.amount = self.amountTF.text;
//    param.tradePassword = tradePw;
//
//    [ReceivableRecordAPI tradeWithParam:param success:^{
//        [Common AppShowToast:NSLocalizedString(@"pay success", nil)];
//        [self delayPop];
//        //跳转到成功页面
//    } faulre:^(NSError *error) {
//        DLog(@"支付失败");
//    }];
    
}

- (void)delayPop {
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [weakSelf.navigationController popViewControllerAnimated:YES];
    });
}


@end
