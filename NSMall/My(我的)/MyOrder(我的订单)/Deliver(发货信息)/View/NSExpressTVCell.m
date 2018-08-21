//
//  NSExpressTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSExpressTVCell.h"

@interface NSExpressTVCell()
@property (nonatomic, strong) UIView  *bgView;
@property(nonatomic,strong)UILabel *expressNameLab;/* 快递公司名称 */
@end

@implementation NSExpressTVCell

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
    
    self.expressNameLab = [[UILabel alloc]init];
    self.expressNameLab.x = 19;
    self.expressNameLab.y = 12;
    self.expressNameLab.font = UISystemFontSize(14);
    self.expressNameLab.textColor = kBlackColor;
    [self.bgView addSubview:self.expressNameLab];
    
    self.seclectIV = [[UIImageView alloc]init];
    self.seclectIV.x = kScreenWidth-16-19;
    self.seclectIV.y = 12;
    self.seclectIV.size = CGSizeMake(16, 16);
    self.seclectIV.image = IMAGE(@"seclected");
    self.seclectIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.bgView addSubview:self.seclectIV];
}

-(void)setExpressModel:(NSExpressModel *)expressModel{
    _expressModel = expressModel;
    self.expressNameLab.text = expressModel.ship_name;
    [self.expressNameLab sizeToFit];
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
}
@end
