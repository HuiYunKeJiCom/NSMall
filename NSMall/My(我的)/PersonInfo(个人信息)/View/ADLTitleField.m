//
//  ADLTitleField.m
//  Lock
//
//  Created by occ on 2017/5/25.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ADLTitleField.h"

@implementation ADLTitleField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
       
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.textField];
        
        WEAKSELF
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(weakSelf);
            make.right.mas_equalTo(weakSelf.mas_right);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(weakSelf);
            make.left.mas_equalTo(weakSelf.mas_left).offset(GetScaleWidth(15));
            make.right.mas_equalTo(weakSelf.textField.mas_left).offset(GetScaleWidth(-2));
        }];
        
    }
    
    return self;
}

#pragma mark - getter

- (NSString *)text {
    return self.textField.text;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero FontSize:kFontNum12 TextColor:KColorTextDA2F2D];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    }
    return _textField;
}


@end
