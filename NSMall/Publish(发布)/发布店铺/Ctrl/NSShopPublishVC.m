//
//  NSShopPublishVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSShopPublishVC.h"
#import "ADOrderTopToolView.h"

@interface NSShopPublishVC ()
@end

@implementation NSShopPublishVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGCOLOR;
    [self setUpNavTopView];
    [self setUpBottomBtn];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    topToolView.hidden = NO;
    topToolView.backgroundColor = k_UIColorFromRGB(0xffffff);
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"发布店铺")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };

    [self.view addSubview:topToolView];
    
}

-(void)setUpBottomBtn{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
