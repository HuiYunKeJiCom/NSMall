//
//  NSMyShopTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/18.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMyShopTVCell.h"

@interface NSMyShopTVCell()
@property (nonatomic, strong) UIView           *bgView;
@property(nonatomic,strong)UIImageView *goodsIV;/* 店铺图片 */
@property(nonatomic,strong)UILabel *goodsName;/* 店铺名称 */
@property(nonatomic,strong)UILabel *detailLab;/* 店铺描述 */
@property(nonatomic,strong)UIView *lineView;/* 分割线 */
@property(nonatomic,strong)UIButton *editBtn;/* 编辑按钮 */
@property(nonatomic,strong)UIButton *delBtn;/* 删除按钮 */
@property(nonatomic,strong)UIImageView *pin;/* 大头针 */
@property(nonatomic,strong)UILabel *addressLab;/* 详细地址 */
@end

@implementation NSMyShopTVCell

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
    _bgView = [[UIView alloc] initWithFrame:self.frame];
    _bgView.backgroundColor = kWhiteColor;
    [self addSubview:self.bgView];
    
    self.goodsIV = [[UIImageView alloc] initWithFrame:CGRectMake(19, 12, 40, 40)];
    //    self.goodsIV.backgroundColor = kGreyColor;
    [self.goodsIV setContentMode:UIViewContentModeScaleAspectFill];
    [self.bgView addSubview:self.goodsIV];
    
    self.goodsName = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    [self.bgView addSubview:self.goodsName];
    
    self.detailLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:kGreyColor];
    [self.bgView addSubview:self.detailLab];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    _lineView.backgroundColor = KBGCOLOR;
    [self.bgView addSubview:self.lineView];
    
    self.pin = [[UIImageView alloc] init];
    [self.pin setContentMode:UIViewContentModeScaleAspectFill];
    [self.bgView addSubview:self.pin];
    
    self.addressLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:kGreyColor];
    [self.bgView addSubview:self.addressLab];
    
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

- (void)setModel:(NSShopListItemModel *)model {
    _model = model;
    
    self.goodsName.x = CGRectGetMaxX(self.goodsIV.frame)+11;
    self.goodsName.y = CGRectGetMinY(self.goodsIV.frame)+4;
    self.goodsName.text = self.model.name;
    [self.goodsName sizeToFit];
    
    self.detailLab.x = CGRectGetMaxX(self.goodsIV.frame)+11;
    self.detailLab.y = CGRectGetMaxY(self.goodsName.frame)+6;
    self.detailLab.text = self.model.introduce;
    [self.detailLab sizeToFit];
    
    self.lineView.x = 0;
    self.lineView.y = CGRectGetMaxY(self.goodsIV.frame)+12;
    self.lineView.size = CGSizeMake(kScreenWidth, 1);
    
    self.pin.x = 19;
    self.pin.y = CGRectGetMaxY(self.lineView.frame)+25;
    self.pin.size = CGSizeMake(8, 12);
    
    self.addressLab.x = CGRectGetMaxX(self.pin.frame)+5;
    self.addressLab.y = CGRectGetMaxY(self.lineView.frame)+25;
    self.addressLab.text = @"浙江省杭州市省政府旁边";
    [self.addressLab sizeToFit];
    
    self.editBtn.x = kScreenWidth-19-53;
    self.editBtn.y = CGRectGetMaxY(self.lineView.frame)+7;
    self.editBtn.size = CGSizeMake(53, 23);
    
    self.delBtn.x = kScreenWidth-19-53-13-53;
    self.delBtn.y = CGRectGetMaxY(self.lineView.frame)+7;
    self.delBtn.size = CGSizeMake(53, 23);
}

@end
