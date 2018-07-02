//
//  NSODTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSODTVCell.h"

@interface NSODTVCell()
@property (nonatomic, strong) UIView  *bgView;
@end

@implementation NSODTVCell

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

-(void)setOrderDetailModel:(NSOrderDetailModel *)orderDetailModel{
    _orderDetailModel = orderDetailModel;
    
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
    [userIV sd_setImageWithURL:[NSURL URLWithString:orderDetailModel.user_avatar]];

    UILabel *userName = [[UILabel alloc]init];
    userName.text = orderDetailModel.user_name;
    CGSize userSize = [self contentSizeWithTitle:orderDetailModel.user_name andFont:14];
    userName.size = CGSizeMake(userSize.width, userSize.height);
    userName.x = CGRectGetMaxX(userIV.frame)+12;
    userName.y = 24-userSize.height*0.5;
    userName.font = UISystemFontSize(14);
    userName.textColor = kBlackColor;
    [headView addSubview:userName];

    float height = 49.0;
    NSInteger buyNum = 0;
    for(int i=0;i<orderDetailModel.productList.count;i++){
        NSODItemModel *goodsModel = orderDetailModel.productList[i];

        DLog(@"goodsModel = %@",goodsModel.mj_keyValues);
//        DLog(@"product_imge = %@",[goodsModel.product_imge class]);
        
        UIView *goodsV = [[UIView alloc]init];
        goodsV.backgroundColor = kWhiteColor;
        [self.bgView addSubview:goodsV];
        goodsV.x = 0;
        goodsV.y = height;
        goodsV.size = CGSizeMake(kScreenWidth, 226);

        UIImageView *goodsIV = [[UIImageView alloc]init];
        goodsIV.contentMode = UIViewContentModeScaleAspectFit;
        goodsIV.x = 19;
        goodsIV.y = 15;
        goodsIV.backgroundColor = KBGCOLOR;
        goodsIV.size = CGSizeMake(53, 53);
        [goodsV addSubview:goodsIV];
        [goodsIV sd_setImageWithURL:[NSURL URLWithString:goodsModel.product_imge]];

        UILabel *goodsName = [[UILabel alloc]init];
        goodsName.x = CGRectGetMaxX(goodsIV.frame)+14;
        goodsName.y = 15;
        goodsName.font = UISystemFontSize(14);
        goodsName.text = goodsModel.product_name;
        [goodsName sizeToFit];
        goodsName.textColor = kBlackColor;
        [goodsV addSubview:goodsName];

        if(goodsModel.product_spec_name){
            UILabel *specLab = [[UILabel alloc]init];
            specLab.x = CGRectGetMaxX(goodsIV.frame)+14;
            specLab.y = CGRectGetMaxY(goodsName.frame)+9;
            specLab.text = [NSString stringWithFormat:@"尺寸规格: %@",goodsModel.product_spec_name];
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
        priceLab.y = CGRectGetMaxY(userName.frame)+20;
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

        UILabel *orderNumberTitle = [[UILabel alloc]init];
        orderNumberTitle.x = 19;
        orderNumberTitle.y = CGRectGetMaxY(line2.frame)+17;
        orderNumberTitle.text = @"订单编号:";
        orderNumberTitle.font = UISystemFontSize(14);
        [orderNumberTitle sizeToFit];
        orderNumberTitle.textColor = kBlackColor;
        [goodsV addSubview:orderNumberTitle];

        UILabel *orderNumberLab = [[UILabel alloc]init];
        orderNumberLab.textColor = kBlackColor;
        orderNumberLab.text = [NSString stringWithFormat:@"%ld",orderDetailModel.order_number];

        CGSize orderNumberSize = [self contentSizeWithTitle:orderNumberLab.text andFont:14];
        orderNumberLab.x = CGRectGetMaxX(orderNumberTitle.frame)+5;
        orderNumberLab.y = CGRectGetMaxY(line2.frame)+23-orderNumberSize.height*0.5;
        [orderNumberLab sizeToFit];
        orderNumberLab.font = UISystemFontSize(14);
        [goodsV addSubview:orderNumberLab];

        UIView *line3 = [[UIView alloc]init];
        line3.x = 0;
        line3.y = CGRectGetMaxY(line2.frame)+46;
        line3.size = CGSizeMake(kScreenWidth, 1);
        line3.backgroundColor = KBGCOLOR;
        [goodsV addSubview:line3];
        
        UILabel *createTimeTitle = [[UILabel alloc]init];
        createTimeTitle.x = 19;
        createTimeTitle.y = CGRectGetMaxY(line3.frame)+17;
        createTimeTitle.text = @"下单时间:";
        createTimeTitle.font = UISystemFontSize(14);
        [createTimeTitle sizeToFit];
        createTimeTitle.textColor = kBlackColor;
        [goodsV addSubview:createTimeTitle];
        
        UILabel *createTimeLab = [[UILabel alloc]init];
        createTimeLab.textColor = kBlackColor;
        createTimeLab.text = [NSString stringWithFormat:@"%@",orderDetailModel.create_time];
        
        CGSize createTimeSize = [self contentSizeWithTitle:createTimeLab.text andFont:14];
        createTimeLab.x = CGRectGetMaxX(createTimeTitle.frame)+5;
        createTimeLab.y = CGRectGetMaxY(line3.frame)+23-createTimeSize.height*0.5;
        [createTimeLab sizeToFit];
        createTimeLab.font = UISystemFontSize(14);
        [goodsV addSubview:createTimeLab];
        

        height = CGRectGetMaxY(goodsV.frame)+10;
        //        DLog(@"里面height = %.2f",height);
    }

    //    footView
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, height, kScreenWidth, 150)];
    footView.backgroundColor = kWhiteColor;
    [self.bgView addSubview:footView];

    UILabel *totalLab = [[UILabel alloc]init];
    totalLab.font = UISystemFontSize(14);
    totalLab.textColor = kRedColor;
    totalLab.text = [NSString stringWithFormat:@"N%.2f",orderDetailModel.order_amount];

    CGSize totalPriceSize = [self contentSizeWithTitle:totalLab.text andFont:14];
    totalLab.x = kScreenWidth-20-totalPriceSize.width;
    totalLab.y = 12;
    [totalLab sizeToFit];
    [footView addSubview:totalLab];

    UILabel *totalTitle = [[UILabel alloc]init];
    totalTitle.text = @"商品总额";
    totalTitle.font = UISystemFontSize(14);
//    CGSize totalSize = [self contentSizeWithTitle:totalTitle.text andFont:14];
    totalTitle.x = 19;
    totalTitle.y = 12;
    [totalTitle sizeToFit];
    totalTitle.textColor = kBlackColor;
    [footView addSubview:totalTitle];
    
    UIView *line4 = [[UIView alloc]init];
    line4.x = 0;
    line4.y = CGRectGetMaxY(totalTitle.frame)+15;
    line4.size = CGSizeMake(kScreenWidth, 1);
    line4.backgroundColor = KBGCOLOR;
    [footView addSubview:line4];
    
    UILabel *shipTitle = [[UILabel alloc]init];
    shipTitle.x = 19;
    shipTitle.y = CGRectGetMaxY(line4.frame)+17;
    shipTitle.text = @"运费";
    shipTitle.font = UISystemFontSize(14);
    [shipTitle sizeToFit];
    shipTitle.textColor = kBlackColor;
    [footView addSubview:shipTitle];
    
    UILabel *shipLab = [[UILabel alloc]init];
    shipLab.textColor = kRedColor;
    shipLab.text = [NSString stringWithFormat:@"N%.2f",orderDetailModel.ship_amount];
    
    CGSize shipSize = [self contentSizeWithTitle:shipLab.text andFont:14];
    shipLab.x = kScreenWidth-20-shipSize.width;
    shipLab.y = CGRectGetMaxY(line4.frame)+23-shipSize.height*0.5;
    [shipLab sizeToFit];
    shipLab.font = UISystemFontSize(14);
    [footView addSubview:shipLab];
    
    UIView *line5 = [[UIView alloc]init];
    line5.x = 0;
    line5.y = CGRectGetMaxY(line4.frame)+46;
    line5.size = CGSizeMake(kScreenWidth, 1);
    line5.backgroundColor = KBGCOLOR;
    [footView addSubview:line5];
    
    UILabel *allTotalLab = [[UILabel alloc]init];
    allTotalLab.font = UISystemFontSize(14);
    allTotalLab.textColor = kRedColor;
    allTotalLab.text = [NSString stringWithFormat:@"N%.2f",orderDetailModel.pay_amount];
    
    CGSize allTotalSize = [self contentSizeWithTitle:allTotalLab.text andFont:14];
    allTotalLab.x = kScreenWidth-20-allTotalSize.width;
    allTotalLab.y = CGRectGetMaxY(line5.frame)+17;
    [allTotalLab sizeToFit];
    [footView addSubview:allTotalLab];
    
    UILabel *allTotalTitle = [[UILabel alloc]init];
    allTotalTitle.text = @"合计:";
    allTotalTitle.font = UISystemFontSize(14);
    CGSize allTotalTitleSize = [self contentSizeWithTitle:allTotalTitle.text andFont:14];
    allTotalTitle.x = CGRectGetMinX(allTotalLab.frame)-allTotalTitleSize.width-3;
    allTotalTitle.y = CGRectGetMaxY(line5.frame)+17;
    [allTotalTitle sizeToFit];
    allTotalTitle.textColor = kBlackColor;
    [footView addSubview:allTotalTitle];

    height += CGRectGetMaxY(footView.frame);
    
    self.bgView.size = CGSizeMake(kScreenWidth, height);
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
