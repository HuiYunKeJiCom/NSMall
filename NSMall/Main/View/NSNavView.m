//
//  NSNavView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/10.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSNavView.h"


@interface NSNavView ()
/** 标题标签 */
@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation NSNavView


#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor clearColor];
    
    _leftItemButton = [UIButton new];
    [_leftItemButton setImage:[UIImage imageNamed:@"top_left_arrow"] forState:UIControlStateNormal];
    [_leftItemButton addTarget:self action:@selector(leftButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    
        _rightItemButton = [UIButton new];
      _rightItemButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_rightItemButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightItemButton.titleLabel.font = [UIFont systemFontOfSize:kFontNum17];
        [_rightItemButton addTarget:self action:@selector(rightButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_leftItemButton];
    [self addSubview:_rightItemButton];
    [self addSubview:self.titleLab];
    
    CAGradientLayer * layer = [[CAGradientLayer alloc] init];
    layer.frame = self.bounds;
    layer.colors = @[(id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.15].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.05].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.03].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.01].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.0].CGColor];
    [self.layer addSublayer:layer];
}

-(void)setRightItemTitle:(NSString *)string{
    [self.rightItemButton setTitle:string forState:UIControlStateNormal];
}

-(void)setRightItemImage:(NSString *)string{
    
    [self.rightItemButton setImage:[UIImage imageNamed:string] forState:UIControlStateNormal];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_leftItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self.mas_left).offset(5);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];
    
        [_rightItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.centerY.equalTo(_leftItemButton.mas_centerY);
            make.top.equalTo(self.mas_top).offset(20);
            make.right.equalTo(self.mas_right).offset(-5);
            make.height.equalTo(@44);
            make.width.equalTo(@44);
        }];
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.centerX.equalTo(self.mas_centerX);
        make.left.equalTo(self.leftItemButton.mas_right);
        make.right.equalTo(self.rightItemButton.mas_left);
        make.centerY.equalTo(_leftItemButton.mas_centerY);
    }];
    
}

#pragma 自定义右边导航Item点击
- (void)rightButtonItemClick {
    !_rightItemClickBlock ? : _rightItemClickBlock();
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum17 TextColor:kWhiteColor];
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

-(void)setTopTitleWithNSString:(NSString *)string{
    self.titleLab.text = string;
}

#pragma 自定义左边导航Item点击
- (void)leftButtonItemClick {
    !_leftItemClickBlock ? : _leftItemClickBlock();
}

@end
