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
@property(nonatomic,strong)UIButton *callBtn;/* 拨打电话 */
@property(nonatomic,strong)UIView *line3;/* 横线3 */
@property(nonatomic,strong)UILabel *shopHoursL;/* 店铺营业时间 */
@property(nonatomic,strong)UIView *line4;/* 横线3 */

@property(nonatomic,strong)UIButton *closeBtn;/* 关闭按钮 */
@property(nonatomic,strong)UILabel *distanceLabel;/* 距离 */
@property(nonatomic,strong)UILabel *arrivalTimeLabel;/* 步行时间 */
@property(nonatomic,strong)UILabel *workStateL;/* 店铺状态 */
@property(nonatomic,strong)UIScrollView *shopSV;/* 店铺所有图片 */
@property(nonatomic,strong)UILabel *introduceLab;/* 店铺简述 */
@property(nonatomic,strong)UILabel *createLab;/* 创建日期 */
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
    
    [self makeConstraints];
    
    CGSize disSize =  [self contentSizeWithTitle:[NSString stringWithFormat:@"%@ 步行约%@",self.storeModel.distance,self.storeModel.walk_time] andFont:14];
    self.distanceLabel.size = disSize;
    
//    CGSize atSize =  [self contentSizeWithTitle:[NSString stringWithFormat:@"步行约%@",self.storeModel.walk_time] andFont:14];
//    self.arrivalTimeLabel.size = atSize;
    
}

- (void)initViews {
    self.shopIV = [[UIImageView alloc] initWithFrame:CGRectZero];
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
    self.navView.backgroundColor = KBGCOLOR;
    [self addSubview:self.navView];
    
    UIImageView *navIV = [[UIImageView alloc]initWithFrame:CGRectMake(55, 12, 18, 18)];
    navIV.image = IMAGE(@"map_ico_coordinate");
    [self.navView addSubview:navIV];
    
    UIButton *navBtn = [[UIButton alloc]initWithFrame:CGRectMake(55, 12, 18, 18)];
    [navBtn addTarget:self action:@selector(navigateToTargetPositionWithThird) forControlEvents:UIControlEventTouchUpInside];
    //    self.closeBtn.backgroundColor = [UIColor greenColor];
    [self.navView addSubview:navBtn];
    
    self.distanceLabel = [[UILabel alloc]init];
    self.distanceLabel.font = [UIFont systemFontOfSize:14];
    self.distanceLabel.x = CGRectGetMaxX(navIV.frame)+10;
    self.distanceLabel.y = 12;
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
    
    self.callBtn = [[UIButton alloc]init];
    [self.callBtn addTarget:self action:@selector(callUp) forControlEvents:UIControlEventTouchUpInside];
    //    self.closeBtn.backgroundColor = [UIColor greenColor];
    [self addSubview:self.callBtn];
    
    self.shopHoursL = [[UILabel alloc]init];
    self.shopHoursL.textColor = [UIColor blackColor];
    self.shopHoursL.font = [UIFont systemFontOfSize:14];
    self.shopHoursL.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.shopHoursL];
    
    self.closeBtn = [[UIButton alloc]init];
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
    
    [self.shopIV sd_setImageWithURL:[NSURL URLWithString:storeModel.storeImageList[0]]];
    self.shopNameL.text = storeModel.name;
    self.shopAddrL.text = [NSString stringWithFormat:@"地址: %@",self.storeModel.address];
    self.distanceLabel.text = [NSString stringWithFormat:@"%@ 步行约%@",self.storeModel.distance,self.storeModel.walk_time];
    self.workStateL.text = @"营业中";
    
    for (LabelItemModel *tag in storeModel.labelList) {
        
        self.shopDescrL.text = [[self.shopDescrL.text stringByAppendingString:tag.label_name] stringByAppendingString:@"、"];
    }
    NSString *tagString = [self removeLastOneChar:self.shopDescrL.text];
    self.shopDescrL.text = tagString;
    self.shopTelL.text = [NSString stringWithFormat:@"电话: %@",self.storeModel.user_phone];
    self.shopHoursL.text = [NSString stringWithFormat:@"营业时间: %@~%@",storeModel.business_hours_start,storeModel.business_hours_end];
    
    [self layoutSubviews];
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    WEAKSELF
    [self.shopIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(5);
        make.top.equalTo(weakSelf.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [self.shopNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.shopIV.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.mas_top).with.offset(20);
    }];

    [self.shopDescrL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.shopIV.mas_right).with.offset(10);
        make.top.equalTo(weakSelf.shopNameL.mas_bottom).with.offset(5);
    }];
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(5);
        make.top.equalTo(weakSelf.mas_top).with.offset(95);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.7-10, 40));
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.shopIV.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.7, 1));
    }];

    [self.shopAddrL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(5);
        make.top.equalTo(weakSelf.mas_top).with.offset(145);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.shopAddrL.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.7, 1));
    }];
    
    [self.shopTelL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(5);
        make.top.equalTo(weakSelf.shopAddrL.mas_bottom).with.offset(20);
    }];

    [self.telIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(kScreenWidth*0.7-60);
        make.top.equalTo(weakSelf.shopTelL.mas_centerY).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(kScreenWidth*0.7-60);
        make.top.equalTo(weakSelf.shopTelL.mas_centerY).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];

    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.shopTelL.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.7, 1));
    }];
    
    [self.shopHoursL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(5);
        make.top.equalTo(weakSelf.shopTelL.mas_bottom).with.offset(20);
    }];
    
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.top.equalTo(weakSelf.shopHoursL.mas_bottom).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.7, 1));
    }];

    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(kScreenWidth*0.7-20);
        make.top.equalTo(weakSelf.mas_top).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.workStateL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(kScreenWidth*0.7-60);
        make.centerY.equalTo(weakSelf.shopHoursL.mas_centerY);
    }];

}

-(NSString*) removeLastOneChar:(NSString*)origin
{
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}

-(void)callUp{
    if ([self.delegate respondsToSelector:@selector(callUpWithPhoneNumber:)]) {
        [self.delegate callUpWithPhoneNumber:self.storeModel.user_phone];
    }
}

-(void)navigateToTargetPositionWithThird{
    DLog(@"点击了导航");
    if ([self.delegate respondsToSelector:@selector(navigateToTargetPositionWithThird)]) {
        [self.delegate navigateToTargetPositionWithThird];
    }
}

@end
