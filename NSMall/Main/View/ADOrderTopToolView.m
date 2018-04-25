//
//  ADOrderTopToolView.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/2/5.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import "ADOrderTopToolView.h"

@interface ADOrderTopToolView ()
/** 标题标签 */
@property(nonatomic,strong)UILabel *titleLab;

///* 右边Item */
//@property (strong , nonatomic)UIButton *rightItemButton;

@end

@implementation ADOrderTopToolView

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
    
        _leftItemButton = ({
            UIButton * button = [UIButton new];
            [button setImage:[UIImage imageNamed:@"navigation_back_normal"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(leftButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
            button;
        });

        [self addSubview:_leftItemButton];
        [self addSubview:self.titleLab];
    
    CAGradientLayer * layer = [[CAGradientLayer alloc] init];
    layer.frame = self.bounds;
    layer.colors = @[(id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.15].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.1].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.05].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.03].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.01].CGColor,(id)[UIColor colorWithWhite:0 alpha:0.0].CGColor];
    [self.layer addSublayer:layer];
}
#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
        [_leftItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(20);
            make.left.equalTo(self.mas_left).offset(0);
            make.height.equalTo(@44);
            make.width.equalTo(@44);
        }];
    
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(_leftItemButton.mas_centerY);
        }];
    
//    [_rightItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        make.centerY.equalTo(_leftItemButton.mas_centerY);
//        make.top.equalTo(self.mas_top).offset(20);
//        make.right.equalTo(self.mas_right).offset(-0);
//        make.height.equalTo(@44);
//        make.width.equalTo(@44);
//    }];
    
}

//#pragma 自定义右边导航Item点击
//- (void)rightButtonItemClick {
//    !_rightItemClickBlock ? : _rightItemClickBlock();
//}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum17 TextColor:k_UIColorFromRGB(0xffffff)];
        _titleLab.textColor = [UIColor blackColor];
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
