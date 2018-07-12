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
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = kWhiteColor;
    [self addSubview:self.bgView];
    
    self.goodsIV = [[UIImageView alloc] init];
//    self.goodsIV.backgroundColor = [UIColor greenColor];
    [self.goodsIV setContentMode:UIViewContentModeScaleAspectFit];
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
    self.pin.image = IMAGE(@"myshop_ico_ coordinate");
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
    [_editBtn addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
    [_delBtn addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.delBtn];
    
}

-(void)setFrame:(CGRect)frame {
    //    frame.origin.y += 15;
    [super setFrame:frame];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self makeConstraints];
}

- (void)setModel:(NSShopListItemModel *)model {
    _model = model;
    
    [self.goodsIV sd_setImageWithURL:[NSURL URLWithString:model.storeImageList[0]]];
    self.goodsName.text = self.model.name;
    self.detailLab.text = self.model.introduce;
    self.addressLab.text = self.model.address;
}

-(void)makeConstraints {
    WEAKSELF
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.goodsIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(19);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(12);
        make.width.mas_equalTo(GetScaleWidth(53));
        make.height.mas_equalTo(GetScaleWidth(53));
    }];
    
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsIV.mas_right).with.offset(11);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(20);
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsIV.mas_right).with.offset(11);
        make.top.equalTo(weakSelf.goodsName.mas_bottom).with.offset(6);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left);
        make.top.equalTo(weakSelf.goodsIV.mas_bottom).with.offset(12);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(GetScaleWidth(1));
    }];

    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).with.offset(-19);
        make.bottom.equalTo(self.bgView.mas_bottom).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(53),GetScaleWidth(23)));
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.editBtn.mas_left).with.offset(-13);
        make.bottom.equalTo(self.bgView.mas_bottom).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(53),GetScaleWidth(23)));
    }];
    
    [self.pin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(19);
        make.bottom.equalTo(self.bgView.mas_bottom).with.offset(-17);
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(8),GetScaleWidth(12)));
    }];

    [self.addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pin.mas_right).with.offset(5);
        make.bottom.equalTo(self.bgView.mas_bottom).with.offset(-17);
    }];

}

#pragma mark - 编辑 点击
- (void)editButtonClick {
        NSLog(@"编辑 点击");
    !_editBtnClickBlock ? : _editBtnClickBlock();
}

#pragma mark - 删除 点击
- (void)deleteButtonClick {
    NSLog(@"删除 点击");
    !_deleteBtnClickBlock ? : _deleteBtnClickBlock();
}

@end
