//
//  NSOrderListVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/18.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSOrderListVC.h"
#import "ADOrderTopToolView.h"
#import "NSOrderHeader.h"

//买入的订单
#import "NSAllBuyVC.h"
#import "NSWaitPayBuyVC.h"
#import "NSWaitReceiveBuyVC.h"
#import "NSCompletedBuyVC.h"
#import "NSAbolishBuyVC.h"

//卖出的订单
#import "NSAllSaleVC.h"
#import "NSWaitPaySaleVC.h"
#import "NSWaitDeliverSaleVC.h"
#import "NSWaitReceiveSaleVC.h"
#import "NSRejectedSaleVC.h"
#import "NSAbolishSaleVC.h"

@interface NSOrderListVC ()<UIScrollViewDelegate>{
    NSOrderHeader *_headView1;
    NSOrderHeader *_headView2;
}
/* 顶部Nva */
@property (strong , nonatomic)ADOrderTopToolView *topToolView;
@property(nonatomic,strong)UIScrollView *scrollView1;/* 买入的订单SV */
@property(nonatomic,strong)UIView *buyView;/* 买入View */
@property(nonatomic,strong)UIScrollView *scrollView2;/* 卖出的订单SV */
@property(nonatomic,strong)UIView *saleView;/* 卖出View */
@property(nonatomic,strong)UIScrollView *SV;/* 总的 */
@end

@implementation NSOrderListVC

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (self.index) {
        
        [self changeScrollview:self.index];
        
        //UIScrollViewDecelerationRateFast;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setUpNavTopView];
}

-(void)createUI{
    self.view.backgroundColor=kBACKGROUNDCOLOR;
    //消除强引用
    __weak typeof(self) weakSelf = self;
    
    self.SV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64,kScreenWidth,kScreenHeight-64)];
    self.SV.backgroundColor = kBACKGROUNDCOLOR;
    self.SV.contentSize = CGSizeMake(self.SV.bounds.size.width*2, self.SV.bounds.size.height);
    self.SV.pagingEnabled = YES;
    self.SV.delegate = self;
    self.SV.directionalLockEnabled = YES;
    self.SV.tag = 1000;
    [self.view addSubview:self.SV];
    
    self.buyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.SV.bounds.size.height)];
    self.buyView.backgroundColor = [UIColor clearColor];
    [self.SV addSubview:self.buyView];
    
    _headView1 = [[NSOrderHeader alloc]initWithFrame:CGRectMake(0, 1, self.buyView.bounds.size.width, 40)];
    _headView1.items = @[@"全部",@"待支付",@"待收货",@"已完成",@"已取消"];
    _headView1.itemClickAtIndex = ^(NSInteger index){
        [weakSelf adjustScrollView:weakSelf.scrollView1 andIndex:index];
    };
    [self.buyView addSubview:_headView1];
    
    
    _scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView1.frame),kScreenWidth,kScreenHeight-64-40)];
    _scrollView1.backgroundColor = kBACKGROUNDCOLOR;
    _scrollView1.contentSize = CGSizeMake(_scrollView1.bounds.size.width*5, _scrollView1.bounds.size.height);
    _scrollView1.pagingEnabled = YES;
    _scrollView1.delegate = self;
    _scrollView1.directionalLockEnabled = YES;
    _scrollView1.tag = 100;
    [self.buyView addSubview:_scrollView1];
    //加载子控制器
    [self addViewControllsToScrollView1];
    
    self.saleView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, self.SV.bounds.size.height)];
    self.saleView.backgroundColor = [UIColor clearColor];
    [self.SV addSubview:self.saleView];
    
    _headView2 = [[NSOrderHeader alloc]initWithFrame:CGRectMake(0, 1, self.saleView.bounds.size.width, 40)];
    _headView2.items = @[@"全部",@"待支付",@"待发货",@"待收货",@"已取消"];//@"退货中",
    _headView2.itemClickAtIndex = ^(NSInteger index){
        [weakSelf adjustScrollView:weakSelf.scrollView2 andIndex:index];
    };
    [self.saleView addSubview:_headView2];
    
    _scrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_headView2.frame),kScreenWidth,kScreenHeight-64-40)];
    _scrollView2.backgroundColor = kBACKGROUNDCOLOR;
    _scrollView2.contentSize = CGSizeMake(_scrollView2.bounds.size.width*5, _scrollView2.bounds.size.height);
    _scrollView2.pagingEnabled = YES;
    _scrollView2.delegate = self;
    _scrollView2.directionalLockEnabled = YES;
    _scrollView2.tag = 10;
    [self.saleView addSubview:_scrollView2];
    //加载子控制器
    [self addViewControllsToScrollView2];
    
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    _topToolView.hidden = NO;
    _topToolView.backgroundColor = [UIColor whiteColor];
//    [_topToolView setTopTitleWithNSString:KLocalizableStr(@"我的订单")];
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    //    _topToolView.rightItemClickBlock = ^{
    //        NSLog(@"点击设置");
    //    };
    
    [self.view addSubview:_topToolView];
    
    //先生成存放标题的数据
    NSArray *array = [NSArray arrayWithObjects:@"我买到的",@"我卖出的", nil];
    //初始化UISegmentedControl
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
    //设置frame
    segment.frame = CGRectMake(kScreenWidth*0.3, (NavBarHeight-25)*0.5+StatusBarHeight, kScreenWidth*0.4, 25);
    //开始时默认选中下标(第一个下标默认是0)
    segment.selectedSegmentIndex = 0;
    //控件渲染色(也就是外观字体颜色)
    segment.tintColor = KMainColor;
    //添加到视图
    [self.topToolView addSubview:segment];
    
    //添加事件
    [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    
}

//点击不同分段就会有不同的事件进行相应
-(void)change:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"1");
    }else if (sender.selectedSegmentIndex == 1){
        NSLog(@"2");
    }
}

#pragma mark-将4个controller添加到applecontroller上
-(void)addViewControllsToScrollView1
{
    NSAllBuyVC * allvc = [[NSAllBuyVC alloc]init];
    allvc.view.frame = CGRectMake(0, 0, self.scrollView1.bounds.size.width, self.scrollView1.bounds.size.height);
    [self.scrollView1 addSubview:allvc.view];
    [self addChildViewController:allvc];
    
    NSWaitPayBuyVC * waitPayvc = [[NSWaitPayBuyVC alloc]init];
    waitPayvc.view.frame = CGRectMake(0, 0, self.scrollView1.bounds.size.width, self.scrollView1.bounds.size.height);
    [self.scrollView1 addSubview:waitPayvc.view];
    [self addChildViewController:waitPayvc];
    
    NSWaitReceiveBuyVC * waitReceivevc = [[NSWaitReceiveBuyVC alloc]init];
    waitReceivevc.view.frame = CGRectMake(0, 0, self.scrollView1.bounds.size.width, self.scrollView1.bounds.size.height);
    [self.scrollView1 addSubview:waitReceivevc.view];
    [self addChildViewController:waitReceivevc];
    
    NSCompletedBuyVC * completedBuyvc = [[NSCompletedBuyVC alloc]init];
    completedBuyvc.view.frame = CGRectMake(0, 0, self.scrollView1.bounds.size.width, self.scrollView1.bounds.size.height);
    [self.scrollView1 addSubview:completedBuyvc.view];
    [self addChildViewController:completedBuyvc];
    
    NSAbolishBuyVC * abolishBuyvc = [[NSAbolishBuyVC alloc]init];
    abolishBuyvc.view.frame = CGRectMake(0, 0, self.scrollView1.bounds.size.width, self.scrollView1.bounds.size.height);
    [self.scrollView1 addSubview:abolishBuyvc.view];
    [self addChildViewController:abolishBuyvc];
}

-(void)addViewControllsToScrollView2
{
    NSAllSaleVC * allvc = [[NSAllSaleVC alloc]init];
    allvc.view.frame = CGRectMake(0, 0, self.scrollView2.bounds.size.width, self.scrollView2.bounds.size.height);
    [self.scrollView2 addSubview:allvc.view];
    [self addChildViewController:allvc];
    
    NSWaitPaySaleVC * waitPayvc = [[NSWaitPaySaleVC alloc]init];
    waitPayvc.view.frame = CGRectMake(0, 0, self.scrollView2.bounds.size.width, self.scrollView2.bounds.size.height);
    [self.scrollView2 addSubview:waitPayvc.view];
    [self addChildViewController:waitPayvc];
    
    NSWaitDeliverSaleVC * waitDelivervc = [[NSWaitDeliverSaleVC alloc]init];
    waitDelivervc.view.frame = CGRectMake(0, 0, self.scrollView2.bounds.size.width, self.scrollView2.bounds.size.height);
    [self.scrollView2 addSubview:waitDelivervc.view];
    [self addChildViewController:waitDelivervc];
    
    NSWaitReceiveSaleVC * waitReceivevc = [[NSWaitReceiveSaleVC alloc]init];
    waitReceivevc.view.frame = CGRectMake(0, 0, self.scrollView2.bounds.size.width, self.scrollView2.bounds.size.height);
    [self.scrollView2 addSubview:waitReceivevc.view];
    [self addChildViewController:waitReceivevc];
    
//    NSRejectedSaleVC * rejectedBuyvc = [[NSRejectedSaleVC alloc]init];
//    rejectedBuyvc.view.frame = CGRectMake(0, 0, self.scrollView2.bounds.size.width, self.scrollView2.bounds.size.height);
//    [self.scrollView2 addSubview:rejectedBuyvc.view];
//    [self addChildViewController:rejectedBuyvc];
    
    NSAbolishSaleVC * abolishBuyvc = [[NSAbolishSaleVC alloc]init];
    abolishBuyvc.view.frame = CGRectMake(0, 0, self.scrollView2.bounds.size.width, self.scrollView2.bounds.size.height);
    [self.scrollView2 addSubview:abolishBuyvc.view];
    [self addChildViewController:abolishBuyvc];
    
}


#pragma mark-通过点击button来改变scrollview的偏移量
-(void)adjustScrollView:(UIScrollView *)scrollView andIndex:(NSInteger)index
{
    [UIView animateWithDuration:0.2 animations:^{
        scrollView.contentOffset = CGPointMake(index*scrollView.bounds.size.width, 0);
    }];
}

#pragma mark-选中scorllview来调整headvie的选中
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/scrollView.bounds.size.width;
    if(scrollView.tag == 100){
        [_headView1 setSelectAtIndex:index];
    }else if (scrollView.tag == 10){
        [_headView2 setSelectAtIndex:index];
    }
    
}


#pragma mark 测试用
-(void)changeScrollview:(NSInteger)index{
    
    [UIView animateWithDuration:0 animations:^{
        _scrollView1.contentOffset = CGPointMake(index*_scrollView1.bounds.size.width, 0);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
