//
//  ADLImageField.m
//  Lock
//
//  Created by occ on 2017/5/25.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "NSLImageField.h"

@implementation NSLImageField

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.imgView];
        [self addSubview:self.lineView];
        [self addSubview:self.textField];
        
        WEAKSELF
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(weakSelf);
            make.right.mas_equalTo(weakSelf.mas_right);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(weakSelf);
            make.height.mas_equalTo(1);
        }];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakSelf.textField.mas_left).offset(GetScaleWidth(-15));
            make.left.mas_equalTo(weakSelf.mas_left).offset(GetScaleWidth(20));
            make.centerY.mas_equalTo(weakSelf);
            
        }];

    }
    
    return self;
}

#pragma mark - getter

- (NSString *)text {
    return self.textField.text;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imgView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = KBGCOLOR;
    }
    return _lineView;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.font = [UIFont systemFontOfSize:kFontNum12];
        _textField.textColor = KBGCOLOR;
    }
    return _textField;
}

- (void)placeholder:(NSString *)place color:(UIColor *)color {
    
    if (!color) {
        color = [UIColor blackColor];
    }
    if (!place) {
        place = @"";
    }
    if (place) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = color;
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:place attributes:dict];
        [self.textField setAttributedPlaceholder:attribute];
    }
}

@end
