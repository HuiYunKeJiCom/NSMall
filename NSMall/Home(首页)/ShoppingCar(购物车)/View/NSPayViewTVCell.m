//
//  NSPayViewTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/1.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSPayViewTVCell.h"

@interface NSPayViewTVCell()
@property (nonatomic, strong) UIView  *bgView;
@property(nonatomic,strong)UILabel *walletNameLab;/* 钱包名称 */

@end

@implementation NSPayViewTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.isSelected = YES;
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.x = 0;
    self.bgView.y = 0;
    [self addSubview:self.bgView];
    
    self.walletNameLab = [[UILabel alloc]init];
    self.walletNameLab.x = 19;
    self.walletNameLab.y = 12;
    self.walletNameLab.font = UISystemFontSize(14);
    self.walletNameLab.textColor = kBlackColor;
    [self.bgView addSubview:self.walletNameLab];
    
    self.seclectIV = [[UIImageView alloc]init];
    self.seclectIV.x = kScreenWidth-16-19;
    self.seclectIV.y = 12;
    self.seclectIV.size = CGSizeMake(16, 16);
    self.seclectIV.image = IMAGE(@"seclected");
    self.seclectIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.bgView addSubview:self.seclectIV];
}

-(void)setWalletModel:(WalletItemModel *)walletModel{
    _walletModel = walletModel;
    self.walletNameLab.text = walletModel.wallet_name;
    [self.walletNameLab sizeToFit];
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
}

@end
