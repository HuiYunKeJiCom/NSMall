//
//  ADAddressLabelTableViewCell.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/4/12.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADAddressLabelTableViewCell : BaseTableCell

@property (strong, nonatomic)UILabel  * leftLabel;
@property (nonatomic, strong) NSString          * leftStr;
@property (nonatomic ,weak) UIButton *btn;
@property (nonatomic, strong) NSString          * labelStr;
@end
