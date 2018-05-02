//
//  FFLoadFailView.m
//  EasyLife
//
//  Created by 朱鹏 on 16/7/25.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "FFLoadFailView.h"

static int const k_loadFailTitleColor            =  0X727373;
//static int const k_loadFailButtonTitleColor      =  0X848483;
//static int const k_loadFailButtonHighTitleColor  =  0XFF6B13;

@interface FFLoadFailView ()

@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UIButton *requestButton;
@property (nonatomic, strong) UILabel *failLabel;
@property (nonatomic, copy) NSString *noDataTitle;

@end

@implementation FFLoadFailView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initUIWithTitle:nil];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIWithTitle:title];
    }
    return self;
}


#pragma mark - 实例化UI
- (void)initUIWithTitle:(NSString *)title
{
    if ([NSString isEmptyOrNull:title]) {
        self.noDataTitle = KLocalizableStr(@"暂无数据");
    } else {
        self.noDataTitle = title;
    }
    
    self.backgroundColor = kBACKGROUNDCOLOR;
    
    [self addSubview:self.centerImageView];
    [self addSubview:self.failLabel];
    [self addSubview:self.requestButton];

    WEAKSELF
    [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@-60);
    }];
    
    [_failLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.centerImageView.mas_bottom).with.offset(GetScaleWidth(25));
        make.centerX.equalTo(@0);
    }];
    
    [_requestButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.failLabel.mas_bottom).with.offset(GetScaleWidth(18));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(112), GetScaleWidth(40)));
        make.centerX.equalTo(@0);
    }];
}


#pragma mark - getter

-(UIImageView *)centerImageView
{
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_failFace"]];
    }
    return _centerImageView;
}

-(UILabel *)failLabel
{
    if (!_failLabel) {
        _failLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _failLabel.text = self.noDataTitle;
        _failLabel.textAlignment = NSTextAlignmentCenter;
        _failLabel.font = [UIFont systemFontOfSize:15];
        _failLabel.textColor = UIColorFromRGB(k_loadFailTitleColor);
    }
    return _failLabel;
}

-(UIButton *)requestButton
{
    if (!_requestButton) {
        _requestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_requestButton addTarget:self action:@selector(requestAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_requestButton setImage:[UIImage imageNamed:@"icon_reloadBtn"] forState:UIControlStateNormal];
        [_requestButton setImage:[UIImage imageNamed:@"icon_reloadBtnH"] forState:UIControlStateHighlighted];
        
    }
    return _requestButton;
}

#pragma mark - private methord
- (void)requestAction
{
    if (_requestDataBlock) {
        _requestDataBlock();
    }
    
    [self performSelector:@selector(userInteractionEnabled:) withObject:self.requestButton afterDelay:1.0f];

}

- (void)userInteractionEnabled:(UIButton *)button {
    self.requestButton.userInteractionEnabled = YES;
}

- (void)setShowButton:(BOOL)showButton {
    self.requestButton.hidden = !showButton;
}

- (void)setFailureText:(NSString *)failureText {
    self.failLabel.text = failureText;
}

@end
