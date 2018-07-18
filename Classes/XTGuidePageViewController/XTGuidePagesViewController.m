//
//  XTGuidePagesViewController.m
//  XTGuidePagesView
//
//  Created by zjwang on 16/5/30.
//  Copyright © 2016年 夏天. All rights reserved.
//

#import "XTGuidePagesViewController.h"

//#define s_w [UIScreen mainScreen].bounds.size.width
//#define s_h [UIScreen mainScreen].bounds.size.height
#define VERSION_INFO_CURRENT @"currentversion"
@interface XTGuidePagesViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;
//@property(nonatomic,strong)UIImageView *IV;/* 引导图 */
@end

@implementation XTGuidePagesViewController

- (void)guidePageControllerWithImages:(NSArray *)images
{
    UIScrollView *gui = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    gui.delegate = self;
    gui.pagingEnabled = YES;
    // 隐藏滑动条
    gui.showsHorizontalScrollIndicator = NO;
    gui.showsVerticalScrollIndicator = NO;
    // 取消反弹
    gui.bounces = NO;
    for (NSInteger i = 0; i < images.count; i ++) {
        [gui addSubview:({
            
            self.btnEnter = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, kScreenHeight)];
            self.btnEnter.image = [UIImage imageNamed:images[i]];
            self.btnEnter.contentMode = UIViewContentModeScaleAspectFit;
            self.btnEnter;
            
        })];
    
    }
    gui.contentSize = CGSizeMake(kScreenWidth * images.count, 0);
    [self.view addSubview:gui];
    
    // pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2, 30)];
    self.pageControl.center = CGPointMake(kScreenWidth / 2, kScreenHeight - 95);
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = images.count;
}
- (void)showWord
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(showWord)]) {
        [self.delegate showWord];
    }
}
+ (BOOL)isShow
{
    // 读取版本信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [user objectForKey:VERSION_INFO_CURRENT];
    NSString *currentVersion =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (localVersion == nil || ![currentVersion isEqualToString:localVersion]) {
        [XTGuidePagesViewController saveCurrentVersion];
        return YES;
    }else
    {
        return NO;
    }
}
// 保存版本信息
+ (void)saveCurrentVersion
{
    NSString *version =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:version forKey:VERSION_INFO_CURRENT];
    [user synchronize];
}
#pragma mark - ScrollerView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
//    DLog(@"currentPage = %lu",self.pageControl.currentPage);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    self.pageControl.currentPage = scrollView.contentOffset.x / kScreenWidth;
//    DLog(@"currentPage = %lu",self.pageControl.currentPage);
    if(self.pageControl.currentPage == 3){
        [self showWord];
    }
}

@end


