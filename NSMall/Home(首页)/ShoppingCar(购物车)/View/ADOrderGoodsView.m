//
//  ADOrderGoodsView.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/1.
//  Copyright © 2018年 Adel. All rights reserved.
//  下单页面-商品列表-商品信息

#import "ADOrderGoodsView.h"

@interface ADOrderGoodsView()
/** 商品图片 */
@property(nonatomic,strong)UIImageView *goodsIV;
/** 商品名 */
@property(nonatomic,strong)UILabel *goodsNameLab;
/** 颜色 */
@property(nonatomic,strong)UILabel *colorLab;
/** 细节描述 */
@property(nonatomic,strong)UILabel *detailLab;
/** 数量标题 */
@property(nonatomic,strong)UILabel *numberTitLab;
/** 数量 */
@property(nonatomic,strong)UILabel *numberLab;
/** 单价 */
@property(nonatomic,strong)UILabel *priceLab;
/** 单位 */
@property(nonatomic,strong)UILabel *unitLab;
/** 横线 */
@property(nonatomic,strong)UIView *lineView;

@end

@implementation ADOrderGoodsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initViews];
        [self setUpData];
    }
    
    return self;
}

- (void)setUpData {
    self.goodsNameLab.text =@"ADEL爱迪尔4920 只能指纹锁";
    self.colorLab.text = @"三合一（亮金色）";
    self.detailLab.text = @"左侧开";
    self.numberTitLab.text = @"数量：";
    self.numberLab.text = @"2";
    self.priceLab.text = @"1968.00";
    self.unitLab.text = @"元";
}

- (void)initViews {
    
    [self addSubview:self.goodsIV];
    [self addSubview:self.goodsNameLab];
    [self addSubview:self.colorLab];
    [self addSubview:self.detailLab];
    [self addSubview:self.numberTitLab];
    [self addSubview:self.numberLab];
    [self addSubview:self.priceLab];
    [self addSubview:self.unitLab];
    [self addSubview:self.lineView];
    [self makeConstraints];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)makeConstraints {
    WEAKSELF
    
    [self.goodsIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(10);
        make.top.equalTo(weakSelf.mas_top).with.offset(10);
        //        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-15);
        make.width.mas_equalTo(weakSelf.height-20);
        make.height.mas_equalTo(weakSelf.height-20);
    }];
    
    [self.goodsNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsIV.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.mas_top).with.offset(10);
    }];
    
    [self.colorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsIV.mas_right).with.offset(10);
        make.bottom.equalTo(weakSelf.detailLab.mas_top).with.offset(-10);
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsIV.mas_right).with.offset(10);
        make.bottom.equalTo(weakSelf.goodsIV.mas_bottom);
    }];
    
    [self.numberTitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.numberLab.mas_left);
        make.centerY.equalTo(weakSelf.colorLab.mas_centerY);
    }];
    
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).with.offset(-10);
        make.centerY.equalTo(weakSelf.colorLab.mas_centerY);
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.unitLab.mas_left).with.offset(-5);
        make.bottom.equalTo(weakSelf.goodsIV.mas_bottom);
    }];
    
    [self.unitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).with.offset(-10);
        make.bottom.equalTo(weakSelf.goodsIV.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.mas_centerX);
        make.top.equalTo(weakSelf.goodsIV.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 1));
    }];
}

-(UIImageView *)goodsIV{
    if (!_goodsIV) {
        _goodsIV = [[UIImageView alloc] init];
        //        [_goodsIV setImage:[UIImage imageNamed:@"icon"]];
        [_goodsIV setBackgroundColor:[UIColor greenColor]];
//        _goodsIV.image = [UIImage imageNamed:@"default_pic_1"];
        [_goodsIV setContentMode:UIViewContentModeScaleAspectFill];
        //        [_goodsIV setClipsToBounds:YES];
    }
    return _goodsIV;
}

- (UILabel *)goodsNameLab {
    if (!_goodsNameLab) {
        _goodsNameLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    }
    return _goodsNameLab;
}

- (UILabel *)colorLab {
    if (!_colorLab) {
        _colorLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _colorLab;
}

- (UILabel *)detailLab {
    if (!_detailLab) {
        _detailLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _detailLab;
}

- (UILabel *)numberTitLab {
    if (!_numberTitLab) {
        _numberTitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _numberTitLab;
}

- (UILabel *)numberLab {
    if (!_numberLab) {
        _numberLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _numberLab;
}

- (UILabel *)priceLab {
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor redColor]];
    }
    return _priceLab;
}

- (UILabel *)unitLab {
    if (!_unitLab) {
        _unitLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor lightGrayColor]];
    }
    return _unitLab;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

@end
