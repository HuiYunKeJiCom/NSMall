//
//  ADAddressLabelTableViewCell.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/4/12.
//  Copyright © 2018年 Adel. All rights reserved.
//  标签

#import "ADAddressLabelTableViewCell.h"

#import "UIView+MJExtension.h"

#define margin 15
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

@interface ADAddressLabelTableViewCell()
@property (nonatomic, strong) UIView           *bgView;


@end

@implementation ADAddressLabelTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.leftLabel];
        [self createUIButton];
        [self makeConstraints];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    WEAKSELF
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(20);
        make.centerY.equalTo(weakSelf.bgView.mas_centerY);
    }];
}


-(void)createUIButton{
    float btnW = 0;
    NSArray *stringArr = @[@"家",@"公司",@"其他"];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        NSString *str = stringArr[i];
        [btn setTitle:str forState:UIControlStateNormal];
        CGSize strsize = [str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName ,nil]];
        btn.width = strsize.width + margin;
        btn.height = strsize.height+ margin;

        if (i == 0) {
            btn.mj_x = kBigMargin+80;
            btnW += CGRectGetMaxX(btn.frame);
        }else{
            btnW += CGRectGetMaxX(btn.frame)+margin;
            btn.mj_x += btnW - btn.width;
        }
        btn.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.15f];
        btn.userInteractionEnabled = YES;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitleColor:Color(104, 97, 97) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.mj_y +=  margin-5;
        
        btn.layer.cornerRadius = btn.height/5;
        
        btn.clipsToBounds = YES;
        btn.tag = i;
        [self.bgView addSubview:btn];
    }
}

- (void)btnClick:(UIButton *)sender{
//    NSLog(@"sender.titleLabel.text = %@",sender.titleLabel.text);
    self.labelStr = sender.titleLabel.text;
    if (![self.btn isEqual:sender]) {
        self.btn.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.15f];
        self.btn.selected = NO;
        sender.backgroundColor = KMainColor;
        sender.selected = YES;
    }else if([self.btn isEqual:sender]){
        if (sender.selected == YES) {
            sender.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.15f];
            sender.selected = NO;
        }else{
            sender.backgroundColor =  KMainColor;
            sender.selected = YES;
        }
    }else{
        
    }
//    if ([self.Attribute_delegate respondsToSelector:@selector(Attribute_View:didClickBtn:)] ) {
//        [self.Attribute_delegate Attribute_View:self didClickBtn:sender];
//    }
    self.btn = sender;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _leftLabel;
}

- (void)setLeftStr:(NSString *)leftStr {
    _leftStr = leftStr;
    _leftLabel.text = _leftStr;
}

- (void)setLabelStr:(NSString *)labelStr {
    _labelStr = labelStr;
}
@end
