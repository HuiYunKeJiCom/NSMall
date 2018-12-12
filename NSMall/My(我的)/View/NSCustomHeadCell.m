//
//  NSCustomHeadCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/4/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSCustomHeadCell.h"

@interface NSCustomHeadCell()
//@property (nonatomic, strong) UIView           *bgView;
/** 商品图片 */
@property(nonatomic,strong)UIImageView *goodsIV;
/** 用户名 */
@property(nonatomic,strong)UILabel *userName;
@property(nonatomic,strong)UIImageView *levelIV;/* VIP等级 */
@property(nonatomic,strong)UILabel *levelLab;/* vip数字 */
/** 记录天数 */
@property(nonatomic,strong)UILabel *daysRecord;
@property (strong, nonatomic) UIImageView    *arrowImgView;
@end

@implementation NSCustomHeadCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        [self createUI];
    }
    return self;
}

-(void)createUI{

    self.backgroundColor = [UIColor whiteColor];
    
    //头像
    self.goodsIV = [[UIImageView alloc] initWithFrame:CGRectMake(GetScaleWidth(19), GetScaleWidth(21), GetScaleWidth(48), GetScaleWidth(48))];
//    self.goodsIV.backgroundColor = [UIColor greenColor];
    [self.goodsIV setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:self.goodsIV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
    // 允许用户交互
    self.goodsIV.userInteractionEnabled = YES;
    [self.goodsIV addGestureRecognizer:tap];
    
    //用户名
    self.userName = [[UILabel alloc] init];
    self.userName.x = CGRectGetMaxX(self.goodsIV.frame)+GetScaleWidth(12);
    self.userName.y = CGRectGetMinY(self.goodsIV.frame)+GetScaleWidth(7);
    self.userName.font = [UIFont systemFontOfSize:kFontNum15];
    self.userName.textColor = KColorText323232;
//    [self.userName sizeToFit];
    [self.contentView addSubview:self.userName];
    
    self.levelIV = [[UIImageView alloc]init];
    [self.levelIV setContentMode:UIViewContentModeScaleAspectFit];
    self.levelIV.image = IMAGE(@"ico_level");
    [self.contentView addSubview:self.levelIV];
    
    self.levelLab = [[UILabel alloc] init];
    self.levelLab.font = [UIFont boldSystemFontOfSize:14];
    self.levelLab.textColor = [UIColor whiteColor];
    [self.contentView addSubview:self.levelLab];
    
    //天数记录
    self.daysRecord = [[UILabel alloc] init];
    self.daysRecord.font = [UIFont systemFontOfSize:kFontNum15];
    self.daysRecord.textColor = KColorText323232;
    [self.contentView addSubview:self.daysRecord];

    self.arrowImgView = [[UIImageView alloc] initWithImage:IMAGE(@"my_ico_right_arrow")];
//    NSLog(@"arrowImgView.frame = %@",NSStringFromCGRect(self.arrowImgView.frame));
    [self.contentView addSubview:self.arrowImgView];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

#pragma mark - 图片 点击
- (void)doTap:(UITapGestureRecognizer *)tap {
//        NSLog(@"图片 点击");
    !_imageViewBtnClickBlock ? : _imageViewBtnClickBlock();
}

-(void)setUserModel:(UserModel *)userModel{
    _userModel = userModel;
    self.userName.text = KLocalizableStr(userModel.user_name);
    [self.userName sizeToFit];
    
    self.levelIV.x = CGRectGetMaxX(self.userName.frame)+GetScaleWidth(5);
    self.levelIV.centerY = CGRectGetMidY(self.userName.frame);
    self.levelIV.size = CGSizeMake(GetScaleWidth(30), GetScaleWidth(30));
    
    self.levelLab.centerX = CGRectGetMidX(self.levelIV.frame);
    self.levelLab.centerY = CGRectGetMidY(self.levelIV.frame)-GetScaleWidth(4);
    
    NSString *daysRecordStr = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"come NS", nil),userModel.regeist_day,NSLocalizedString(@"!", nil)];
    self.daysRecord.x = CGRectGetMaxX(self.goodsIV.frame)+GetScaleWidth(12);
    self.daysRecord.y = CGRectGetMaxY(self.userName.frame)+GetScaleWidth(9);
    self.daysRecord.text = KLocalizableStr(daysRecordStr);
    [self.daysRecord sizeToFit];
    [self.goodsIV sd_setImageWithURL:[NSURL URLWithString:userModel.pic_img]];
    
    if(userModel.level != 0){
        self.levelLab.alpha = 1.0;
        self.levelIV.alpha = 1.0;
        self.levelLab.text = [NSString stringWithFormat:@"%ld",userModel.level];
        [self.levelLab sizeToFit];
    }else{
        self.levelLab.alpha = 0.0;
        self.levelIV.alpha = 0.0;
    }
    
    self.arrowImgView.right = kScreenWidth- GetScaleWidth(19);
    self.arrowImgView.top = GetScaleWidth(40);
    self.arrowImgView.size = CGSizeMake(GetScaleWidth(5), GetScaleWidth(9));
    
}

@end
