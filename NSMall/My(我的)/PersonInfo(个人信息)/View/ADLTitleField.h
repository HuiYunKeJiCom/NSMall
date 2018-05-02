//
//  ADLTitleField.h
//  Lock
//
//  Created by occ on 2017/5/25.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLTitleField : UIView

@property (nonatomic, strong) UILabel        *titleLabel;

@property (nonatomic, strong) UITextField    *textField;

@property (nonatomic, readonly, copy) NSString         *text;

@end
