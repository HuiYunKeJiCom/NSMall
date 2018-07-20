//
//  UserHeaderV.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "UserHeaderV.h"
#import "UIButton+Bootstrap.h"

@interface UserHeaderV()
@property(nonatomic,strong)UIImageView *bgIV;/* 背景图 */
@property(nonatomic,strong)UIImageView *headerIV;/* 头像 */
@property(nonatomic,strong)UILabel *userNameL;/* 昵称 */
@property(nonatomic,strong)UILabel *regeistDayL;/* 注册天数 */
@property(nonatomic,strong)UIImageView *idenIV;/* 实名认证图片 */
@property(nonatomic,strong)UILabel *idenLab;/* 实名认证 */
@property(nonatomic,strong)UILabel *goodsL;/* 商品数 */
@property(nonatomic,strong)UILabel *shopL;/* 店铺数 */
@property(nonatomic,strong)UILabel *commentL;/* 评价数 */
@property(nonatomic,strong)UIButton *editBtn;/* 编辑按钮 */
@property(nonatomic,strong)UIButton *shareBtn;/* 分享按钮 */
@end


@implementation UserHeaderV

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
//        self.backgroundColor = kWhiteColor;
    }
    
    return self;
}

- (void)initViews {

    self.bgIV = [[UIImageView alloc]init];
//    self.bgIV.backgroundColor = kBlueColor;
    self.bgIV.image = IMAGE(@"default_personal_head");
    [self addSubview:self.bgIV];
    
    self.headerIV = [[UIImageView alloc]init];
//    self.headerIV.backgroundColor = [UIColor greenColor];
    [self addSubview:self.headerIV];
    
    self.userNameL = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum15 TextColor:kBlackColor];
    [self addSubview:self.userNameL];
    
    self.regeistDayL = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum14 TextColor:kGreyColor];
    [self addSubview:self.regeistDayL];
    
    self.idenIV = [[UIImageView alloc]init];
//    self.idenIV.backgroundColor = kRedColor;
    self.idenIV.image = IMAGE(@"mypage_ico_realname");
    self.idenIV.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.idenIV];
    
    self.idenLab = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:kBlackColor];
    self.idenLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.idenLab];
    
    self.goodsL = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:kBlackColor];
    [self addSubview:self.goodsL];
    
    self.shopL = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:kBlackColor];
    [self addSubview:self.shopL];

    self.commentL = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum13 TextColor:kBlackColor];
    [self addSubview:self.commentL];
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.shareBtn setImageWithTitle:IMAGE(@"mypage_ico_share") withTitle:@"分享" position:@"left" font:[UIFont systemFontOfSize:kFontNum12] forState:UIControlStateNormal];
    [self addSubview:self.shareBtn];
    [self.shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.editBtn setImageWithTitle:IMAGE(@"mypage_ico_edit") withTitle:@"编辑" position:@"left" font:[UIFont systemFontOfSize:kFontNum12] forState:UIControlStateNormal];
    [self addSubview:self.editBtn];
    [self.editBtn addTarget:self action:@selector(editButtonClick) forControlEvents:UIControlEventTouchUpInside];

    
    [self makeConstraints];
    //    [self setUpDictionary:self.dict];
}

-(void)setUserPageM:(UserPageModel *)userPageM{
    _userPageM = userPageM;
    
    self.userNameL.text = [userPageM.nick_name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.regeistDayL.text = [NSString stringWithFormat:@"来诺商%@了!",userPageM.regeist_day];
    self.idenLab.text = @"实名认证";
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:userPageM.pic_img]];
    self.goodsL.text = [NSString stringWithFormat:@"%d 商品",userPageM.product_number];
    self.shopL.text = [NSString stringWithFormat:@"%d 店铺",userPageM.store_number];
    self.commentL.text = [NSString stringWithFormat:@"%d 评价",userPageM.comment_number];
}

- (void)makeConstraints {
    WEAKSELF
    
    [self.bgIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf.mas_top);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, GetScaleWidth(112)));
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).with.offset(GetScaleWidth(-19));
        make.top.equalTo(weakSelf.mas_top).with.offset(GetScaleWidth(88));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(48), GetScaleWidth(48)));
    }];
    
    [self.userNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(GetScaleWidth(18));
        make.top.equalTo(weakSelf.bgIV.mas_bottom).with.offset(GetScaleWidth(8));
        
            make.height.mas_equalTo(GetScaleWidth(13));
    
    }];
    
    [self.regeistDayL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(GetScaleWidth(18));
        make.top.equalTo(weakSelf.userNameL.mas_bottom).with.offset(GetScaleWidth(15));
        make.height.mas_equalTo(GetScaleWidth(12));
        
    }];
    
    [self.idenLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).with.offset(GetScaleWidth(-18));
        make.top.equalTo(weakSelf.userNameL.mas_bottom).with.offset(GetScaleWidth(15));
        make.height.mas_equalTo(GetScaleWidth(12));
        
    }];
    
    [self.idenIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.idenLab.mas_left).with.offset(GetScaleWidth(-5));
        make.centerY.equalTo(weakSelf.idenLab.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(20), GetScaleWidth(18)));
        
    }];
    
    [self.goodsL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left).with.offset(GetScaleWidth(18));
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(GetScaleWidth(-13));
        
        make.height.mas_equalTo(GetScaleWidth(9));
        
    }];
    
    [self.shopL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.goodsL.mas_right).with.offset(GetScaleWidth(12));
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(GetScaleWidth(-13));
        make.height.mas_equalTo(GetScaleWidth(9));
    }];

    [self.commentL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.shopL.mas_right).with.offset(GetScaleWidth(15));
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(GetScaleWidth(-13));
        make.height.mas_equalTo(GetScaleWidth(9));
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.mas_right).with.offset(GetScaleWidth(-8));
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(GetScaleWidth(-9));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(80), GetScaleWidth(20)));
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.shareBtn.mas_left).with.offset(GetScaleWidth(14));
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(GetScaleWidth(-7));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(80), GetScaleWidth(20)));
    }];
}

- (void)shareButtonClick {
    !_shareBtnClickBlock ? : _shareBtnClickBlock();
}

- (void)editButtonClick {
    !_editBtnClickBlock ? : _editBtnClickBlock();
}

@end
