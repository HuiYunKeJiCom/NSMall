//
//  NSGoodsShowCellTest.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/2.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGoodsShowCellTest.h"
#import "UIButton+Bootstrap.h"

@interface NSGoodsShowCellTest()
@property (nonatomic, strong) UIView           *bgView;
@property(nonatomic,strong)UIImageView *headerIV;/* 发布者头像 */
@property(nonatomic,strong)UILabel *userName;/* 用户名 */
@property(nonatomic,strong)UILabel *timeLab;/* 时间标签 */
@property(nonatomic,strong)UILabel *priceLab;/* 价格 */
@property(nonatomic,strong)UIScrollView *imageSV;/* 图片滚动 */
@property(nonatomic,strong)UILabel *detailLab;/* 描述 */
@property(nonatomic,strong)UIButton *commentBtn;/* 评论按钮 */
@property(nonatomic,strong)UIButton *shareBtn;/* 分享按钮 */
@end

@implementation NSGoodsShowCellTest

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.isLike = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    self.headerIV = [[UIImageView alloc]initWithFrame:CGRectMake(GetScaleWidth(11), GetScaleWidth(19), GetScaleWidth(33), GetScaleWidth(33))];
    [self.headerIV setContentMode:UIViewContentModeScaleAspectFill];
    //    [self.headerIV.layer setCornerRadius:33];
    //    [self.headerIV.layer setMasksToBounds:YES];
    [self.bgView addSubview:self.headerIV];
    
    self.userName = [[UILabel alloc] init];
    self.userName.x = CGRectGetMaxX(self.headerIV.frame)+GetScaleWidth(6);
    self.userName.y = GetScaleWidth(19);
    self.userName.font = [UIFont systemFontOfSize:kFontNum13];
    self.userName.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.userName];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.font = [UIFont systemFontOfSize:kFontNum13];
    self.timeLab.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:self.timeLab];
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.font = [UIFont systemFontOfSize:kFontNum13];
    self.priceLab.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:self.priceLab];
    
    self.imageSV = [[UIScrollView alloc]init];
    self.imageSV.backgroundColor = [UIColor greenColor];
    [self.bgView addSubview:self.imageSV];
    
    self.detailLab = [[UILabel alloc] init];
    //    self.detailLab.size = CGSizeMake(kScreenWidth-20, 20);
    self.detailLab.numberOfLines = 0;
    self.detailLab.font = [UIFont systemFontOfSize:kFontNum14];
    self.detailLab.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.detailLab];
    
    self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.likeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.likeBtn setImageWithTitle:IMAGE(@"ico_like") withTitle:@"喜欢" position:@"left" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.bgView addSubview:self.likeBtn];
    [self.likeBtn addTarget:self action:@selector(likeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.commentBtn setImageWithTitle:IMAGE(@"ico_comment") withTitle:@"评论" position:@"left" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.bgView addSubview:self.commentBtn];
    [self.commentBtn addTarget:self action:@selector(commentButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.shareBtn setImageWithTitle:IMAGE(@"ico_share") withTitle:@"分享" position:@"left" font:[UIFont systemFontOfSize:kFontNum14] forState:UIControlStateNormal];
    [self.bgView addSubview:self.shareBtn];
    [self.shareBtn addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
//    self.likeBtn.backgroundColor = [UIColor yellowColor];
//    self.commentBtn.backgroundColor = kRedColor;
//    self.shareBtn.backgroundColor = [UIColor greenColor];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self makeConstraints];
}

- (void)makeConstraints {
    
    WEAKSELF
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.mas_left);
        make.right.equalTo(weakSelf.mas_right);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
    
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(11));
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(GetScaleWidth(18));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(33), GetScaleWidth(33)));
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerIV.mas_right).with.offset(GetScaleWidth(6));
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(GetScaleWidth(21));
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.headerIV.mas_right).with.offset(GetScaleWidth(6));
        make.top.equalTo(weakSelf.userName.mas_bottom).with.offset(GetScaleWidth(6));
    }];
    
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-GetScaleWidth(10));
        make.centerY.equalTo(weakSelf.headerIV.mas_centerY);
    }];
    
    [self.imageSV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(11));
        make.top.equalTo(weakSelf.headerIV.mas_bottom).with.offset(GetScaleWidth(15));
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, (kScreenWidth-GetScaleWidth(22)-GetScaleWidth(16))/3.0));
    }];
    
    [self.detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset(GetScaleWidth(11));
        make.top.equalTo(weakSelf.imageSV.mas_bottom).with.offset(GetScaleWidth(10));
        make.right.equalTo(weakSelf.bgView.mas_right).with.offset(-GetScaleWidth(13));
    }];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset((kScreenWidth-GetScaleWidth(80*3))/4.0);
        make.top.equalTo(weakSelf.detailLab.mas_bottom).with.offset(GetScaleWidth(15));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(80), GetScaleWidth(20)));
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(-GetScaleWidth(19));
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset((kScreenWidth-GetScaleWidth(80*3))/2.0+GetScaleWidth(80));
        make.top.equalTo(weakSelf.detailLab.mas_bottom).with.offset(GetScaleWidth(15));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(80), GetScaleWidth(20)));
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(-GetScaleWidth(14));
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left).with.offset((kScreenWidth-GetScaleWidth(80*3))/4.0*3+GetScaleWidth(80*2));
        make.top.equalTo(weakSelf.detailLab.mas_bottom).with.offset(GetScaleWidth(15));
        make.size.mas_equalTo(CGSizeMake(GetScaleWidth(80), GetScaleWidth(20)));
        make.bottom.equalTo(weakSelf.bgView.mas_bottom).with.offset(-GetScaleWidth(14));
    }];
}

-(void)setProductModel:(ProductListItemModel *)productModel{
    _productModel = productModel;
    
    if(productModel.is_like == 1){
        self.isLike = YES;
        [self.likeBtn setImageWithTitle:IMAGE(@"home_ico_like_press") withTitle:[NSString stringWithFormat:@"喜欢(%@)",[NSNumber numberWithInteger:productModel.like_number]] position:@"left" font:UISystemFontSize(14) forState:UIControlStateNormal];
    }else{
        self.isLike = NO;
        [self.likeBtn setImageWithTitle:IMAGE(@"ico_like") withTitle:@"喜欢" position:@"left" font:UISystemFontSize(14) forState:UIControlStateNormal];
    }
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:productModel.user_avatar]];
    self.userName.text = productModel.user_name;
    self.timeLab.text = productModel.update_time;

    NSString *str = [NSString stringWithFormat:@"N%.2f/¥%.2f",[productModel.show_price floatValue],[productModel.show_score floatValue]];
    NSArray *strArr = [str componentsSeparatedByString:@"/¥"];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:kRedColor
     
                          range:[str rangeOfString:strArr[0]]];
    self.priceLab.attributedText = AttributedStr;
    
    float itemWidth = (kScreenWidth-GetScaleWidth(22)-GetScaleWidth(16))/3.0;
    self.imageSV.contentSize = CGSizeMake((itemWidth+GetScaleWidth(8))*productModel.productImageList.count, 0);
    for(int i=0;i<productModel.productImageList.count;i++){
        UIImageView *goodsIV = [[UIImageView alloc]initWithFrame:CGRectMake((itemWidth+GetScaleWidth(8))*i, 0, itemWidth, itemWidth)];
        [goodsIV sd_setImageWithURL:[NSURL URLWithString:productModel.productImageList[i]]];
        [self.imageSV addSubview:goodsIV];
    }
    
    self.detailLab.text = productModel.introduce;
}

- (void)likeButtonClick {
    DLog(@"点击了喜欢");
    !_likeBtnClickBlock ? : _likeBtnClickBlock();
}

- (void)commentButtonClick {
    !_commentBtnClickBlock ? : _commentBtnClickBlock();
}

- (void)shareButtonClick {
    !_shareBtnClickBlock ? : _shareBtnClickBlock();
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGFloat totalHeight = 0;
    totalHeight += [self.headerIV sizeThatFits:size].height;
    totalHeight += [self.imageSV sizeThatFits:size].height;
    totalHeight += [self.detailLab sizeThatFits:size].height;
    totalHeight += [self.commentBtn sizeThatFits:size].height;
    totalHeight += 19+15+13+14+10; // margins
    return CGSizeMake(size.width, totalHeight);
}

@end
