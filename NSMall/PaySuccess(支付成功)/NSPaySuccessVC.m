//
//  NSPaySuccessVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/19.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSPaySuccessVC.h"
#import "DCTabBarController.h"

@interface NSPaySuccessVC ()
@property(nonatomic,strong)UIImageView *paySuccessIV;/* 成功图标 */
@property(nonatomic,strong)UILabel *paySuccessLab;/* 成功文字 */
@property(nonatomic,strong)UILabel *amountLab;/* 金额 */
@property(nonatomic,strong)UILabel *payeeLab;/* 收款人 */
@property(nonatomic,strong)UIImageView *payeeHeaderIV;/* 收款人头像 */
@property(nonatomic,strong)UILabel *payeeNameLab;/* 收款人昵称 */
@property(nonatomic,strong)UIButton *completeBtn;/* 完成按钮 */
@end

@implementation NSPaySuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kWhiteColor;
    [self buildUI];
    [self makeConstraints];
}

-(void)buildUI{

    [self.view addSubview:self.paySuccessIV];
    [self.view addSubview:self.paySuccessLab];
    [self.view addSubview:self.amountLab];
    [self.view addSubview:self.payeeLab];
    [self.view addSubview:self.payeeHeaderIV];
    [self.view addSubview:self.payeeNameLab];
    [self.view addSubview:self.completeBtn];
}

-(void)setUpDataWithModel:(UserPageModel *)userPageM andAmount:(NSString *)amount{
    self.paySuccessIV.image = IMAGE(@"money_ico_success");
    self.paySuccessLab.text = NSLocalizedString(@"pay success", nil);
    self.amountLab.text = [NSString stringWithFormat:@"N%.2f",[amount floatValue]];
    self.payeeLab.text = NSLocalizedString(@"payee", nil);
    [self.payeeHeaderIV sd_setImageWithURL:[NSURL URLWithString:userPageM.pic_img]];
    self.payeeNameLab.text = userPageM.nick_name;
    [self.completeBtn setTitle:NSLocalizedString(@"complete", nil) forState:UIControlStateNormal];
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.paySuccessIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(75);
        make.size.mas_equalTo(CGSizeMake(42, 45));
    }];
    
    [self.paySuccessLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.paySuccessIV.mas_bottom).with.offset(9);
    }];
    
    [self.amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.paySuccessLab.mas_bottom).with.offset(20);
    }];
    
    [self.payeeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.amountLab.mas_bottom).with.offset(83);
    }];
    
    [self.payeeHeaderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.payeeLab.mas_bottom).with.offset(14);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.payeeNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.top.equalTo(weakSelf.payeeHeaderIV.mas_bottom).with.offset(13);
    }];
    
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).with.offset(19);
        make.top.equalTo(weakSelf.payeeNameLab.mas_bottom).with.offset(104);
        make.right.equalTo(weakSelf.view.mas_right).with.offset(-19);
        make.height.mas_equalTo(44);
    }];
    
}

-(UIImageView *)paySuccessIV{
    if (!_paySuccessIV) {
        _paySuccessIV = [[UIImageView alloc] init];
        [_paySuccessIV setContentMode:UIViewContentModeScaleAspectFit];
    }
    return _paySuccessIV;
}

- (UILabel *)paySuccessLab {
    if (!_paySuccessLab) {
        _paySuccessLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:KMainColor];
    }
    return _paySuccessLab;
}

- (UILabel *)amountLab {
    if (!_amountLab) {
        _amountLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum17 TextColor:kBlackColor];
        _amountLab.font = [UIFont boldSystemFontOfSize:17];
    }
    return _amountLab;
}

- (UILabel *)payeeLab {
    if (!_payeeLab) {
        _payeeLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor lightGrayColor]];
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

- (UILabel *)payeeNameLab {
    if (!_payeeNameLab) {
        _payeeNameLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:kBlackColor];
    }
    return _payeeNameLab;
}

-(UIButton *)completeBtn{
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _completeBtn.showsTouchWhenHighlighted = YES;
        _completeBtn.backgroundColor = KMainColor;
        [_completeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _completeBtn.titleLabel.font = UISystemFontSize(14);
        _completeBtn.layer.masksToBounds = YES;
        _completeBtn.layer.cornerRadius = 10;
        
        [_completeBtn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

-(void)complete{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if([vc isKindOfClass:[DCTabBarController class]]){
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
    
    
//    [kAppDelegate comeBackToRootVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
