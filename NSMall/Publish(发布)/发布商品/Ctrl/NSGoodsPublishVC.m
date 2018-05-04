//
//  NSGoodsPublishVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSGoodsPublishVC.h"
#import "ADOrderTopToolView.h"

@interface NSGoodsPublishVC ()
@property (strong , nonatomic)ADOrderTopToolView *topToolView;/* 顶部Nva */
@end

@implementation NSGoodsPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGCOLOR;
    [self setUpNavTopView];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _topToolView.hidden = NO;
    _topToolView.backgroundColor = k_UIColorFromRGB(0xffffff);
    [_topToolView setTopTitleWithNSString:KLocalizableStr(@"发布商品")];
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self.view addSubview:_topToolView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
