//
//  NSRejectedSaleVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSRejectedSaleVC.h"
#import "NSMyOrderTVCell.h"
#import "NSOrderListItemModel.h"
#import "MyOrderAPI.h"
#import "MyOrderParam.h"
#import "NSOrderDetailVC.h"

@interface NSRejectedSaleVC ()<UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, strong) BaseTableView         *allOrderTable;
/** 当前页数 */
@property(nonatomic)NSInteger currentPage;

@end

@implementation NSRejectedSaleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
