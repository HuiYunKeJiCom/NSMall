//
//  ADBottomView.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/1.
//  Copyright © 2018年 Adel. All rights reserved.
//  下单页面-底部页面

#import "ADBottomView.h"

@interface ADBottomView()

///** 数量 */
//@property(nonatomic,strong)UILabel *numLab;
///** 单位 */
//@property(nonatomic,strong)UILabel *unitLab;
/* 金额合计：右边按钮 */
@property (strong , nonatomic)UIButton *rightButton;
@end

@implementation ADBottomView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
        [self setUpData];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLab];
//    [self addSubview:self.numLab];
//    [self addSubview:self.unitLab];
    [self addSubview:self.rightButton];
    
}

#pragma mark - 填充数据
-(void)setUpData{
//    self.titleLab.text = @"合计（不含运费）：";
//    self.numLab.text = @"7450.00";
//    self.unitLab.text = @"元";
    [self.rightButton setTitle:@"马上下单" forState:UIControlStateNormal];
}
    
#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self makeConstraints];
}

#pragma mark - Constraints
- (void)makeConstraints {
    WEAKSELF
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(10);
        make.centerY.equalTo(weakSelf.mas_centerY);
    }];
    
//    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.titleLab.mas_right);
//        make.centerY.equalTo(weakSelf.mas_centerY);
//    }];
//
//    [self.unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakSelf.numLab.mas_right);
//        make.centerY.equalTo(weakSelf.mas_centerY);
//    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.centerY.equalTo(weakSelf.mas_centerY);
        make.width.mas_equalTo(kScreenWidth*0.4);
        make.height.mas_equalTo(50);
    }];
    
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:18.0 TextColor:[UIColor redColor]];
    }
    return _titleLab;
}

//- (UILabel *)numLab {
//    if (!_numLab) {
//        _numLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor redColor]];
//    }
//    return _numLab;
//}
//
//- (UILabel *)unitLab {
//    if (!_unitLab) {
//        _unitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor redColor]];
//    }
//    return _unitLab;
//}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:kFontNum12];
        _rightButton.backgroundColor = [UIColor redColor];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

#pragma mark - 马上下单 点击
- (void)rightButtonClick {
    NSLog(@"马上下单 点击");
    !_rightBtnClickBlock ? : _rightBtnClickBlock();
}

- (NSDictionary *)dict
{
    if (!_dict) {
        _dict = [NSDictionary dictionary];
    }
    return _dict;
}

@end
