//
//  TDUserCertifyCellTxtInput.m
//  Trade
//
//  Created by FeiFan on 2017/8/31.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyCellTxtInput.h"

@implementation TDUserCertifyCellTxtInput

# pragma mark - life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initializeDatas];
        [self initializeViews];
    }
    return self;
}

- (void) initializeDatas {
    self.backgroundColor = KColorMainBackground;
    self.titleLabel.font = UIBoldFontSize(14);
    self.titleLabel.textColor = KColorTextPlaceHolder;
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    self.textField.font = UIBoldFontSize(14);
    self.textField.textAlignment = NSTextAlignmentLeft;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.textColor = KColorTextFFFFFF;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void) initializeViews {
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetScaleWidth(25));
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).multipliedBy(0.33);
        make.right.mas_equalTo(-40);
        make.top.bottom.mas_equalTo(0);
    }];
}




@end
