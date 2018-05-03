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
    self.goodsIV = [[UIImageView alloc] initWithFrame:CGRectMake(GetScaleWidth(29), GetScaleWidth(38), GetScaleWidth(71), GetScaleWidth(71))];
//    self.goodsIV.backgroundColor = [UIColor greenColor];
    [self.goodsIV setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:self.goodsIV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTap:)];
    // 允许用户交互
    self.goodsIV.userInteractionEnabled = YES;
    [self.goodsIV addGestureRecognizer:tap];
    
    //用户名
    self.userName = [[UILabel alloc] init];
    self.userName.x = CGRectGetMaxX(self.goodsIV.frame)+GetScaleWidth(18);
    self.userName.y = CGRectGetMinY(self.goodsIV.frame)+GetScaleWidth(10);
    self.userName.font = [UIFont systemFontOfSize:kFontNum15];
    self.userName.textColor = KColorText323232;
//    [self.userName sizeToFit];
    [self.contentView addSubview:self.userName];
    
    //天数记录
    self.daysRecord = [[UILabel alloc] init];
    self.daysRecord.x = CGRectGetMaxX(self.goodsIV.frame)+GetScaleWidth(18);
    self.daysRecord.y = CGRectGetMaxY(self.userName.frame)+GetScaleWidth(23);
    self.daysRecord.font = [UIFont systemFontOfSize:kFontNum15];
    self.daysRecord.textColor = KColorText323232;
    [self.contentView addSubview:self.daysRecord];

    self.arrowImgView = [[UIImageView alloc] initWithImage:IMAGE(@"my_ico_right_arrow")];
    self.arrowImgView.right = CGRectGetMaxX(self.contentView.frame) + GetScaleWidth(58);
    self.arrowImgView.top = GetScaleWidth(68);
    self.arrowImgView.size = CGSizeMake(GetScaleWidth(8), GetScaleWidth(14));
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
    self.userName.text = KLocalizableStr([userModel.user_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    [self.userName sizeToFit];
    NSString *daysRecordStr = [NSString stringWithFormat:@"来诺商%@了!",userModel.regeist_day];
    self.daysRecord.text = KLocalizableStr(daysRecordStr);
    [self.daysRecord sizeToFit];
    [self.goodsIV sd_setImageWithURL:[NSURL URLWithString:userModel.pic_img]];
    
}

@end
