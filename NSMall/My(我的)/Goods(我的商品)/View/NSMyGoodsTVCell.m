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
    [self.goodsIV setContentMode:UIViewContentModeScaleAspectFit];
//    self.goodsIV.backgroundColor = kRedColor;
    [self.bgView addSubview:self.goodsIV];
    
    self.goodsName = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:[UIColor blackColor]];
    [self.bgView addSubview:self.goodsName];
    
    self.publishLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:[UIColor whiteColor]];
    self.publishLab.backgroundColor = KMainColor;
    self.publishLab.textAlignment = NSTextAlignmentCenter;
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
    [_editBtn setTitle:NSLocalizedString(@"edit", nil)
 forState:UIControlStateNormal];
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
    [_delBtn setTitle:NSLocalizedString(@"delete", nil)
 forState:UIControlStateNormal];
    [_delBtn addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.delBtn];
    
}

-(void)setFrame:(CGRect)frame {
//    frame.origin.y += 15;
    [super setFrame:frame];
    
}

- (void)setModel:(NSMyProductListItemModel *)model {
    _model = model;
    
    [self.goodsIV sd_setImageWithURL:[NSURL URLWithString:model.productImageList[0]]];
    self.goodsName.x = CGRectGetMaxX(self.goodsIV.frame)+GetScaleWidth(14);
    self.goodsName.y = CGRectGetMinY(self.goodsIV.frame);
    self.goodsName.text = self.model.name;
    [self.goodsName sizeToFit];
    
    if(model.is_shelve == 1){
        self.publishLab.text = NSLocalizedString(@"on sale", nil)
        ;
    }else if(model.is_shelve == -1){
        self.publishLab.text = @"未发布";
    }
    CGSize publishSize = [self contentSizeWithTitle:self.publishLab.text andFont:kFontNum12];
    self.publishLab.x = CGRectGetMaxX(self.goodsName.frame)+GetScaleWidth(7);
    self.publishLab.y = CGRectGetMinY(self.goodsIV.frame)+GetScaleWidth(2);
    self.publishLab.size = CGSizeMake(publishSize.width+10, publishSize.height);
    self.publishLab.layer.cornerRadius = 5;//设置那个圆角的有多圆
    self.publishLab.layer.masksToBounds = YES;//设为NO去试试
    
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

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

@end
