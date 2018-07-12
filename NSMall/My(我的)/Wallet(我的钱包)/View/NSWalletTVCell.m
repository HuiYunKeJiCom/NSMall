//
//  NSWalletTVCell.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSWalletTVCell.h"

@interface NSWalletTVCell()
@property (nonatomic, strong) UIView  *bgView;
@property(nonatomic,strong)UILabel *walletName;/* 钱包名称 */
@property(nonatomic,strong)UILabel *walletAddress;/* 钱包地址 */
//@property(nonatomic,strong)UIButton *defaultBtn;/* 默认按钮 */
@end

@implementation NSWalletTVCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self buildUI];
    }
    
    return self;
}

-(void)buildUI{
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.x = 0;
    self.bgView.y = 0;
    self.bgView.size = CGSizeMake(kScreenWidth, GetScaleWidth(65));
    [self addSubview:self.bgView];

    
    self.walletName = [[UILabel alloc]init];
    self.walletName.x = 19;
    self.walletName.y = 15;
    self.walletName.font = UISystemFontSize(14);
    self.walletName.textColor = kBlackColor;
    [self.bgView addSubview:self.walletName];
    
    self.walletAddress = [[UILabel alloc]init];
    self.walletAddress.font = UISystemFontSize(14);
    self.walletAddress.textColor = kBlackColor;
    [self.bgView addSubview:self.walletAddress];
    
//    self.defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.defaultBtn .titleLabel.font = UISystemFontSize(14);
//    [self.defaultBtn setTitle:@"默认" forState:UIControlStateNormal];
//    [self.defaultBtn  setTitleColor:kWhiteColor forState:UIControlStateNormal];
//    self.defaultBtn.backgroundColor = kWhiteColor;
//    self.defaultBtn.layer.cornerRadius = 5;//设置那个圆角的有多圆
//    self.defaultBtn.layer.masksToBounds = YES;//设为NO去试试
//    [self.defaultBtn  addTarget:self action:@selector(defaultButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgView addSubview:self.defaultBtn];
//    self.defaultBtn.x = kScreenWidth-19-66;
//    self.defaultBtn.y = 15;
//    self.defaultBtn.size = CGSizeMake(66, 20);
//    self.defaultBtn.backgroundColor = [UIColor greenColor];
}

-(void)setWalletModel:(WalletItemModel *)walletModel{
    _walletModel = walletModel;

    self.walletName.text = [NSString stringWithFormat:@"钱包名称:%@",walletModel.wallet_name];
    [self.walletName sizeToFit];

    self.walletAddress.x = 19;
    self.walletAddress.y = CGRectGetMaxY(self.walletName.frame)+13;
    self.walletAddress.text = [NSString stringWithFormat:@"钱包地址:%@",walletModel.wallet_address];
    [self.walletAddress sizeToFit];
    
//    if(walletModel.is_sell_default == 1){
//        [self.defaultBtn setTitle:@"默认收款" forState:UIControlStateNormal];
//        self.defaultBtn.userInteractionEnabled = NO;
//        [self.defaultBtn.layer setMasksToBounds:NO];
//        [self.defaultBtn.layer setBorderWidth:0];
//        [self.defaultBtn setTitleColor:KMainColor forState:UIControlStateNormal];
//    }else{
//        [self.defaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
//        self.defaultBtn.userInteractionEnabled = YES;
//        [self.defaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.defaultBtn.layer setBorderColor:[UIColor blackColor].CGColor];
//        [self.defaultBtn.layer setBorderWidth:1];
//        [self.defaultBtn.layer setMasksToBounds:YES];
//        self.defaultBtn.layer.cornerRadius = 3.0;
//    }
}

//#pragma mark - 默认 点击
//- (void)defaultButtonClick {
//    NSLog(@"默认 点击");
//    !_defaultClickBlock ? : _defaultClickBlock();
//}

@end
