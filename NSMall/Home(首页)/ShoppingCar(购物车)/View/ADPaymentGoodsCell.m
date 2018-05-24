//
//  ADPaymentGoodsCell.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/14.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import "ADPaymentGoodsCell.h"

@interface ADPaymentGoodsCell()
@property (nonatomic, strong) UIView  *bgView;
/** 商品图片 */
@property(nonatomic,strong)UIImageView *goodsIV;
/** 名称 */
@property(nonatomic,strong)UILabel *goodsNameLab;
/** 类型 */
@property(nonatomic,strong)UILabel *typeLab;
/** 描述1 */
@property(nonatomic,strong)UILabel *detailLab1;
/** 描述2 */
@property(nonatomic,strong)UILabel *detailLab2;
@end

@implementation ADPaymentGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.bgView];
        [self addSubview:self.goodsNameLab];
        [self addSubview:self.typeLab];
        [self addSubview:self.detailLab1];
        [self addSubview:self.detailLab2];
        [self addSubview:self.goodsIV];
        //        self.bgView.backgroundColor = [UIColor redColor];
        [self makeConstraints];
    }
    
    return self;
}

-(void)setFrame:(CGRect)frame {
//    frame.origin.y += 15;
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
    
    [self.goodsIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left);
        make.top.equalTo(weakSelf.bgView.mas_top);
        make.bottom.equalTo(weakSelf.bgView.mas_bottom);
        make.width.mas_equalTo(kScreenWidth*0.5-65);
    }];
    
    [self.goodsNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-10);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(10);
    }];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-10);
        make.top.equalTo(weakSelf.goodsNameLab.mas_bottom).with.offset(5);
    }];
    
    [self.detailLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-10);
        make.top.equalTo(weakSelf.typeLab.mas_bottom).with.offset(20);
    }];
    
    [self.detailLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-10);
        make.top.equalTo(weakSelf.detailLab1.mas_bottom).with.offset(5);
    }];

}

- (void)setModel:(ADPaymentGoodsModel *)model {
    _model = model;
    
    self.goodsNameLab.text = model.goodsName;
    self.typeLab.text = model.type;
    self.detailLab1.text = model.detail1;
    self.detailLab2.text = model.detail2;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)goodsNameLab {
    if (!_goodsNameLab) {
        _goodsNameLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _goodsNameLab;
}

- (UILabel *)typeLab {
    if (!_typeLab) {
        _typeLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _typeLab;
}

- (UILabel *)detailLab1 {
    if (!_detailLab1) {
        _detailLab1 = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:[UIColor lightGrayColor]];
    }
    return _detailLab1;
}

- (UILabel *)detailLab2 {
    if (!_detailLab2) {
        _detailLab2 = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor lightGrayColor]];
    }
    return _detailLab2;
}

-(UIImageView *)goodsIV{
    if (!_goodsIV) {
        _goodsIV = [[UIImageView alloc] init];
        //        [_goodsIV setImage:[UIImage imageNamed:@"icon"]];
        [_goodsIV setBackgroundColor:[UIColor greenColor]];
        [_goodsIV setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _goodsIV;
}

@end
