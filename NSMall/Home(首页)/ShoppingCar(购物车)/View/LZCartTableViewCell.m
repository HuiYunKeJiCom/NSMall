//
//  LZCartTableViewCell.m
//  LZCartViewController
//
//  Created by Artron_LQQ on 16/5/31.
//  Copyright © 2016年 Artup. All rights reserved.
//  购物车-商品cell

#import "LZCartTableViewCell.h"
#import "LZConfigFile.h"
//#import "LZCartModel.h"
#import "LZGoodsModel.h"


@interface LZCartTableViewCell ()<UITextFieldDelegate>
{
    LZNumberChangedBlock numberAddBlock;
    LZNumberChangedBlock numberCutBlock;
    LZCellSelectedBlock cellSelectedBlock;
}
//选中按钮
@property (nonatomic,retain) UIButton *selectBtn;
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
@property (nonatomic,retain)UITextField *numberTF;

@end

@implementation LZCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
//    self.lzImageView.image = model.goods_image_path;
    [self.lzImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_image_path]];
    self.nameLabel.text = model.goods_name;
    self.detail1Label.text = model.spec_info;
    self.detail2Label.text = model.total_price;
    self.dateLabel.text = [NSString stringWithFormat:@"%.2f 元",[model.price floatValue]];
    self.numberTF.text = [NSString stringWithFormat:@"%ld",(long)model.count];
//    self.sizeLabel.text = model.sizeStr;
    self.selectBtn.selected = model.select;
}

- (void)numberAddWithBlock:(LZNumberChangedBlock)block {
    numberAddBlock = block;
}

- (void)numberCutWithBlock:(LZNumberChangedBlock)block {
    numberCutBlock = block;
}

- (void)cellSelectedWithBlock:(LZCellSelectedBlock)block {
    cellSelectedBlock = block;
}
#pragma mark - 重写setter方法
- (void)setLzNumber:(NSInteger)lzNumber {
    _lzNumber = lzNumber;
    self.numberTF.text = [NSString stringWithFormat:@"%ld",(long)lzNumber];
}

- (void)setLzSelected:(BOOL)lzSelected {
    _lzSelected = lzSelected;
    self.selectBtn.selected = lzSelected;
}
#pragma mark - 按钮点击方法
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (cellSelectedBlock) {
        cellSelectedBlock(button.selected);
    }
}

- (void)addBtnClick:(UIButton*)button {
    
    NSInteger count = [self.numberTF.text integerValue];
    count++;
    //这里需要修改
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
//    [RequestTool changeCartCount:@{@"count":[NSString stringWithFormat:@"%ld",(long)count],@"goodsCartId":self.model.goodscart_id} withSuccessBlock:^(NSDictionary *result) {
//        NSLog(@"购物车商品数量增result = %@",result);
//        if([result[@"code"] integerValue] == 1){
//            [hud hide:YES];
//
//            if (numberAddBlock) {
//                numberAddBlock(count);
//            }
//        }else if([result[@"code"] integerValue] == -2){
//            hud.detailsLabelText = @"登录失效";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }else if([result[@"code"] integerValue] == -1){
//            hud.detailsLabelText = @"未登录";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }else if([result[@"code"] integerValue] == 0){
//            hud.detailsLabelText = @"失败";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }else if([result[@"code"] integerValue] == 2){
//            hud.detailsLabelText = @"无返回数据";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }
//    } withFailBlock:^(NSString *msg) {
//        NSLog(@"购物车商品数量增msg = %@",msg);
//        hud.detailsLabelText = msg;
//        hud.mode = MBProgressHUDModeText;
//        [hud hide:YES afterDelay:1.0];
//    }];
}

- (void)cutBtnClick:(UIButton*)button {
    NSInteger count = [self.numberTF.text integerValue];
    count--;
    if(count <= 0){
        return ;
    }
    //这里需要修改
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
//    [RequestTool changeCartCount:@{@"count":[NSString stringWithFormat:@"%ld",(long)count],@"goodsCartId":self.model.goodscart_id} withSuccessBlock:^(NSDictionary *result) {
//        NSLog(@"购物车商品数量减result = %@",result);
//        if([result[@"code"] integerValue] == 1){
//            [hud hide:YES];
//            
//            if (numberCutBlock) {
//                numberCutBlock(count);
//            }
//        }else if([result[@"code"] integerValue] == -2){
//            hud.detailsLabelText = @"登录失效";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }else if([result[@"code"] integerValue] == -1){
//            hud.detailsLabelText = @"未登录";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }else if([result[@"code"] integerValue] == 0){
//            hud.detailsLabelText = @"失败";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }else if([result[@"code"] integerValue] == 2){
//            hud.detailsLabelText = @"无返回数据";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }
//    } withFailBlock:^(NSString *msg) {
//        NSLog(@"购物车商品数量减msg = %@",msg);
//        hud.detailsLabelText = msg;
//        hud.mode = MBProgressHUDModeText;
//        [hud hide:YES afterDelay:1.0];
//    }];

}

- (void)setModel:(LZGoodsModel *)model {
    _model = model;
}

#pragma mark - 布局主视图
-(void)setupMainView {
    //白色背景
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = CGRectMake(0, 0, LZSCREEN_WIDTH, lz_CartRowHeight - 1);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = LZColorFromHex(0xEEEEEE).CGColor;
    bgView.layer.borderWidth = 1;
    [self addSubview:bgView];
    
    //选中按钮
    UIButton* selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.center = CGPointMake(20, 20);
    selectBtn.bounds = CGRectMake(0, 0, 15, 15);
    [selectBtn setImage:[UIImage imageNamed:lz_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:lz_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:selectBtn];
    self.selectBtn = selectBtn;
    
    //照片背景
    UIView *imageBgView = [[UIView alloc]init];
    imageBgView.frame = CGRectMake(selectBtn.right + 10, selectBtn.bottom+10, bgView.height - 50, bgView.height - 50);
    imageBgView.backgroundColor = LZColorFromHex(0xF3F3F3);
    [bgView addSubview:imageBgView];
    
    //显示照片
    UIImageView* imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"default_pic_1"];
    imageView.frame = CGRectMake(imageBgView.left, imageBgView.top, imageBgView.width , imageBgView.height);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:imageView];
    self.lzImageView = imageView;
    
    CGFloat width = (bgView.width - imageBgView.right - 30)/2.0;
    
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
    dateLabel.frame = CGRectMake(imageView.right+10, bgView.height - 40 , width, 20);
    dateLabel.font = [UIFont systemFontOfSize:14];
    dateLabel.textColor = BASECOLOR_RED;
    [bgView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    //数量加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(bgView.width - 35, bgView.height - 35, 25, 25);
    [addBtn setImage:[UIImage imageNamed:@"buycar_ico_add"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"buycar_ico_add"] forState:UIControlStateHighlighted];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:addBtn];
    
    //数量显示
    UITextField* numberTF = [[UITextField alloc]init];
    numberTF.frame = CGRectMake(addBtn.left - 55, addBtn.top, 50, 25);
    numberTF.textAlignment = NSTextAlignmentCenter;
    numberTF.text = @"1";
    numberTF.font = [UIFont systemFontOfSize:15];
    numberTF.keyboardType = UIKeyboardTypeNumberPad;
    numberTF.delegate = self;
    [bgView addSubview:numberTF];
    numberTF.layer.borderColor = [[UIColor grayColor]CGColor];
    numberTF.layer.borderWidth = 1.0f;
    numberTF.layer.masksToBounds = YES;
    self.numberTF = numberTF;
    
    //数量减按钮
    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cutBtn.frame = CGRectMake(numberTF.left - 30, addBtn.top, 25, 25);
    [cutBtn setImage:[UIImage imageNamed:@"buycar_ico_sub"] forState:UIControlStateNormal];
    [cutBtn setImage:[UIImage imageNamed:@"buycar_ico_sub"] forState:UIControlStateHighlighted];
    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cutBtn];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSInteger count = [self.numberTF.text integerValue];
    //这里需要修改
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.contentView animated:YES];
//    [RequestTool changeCartCount:@{@"count":[NSString stringWithFormat:@"%ld",(long)count],@"goodsCartId":self.model.goodscart_id} withSuccessBlock:^(NSDictionary *result) {
//        NSLog(@"购物车商品数量增result = %@",result);
//        if([result[@"code"] integerValue] == 1){
//            [hud hide:YES];
//
//            if (numberAddBlock) {
//                numberAddBlock(count);
//            }
//        }else if([result[@"code"] integerValue] == -2){
//            hud.detailsLabelText = @"登录失效";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }else if([result[@"code"] integerValue] == -1){
//            hud.detailsLabelText = @"未登录";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }else if([result[@"code"] integerValue] == 0){
//            hud.detailsLabelText = @"失败";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }else if([result[@"code"] integerValue] == 2){
//            hud.detailsLabelText = @"无返回数据";
//            hud.mode = MBProgressHUDModeText;
//            [hud hide:YES afterDelay:1.0];
//        }
//    } withFailBlock:^(NSString *msg) {
//        NSLog(@"购物车商品数量增msg = %@",msg);
//        hud.detailsLabelText = msg;
//        hud.mode = MBProgressHUDModeText;
//        [hud hide:YES afterDelay:1.0];
//    }];
}

@end
