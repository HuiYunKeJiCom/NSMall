//
//  LZTableHeaderView.m
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//  购物车-门店

#import "LZTableHeaderView.h"
#import "LZConfigFile.h"

@interface LZTableHeaderView ()

@property (strong,nonatomic)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *userIV;/* 卖家头像 */
@property (strong,nonatomic)UIButton *button;
@end
@implementation LZTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(11, 15, 15, 15);
    
    [button setImage:[UIImage imageNamed:@"buycar_ico_check"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"buycar_ico_checked"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    self.button = button;
    
    self.userIV = [[UIImageView alloc]init];
    self.userIV.x = CGRectGetMaxX(button.frame)+8;
    self.userIV.y = 7;
    self.userIV.size = CGSizeMake(29, 29);
    [self.contentView addSubview:self.userIV];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(CGRectGetMaxX(self.userIV.frame)+12, 18, LZSCREEN_WIDTH - 100, 8);
    label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label];
    self.titleLabel = label;
}
- (void)buttonClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (self.lzClickBlock) {
        self.lzClickBlock(button.selected);
    }
}

- (void)setSelect:(BOOL)select {
    
    self.button.selected = select;
    _select = select;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
    _title = title;
}

-(void)setImagePath:(NSString *)imagePath{
    _imagePath = imagePath;
    [self.userIV sd_setImageWithURL:[NSURL URLWithString:imagePath]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
