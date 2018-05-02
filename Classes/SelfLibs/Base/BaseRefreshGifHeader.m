//
//  BaseRefreshGifHeader.m
//  EasyLife
//
//  Created by occ on 2016/12/5.
//  Copyright © 2016年 CCJ. All rights reserved.
//

#import "BaseRefreshGifHeader.h"

@implementation BaseRefreshGifHeader

- (void)prepare
{
    [super prepare];
    
    self.size = CGSizeMake(kScreenWidth, 190);
    //设置 giftView坐标
    //时间 更新状态
    self.lastUpdatedTimeLabel.hidden = YES;
//    self.stateLabel.hidden = YES;
    
    
    [self setTitle:@"Pull down to refresh" forState:MJRefreshStateIdle];
    
    [self setTitle:@"Release to refresh" forState:MJRefreshStatePulling];
    
    [self setTitle:@"Loading ..." forState:MJRefreshStateRefreshing];

//    self.ignoredScrollViewContentInsetTop = -120;
    
    // 设置普通状态的动画图片
    
    NSArray *idleImages = @[[UIImage imageNamed:@"icon_homeRefresh"]];
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSArray *refreshingImages = @[[UIImage imageNamed:@"icon_homeRefresh"]];
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    
    // 初始化文字
    [self setTitle:MJRefreshHeaderIdleText forState:MJRefreshStateIdle];
    [self setTitle:MJRefreshHeaderPullingText forState:MJRefreshStatePulling];
    [self setTitle:MJRefreshHeaderRefreshingText forState:MJRefreshStateRefreshing];
    

    

}

@end
