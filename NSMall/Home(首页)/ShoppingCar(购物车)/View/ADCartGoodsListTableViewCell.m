//
//  ADCartGoodsListTableViewCell.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/4/11.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import "ADCartGoodsListTableViewCell.h"
#import "LZConfigFile.h"
#import "LZGoodsModel.h"

@interface ADCartGoodsListTableViewCell()
//显示照片
@property (nonatomic,retain) UIImageView *lzImageView;
//商品名
@property (nonatomic,retain) UILabel *nameLabel;
////尺寸
//@property (nonatomic,retain) UILabel *sizeLabel;
//价格
@property (nonatomic,retain) UILabel *dateLabel;
//描述1
@property (nonatomic,retain) UILabel *detail1Label;
//描述2
@property (nonatomic,retain) UILabel *detail2Label;
//数量
@property (nonatomic,retain)UILabel *numberLab;
@end

@implementation ADCartGoodsListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LZColorFromRGB(245, 246, 248);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupMainView];
    }
    return self;
}
#pragma mark - public method
- (void)reloadDataWithModel:(LZGoodsModel*)model {
    NSLog(@"model.spec_info = %@",model.spec_info);
    //    self.lzImageView.image = model.goods_image_path;
    [self.lzImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image_path]];
    self.nameLabel.text = model.goods_name;
    self.detail1Label.text = model.spec_info;
    self.detail2Label.text = model.total_price;
    self.dateLabel.text = [NSString stringWithFormat:@"%.2f 元",[model.price floatValue]];
    self.numberLab.text = [NSString stringWithFormat:@"数量: %ld",(long)model.count];
}

#pragma mark - 按钮点击方法

//- (void)setModel:(LZGoodsModel *)model {
//    _model = model;
//}

#pragma mark - 布局主视图
-(void)setupMainView {
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, LZSCREEN_WIDTH, lz_CartRowHeight - 1);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = LZColorFromHex(0xEEEEEE).CGColor;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.frame = CGRectMake(20, 35, bgView.height - 50, bgView.height - 50);
    imageBgView.backgroundColor = LZColorFromHex(0xF3F3F3);
    [bgView addSubview:imageBgView];
    
    //显示照片
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"default_pic_1"];
    imageView.frame = CGRectMake(imageBgView.left, imageBgView.top, imageBgView.width , imageBgView.height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imageView];
    self.lzImageView = imageView;
    
//    CGFloat width = (bgView.width - imageBgView.right - 30)/2.0;
    
    //商品名
    UILabel* nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(imageBgView.left, 10, bgView.width-40, 20);
    nameLabel.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    //描述1
    UILabel* detail1Label = [[UILabel alloc]init];
    detail1Label.frame = CGRectMake(imageView.right+10, imageView.top, nameLabel.width-10-imageView.width, 20);
    detail1Label.font = [UIFont boldSystemFontOfSize:14];
    detail1Label.textColor = LZColorFromRGB(132, 132, 132);
    detail1Label.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:detail1Label];
    self.detail1Label = detail1Label;
    
    //描述2
    UILabel* detail2Label = [[UILabel alloc]init];
    detail2Label.frame = CGRectMake(imageView.right+10, detail1Label.bottom, nameLabel.width-10-imageView.width, 20);
    detail2Label.font = [UIFont boldSystemFontOfSize:14];
    detail2Label.textColor = LZColorFromRGB(132, 132, 132);
    detail2Label.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:detail2Label];
    self.detail2Label = detail2Label;
    
    //价格
    UILabel* dateLabel = [[UILabel alloc]init];
    dateLabel.frame = CGRectMake(bgView.width - 75 - 35, bgView.height - 35, 90, 20);
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.textColor = BASECOLOR_RED;
    [bgView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    //数量显示
    UILabel* numberlab = [[UILabel alloc]init];
    numberlab.frame = CGRectMake(bgView.width - 75 - 35, bgView.height - 65, 90, 20);
    numberlab.textAlignment = NSTextAlignmentRight;
//    numberlab.backgroundColor = [UIColor greenColor];
    numberlab.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:numberlab];
    self.numberLab = numberlab;
    
}

@end
