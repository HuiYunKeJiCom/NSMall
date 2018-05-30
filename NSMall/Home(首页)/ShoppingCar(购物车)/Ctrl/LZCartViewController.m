//
//  LZCartViewController.m
//  LZCartViewController
//
//  Created by apple on 2017/6/8.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//  购物车

#import "LZCartViewController.h"
#import "LZConfigFile.h"
#import "LZCartTableViewCell.h"
#import "LZShopModel.h"
#import "LZGoodsModel.h"
#import "LZTableHeaderView.h"
#import "ADOrderTopToolView.h"
//#import "ADPlaceOrderViewController.h"
//#import "ADHomePageViewController.h"//首页
#import "DCTabBarController.h"
#import "CartAPI.h"

#import "NSFirmOrderVC.h"//确认订单

@interface LZCartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isHiddenNavigationBarWhenDisappear;//记录当页面消失时是否需要隐藏系统导航
    BOOL _isHasTabBarController;//是否含有tabbar
    BOOL _isHasNavitationController;//是否含有导航
}
/* 顶部Nva */
@property (strong , nonatomic)ADOrderTopToolView *topToolView;
@property (strong,nonatomic)NSMutableArray<LZShopModel *> *dataArray;
@property (strong,nonatomic)NSMutableArray *selectedArray;
@property (strong,nonatomic)UITableView *myTableView;
@property (strong,nonatomic)UIButton *allSellectedButton;
@property (strong,nonatomic)UILabel *totlePriceLabel;
@end

@implementation LZCartViewController

#pragma mark - viewController life cicle
- (void)viewWillAppear:(BOOL)animated {
    
    if (_isHasNavitationController == YES) {
        if (self.navigationController.navigationBarHidden == YES) {
            _isHiddenNavigationBarWhenDisappear = NO;
        } else {
            self.navigationController.navigationBarHidden = YES;
            _isHiddenNavigationBarWhenDisappear = YES;
        }
    }
    
    
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
    if (self.selectedArray.count > 0) {
        for (LZGoodsModel *model in self.selectedArray) {
            model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
        }
        [self.selectedArray removeAllObjects];
    }
    
    //初始化显示状态
    _allSellectedButton.selected = NO;
    _totlePriceLabel.attributedText = [self LZSetString:@"N0.00/¥0.00"];
    
    [self loadData];
}

-(void)creatData {
    //这里已修改
    [CartAPI getCartList:nil success:^(NSCartModel *cartModel) {
        DLog(@"获取购物车列表成功");
        _dataArray = [NSMutableArray arrayWithArray:cartModel.result];
//        LZShopModel *shopModel = _dataArray[0];
//        for (LZGoodsModel *model in shopModel.productList) {
//        }
        [self.myTableView reloadData];
        [self changeView];
    } failure:^(NSError *error) {
        DLog(@"获取购物车列表失败");
    }];
}


- (void)loadData {
    [self creatData];
//    [self changeView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = KBGCOLOR;
    _isHasTabBarController = self.tabBarController?YES:NO;
    _isHasNavitationController = self.navigationController?YES:NO;
    
//#warning 模仿请求数据,延迟2s加载数据,实际使用时请移除更换
//    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    
    [self setUpNavTopView];
//    [self setupCustomNavigationBar];
    if (self.dataArray.count > 0) {
        
        [self setupCartView];
    } else {
        [self setupCartEmptyView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_isHiddenNavigationBarWhenDisappear == YES) {
        self.navigationController.navigationBarHidden = NO;
    }
}

/**
 *  @author LQQ, 16-02-18 11:02:16
 *
 *  计算已选中商品金额
 */
-(void)countPrice {
    double totlePrice = 0.0;
    double totleScore = 0.0;
    for (LZGoodsModel *model in self.selectedArray) {
        
        double price = model.price;
        double score = model.score;
        
        totlePrice += price * model.buy_number;
        totleScore += score * model.buy_number;
    }
    NSString *string = [NSString stringWithFormat:@"N%.2f/¥%.2f",totlePrice,totleScore];
    self.totlePriceLabel.attributedText = [self LZSetString:string];
}

#pragma mark - 初始化数组
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}

#pragma mark - 布局页面视图

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    _topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    _topToolView.hidden = NO;
    _topToolView.backgroundColor = [UIColor whiteColor];
    [_topToolView setTopTitleWithNSString:KLocalizableStr(@"购物车")];
    WEAKSELF
    _topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:_topToolView];
    
}

#pragma mark -- 自定义底部视图 
- (void)setupCustomBottomView {
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.tag = TAG_CartEmptyView + 1;
    [self.view addSubview:backgroundView];
    
    //当有tabBarController时,在tabBar的上面
    if (_isHasTabBarController == YES) {
        backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  2*LZTabBarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
    } else {
        backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  LZTabBarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, LZSCREEN_WIDTH, 1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:14];
    selectAll.frame = CGRectMake(-10, 5, 80, LZTabBarHeight - 10);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:lz_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:lz_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = KMainColor;
    btn.frame = CGRectMake(LZSCREEN_WIDTH - 67-19, 10, 67, 28);
    [btn setTitle:@"去结算" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = KBGCOLOR;
    [backgroundView addSubview:label];
    
    label.attributedText = [self LZSetString:@"N0.00/¥0.00"];
    CGFloat maxWidth = LZSCREEN_WIDTH - selectAll.bounds.size.width - btn.bounds.size.width - 30;
//    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, LZTabBarHeight)];
    label.frame = CGRectMake(selectAll.bounds.size.width, 0, maxWidth - 10, LZTabBarHeight);
    self.totlePriceLabel = label;
}

- (NSMutableAttributedString*)LZSetString:(NSString*)string {
    
    NSString *text = [NSString stringWithFormat:@"合计:%@",string];
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"合计:"];
    NSArray *strArr = [text componentsSeparatedByString:@"/¥"];
    NSRange rang2 = [text rangeOfString:strArr[0]];
    [LZString addAttribute:NSForegroundColorAttributeName value:kRedColor range:rang2];
    
    [LZString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rang];
    return LZString;
}

#pragma mark -- 购物车为空时的默认视图
- (void)changeView {
    if (self.dataArray.count > 0) {
//        NSLog(@"不空还是空");
        UIView *view = [self.view viewWithTag:TAG_CartEmptyView];
        if (view != nil) {
            [view removeFromSuperview];
        }
        
        [self setupCartView];
    } else {
//        NSLog(@"空还是不空");
        UIView *bottomView = [self.view viewWithTag:TAG_CartEmptyView + 1];
        [bottomView removeFromSuperview];
        
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        [self setupCartEmptyView];
    }
}

- (void)setupCartEmptyView {
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, LZNaigationBarHeight, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight)];
    backgroundView.tag = TAG_CartEmptyView;
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:lz_CartEmptyString]];
    img.center = CGPointMake(LZSCREEN_WIDTH/2.0, LZSCREEN_HEIGHT/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(LZSCREEN_WIDTH/2.0, 130);
    warnLabel.bounds = CGRectMake(0, 0, LZSCREEN_WIDTH, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车空空如也～";
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = LZColorFromHex(0x706F6F);
    [backgroundView addSubview:warnLabel];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.center = CGPointMake(LZSCREEN_WIDTH/2.0, 180);
    btn.bounds = CGRectMake(0, 0, LZSCREEN_WIDTH*0.3, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:kFontNum14];
    //        _toLoginBtn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"去首页逛逛" forState:UIControlStateNormal];
    btn.backgroundColor = KMainColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToHomeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [backgroundView addSubview:btn];
}

-(void)goToHomeBtnClick:(UIButton *)btn{
    NSLog(@"跳转回主页");
    //这里需要修改
//    DCTabBarController *vc = [[DCTabBarController alloc]init];
//    [vc goToSelectedViewControllerWith:0];
//    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark -- 购物车有商品时的视图
- (void)setupCartView {
    //创建底部视图
    [self setupCustomBottomView];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    table.delegate = self;
    table.dataSource = self;
    
    table.rowHeight = lz_CartRowHeight;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = KBGCOLOR;
    [self.view addSubview:table];
    self.myTableView = table;
    
    if (_isHasTabBarController) {
        table.frame = CGRectMake(0, LZNaigationBarHeight, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - 2*LZTabBarHeight);
    } else {
        table.frame = CGRectMake(0, LZNaigationBarHeight, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - LZTabBarHeight);
    }
    
    [table registerClass:[LZTableHeaderView class] forHeaderFooterViewReuseIdentifier:@"LZHeaderView"];
}
#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    LZShopModel *model = [self.dataArray objectAtIndex:section];
    return model.productList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LZCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
    if (cell == nil) {
        cell = [[LZCartTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LZCartReusableCell"];
    }
    
    LZShopModel *shopModel = self.dataArray[indexPath.section];
    LZGoodsModel *model = [shopModel.productList objectAtIndex:indexPath.row];
    cell.model = model;
    
    __block typeof(cell)wsCell = cell;
    
    [cell numberAddWithBlock:^(NSInteger number) {
        wsCell.lzNumber = number;
        model.buy_number = number;
        
        //这里需要修改
        [shopModel.productList replaceObjectAtIndex:indexPath.row withObject:model];
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell numberCutWithBlock:^(NSInteger number) {
        
        wsCell.lzNumber = number;
        model.buy_number = number;
        //这里需要修改
        [shopModel.productList replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell cellSelectedWithBlock:^(BOOL select) {
        
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        [self verityAllSelectState];
        [self verityGroupSelectState:indexPath.section];
        
        [self countPrice];
    }];
    
    [cell reloadDataWithModel:model];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LZTableHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"LZHeaderView"];
    LZShopModel *model = [self.dataArray objectAtIndex:section];
//    NSLog(@">>>>>>%d", model.select);
    view.title = model.user_name;
    view.imagePath = model.user_avatar;
    view.select = model.select;
    view.lzClickBlock = ^(BOOL select) {
        model.select = select;
        if (select) {

            for (LZGoodsModel *good in model.productList) {
                good.select = YES;
                if (![self.selectedArray containsObject:good]) {
                    
                    [self.selectedArray addObject:good];
                }
            }
            
        } else {
            for (LZGoodsModel *good in model.productList) {
                good.select = NO;
                if ([self.selectedArray containsObject:good]) {
                    
                    [self.selectedArray removeObject:good];
                }
            }
        }
        
        [self verityAllSelectState];

        [tableView reloadData];
        [self countPrice];
    };
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return LZTableViewHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
        //这里需要修改
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            LZShopModel *shop = [self.dataArray objectAtIndex:indexPath.section];
            LZGoodsModel *model = [shop.productList objectAtIndex:indexPath.row];

            [CartAPI removeCartWithParam:model.cart_id success:^{
                DLog(@"商品移除成功");
                [shop.productList removeObjectAtIndex:indexPath.row];
                //                    //    删除
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                if (shop.productList.count == 0) {
                    [self.dataArray removeObjectAtIndex:indexPath.section];
                }
                //判断删除的商品是否已选择
                if ([self.selectedArray containsObject:model]) {
                    //从已选中删除,重新计算价格
                    [self.selectedArray removeObject:model];
                    [self countPrice];
                }
                NSInteger count = 0;
                for (LZShopModel *shop in self.dataArray) {
                    count += shop.productList.count;
                }
                if (self.selectedArray.count == count) {
                    _allSellectedButton.selected = YES;
                } else {
                    _allSellectedButton.selected = NO;
                }
                if (count == 0) {
                    [self changeView];
                }
                //如果删除的时候数据紊乱,可延迟0.5s刷新一下
                [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
                
            } faulre:^(NSError *error) {
                DLog(@"商品移除失败");
            }];
    }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
                                   
- (void)reloadTable {
    [self.myTableView reloadData];
}
#pragma mark -- 页面按钮点击事件
#pragma mark --- 返回按钮点击事件
- (void)backButtonClick:(UIButton*)button {
    if (_isHasNavitationController == NO) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark --- 全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (LZGoodsModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        
        for (LZShopModel *shop in self.dataArray) {
            shop.select = YES;
            for (LZGoodsModel *model in shop.productList) {
                model.select = YES;
                [self.selectedArray addObject:model];
            }
        }
        
    } else {
        for (LZShopModel *shop in self.dataArray) {
            shop.select = NO;
        }
    }
    
    [self.myTableView reloadData];
    [self countPrice];
}
#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
    
    if(self.selectedArray.count > 0){
        NSMutableString *goodsCartIdStr = [[NSMutableString alloc] init];
        for(int i=0;i<self.selectedArray.count;i++){
            LZGoodsModel *model = self.selectedArray[i];
            if(i == 0){
                goodsCartIdStr = [NSMutableString stringWithString:model.cart_id];
            }else{
                [goodsCartIdStr appendString:[NSString stringWithFormat:@",%@",model.cart_id]];
            }
        }
        NSString *CartIdStr = goodsCartIdStr;
        DLog(@"CartIdStr = %@",CartIdStr);
        //跳转到 确认订单页面
        NSFirmOrderVC *firmOrderVC = [[NSFirmOrderVC alloc] init];
        [firmOrderVC loadDataWithNSString:CartIdStr];
        [self.navigationController pushViewController:firmOrderVC animated:YES];
    }else{
        [Common AppShowToast:@"您还没有选择任何商品"];
    }
}

- (void)verityGroupSelectState:(NSInteger)section {
    
    // 判断某个区的商品是否全选
    LZShopModel *tempShop = self.dataArray[section];
    // 是否全选标示符
    BOOL isShopAllSelect = YES;
    for (LZGoodsModel *model in tempShop.productList) {
        // 当有一个为NO的是时候,将标示符置为NO,并跳出循环
        if (model.select == NO) {
            isShopAllSelect = NO;
            break;
        }
    }
    
    LZTableHeaderView *header = (LZTableHeaderView *)[self.myTableView headerViewForSection:section];
    header.select = isShopAllSelect;
    tempShop.select = isShopAllSelect;
}

- (void)verityAllSelectState {
    
    NSInteger count = 0;
    for (LZShopModel *shop in self.dataArray) {
        count += shop.productList.count;
    }
    
    if (self.selectedArray.count == count) {
        _allSellectedButton.selected = YES;
    } else {
        _allSellectedButton.selected = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *)view).backgroundView.backgroundColor = kWhiteColor;
    }
}

@end
