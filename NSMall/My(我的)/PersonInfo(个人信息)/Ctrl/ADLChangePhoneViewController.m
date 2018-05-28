//
//  ADLChangePhoneViewController.m
//  Lock
//
//  Created by 张锐凌 on 2017/12/29.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ADLChangePhoneViewController.h"
#import "UIView+animation.h"
#import "NSTimer+BlockSupport.h"
#import "NSTimer+wrapper.h"
#import "ADLTitleField.h"
#import "UserInfoAPI.h"
#import "GetVcodeAPI.h"
#import "GetVcodeParam.h"

@interface ADLChangePhoneViewController ()<UITextFieldDelegate>
//@property (nonatomic, strong) UITextField         *contentField;
@property (nonatomic, strong) UIButton            *commitButton;

@property (nonatomic, strong) UIView             *phoneView;
@property (nonatomic, strong) UILabel            *markLab;
@property (nonatomic, strong) UITextField        *countryField;
@property (nonatomic, strong) UIView             *lineView;
@property (nonatomic, strong) UITextField        *phoneField;

@property (nonatomic, strong) ADLTitleField        *codeField;
@property (nonatomic, strong) UILabel             *errorLabel;
@property (nonatomic, strong) UIButton            *codeButton;
//@property (nonatomic, strong) UIButton            *commitButton;

@property (nonatomic,strong)  NSDate    *currentDate;     /** 当前时间*/
@property (nonatomic,strong)  NSTimer   *timer;           /** 计时器*/
@end

@implementation ADLChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KColorTextFFFFFF;
    
//    [self.view addSubview:self.phoneField];
//    [self.view addSubview:self.commitButton];
    [self initViews];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
//    [self makeConstraints];
    
}



- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark - setter / getter

- (void)setEditTitle:(NSString *)editTitle {
    _editTitle = editTitle;
    
    self.title = [NSString stringWithFormat:@"%@ %@",KLocalizableStr(@"修改"),_editTitle];
    
    self.phoneField.placeholder = KLocalizableStr(@"请输入新的手机号码");
}




- (UITextField *)phoneField {
    if (!_phoneField) {
        _phoneField = [[UITextField alloc] initWithFrame:CGRectZero];
        _phoneField.font = UISystemFontSize(13);
        _phoneField.placeholder = KLocalizableStr(@"请输入新的手机号");
        _phoneField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneField.delegate = self;
    }
    return _phoneField;
}

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setTitle:KLocalizableStr(@"保存") forState:UIControlStateNormal];
        [_commitButton setTitleColor:KColorTextFFFFFF forState:UIControlStateNormal];
        _commitButton.titleLabel.font = UISystemFontSize(15);
        _commitButton.backgroundColor = KMainColor;
        _commitButton.layer.cornerRadius = GetScaleWidth(20);
        _commitButton.layer.masksToBounds = YES;
        [_commitButton addTarget:self action:@selector(actionCommit) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

-(void)actionCommit {
    if ([[self.phoneField.text trim] isEmptyOrNull]) {
        [self.phoneField animateShake];
        _errorLabel.text = KLocalizableStr(@"请输入手机号");
        return;
    }
    
    if ([[self.codeField.text trim] isEmptyOrNull]) {
        [self.codeField animateShake];
        _errorLabel.text = KLocalizableStr(@"请输入验证码");
        return;
    }
    
    [self.view endEditing:YES];
    _errorLabel.text = @"";
    
    WEAKSELF
    if (self.phoneField.text.length >0 && self.codeField.text.length >0) {
        //这里已修改
        ChangeMobileParam *param = [ChangeMobileParam new];
        param.mobile = self.phoneField.text;
        param.smsVerifyCode = self.codeField.text;
        [UserInfoAPI changeMobileWithParam:param success:^{
            DLog(@"修改手机号成功");
            UserModel *usermodel = [UserModel modelFromUnarchive];
            usermodel.telephone = self.phoneField.text;
            [usermodel archive];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } faulre:^(NSError *error) {
            DLog(@"修改手机号失败");
        }];
    }
}

-(NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    NSString * string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return string;
    
}

- (void)dealloc {
    
    [_timer pauseTimer];
    _timer = nil;
    
}

- (void)initViews {
    [self.navigationController setNavigationBarHidden:NO];
    [self.view addSubview:self.phoneView];
    [self.phoneView addSubview:self.markLab];
    [self.phoneView addSubview:self.countryField];
    [self.phoneView addSubview:self.lineView];
    [self.phoneView addSubview:self.phoneField];
    [self.view addSubview:self.codeField];
    [self.view addSubview:self.errorLabel];
    [self.view addSubview:self.codeButton];
    [self.view addSubview:self.commitButton];
    
    [self makeConstraints];
    
    _currentDate = [NSDate date];
    WEAKSELF
    _timer = [NSTimer ff_scheduledTimerWithTimeInterval:1.0
                                                  block:^{
                                                      [weakSelf onTimerStart];
                                                  } repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [_timer pauseTimer];

}

- (void)reStartTimer {
    _currentDate = [NSDate date];
    [_timer resumeTimer];
}

- (void)showError:(NSString *)error {
    self.errorLabel.text = error;
}


- (void)onTimerStart
{
    self.codeButton.userInteractionEnabled = NO;
    if (_currentDate) {
        NSTimeInterval timeDiff = [[[NSDate alloc] init] timeIntervalSinceDate:_currentDate];
        NSInteger diff = round(timeDiff);
        if (diff < 120) {
            [self.codeButton setTitle:[NSString stringWithFormat:@"      %@%@      ",@(120 - diff),@"S"] forState:UIControlStateNormal];
        }
        if (diff == 120) {
            [_timer pauseTimer];
            NSString *title = [NSString stringWithFormat:@"    %@    ",KLocalizableStr(@"重新获取")];
            [self.codeButton setTitle:title forState:UIControlStateNormal];
            self.codeButton.backgroundColor = [UIColor whiteColor];
            self.codeButton.userInteractionEnabled = YES;
            _currentDate = nil;
        }
    }
}

#pragma mark - getter / setter

- (UIView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[UIView alloc] initWithFrame:CGRectZero];
        _phoneView.layer.borderColor = KMainColor.CGColor;
        _phoneView.layer.borderWidth = 1;
        _phoneView.layer.cornerRadius = GetScaleWidth(20);
        _phoneView.layer.masksToBounds = YES;
    }
    return _phoneView;
}

- (UILabel *)markLab {
    if (!_markLab) {
        _markLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:KColorText999999];
        _markLab.textAlignment = NSTextAlignmentRight;
        _markLab.text = @"+";
    }
    return _markLab;
}

- (UITextField *)countryField {
    if (!_countryField) {
        _countryField = [[UITextField alloc] initWithFrame:CGRectZero];
        _countryField.font = UISystemFontSize(13);
        _countryField.keyboardType = UIKeyboardTypeNumberPad;
        _countryField.text = @"86";
        _countryField.textColor = KColorText999999;
        _countryField.backgroundColor = [UIColor clearColor];
    }
    return _countryField;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = KColorText999999;
    }
    return _lineView;
}

- (UIButton *)codeButton {
    if (!_codeButton) {
        _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [NSString stringWithFormat:@"  %@  ",KLocalizableStr(@"获取验证码")];
        [_codeButton setTitle:title forState:UIControlStateNormal];
        [_codeButton setTitleColor:KMainColor forState:UIControlStateNormal];
        _codeButton.titleLabel.font = UISystemFontSize(12);
        _codeButton.backgroundColor = [UIColor clearColor];
        _codeButton.layer.cornerRadius = GetScaleWidth(20);
        _codeButton.layer.borderColor = KMainColor.CGColor;
        _codeButton.layer.borderWidth = 1;
        _codeButton.layer.masksToBounds = YES;
        [_codeButton addTarget:self action:@selector(actionCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeButton;
}


- (ADLTitleField *)codeField {
    if (!_codeField) {
        _codeField = [[ADLTitleField alloc] initWithFrame:CGRectZero];
        _codeField.backgroundColor = KColorTextF2F4F7;
        _codeField.layer.cornerRadius = GetScaleWidth(20);
        _codeField.textField.placeholder = KLocalizableStr(@"请输入验证码");
        _codeField.textField.font = UISystemFontSize(12);
        _codeField.textField.keyboardType = UIKeyboardTypeNumberPad;
        _codeField.textField.delegate = self;
        
        _codeField.layer.borderColor = [UIColor clearColor].CGColor;
        _codeField.layer.borderWidth = 1;
        _codeField.layer.cornerRadius = GetScaleWidth(20);
        _codeField.layer.masksToBounds = YES;
        
    }
    
    return _codeField;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:KColorText0XFC3A06];
    }
    return _errorLabel;
}

#pragma mark - makeConstraints

- (void)makeConstraints {
    
    WEAKSELF
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.view.mas_top).offset(GetScaleWidth(60+TopBarHeight));
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(GetScaleWidth(16));
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(GetScaleWidth(-16));
        make.height.mas_equalTo(GetScaleWidth(40));
    }];
    
    [self.markLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.phoneView);
        make.centerY.equalTo(weakSelf.phoneView.mas_centerY).with.offset(-1);
        make.width.mas_equalTo(GetScaleWidth(30));
        make.height.mas_equalTo(30);
    }];
    

    [self.countryField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.markLab.mas_right).with.offset(2);
        make.top.bottom.equalTo(weakSelf.phoneView);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(GetScaleWidth(40));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.countryField.mas_right);
        make.centerY.equalTo(weakSelf.phoneView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 15));
    }];
    
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(weakSelf.phoneView);
        make.left.equalTo(weakSelf.lineView.mas_right).with.offset(10);
        make.height.mas_equalTo(GetScaleWidth(40));
    }];
    
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.phoneView.mas_bottom).offset(GetScaleWidth(10));
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(GetScaleWidth(-16));
        make.width.mas_equalTo(GetScaleWidth(100));
        make.height.mas_equalTo(GetScaleWidth(40));
    }];
    
    
    [self.codeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.codeButton.mas_top);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(GetScaleWidth(16));
        make.right.mas_equalTo(weakSelf.codeButton.mas_left).offset(GetScaleWidth(-24));
        make.height.mas_equalTo(GetScaleWidth(40));
    }];
    
    [self.commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(GetScaleWidth(16));
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(GetScaleWidth(-16));
        make.top.mas_equalTo(weakSelf.codeField.mas_bottom).offset(GetScaleWidth(30));
        make.height.mas_equalTo(GetScaleWidth(40));
        
    }];
    
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.phoneView.mas_top).offset(GetScaleWidth(-10));
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX);
    }];
    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    _phoneView.backgroundColor = KColorTextF2F4F7;
    _phoneView.layer.borderColor = [UIColor clearColor].CGColor;
    
    _codeField.backgroundColor = KColorTextF2F4F7;
    _codeField.layer.borderColor = [UIColor clearColor].CGColor;
    
    ADLTitleField *titleField = (ADLTitleField *)textField.superview;
    titleField.backgroundColor = KColorTextFFFFFF;
    titleField.layer.borderColor = KMainColor.CGColor;
    
}


#pragma mark - action

- (void)actionCode:(UIButton *)button {
    
    WEAKSELF
    if ([[self.phoneField.text trim] isEmptyOrNull]) {
        [self.phoneField animateShake];
        _errorLabel.text = KLocalizableStr(@"请输入手机号");
        return;
    }
    
    [self.view endEditing:YES];
    _errorLabel.text = @"";
    //这里已修改
    weakSelf.view.userInteractionEnabled = NO;
    GetVcodeParam *param = [GetVcodeParam new];
    param.mobile = self.phoneField.text;
    param.type = @"2";
    [GetVcodeAPI getVcodeWithParam:param success:^{
        NSLog(@"获取验证码成功");
        weakSelf.view.userInteractionEnabled = YES;
        [weakSelf reStartTimer];
    } faulre:^(NSError *error) {
        NSLog(@"获取验证码失败");
        weakSelf.view.userInteractionEnabled = YES;
    }];
}





@end
