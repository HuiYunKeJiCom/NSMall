//
//  NSLoginView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSLoginView.h"
#import "NSLImageField.h"

@interface NSLoginView()<UITextFieldDelegate>
/** 错误提示 */
@property (nonatomic, strong)UILabel *errorLabel;
/** 用户名 */
@property (nonatomic, strong) NSLImageField           *nameTextField;
/** 密码 */
@property (nonatomic, strong) NSLImageField           *passTextField;
/** 登录按钮 */
@property (nonatomic, strong) UIButton              *loginButton;
/** logo */
@property(nonatomic,strong)UIImageView *logoIV;
///** 忘记密码按钮 */
//@property (nonatomic, strong) UIButton              *forgetButton;
///** 注册按钮 */
//@property (nonatomic, strong) UIButton              *phoneButton;
@end

@implementation NSLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    
    return self;
}

- (void)initViews {
    
    [self addSubview:self.errorLabel];
    [self addSubview:self.nameTextField];
    [self addSubview:self.passTextField];
    [self addSubview:self.loginButton];
    [self addSubview:self.logoIV];
    [self addSubview:self.sendBtn];
//    [self addSubview:self.forgetButton];
//    [self addSubview:self.phoneButton];
    
    [self refreshView];
    
    [self makeConstraints];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:tap];
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:KColorTextDA2F2D];
    }
    return _errorLabel;
}

- (NSLImageField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[NSLImageField alloc] initWithFrame:CGRectZero];
        _nameTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.textField.keyboardType = UIKeyboardTypeDefault;
        _nameTextField.textField.delegate = self;
        _nameTextField.layer.cornerRadius = GetScaleWidth(5);
        _nameTextField.layer.masksToBounds = YES;
        
        [self nameTextSelect:NO];
        
    }
    return _nameTextField;
}


- (NSLImageField *)passTextField {
    if (!_passTextField) {
        _passTextField = [[NSLImageField alloc] initWithFrame:CGRectZero];
        _passTextField.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passTextField.textField.secureTextEntry = YES;
        _passTextField.textField.delegate = self;
        _passTextField.layer.cornerRadius = GetScaleWidth(5);
        _passTextField.layer.masksToBounds = YES;
        
        [self passTextSelect:NO];
        
        
    }
    return _passTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitleColor:KColorTextFFFFFF forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:kFontNum15];
        _loginButton.backgroundColor = UIColorFromRGB(0x0aa1e0);
        _loginButton.layer.cornerRadius = GetScaleWidth(5);
        _loginButton.layer.masksToBounds = YES;
        [_loginButton addTarget:self action:@selector(actionLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

//- (UIButton *)phoneButton {
//    if (!_phoneButton) {
//        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_phoneButton setTitleColor:KColorText333333 forState:UIControlStateNormal];
//        _phoneButton.titleLabel.font = [UIFont systemFontOfSize:kFontNum14];
//        [_phoneButton addTarget:self action:@selector(actionRegister:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _phoneButton;
//}


//- (UIButton *)forgetButton {
//    if (!_forgetButton) {
//        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_forgetButton setTitleColor:KColorText333333 forState:UIControlStateNormal];
//        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:kFontNum14];
//        [_forgetButton addTarget:self action:@selector(actionForget:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _forgetButton;
//}

- (void)makeConstraints {
    
    WEAKSELF
    
    float topImgY = kScreenWidth > 320 ? GetScaleWidth(103) : 90;
    //    float nameTextY = kScreenWidth > 320 ? GetScaleWidth(75) : 60;
    float topImgWidth =  kScreenWidth > 320 ? GetScaleWidth(115) : 90;
    
    [self.logoIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.nameTextField);
        make.bottom.mas_equalTo(weakSelf.nameTextField.mas_top).offset(GetScaleWidth(-20));
        make.height.mas_equalTo(GetScaleWidth(28));
        make.width.mas_equalTo(GetScaleWidth(90));
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).offset(topImgY+topImgWidth);
        make.left.mas_equalTo(weakSelf.mas_left).offset(GetScaleWidth(30));
        make.right.mas_equalTo(weakSelf.mas_right).offset(GetScaleWidth(-30));
        make.height.mas_equalTo(GetScaleWidth(40));
    }];
    
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(weakSelf.nameTextField.mas_top).offset(GetScaleWidth(-10));
        make.centerX.mas_equalTo(weakSelf);
    }];
    
    [self.passTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.nameTextField.mas_bottom).offset(GetScaleWidth(10));
        make.width.height.mas_equalTo(weakSelf.nameTextField);
        make.centerX.mas_equalTo(weakSelf.nameTextField);
    }];
    
    [self.sendBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.nameTextField.mas_right);
        make.top.mas_equalTo(weakSelf.nameTextField.mas_bottom).offset(GetScaleWidth(10));
        make.height.mas_equalTo(weakSelf.nameTextField);
        make.width.mas_equalTo(65);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.passTextField.mas_bottom).offset(GetScaleWidth(30));
        make.width.height.mas_equalTo(weakSelf.nameTextField);
        make.centerX.mas_equalTo(weakSelf.nameTextField);
    }];
    
//    [self.phoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.loginButton.mas_bottom).offset(5);
//        make.left.mas_equalTo(weakSelf.loginButton.mas_left).offset(15);
//        make.height.mas_equalTo(GetScaleWidth(20));
//    }];
//
//    [self.forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(weakSelf.loginButton.mas_bottom).offset(5);
//        make.right.mas_equalTo(weakSelf.loginButton.mas_right).offset(-15);
//        make.height.mas_equalTo(GetScaleWidth(20));
//    }];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.superview) {
        if (textField.superview == self.nameTextField) {
            
            [self passTextSelect:NO];
            [self nameTextSelect:YES];
            
        } else if(textField.superview == self.passTextField) {
            
            [self passTextSelect:YES];
            [self nameTextSelect:NO];
            
        }
    }
    
}

- (void)nameTextSelect:(BOOL)selected {
    
//    _nameTextField.imgView.image = selected ? IMAGE(@"ico_login_name_H") : IMAGE(@"ico_login_name");
    _nameTextField.imgView.image = IMAGE(@"login_ico_mobile");
    _nameTextField.lineView.backgroundColor = KBGCOLOR;
    _nameTextField.textField.textColor = KBGCOLOR;
    _nameTextField.backgroundColor = [UIColor whiteColor];
}

- (void)passTextSelect:(BOOL)selected {
    
    _passTextField.imgView.image = IMAGE(@"login_ico_envelope");
    _passTextField.lineView.backgroundColor = KBGCOLOR;
    _passTextField.textField.textColor = KBGCOLOR;
    _passTextField.backgroundColor = [UIColor whiteColor];
}

#pragma mark - public

- (void)showError:(NSString *)error {
    self.errorLabel.text = error;
}

#pragma mark - action
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
}

/**
 *登陆
 */
- (void)actionLogin:(UIButton *)button {
    //测试
//    self.nameTextField.textField.text = @"test";
//    self.passTextField.textField.text = @"123456";
    //    测试账号1【账号：myshop 密码：123456】
    //    测试账号2【账号：test 密码：123456】
    if ([[self.nameTextField.text trim] isEmptyOrNull]) {
        self.nameTextField.textField.text = @"";
        [self.nameTextField animateShake];
        _errorLabel.text = KLocalizableStr(@"用户名不能为空");
        return;
    }
    
    if ([[self.passTextField.text trim] isEmptyOrNull]) {
        self.passTextField.textField.text = @"";
        [self.passTextField animateShake];
        _errorLabel.text = KLocalizableStr(@"密码不能为空");
        return;
    } else {
        NSString *reg = @"^[a-zA-Z0-9_]{6,20}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
        if (![predicate evaluateWithObject:[self.passTextField.text trim]]) {
            _errorLabel.text = KLocalizableStr(@"6-20位数，数字字母组合");
            return;
        }
    }
    
    
    
    [self endEditing:YES];
    _errorLabel.text = @"";
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginView:userName:pwd:)]) {
        [self.delegate loginView:self userName:[self.nameTextField.text trim] pwd:[self.passTextField.text trim]];
    }
}

//- (void)actionRegister:(UIButton *)button {
//
//    [self handleType:UseLoginTypeRegister];
//}
//
//- (void)actionForget:(UIButton *)button {
//    [self handleType:UseLoginTypeForget];
//}

- (void)handleType:(UseLoginType)type {
    [self endEditing:YES];
    
    if ([self.delegate respondsToSelector:@selector(loginView:eventType:)]) {
        [self.delegate loginView:self eventType:type];
    }
}

- (void)refreshView {
    
    self.errorLabel.text = @"";
    
    [self.nameTextField placeholder:KLocalizableStr(@"手机号码") color:KBGCOLOR];
    [self.passTextField placeholder:KLocalizableStr(@"短信验证码") color:KBGCOLOR];
    [self.loginButton setTitle:KLocalizableStr(@"登录") forState:UIControlStateNormal];
//    [self.phoneButton setTitle:KLocalizableStr(@"注册账号") forState:UIControlStateNormal];
//    [self.forgetButton setTitle:KLocalizableStr(@"忘记密码") forState:UIControlStateNormal];
}

- (UIImageView *)logoIV {
    if (!_logoIV) {
        _logoIV = [[UIImageView alloc] initWithFrame:CGRectZero];
        _logoIV.contentMode = UIViewContentModeScaleToFill;
        _logoIV.image = [UIImage imageNamed:@"login_logo"];
    }
    return _logoIV;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:UIColorFromRGB(0x0aa1e0) forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:kFontNum12];
        _sendBtn.layer.cornerRadius = 5;
        _sendBtn.layer.masksToBounds = YES;
    }
    return  _sendBtn;
}

@end
