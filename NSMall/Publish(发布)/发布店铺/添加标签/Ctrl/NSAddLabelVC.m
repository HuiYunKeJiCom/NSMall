//
//  NSAddLabelVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/7.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSAddLabelVC.h"
#import "CLDispalyTagView.h"
#import "CLRecentTagView.h"
#import "CLTools.h"
#import "ADOrderTopToolView.h"

@interface NSAddLabelVC (){
    CLDispalyTagView *_displayTagView;
    CLRecentTagView *_recentTagView;
}


@end

@implementation NSAddLabelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xd2d2d2);
    [self showUI];
    [self setUpNavTopView];
}
    
#pragma mark - 导航栏处理
- (void)setUpNavTopView
    {
        ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        topToolView.hidden = NO;
        topToolView.backgroundColor = k_UIColorFromRGB(0xffffff);
        [topToolView setTopTitleWithNSString:KLocalizableStr(@"添加标签")];
        WEAKSELF
        topToolView.leftItemClickBlock = ^{
            NSLog(@"点击了返回");
        [weakSelf saveItemClick];
        };
        
        [self.view addSubview:topToolView];
        
    }

    
- (void)showUI {
    [CLTools sharedTools].cornerRadius = self.cornerRadius;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _displayTagView = [[CLDispalyTagView alloc] initWithOriginalY:65 Font:kCLTagFont];
    [self.view addSubview:_displayTagView];
    
    _recentTagView = [[CLRecentTagView alloc] init];
    [self.view addSubview:_recentTagView];
    
    _recentTagView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_displayTagView]-1-[_recentTagView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_displayTagView,_recentTagView)]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_recentTagView]-0-|" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:NSDictionaryOfVariableBindings(_recentTagView)]];
    
    if (self.isHighlightTag) {
        _recentTagView.displayTags = self.tagsDisplayArray;
    }
    
    _displayTagView.maxRows = self.maxRows;
    _displayTagView.maxStringAmount = self.maxStringAmount;
    _displayTagView.normalTextColor = self.normalTextColor;
    _displayTagView.textFieldBorderColor = self.textFieldBorderColor;
    
    _recentTagView.tagsModel = self.tagsModelArray;
    _displayTagView.labels = self.tagsDisplayArray;

}
    
    // 点击保存，获取输入的标签
- (void)saveItemClick{
    //    NSLog(@"%@", _displayTagView.tags);
    if ([self.tagsDelegate respondsToSelector:@selector(tagViewController:tags:)]) {
        [self.tagsDelegate tagViewController:self tags:_displayTagView.tags];
    }
}
@end
