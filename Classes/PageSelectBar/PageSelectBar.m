//
//  PageSelectBar.m
//  ScrollView_Nest
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 1911. All rights reserved.
//

#import "PageSelectBar.h"

@interface PageSelectBar()

@property (nonatomic,strong)NSArray *options;//选项
@property (nonatomic,strong)NSArray *buttons;//按钮数组
@property (nonatomic,strong)UIImageView *bottomBar;//底部的滑动条
@property (nonatomic,copy)void (^callBackBlock)(NSString *,NSInteger);//回调函数

@end

@implementation PageSelectBar

- (instancetype)initWithFrame:(CGRect)frame options:(NSArray<NSString *> *)options selectBlock:(void (^)(NSString *, NSInteger))callBackBlock{
    self = [super initWithFrame:frame];
    _options = options;
    NSMutableArray *buttonsArray = [NSMutableArray array];
    for (int i = 0; i < _options.count; i++) {
        UIButton *optionBtn = [self buildButtonAtIndex:i];
        [self addSubview:optionBtn];
        [buttonsArray addObject:optionBtn];
    }
    _buttons = buttonsArray.copy;
    _bottomBar = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 3, self.frame.size.width/4, 2)];
    _bottomBar.backgroundColor = [UIColor redColor];
    [self addSubview:_bottomBar];
    _callBackBlock = [callBackBlock copy];
    return self;
}

#pragma mark - --  Option Button Build Function
- (UIButton *)buildButtonAtIndex:(NSInteger)index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((self.frame.size.width/(_options.count)) * index, 0, self.frame.size.width/(_options.count), self.frame.size.height);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:kFontNum15];
    [button setTitle:((NSString *)(_options[index])) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(optionBtnWasClicked:) forControlEvents:UIControlEventTouchDown];
    button.tag = index;
    return button;
}

#pragma mark - -- 底端红条移动到某个位置
- (void)bottomBarMoveToIndex:(NSInteger)index{
    [UIView animateWithDuration:0.2 animations:^{
        _bottomBar.frame = CGRectMake((self.frame.size.width/(_options.count)) * index, self.frame.size.height - 3, self.frame.size.width/4, 2);
    }];
}

#pragma mark - -- Option Button Click Function
- (void)optionBtnWasClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSInteger index = btn.tag;
    _selectIndex = index;
    [self bottomBarMoveToIndex:index];
    _callBackBlock(_options[index],index);
}

#pragma mark - -- 代码调用选中某个按钮
- (void)setSelected:(NSInteger)index withAction:(BOOL)withAction{
    if (withAction) {
        UIButton *button = _buttons[index];
        [self optionBtnWasClicked:button];
    }else{
        _selectIndex = index;
        [self bottomBarMoveToIndex:index];
    }
}

@end
