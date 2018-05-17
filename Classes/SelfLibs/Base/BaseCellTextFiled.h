//
//  BaseCellTextFiled.h
//  Trade
//
//  Created by FeiFan on 2017/9/4.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCellTextFiled : UITableViewCell

@property (nonatomic, strong) UILabel* titleLabel; // 用titleLabel替换textLabel

@property (nonatomic, strong) UITextField* textField;

@end
