//
//  ShopInfoView.m
//  BMKMapClusterView
//
//  Created by 张锐凌 on 2018/4/30.
//  Copyright © 2018年 BaiduMap. All rights reserved.
//


#import "ShopInfoView.h"

@interface ShopInfoView()
@property(nonatomic,strong)UIImageView *shopIV;/* 店铺图片 */
@property(nonatomic,strong)UILabel *shopNameL;/* 店铺名称 */
@property(nonatomic,strong)UILabel *shopDescrL;/* 店铺描述 */
@property(nonatomic,strong)UIView *navView;/* 导航View */
@property(nonatomic,strong)UIView *line1;/* 横线1 */
@property(nonatomic,strong)UILabel *shopAddrL;/* 店铺地址 */
@property(nonatomic,strong)UIView *line2;/* 横线2 */
@property(nonatomic,strong)UILabel *shopTelL;/* 店铺电话 */
@property(nonatomic,strong)UIImageView *telIV;/* 电话 */
@property(nonatomic,strong)UIView *line3;/* 横线3 */
@property(nonatomic,strong)UILabel *shopHoursL;/* 店铺营业时间 */
@property(nonatomic,strong)UIView *line4;/* 横线3 */

@property(nonatomic,strong)UIButton *closeBtn;/* 关闭按钮 */
@property(nonatomic,strong)UILabel *distanceLabel;/* 距离 */
@property(nonatomic,strong)UILabel *arrivalTimeLabel;/* 步行时间 */
@property(nonatomic,strong)UILabel *workStateL;/* 店铺状态 */
@end

@implementation ShopInfoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize nameSize =  [self contentSizeWithTitle:self.storeModel.name andFont:15];
    self.shopNameL.frame = CGRectMake(75, 20, nameSize.width ,nameSize.height);
    
    CGSize descrSize =  [self contentSizeWithTitle:@"餐饮,快餐" andFont:14];
    self.shopDescrL.frame = CGRectMake(75, 40, descrSize.width ,descrSize.height);
    
    CGSize addrSize =  [self contentSizeWithTitle:[NSString stringWithFormat:@"地址: %@",self.storeModel.address] andFont:14];
    self.shopAddrL.frame = CGRectMake(5, 160, kScreenWidth*0.7-10 ,addrSize.height);
    
    self.navView.frame = CGRectMake(5, 95, kScreenWidth*0.7-10, addrSize.height+20);
    
    CGSize disSize =  [self contentSizeWithTitle:self.storeModel.distance andFont:14];
    self.distanceLabel.size = disSize;
    
    CGSize atSize =  [self contentSizeWithTitle:[NSString stringWithFormat:@"步行约%@",self.storeModel.walk_time] andFont:14];
    self.arrivalTimeLabel.size = atSize;
    
    CGSize telSize =  [self contentSizeWithTitle:[NSString stringWithFormat:@"电话: %@",self.storeModel.user_phone] andFont:14];
    self.shopTelL.frame = CGRectMake(5, CGRectGetMaxY(self.shopAddrL.frame)+20, telSize.width ,telSize.height);
    
    self.telIV.frame = CGRectMake(kScreenWidth*0.7-60, CGRectGetMidY(self.shopTelL.frame)-10, 20, 20);
    
    CGSize hoursSize =  [self contentSizeWithTitle:@"营业时间: 00:00~23:59" andFont:14];
    self.shopHoursL.frame = CGRectMake(5, CGRectGetMaxY(self.shopTelL.frame)+20, hoursSize.width ,hoursSize.height);
    
    CGSize workStateSize =  [self contentSizeWithTitle:@"营业中" andFont:14];
    self.workStateL.frame = CGRectMake(kScreenWidth*0.7-60, CGRectGetMidY(self.shopHoursL.frame)-workStateSize.height*0.5, workStateSize.width ,workStateSize.height);

    self.line1.x = 0;
    self.line1.y = CGRectGetMaxY(self.shopIV.frame)+10;
    self.line1.size = CGSizeMake(kScreenWidth*0.7, 1);
    
    self.line2.x = 0;
    self.line2.y = CGRectGetMaxY(self.shopAddrL.frame)+10;
    self.line2.size = CGSizeMake(kScreenWidth*0.7, 1);

    self.line3.x = 0;
    self.line3.y = CGRectGetMaxY(self.shopTelL.frame)+10;
    self.line3.size = CGSizeMake(kScreenWidth*0.7, 1);
    
    self.line4.x = 0;
    self.line4.y = CGRectGetMaxY(self.shopHoursL.frame)+10;
    self.line4.size = CGSizeMake(kScreenWidth*0.7, 1);
}

- (void)initViews {
    self.shopIV = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 60, 60)];
    self.shopIV.backgroundColor = [UIColor greenColor];
    [self.shopIV setContentMode:UIViewContentModeScaleAspectFill];
    [self addSubview:self.shopIV];
    
    self.shopNameL = [[UILabel alloc]init];
    self.shopNameL.textColor = [UIColor blackColor];
    self.shopNameL.font = [UIFont systemFontOfSize:15];
    self.shopNameL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.shopNameL];
    
    self.shopDescrL = [[UILabel alloc]init];
    self.shopDescrL.textColor = [UIColor lightGrayColor];
    self.shopDescrL.font = [UIFont systemFontOfSize:14];
    self.shopDescrL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.shopDescrL];
    
    self.shopAddrL = [[UILabel alloc]init];
    self.shopAddrL.textColor = [UIColor blackColor];
    self.shopAddrL.font = [UIFont systemFontOfSize:14];
    self.shopAddrL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.shopAddrL];
    
    self.navView = [[UIView alloc]init];
    self.navView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.navView];
    
    UIImageView *navIV = [[UIImageView alloc]initWithFrame:CGRectMake(75, 8, 20, 20)];
    navIV.image = IMAGE(@"map_ico_coordinate");
    [self.navView addSubview:navIV];
    
    self.distanceLabel = [[UILabel alloc]init];
    self.distanceLabel.font = [UIFont systemFontOfSize:14];
    self.distanceLabel.x = CGRectGetMaxX(navIV.frame)+10;
    self.distanceLabel.y = 10;
    [self.navView addSubview:self.distanceLabel];
    
    self.arrivalTimeLabel = [[UILabel alloc]init];
    self.arrivalTimeLabel.font = [UIFont systemFontOfSize:14];
    self.arrivalTimeLabel.x = CGRectGetMaxX(self.distanceLabel.frame)+10;
    self.arrivalTimeLabel.y = 10;
    [self.navView addSubview:self.arrivalTimeLabel];
    
    self.shopTelL = [[UILabel alloc]init];
    self.shopTelL.textColor = [UIColor blackColor];
    self.shopTelL.font = [UIFont systemFontOfSize:14];
    self.shopTelL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.shopTelL];
    
    self.telIV = [[UIImageView alloc]init];
    self.telIV.image = IMAGE(@"map_ico_telephone");
    [self addSubview:self.telIV];
    
    self.shopHoursL = [[UILabel alloc]init];
    self.shopHoursL.textColor = [UIColor blackColor];
    self.shopHoursL.font = [UIFont systemFontOfSize:14];
    self.shopHoursL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.shopHoursL];
    
    self.closeBtn = [[UIButton alloc]init];
    self.closeBtn.frame = CGRectMake(kScreenWidth*0.7-20, 5, 15, 15);
    [self.closeBtn addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    //    self.closeBtn.backgroundColor = [UIColor greenColor];
    [self addSubview:self.closeBtn];
    
    self.workStateL = [[UILabel alloc]init];
    self.workStateL.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.workStateL];
    
    self.line1 = [[UIView alloc]init];
    self.line1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.line1];
    
    self.line2 = [[UIView alloc]init];
    self.line2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.line2];
    
    self.line3 = [[UIView alloc]init];
    self.line3.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.line3];
    
    self.line4 = [[UIView alloc]init];
    self.line4.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.line4];
    
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

#pragma 自定义左边导航Item点击
- (void)closeButtonClick {
    
    !_closeClickBlock ? : _closeClickBlock();
}

-(void)setStoreModel:(NSStoreModel *)storeModel{
    _storeModel = storeModel;
    
    [self.shopIV sd_setImageWithURL:[NSURL URLWithString:storeModel.store_imge]];
    self.shopNameL.text = storeModel.name;
    self.shopAddrL.text = [NSString stringWithFormat:@"地址: %@",self.storeModel.address];
    self.distanceLabel.text = self.storeModel.distance;
    self.workStateL.text = @"营业中";
    self.shopDescrL.text = @"餐饮,快餐";
    self.shopTelL.text = [NSString stringWithFormat:@"电话: %@",self.storeModel.user_phone];
    self.shopHoursL.text = @"营业时间: 00:00~23:59";
    
    [self layoutSubviews];
}

@end
