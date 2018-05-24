//
//  ADCartTableHeaderView.m
//  AdelMall
//
//  Created by 张锐凌 on 2018/4/11.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import "ADCartTableHeaderView.h"
#import "LZConfigFile.h"


@interface ADCartTableHeaderView()
@property (strong,nonatomic)UILabel *titleLabel;
@end

@implementation ADCartTableHeaderView
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI {
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(20, 0, LZSCREEN_WIDTH - 100, 30);
    label.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:label];
    self.titleLabel = label;
}

- (void)setTitleString:(NSString *)titleString {

    self.titleLabel.text = titleString;
    _titleString = titleString;
}

@end
