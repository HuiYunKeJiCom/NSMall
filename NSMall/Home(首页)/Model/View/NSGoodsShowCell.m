//
//  NSGoodsShowCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/14.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGoodsShowCell.h"
#import "UIButton+Bootstrap.h"

@interface NSGoodsShowCell()
@property (nonatomic, strong) UIView           *bgView;
@property(nonatomic,strong)UIImageView *headerIV;/* 发布者头像 */
@property(nonatomic,strong)UILabel *userName;/* 用户名 */
@property(nonatomic,strong)UILabel *timeLab;/* 时间标签 */
@property(nonatomic,strong)UILabel *priceLab;/* 价格 */
@property(nonatomic,strong)UIScrollView *imageSV;/* 图片滚动 */
@property(nonatomic,strong)UILabel *detailLab;/* 描述 */
@property(nonatomic,strong)UIButton *likeBtn;/* 喜欢按钮 */
@property(nonatomic,strong)UIButton *commentBtn;/* 评论按钮 */
@property(nonatomic,strong)UIButton *shareBtn;/* 分享按钮 */
@end

@implementation NSGoodsShowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        self.backgroundColor = [UIColor clearColor];
        
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    self.headerIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
//    self.headerIV.backgroundColor = [UIColor greenColor];
    [self.headerIV setContentMode:UIViewContentModeScaleAspectFit];
    [self.bgView addSubview:self.headerIV];

    self.userName = [[UILabel alloc] init];
    self.userName.x = CGRectGetMaxX(self.headerIV.frame)+10;
    self.userName.y = 10;
    self.userName.font = [UIFont systemFontOfSize:kFontNum14];
    self.userName.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.userName];
    
    self.timeLab = [[UILabel alloc] init];
    self.timeLab.font = [UIFont systemFontOfSize:kFontNum14];
    self.timeLab.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:self.timeLab];
    
    self.priceLab = [[UILabel alloc] init];
    self.priceLab.font = [UIFont systemFontOfSize:kFontNum14];
    self.priceLab.textColor = [UIColor redColor];
    [self.bgView addSubview:self.priceLab];
    
    self.imageSV = [[UIScrollView alloc]init];
    self.imageSV.contentSize = CGSizeMake(kScreenWidth, 0);
    [self.bgView addSubview:self.imageSV];
    float itemWidth = (kScreenWidth-20-24)/3.0;
    for(int i=0;i<3;i++){
        UIImageView *goodsIV = [[UIImageView alloc]initWithFrame:CGRectMake((itemWidth+12)*i, 0, itemWidth, itemWidth)];
        if(i==0){
            goodsIV.backgroundColor = [UIColor greenColor];
        }else if (i==1){
            goodsIV.backgroundColor = [UIColor redColor];
        }else{
            goodsIV.backgroundColor = [UIColor yellowColor];
        }
        [self.imageSV addSubview:goodsIV];
    }
    
    self.detailLab = [[UILabel alloc] init];
//    self.detailLab.size = CGSizeMake(kScreenWidth-20, 20);
    self.detailLab.numberOfLines = 0;
    self.detailLab.font = [UIFont systemFontOfSize:kFontNum17];
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
    
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

-(void)setProductModel:(ProductListItemModel *)productModel{
    _productModel = productModel;
    
    [self.headerIV sd_setImageWithURL:[NSURL URLWithString:productModel.user_avatar]];
    self.userName.text = productModel.user_name;
    [self.userName sizeToFit];
    self.timeLab.text = productModel.update_time;
    self.timeLab.x = CGRectGetMaxX(self.headerIV.frame)+10;
    self.timeLab.y = CGRectGetMaxY(self.userName.frame)+5;
    [self.timeLab sizeToFit];
//    NSLog(@"show_price = %@",productModel.show_score);
    self.priceLab.text = [NSString stringWithFormat:@"N%.2f/¥%.2f",[productModel.show_price floatValue],[productModel.show_score floatValue]];
    self.priceLab.x = kScreenWidth-10-self.priceLab.width;
    self.priceLab.centerY = CGRectGetMidY(self.headerIV.frame);
    [self.priceLab sizeToFit];
    float itemWidth = (kScreenWidth-20-24)/3.0;
    self.imageSV.x = 10;
    self.imageSV.y = CGRectGetMaxY(self.timeLab.frame)+20;
    self.imageSV.size = CGSizeMake(kScreenWidth, itemWidth);
    self.detailLab.x = 10;
    self.detailLab.y = CGRectGetMaxY(self.imageSV.frame)+15;
    self.detailLab.text = productModel.introduce;
    CGSize maximumLabelSize = CGSizeMake(kScreenWidth-20, 9999);//labelsize的最大值
    CGSize expectSize = [self.detailLab sizeThatFits:maximumLabelSize];
    self.detailLab.size = CGSizeMake(expectSize.width, expectSize.height);
    self.likeBtn.centerX = itemWidth*0.5-40+40;
    self.likeBtn.y = CGRectGetMaxY(self.detailLab.frame)+25;
    self.likeBtn.size = CGSizeMake(80, 20);
    self.commentBtn.centerX = itemWidth*1.5-28+40;
    self.commentBtn.y = CGRectGetMaxY(self.detailLab.frame)+25;
    self.commentBtn.size = CGSizeMake(80, 20);
    self.shareBtn.centerX = itemWidth*2.5-16+40;
    self.shareBtn.y = CGRectGetMaxY(self.detailLab.frame)+25;
    self.shareBtn.size = CGSizeMake(80, 20);
}

- (void)likeButtonClick {
    !_likeBtnClickBlock ? : _likeBtnClickBlock();
}

- (void)commentButtonClick {
    !_commentBtnClickBlock ? : _commentBtnClickBlock();
}

- (void)shareButtonClick {
    !_shareBtnClickBlock ? : _shareBtnClickBlock();
}

@end
