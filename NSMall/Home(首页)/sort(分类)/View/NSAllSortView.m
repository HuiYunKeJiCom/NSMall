//
//  NSAllSortView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSAllSortView.h"

@interface NSAllSortView()
@property(nonatomic)float height;/* 高度 */
@end

@implementation NSAllSortView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = KBGCOLOR;
//        [self setUpUI];
        self.height = 0;
    }
    return self;
}

//- (void)setUpUI
//{
//}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.size = CGSizeMake(self.size.width, self.height+13);
}

-(float)getHeight{
    return self.height;
}

-(void)setDataArr:(NSArray<CategoryModel *> *)dataArr{
    _dataArr = dataArr;
    
    float buttonW = 76*1.25;
    float buttonH = 25*1.25;
    
    for(int i=0;i<dataArr.count;i++){
        CategoryModel *model = dataArr[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = UISystemFontSize(14);
        [button setTitleColor:kBlackColor forState:UIControlStateNormal];
        button.tag = i + 20;
        [button setTitle:model.name forState:UIControlStateNormal];
        button.x = 17+(buttonW+28)*(i%2);
        button.y = 13+(buttonH+11)*(i/2);
        button.size = CGSizeMake(buttonW, buttonH);
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = kWhiteColor;
        [self addSubview:button];
        self.height = button.y+buttonH;
    }
}

-(void)btnClick:(UIButton *)btn{
    if (_tbDelegate && [_tbDelegate respondsToSelector:@selector(didClickByButton:andNSArray:)]) {
        [_tbDelegate didClickByButton:btn andNSArray:self.dataArr];
    }
}

@end
