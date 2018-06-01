//
//  NSInputPwView.m
//  PayPasswordDemo
//
//  Created by 张锐凌 on 2018/6/1.
//  Copyright © 2018年 高磊. All rights reserved.
//

#import "NSInputPwView.h"
#import "GLTextField.h"
#import "UIView+category.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//密码位数
static NSInteger const kDotsNumber = 6;

//假密码点点的宽和高  应该是等高等宽的正方形 方便设置为圆
static CGFloat const kDotWith_height = 10;

@interface NSInputPwView()<UITextFieldDelegate>

//密码输入文本框
@property (nonatomic,strong) GLTextField *passwordField;
//用来装密码圆点的数组
@property (nonatomic,strong) NSMutableArray *passwordDotsArray;
//默认密码
@property (nonatomic,strong,readonly) NSString *password;
@property (nonatomic, weak) UIView *contentView;
@end

@implementation NSInputPwView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5];
        [self setupBasicView];
    }
    return self;
}

/**
 *  设置视图的基本内容
 */
- (void)setupBasicView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - kATTR_VIEW_HEIGHT}];
    bgView.backgroundColor = kClearColor;
    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [bgView addGestureRecognizer:tapBackGesture];
    [self addSubview:bgView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:(CGRect){0, kScreenHeight - kATTR_VIEW_HEIGHT, kScreenWidth, kATTR_VIEW_HEIGHT}];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"请输入交易密码";
    [titleLab sizeToFit];
    CGSize titleSize = [self contentSizeWithTitle:titleLab.text andFont:14];
    titleLab.centerX = self.contentView.centerX;
    titleLab.y = 12;
    titleLab.font = UISystemFontSize(14);
    titleLab.textColor = kBlackColor;
    [self.contentView addSubview:titleLab];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.backgroundColor = KMainColor;
    backBtn.x = 19;
    backBtn.y = 12;
    backBtn.size = CGSizeMake(titleSize.height*0.6, titleSize.height);
    [backBtn setImage:IMAGE(@"top_left_arrow") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(comeBack) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:backBtn];
    
    float width = (kScreenWidth-38)/6.0;
    self.passwordField = [[GLTextField alloc] initWithFrame:CGRectMake(19, CGRectGetMaxY(titleLab.frame)+12, width * 6, width)];
    self.passwordField.delegate = (id)self;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    //将密码的文字颜色和光标颜色设置为透明色
    //之前是设置的白色 这里有个问题 如果密码太长的话 文字和光标的位置如果到了第一个黑色的密码点的时候 就看出来了
    self.passwordField.textColor = [UIColor clearColor];
    self.passwordField.tintColor = [UIColor clearColor];
    [self.passwordField setBorderColor:UIColorFromRGB(0xdddddd) width:1];
    self.passwordField.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordField.secureTextEntry = YES;
    [self.passwordField addTarget:self action:@selector(passwordFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.passwordField];
    [self.passwordField becomeFirstResponder];
    
    [self addDotsViews];
}

#pragma mark == private method
- (void)addDotsViews
{
    //密码输入框的宽度
    CGFloat passwordFieldWidth = CGRectGetWidth(self.passwordField.frame);
    //六等分 每等分的宽度
    CGFloat password_width = passwordFieldWidth / kDotsNumber;
    //密码输入框的高度
    CGFloat password_height = CGRectGetHeight(self.passwordField.frame);
    
    for (int i = 0; i < kDotsNumber; i ++)
    {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(i * password_width, 0, 1, password_height)];
        line.backgroundColor = UIColorFromRGB(0xdddddd);
        [self.passwordField addSubview:line];
        
        //假密码点的x坐标
        CGFloat dotViewX = (i + 1)*password_width - password_width / 2.0 - kDotWith_height / 2.0;
        CGFloat dotViewY = (password_height - kDotWith_height) / 2.0;
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(dotViewX, dotViewY, kDotWith_height, kDotWith_height)];
        dotView.backgroundColor = UIColorFromRGB(0x222222);
        [dotView setCornerRadius:kDotWith_height/2.0];
        dotView.hidden = YES;
        [self.passwordField addSubview:dotView];
        [self.passwordDotsArray addObject:dotView];
    }
}

- (void)cleanPassword
{
    _passwordField.text = @"";
    
    [self setDotsViewHidden];
}

//将所有的假密码点设置为隐藏状态
- (void)setDotsViewHidden
{
    for (UIView *view in _passwordDotsArray)
    {
        [view setHidden:YES];
    }
}


#pragma mark == UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //删除键
    if (string.length == 0)
    {
        return YES;
    }
    
    if (_passwordField.text.length >= kDotsNumber)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark == event response
- (void)passwordFieldDidChange:(UITextField *)field
{
    [self setDotsViewHidden];
    
    for (int i = 0; i < _passwordField.text.length; i ++)
    {
        if (_passwordDotsArray.count > i )
        {
            UIView *dotView = _passwordDotsArray[i];
            [dotView setHidden:NO];
        }
    }

    if (_passwordField.text.length == 6)
    {
        if (_tbDelegate && [_tbDelegate respondsToSelector:@selector(payOrder:)]) {
            [_tbDelegate payOrder:_passwordField.text];
        }
//        NSString *password = _passwordField.text;
        //调接口
    }
}


//#pragma mark == 懒加载
//- (GLTextField *)passwordField
//{
//    if (nil == _passwordField)
//    {
//        float width = (kScreenWidth-38)/6.0;
//        _passwordField = [[GLTextField alloc] initWithFrame:CGRectMake(19, 12, width * 6, width)];
//        _passwordField.delegate = (id)self;
//        _passwordField.backgroundColor = [UIColor whiteColor];
//        //将密码的文字颜色和光标颜色设置为透明色
//        //之前是设置的白色 这里有个问题 如果密码太长的话 文字和光标的位置如果到了第一个黑色的密码点的时候 就看出来了
//        _passwordField.textColor = [UIColor clearColor];
//        _passwordField.tintColor = [UIColor clearColor];
//        [_passwordField setBorderColor:UIColorFromRGB(0xdddddd) width:1];
//        _passwordField.keyboardType = UIKeyboardTypeNumberPad;
//        _passwordField.secureTextEntry = YES;
//        [_passwordField addTarget:self action:@selector(passwordFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    }
//    return _passwordField;
//}

- (NSMutableArray *)passwordDotsArray
{
    if (nil == _passwordDotsArray)
    {
        _passwordDotsArray = [[NSMutableArray alloc] initWithCapacity:kDotsNumber];
    }
    return _passwordDotsArray;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    __weak typeof(self) _weakSelf = self;
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kATTR_VIEW_HEIGHT);;
    
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _weakSelf.contentView.frame = CGRectMake(0, kScreenHeight - kATTR_VIEW_HEIGHT, kScreenWidth, kATTR_VIEW_HEIGHT);
    }];
}

- (void)removeView {
    __weak typeof(self) _weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor clearColor];
        _weakSelf.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kATTR_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [_weakSelf removeFromSuperview];
    }];
}

-(void)comeBack{
    !_backClickBlock ? : _backClickBlock();
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

@end
