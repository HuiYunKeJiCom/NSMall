//
//  NSMyGoodsTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/17.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMyGoodsTVCell.h"

@interface NSMyGoodsTVCell()
@property (nonatomic, strong) UIView           *bgView;
@property(nonatomic,strong)UIImageView *goodsIV;/* 商品图片 */
@property(nonatomic,strong)UILabel *goodsName;/* 商品名称 */
@property(nonatomic,strong)UILabel *publishLab;/* 发布标签 */
@property(nonatomic,strong)UILabel *detailLab;/* 商品描述 */
@property(nonatomic,strong)UIView *lineView;/* 分割线 */
@property(nonatomic,strong)UIButton *editBtn;/* 编辑按钮 */
@property(nonatomic,strong)UIButton *delBtn;/* 删除按钮 */
@end

@implementation NSMyGoodsTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = KBGCOLOR;
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
    _bgView = [[UIView alloc] init];
    self.bgView.x = 0;
    self.bgView.y = 0;
    self.bgView.size = CGSizeMake(kScreenWidth, GetScaleWidth(127));
    _bgView.backgroundColor = kWhiteColor;
    [self addSubview:self.bgView];
    
    self.goodsIV = [[UIImageView alloc] initWithFrame:CGRectMake(GetScaleWidth(19), GetScaleWidth(12), GetScaleWidth(53), GetScaleWidth(53))];
    [self.goodsIV setContentMode:UIViewContentModeScaleAspectFill];
    self.goodsIV.backgroundColor = kRedColor;
    [self.bgView addSubview:self.goodsIV];
    
    self.goodsName = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    [self.bgView addSubview:self.goodsName];
    
    self.publishLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor blackColor]];
    [self.bgView addSubview:self.publishLab];
    
    self.detailLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:[UIColor blackColor]];
    [self.bgView addSubview:self.detailLab];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = KBGCOLOR;
    [self.bgView addSubview:self.lineView];
    
    _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:kFontNum14];
    // 设置圆角的大小
    _editBtn.layer.cornerRadius = 5;
    [_editBtn.layer setMasksToBounds:YES];
    _editBtn.layer.borderWidth = 1;
    _editBtn.layer.borderColor = [KMainColor CGColor];
    [_editBtn setTitleColor:KMainColor forState:UIControlStateNormal];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
//    [_editBtn addTarget:self action:@selector(evaluateBtnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.editBtn];
    
    _delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _delBtn.titleLabel.font = [UIFont systemFontOfSize:kFontNum14];
    // 设置圆角的大小
    _delBtn.layer.cornerRadius = 5;
    [_delBtn.layer setMasksToBounds:YES];
    _delBtn.layer.borderWidth = 1;
    _delBtn.layer.borderColor = [kRedColor CGColor];
    [_delBtn setTitleColor:kRedColor forState:UIControlStateNormal];
    [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
    //    [_delBtn addTarget:self action:@selector(evaluateBtnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.delBtn];
    
}

-(void)setFrame:(CGRect)frame {
//    frame.origin.y += 15;
    [super setFrame:frame];
    
}

- (void)setModel:(NSMyProductListItemModel *)model {
    _model = model;
    
    [self.goodsIV sd_setImageWithURL:[NSURL URLWithString:model.product_imge]];
    self.goodsName.x = CGRectGetMaxX(self.goodsIV.frame)+GetScaleWidth(14);
    self.goodsName.y = CGRectGetMinY(self.goodsIV.frame);
    self.goodsName.text = self.model.name;
    [self.goodsName sizeToFit];
    
    self.publishLab.x = CGRectGetMaxX(self.goodsName.frame)+GetScaleWidth(7);
    self.publishLab.y = CGRectGetMinY(self.goodsIV.frame)+GetScaleWidth(2);
    self.publishLab.text = @"售卖中";
    [self.publishLab sizeToFit];
    
    self.detailLab.x = CGRectGetMaxX(self.goodsIV.frame)+GetScaleWidth(14);
    self.detailLab.y = CGRectGetMaxY(self.goodsName.frame)+GetScaleWidth(10);
    self.detailLab.text = self.model.introduce;
    [self.detailLab sizeToFit];
    
    self.lineView.x = 0;
    self.lineView.y = CGRectGetMaxY(self.goodsIV.frame)+GetScaleWidth(13);
    self.lineView.size = CGSizeMake(kScreenWidth, 1);
    
    self.editBtn.x = kScreenWidth-GetScaleWidth(19-53);
    self.editBtn.y = CGRectGetMaxY(self.lineView.frame)+GetScaleWidth(13);
    self.editBtn.size = CGSizeMake(GetScaleWidth(53), GetScaleWidth(23));
    
    self.delBtn.x = kScreenWidth-GetScaleWidth(19-53-13-53);
    self.delBtn.y = CGRectGetMaxY(self.lineView.frame)+GetScaleWidth(13);
    self.delBtn.size = CGSizeMake(GetScaleWidth(53), GetScaleWidth(23));
}



@end
