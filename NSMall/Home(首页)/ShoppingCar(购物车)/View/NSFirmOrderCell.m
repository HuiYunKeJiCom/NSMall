//
//  NSFirmOrderCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/30.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSFirmOrderCell.h"

@interface NSFirmOrderCell()
@property (nonatomic, strong) UIView  *bgView;
@end

@implementation NSFirmOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.x = 0;
    self.bgView.y = 0;
    self.bgView.size = CGSizeMake(kScreenWidth, 65);
    self.bgView.backgroundColor = KBGCOLOR;
    [self addSubview:self.bgView];
    
}

-(void)setShopModel:(LZShopModel *)shopModel{
    _shopModel = shopModel;
    
//    headView
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    headView.backgroundColor = kWhiteColor;
    [self.bgView addSubview:headView];
    
    UIImageView *userIV = [[UIImageView alloc]init];
    userIV.contentMode = UIViewContentModeScaleAspectFit;
    userIV.x = 19;
    userIV.y = 10;
    userIV.size = CGSizeMake(29, 29);
    [headView addSubview:userIV];
    [userIV sd_setImageWithURL:[NSURL URLWithString:shopModel.user_avatar]];
    
    UILabel *userName = [[UILabel alloc]init];
    userName.text = shopModel.user_name;
    CGSize userSize = [self contentSizeWithTitle:shopModel.user_name andFont:14];
    userName.size = CGSizeMake(userSize.width, userSize.height);
    userName.x = CGRectGetMaxX(userIV.frame)+12;
    userName.y = 24-userSize.height*0.5;
    userName.font = UISystemFontSize(14);
    userName.textColor = kBlackColor;
    [headView addSubview:userName];
    if(shopModel.level != 0){
        UIImageView *levelIV = [[UIImageView alloc]init];
        [levelIV setContentMode:UIViewContentModeScaleAspectFit];
        levelIV.image = IMAGE(@"ico_level");
        [headView addSubview:levelIV];
        
        UILabel *levelLab = [[UILabel alloc] init];
        levelLab.font = [UIFont boldSystemFontOfSize:14];
        levelLab.textColor = [UIColor whiteColor];
        [headView addSubview:levelLab];
        
        levelIV.x = CGRectGetMaxX(userName.frame)+GetScaleWidth(5);
        levelIV.y = 19-userSize.height*0.5;
        levelIV.size = CGSizeMake(GetScaleWidth(30), GetScaleWidth(30));
        
        levelLab.centerX = CGRectGetMidX(levelIV.frame)-GetScaleWidth(5);
        levelLab.y = 21-userSize.height*0.5;
        levelLab.text = [NSString stringWithFormat:@"%ld",shopModel.level];
        [levelLab sizeToFit];
    }
    
    float height = 49.0;
    NSInteger buyNum = 0;
    for(int i=0;i<shopModel.productList.count;i++){
        LZGoodsModel *goodsModel = shopModel.productList[i];
        
        UIView *goodsV = [[UIView alloc]init];
        goodsV.backgroundColor = kWhiteColor;
        [self.bgView addSubview:goodsV];
        goodsV.x = 0;
        goodsV.y = height;
        goodsV.size = CGSizeMake(kScreenWidth, 176);
        
        UIImageView *goodsIV = [[UIImageView alloc]init];
        goodsIV.contentMode = UIViewContentModeScaleAspectFit;
        goodsIV.x = 19;
        goodsIV.y = 15;
//        goodsIV.backgroundColor = KBGCOLOR;
        goodsIV.size = CGSizeMake(53, 53);
        [goodsV addSubview:goodsIV];
        [goodsIV sd_setImageWithURL:[NSURL URLWithString:goodsModel.product_image]];
        
        UILabel *goodsName = [[UILabel alloc]init];
        goodsName.x = CGRectGetMaxX(goodsIV.frame)+14;
        goodsName.y = 15;
        goodsName.font = UISystemFontSize(14);
        goodsName.text = goodsModel.product_name;
        [goodsName sizeToFit];
        goodsName.textColor = kBlackColor;
        [goodsV addSubview:goodsName];
        
        if(goodsModel.spec_name){
            UILabel *specLab = [[UILabel alloc]init];
            specLab.x = CGRectGetMaxX(goodsIV.frame)+14;
            specLab.y = CGRectGetMaxY(goodsName.frame)+9;
            specLab.text = [NSString stringWithFormat:@"尺寸规格: %@",goodsModel.spec_name];
            specLab.font = UISystemFontSize(14);
            specLab.textColor = kBlackColor;
            [specLab sizeToFit];
            [goodsV addSubview:specLab];
        }
        
        UILabel *priceLab = [[UILabel alloc]init];
        priceLab.textColor = kRedColor;
        priceLab.font = UISystemFontSize(14);
        [goodsV addSubview:priceLab];
        priceLab.text = [NSString stringWithFormat:@"N%.2f",goodsModel.price];
         priceLab.x = CGRectGetMaxX(goodsIV.frame)+14;
         priceLab.y = CGRectGetMaxY(userName.frame)+25;
         [priceLab sizeToFit];
        
        UIView *line1 = [[UIView alloc]init];
        line1.x = 0;
        line1.y = CGRectGetMaxY(goodsIV.frame)+15;
        line1.size = CGSizeMake(kScreenWidth, 1);
        line1.backgroundColor = KBGCOLOR;
        [goodsV addSubview:line1];
        
        UILabel *numTitle = [[UILabel alloc]init];
        numTitle.x = 19;
        numTitle.y = CGRectGetMaxY(line1.frame)+17;
        numTitle.text = @"购买数量";
        numTitle.font = UISystemFontSize(14);
        [numTitle sizeToFit];
        numTitle.textColor = kBlackColor;
        [goodsV addSubview:numTitle];
        
        UILabel *numLab = [[UILabel alloc]init];
        numLab.text = [NSString stringWithFormat:@"x%lu",goodsModel.buy_number];
        CGSize contentSize = [self contentSizeWithTitle:numLab.text andFont:14];
        numLab.x = kScreenWidth-20-contentSize.width;
        numLab.y = CGRectGetMaxY(line1.frame)+23-contentSize.height*0.5;
        numLab.size = CGSizeMake(contentSize.width, contentSize.height);
        numLab.font = UISystemFontSize(14);
        numLab.textColor = kBlackColor;
        [goodsV addSubview:numLab];
        buyNum += goodsModel.buy_number;
        
        UIView *line2 = [[UIView alloc]init];
        line2.x = 0;
        line2.y = CGRectGetMaxY(line1.frame)+46;
        line2.size = CGSizeMake(kScreenWidth, 1);
        line2.backgroundColor = KBGCOLOR;
        [goodsV addSubview:line2];
        
        UILabel *shipTitle = [[UILabel alloc]init];
        shipTitle.x = 19;
        shipTitle.y = CGRectGetMaxY(line2.frame)+17;
        shipTitle.text = @"运费";
        shipTitle.font = UISystemFontSize(14);
        [shipTitle sizeToFit];
        shipTitle.textColor = kBlackColor;
        [goodsV addSubview:shipTitle];
        
        UILabel *shipLab = [[UILabel alloc]init];
        shipLab.textColor = kRedColor;
        shipLab.text = [NSString stringWithFormat:@"N%.2f",goodsModel.ship_price];
        
        CGSize shipSize = [self contentSizeWithTitle:shipLab.text andFont:14];
        shipLab.x = kScreenWidth-20-shipSize.width;
        shipLab.y = CGRectGetMaxY(line2.frame)+23-shipSize.height*0.5;
        [shipLab sizeToFit];
        shipLab.font = UISystemFontSize(14);
        [goodsV addSubview:shipLab];
        
        UIView *line3 = [[UIView alloc]init];
        line3.x = 0;
        line3.y = CGRectGetMaxY(line2.frame)+46;
        line3.size = CGSizeMake(kScreenWidth, 1);
        line3.backgroundColor = KBGCOLOR;
        [goodsV addSubview:line3];
        
        height = CGRectGetMaxY(goodsV.frame)+10;
//        DLog(@"里面height = %.2f",height);
        if(i == shopModel.productList.count-1){
            height -= 10;
        }
    }
    
//    DLog(@"外面height = %.2f",height);
    
//    footView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, height+1, kScreenWidth, 34)];
    footView.backgroundColor = kWhiteColor;
    [self.bgView addSubview:footView];
    
    UILabel *totalLab = [[UILabel alloc]init];
    totalLab.font = UISystemFontSize(14);
    totalLab.textColor = kRedColor;
    totalLab.text = [NSString stringWithFormat:@"N%.2f",shopModel.sum_price];
    
    CGSize totalPriceSize = [self contentSizeWithTitle:totalLab.text andFont:14];
    totalLab.x = kScreenWidth-20-totalPriceSize.width;
    totalLab.y = 12;
    [totalLab sizeToFit];
    [footView addSubview:totalLab];
    
    UILabel *totalTitle = [[UILabel alloc]init];
    totalTitle.text = [NSString stringWithFormat:@"共%lu件商品,小计",buyNum];
    totalTitle.font = UISystemFontSize(14);
    CGSize totalSize = [self contentSizeWithTitle:totalTitle.text andFont:14];
    totalTitle.x = CGRectGetMinX(totalLab.frame)-totalSize.width-3;
    totalTitle.y = 12;
    [totalTitle sizeToFit];
    totalTitle.textColor = kGreyColor;
    [footView addSubview:totalTitle];
    
    self.bgView.size = CGSizeMake(kScreenWidth, height+34);
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}
@end
