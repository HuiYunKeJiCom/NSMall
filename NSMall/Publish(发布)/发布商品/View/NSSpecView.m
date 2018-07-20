//
//  NSSpecView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSSpecView.h"

@interface NSSpecView()<UITextFieldDelegate>
@property(nonatomic,strong)UIView *bgView;/* 背景 */
@property(nonatomic,strong)UILabel *specLabel;/* 规格标题 */
@property(nonatomic,strong)UITextField *specTF;/* 规格 */
@property(nonatomic,strong)UIView *specLineV;/* 分割线 */
@property(nonatomic,strong)UILabel *priceLabel;/* 价格标题 */
@property(nonatomic,strong)UITextField *priceTF;/* 价格 */
@property(nonatomic,strong)UIView *priceLineV;/* 分割线 */
@property(nonatomic,strong)UILabel *inventoryLabel;/*  库存标题 */
@property(nonatomic,strong)UITextField *inventoryTF;/*  库存 */
@property(nonatomic,strong)UIButton *delButton;/*  删除按钮 */
@end

@implementation NSSpecView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
//        [self setUpData];
    }
    
    return self;
}

-(void)initViews{
    self.bgView = [[UIView alloc] init];
    self.bgView.x = 0;
    self.bgView.y = 10;
    self.bgView.size = CGSizeMake(kScreenWidth-30, GetScaleWidth(43)*3);
    self.bgView.backgroundColor = kWhiteColor;
    [self addSubview:self.bgView];
    
    self.specLabel = [[UILabel alloc] init];
    self.specLabel.text = NSLocalizedString(@"specifications", nil);
    self.specLabel.font = UISystemFontSize(14);
    self.specLabel.x = 29;
    self.specLabel.y = 14;
    [self.specLabel sizeToFit];
    [self.bgView addSubview:self.specLabel];
    
    self.specTF = [[UITextField alloc] initWithFrame:CGRectZero];
    self.specTF.frame = CGRectMake(CGRectGetMaxX(self.specLabel.frame), 5, kScreenWidth-30-CGRectGetMaxX(self.specLabel.frame), GetScaleWidth(30));
    self.specTF.delegate = self;
    self.specTF.tag = 10;
    self.specTF.font = [UIFont systemFontOfSize:14];
    self.specTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.specTF.placeholder = NSLocalizedString(@"size, size, color, etc", nil);
    self.specTF.textColor = [UIColor lightGrayColor];
    self.specTF.backgroundColor = kWhiteColor;
    UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, GetScaleWidth(30))];
    self.specTF.leftView = paddingView;
    self.specTF.leftViewMode = UITextFieldViewModeAlways;
    [self.bgView addSubview:self.specTF];
    
    self.specLineV = [[UIView alloc] init];
    self.specLineV.x = 0;
    self.specLineV.y = CGRectGetMaxY(self.specLabel.frame)+14;
    self.specLineV.size = CGSizeMake(kScreenWidth-30, 1);
    self.specLineV.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:self.specLineV];
    
    self.priceLabel = [[UILabel alloc] init];
    self.priceLabel.text = NSLocalizedString(@"price", nil);
    self.priceLabel.font = UISystemFontSize(14);
    self.priceLabel.x = 29;
    self.priceLabel.y = CGRectGetMaxY(self.specLineV.frame)+14;
    [self.priceLabel sizeToFit];
    [self.bgView addSubview:self.priceLabel];
    
    self.priceTF = [[UITextField alloc] initWithFrame:CGRectZero];
    self.priceTF.frame = CGRectMake(CGRectGetMaxX(self.priceLabel.frame), CGRectGetMaxY(self.specLineV.frame)+5, kScreenWidth-30-CGRectGetMaxX(self.priceLabel.frame), GetScaleWidth(30));
    self.priceTF.delegate = self;
    self.priceTF.tag = 100;
    self.priceTF.font = [UIFont systemFontOfSize:14];
    self.priceTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.priceTF.placeholder = NSLocalizedString(@"make a good price for the goods", nil);
    self.priceTF.textColor = [UIColor lightGrayColor];
    self.priceTF.backgroundColor = kWhiteColor;
    UIView *paddingView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, GetScaleWidth(30))];
    self.priceTF.leftView = paddingView2;
    self.priceTF.leftViewMode = UITextFieldViewModeAlways;
    [self.bgView addSubview:self.priceTF];
    
    self.priceLineV = [[UIView alloc] init];
    self.priceLineV.x = 0;
    self.priceLineV.y = CGRectGetMaxY(self.priceLabel.frame)+14;
    self.priceLineV.size = CGSizeMake(kScreenWidth-30, 1);
    self.priceLineV.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:self.priceLineV];
    
    self.inventoryLabel = [[UILabel alloc] init];
    self.inventoryLabel.text = NSLocalizedString(@"stock", nil);
    self.inventoryLabel.font = UISystemFontSize(14);
    self.inventoryLabel.x = 29;
    self.inventoryLabel.y = CGRectGetMaxY(self.priceLineV.frame)+14;
    [self.inventoryLabel sizeToFit];
    [self.bgView addSubview:self.inventoryLabel];
    
    self.inventoryTF = [[UITextField alloc] initWithFrame:CGRectZero];
    self.inventoryTF.frame = CGRectMake(CGRectGetMaxX(self.inventoryLabel.frame), CGRectGetMaxY(self.priceLineV.frame)+5, kScreenWidth-30-CGRectGetMaxX(self.priceLabel.frame), GetScaleWidth(30));
    self.inventoryTF.delegate = self;
    self.inventoryTF.tag = 1000;
    self.inventoryTF.font = [UIFont systemFontOfSize:14];
    self.inventoryTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.inventoryTF.placeholder = NSLocalizedString(@"setting up reasonable stock", nil);
    self.inventoryTF.textColor = [UIColor lightGrayColor];
    self.inventoryTF.backgroundColor = kWhiteColor;
    UIView *paddingView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, GetScaleWidth(30))];
    self.inventoryTF.leftView = paddingView3;
    self.inventoryTF.leftViewMode = UITextFieldViewModeAlways;
    [self.bgView addSubview:self.inventoryTF];
    
    self.delButton = [UIButton new];
    self.delButton.x = kScreenWidth-40;
    self.delButton.y = CGRectGetMaxY(self.specLineV.frame)+20;
    self.delButton.size = CGSizeMake(20, 20);
    [self.delButton setImage:kGetImage(@"goods_ico_add_del") forState:UIControlStateNormal];
    [self.delButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.delButton];
}

-(void)delete:(UIButton *)button{
    !_deleteClickBlock ? : _deleteClickBlock();
    [button.superview removeFromSuperview];
}



-(NSMutableDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionary];
    }
    return _dataDict;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    DLog(@"什么时候调用");
    if(textField.tag == 10){
        [self.dataDict setValue:textField.text forKey:@"spec_name"];
    }else if(textField.tag == 100){
        [self.dataDict setValue:textField.text forKey:@"price"];
    }else{
        [self.dataDict setValue:textField.text forKey:@"stock"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];// 使当前文本框失去第一响应者的特权，就会回收键盘了
    return YES;
}

@end
