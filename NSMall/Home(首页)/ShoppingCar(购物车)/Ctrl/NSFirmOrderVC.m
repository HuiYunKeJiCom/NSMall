//
//  NSFirmOrderVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/30.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSFirmOrderVC.h"
#import "ADOrderTopToolView.h"
#import "NSFirmOrderModel.h"
#import "NSFirmOrderCell.h"
#import "NSAddressTVCell.h"
#import "CartAPI.h"

#import "ADReceivingAddressViewController.h"//地址列表

@interface NSFirmOrderVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *goodsTable;
@property(nonatomic,strong)NSFirmOrderModel *firmOrderModel;/* 数据模型 */
@property(nonatomic,copy)NSString *cartId;/* 购物车Id */
@end

@implementation NSFirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.goodsTable];
    [self setUpNavTopView];
    [self makeConstraints];
//    [self requestAllOrder:NO];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"确认订单")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

-(void)setUpButtomView{
    UIView *buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-48, kScreenWidth, 48)];
    buttomView.backgroundColor = kWhiteColor;
    [self.view addSubview:buttomView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    lineView.backgroundColor = KBGCOLOR;
    [buttomView addSubview:lineView];
    
    UIButton *submission = [UIButton buttonWithType:UIButtonTypeCustom];
    submission.backgroundColor = kRedColor;
    submission.x = kScreenWidth-19-80;
    submission.y = 10;
    submission.size = CGSizeMake(80, 28);
    [submission setTitle:@"提交并支付" forState:UIControlStateNormal];
    submission.titleLabel.font = UISystemFontSize(14);
    [submission setTitleColor:kWhiteColor forState:UIControlStateNormal];
//    [submission addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:submission];
    
    UILabel *sumLab = [[UILabel alloc]init];
    NSString *str = [NSString stringWithFormat:@"N%.2f/¥%.2f",self.firmOrderModel.payment_price,self.firmOrderModel.payment_score];
    NSArray *strArr = [str componentsSeparatedByString:@"/¥"];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:str];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:kRedColor
     
                          range:[str rangeOfString:strArr[0]]];
    
    sumLab.attributedText = AttributedStr;
    CGSize sum = [self contentSizeWithTitle:str andFont:14];
    sumLab.x = CGRectGetMinX(submission.frame)-13-sum.width;
    sumLab.y = 24-sum.height*0.5;
    sumLab.font = UISystemFontSize(14);
    [sumLab sizeToFit];
    sumLab.textColor = KBGCOLOR;
    [buttomView addSubview:sumLab];
    
    UILabel *sumTitle = [[UILabel alloc]init];
    sumTitle.font = UISystemFontSize(14);
    sumTitle.text = @"合计";
    CGSize sumTitSize = [self contentSizeWithTitle:sumTitle.text andFont:14];
    sumTitle.x = CGRectGetMinX(sumLab.frame)-7-sumTitSize.width;
    sumTitle.y = 24-sumTitSize.height*0.5;
    [sumTitle sizeToFit];
    sumTitle.textColor = kBlackColor;
    [buttomView addSubview:sumTitle];
}

#pragma mark - Constraints
- (void)makeConstraints {
    
    [self.goodsTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(TopBarHeight);
    }];
    
}

-(void)loadDataWithNSString:(NSString *)string{
    self.cartId = string;
    [self requestAllOrder:NO];
    [self setUpButtomView];
}

- (void)requestAllOrder:(BOOL)more {
    [self.goodsTable updateLoadState:more];
    
    
    WEAKSELF
    [CartAPI checkCartDataWithParam:self.cartId success:^(NSFirmOrderModel *firmOrderModel) {
        NSLog(@"获取获取购物车结算页面数据成功");
        weakSelf.firmOrderModel = firmOrderModel;
        weakSelf.goodsTable.data = [NSMutableArray arrayWithArray:firmOrderModel.cartList];
        [self.goodsTable updatePage:more];
        self.goodsTable.noDataView.hidden = self.goodsTable.data.count;
        [self.goodsTable reloadData];
    } faulre:^(NSError *error) {
        NSLog(@"获取获取购物车结算页面数据失败");
    }];
    
}

- (BaseTableView *)goodsTable {
    if (!_goodsTable) {
        _goodsTable = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _goodsTable.delegate = self;
        _goodsTable.dataSource = self;
        _goodsTable.isLoadMore = YES;
        _goodsTable.isRefresh = YES;
        _goodsTable.delegateBase = self;
        [_goodsTable registerClass:[NSFirmOrderCell class] forCellReuseIdentifier:@"NSFirmOrderCell"];
        [_goodsTable registerClass:[NSAddressTVCell class] forCellReuseIdentifier:@"NSAddressTVCell"];
    }
    return _goodsTable;
}

#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return GetScaleWidth(0);
    }else{
        //设置间隔高度
        return GetScaleWidth(15);
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, GetScaleWidth(15))];
    sectionView.backgroundColor = kGreyColor;
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.goodsTable.data.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        return GetScaleWidth(65);
    }else{
        LZShopModel *shopModel = self.goodsTable.data[indexPath.section-1];
        DLog(@"cellHeight = %.2f",shopModel.cellHeight);
        return shopModel.cellHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        NSAddressTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSAddressTVCell"];
        cell.addressModel = self.firmOrderModel.defaultAddress;
        return cell;
    }else{
        NSFirmOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSFirmOrderCell"];
        if (self.goodsTable.data.count > indexPath.section-1) {
            LZShopModel *model = self.goodsTable.data[indexPath.section-1];
            //        NSLog(@"model = %@",model.mj_keyValues);
            cell.shopModel = model;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0){
        ADReceivingAddressViewController *receivingAddressVC = [[ADReceivingAddressViewController alloc] init];
        [self.navigationController pushViewController:receivingAddressVC animated:YES];
    }
}

- (void)baseTableVIew:(BaseTableView *)tableView refresh:(BOOL)flag {
    [self requestAllOrder:NO];
}

- (void)baseTableView:(BaseTableView *)tableView loadMore:(BOOL)flag {
    [self requestAllOrder:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

@end
