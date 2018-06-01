//
//  NSPayView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/6/1.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSPayView.h"
#import "NSPayView.h"
#import "NSPayViewTVCell.h"

@interface NSPayView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, weak) UIView *contentView;
@property(nonatomic,strong)UILabel *payTitle;/* 付款标题 */
@property(nonatomic,strong)UILabel *payLab;/* 付款金额 */
@property(nonatomic,strong)NSMutableArray *cellArray;/* 保存地址列表Cell */
@property(nonatomic,strong)BaseTableView *walletListTV;/* 钱包列表 */
@property (nonatomic) NSInteger row;
@end

@implementation NSPayView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5];
        self.row = 0;
        [self setupBasicView];
    }
    return self;
}

/**
 *  设置视图的基本内容
 */
- (void)setupBasicView {
    // 添加手势，点击背景视图消失
    /** 使用的时候注意名字不能用错，害我定格了几天才发现。FK
     UIGestureRecognizer
     UITapGestureRecognizer // 点击手势
     UISwipeGestureRecognizer // 轻扫手势
     */
    UIView *bgView = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight - kATTR_VIEW_HEIGHT}];
    bgView.backgroundColor = kClearColor;
    UITapGestureRecognizer *tapBackGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    [bgView addGestureRecognizer:tapBackGesture];
    [self addSubview:bgView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:(CGRect){0, kScreenHeight - kATTR_VIEW_HEIGHT, kScreenWidth, kATTR_VIEW_HEIGHT}];
    contentView.backgroundColor = [UIColor whiteColor];
//    // 添加手势，遮盖整个视图的手势，
//    UITapGestureRecognizer *contentViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
//    [contentView addGestureRecognizer:contentViewTapGesture];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UILabel *titleLab = [[UILabel alloc]init];
    titleLab.text = @"请选择钱包";
    [titleLab sizeToFit];
    titleLab.centerX = self.contentView.centerX;
    titleLab.y = 12;
    titleLab.font = UISystemFontSize(14);
    titleLab.textColor = kBlackColor;
    [self.contentView addSubview:titleLab];
    
    self.walletListTV = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.walletListTV.x = 0;
    self.walletListTV.y = CGRectGetMaxY(titleLab.frame)+12;
    self.walletListTV.size = CGSizeMake(kScreenWidth, GetScaleWidth(40)*4);
//    self.walletListTV.backgroundColor = kRedColor;
    self.walletListTV.delegate = self;
    self.walletListTV.dataSource = self;
    self.walletListTV.isLoadMore = YES;
    self.walletListTV.isRefresh = NO;
    self.walletListTV.delegateBase = self;
    [self.walletListTV registerClass:[NSPayViewTVCell class] forCellReuseIdentifier:@"NSPayViewTVCell"];
    [self.contentView addSubview:self.walletListTV];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor = KMainColor;
    confirmBtn.x = 18;
    confirmBtn.y = kATTR_VIEW_HEIGHT-44-15;
    confirmBtn.size = CGSizeMake(kScreenWidth-36, 44);
    [confirmBtn setTitle:@"确认添加" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmPay) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 5;//设置那个圆角的有多圆
    confirmBtn.layer.masksToBounds = YES;//设为NO去试试
    [self.contentView addSubview:confirmBtn];
    
    self.payLab = [[UILabel alloc]init];
    self.payLab.font = UISystemFontSize(14);
    self.payLab.textColor = KBGCOLOR;
    [self.contentView addSubview:self.payLab];
    
    self.payTitle = [[UILabel alloc]init];
    self.payTitle.font = UISystemFontSize(14);
    self.payTitle.textColor = kBlackColor;
    [self.contentView addSubview:self.payTitle];
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    __weak typeof(self) _weakSelf = self;
    self.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kATTR_VIEW_HEIGHT);;
    
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _weakSelf.contentView.frame = CGRectMake(0, kScreenHeight - kATTR_VIEW_HEIGHT, kScreenWidth, kATTR_VIEW_HEIGHT);
    }];
}

- (void)removeView {
    __weak typeof(self) _weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        _weakSelf.backgroundColor = [UIColor clearColor];
        _weakSelf.contentView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kATTR_VIEW_HEIGHT);
    } completion:^(BOOL finished) {
        [_weakSelf removeFromSuperview];
    }];
}

-(void)confirmPay{
    DLog(@"确认添加");
    for(NSPayViewTVCell *cell in self.cellArray){
        if(cell.isSelected){
            self.walletId = cell.walletModel.wallet_id;
        }
    }
    !_confirmClickBlock ? : _confirmClickBlock();
}

-(void)setWalletId:(NSString *)walletId{
    _walletId = walletId;
}

-(void)setPayString:(NSString *)payString{
    _payString = payString;
    
    NSArray *strArr = [payString componentsSeparatedByString:@"/¥"];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:payString];
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:kRedColor
     
                          range:[payString rangeOfString:strArr[0]]];
    
    self.payLab.attributedText = AttributedStr;
    CGSize sum = [self contentSizeWithTitle:payString andFont:14];
    self.payLab.y = kATTR_VIEW_HEIGHT-44-15-sum.height-20;
    self.payLab.x = kScreenWidth-19-sum.width;
    [self.payLab sizeToFit];
    
    self.payTitle.text = @"需付款";
    CGSize titleSize = [self contentSizeWithTitle:self.payTitle.text andFont:14];
    self.payTitle.x = CGRectGetMinX(self.payLab.frame)-10-titleSize.width;
    self.payTitle.y = CGRectGetMinY(self.payLab.frame);
    [self.payTitle sizeToFit];
    
}

- (CGSize)contentSizeWithTitle:(NSString *)title andFont:(float)font{
    CGSize maxSize = CGSizeMake(kScreenWidth *0.5, MAXFLOAT);
    // 计算文字的高度
    return  [title boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}

-(NSMutableArray *)cellArray{
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}

-(void)setWalletNameArr:(NSMutableArray<WalletItemModel *> *)walletNameArr{
    _walletNameArr = walletNameArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.walletNameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return GetScaleWidth(40);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSPayViewTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSPayViewTVCell"];
    WalletItemModel *model = self.walletNameArr[indexPath.row];
    cell.walletModel = model;
    if(indexPath.row ==self.row && cell.isSelected){
        cell.seclectIV.alpha = 1.0;
    }else{
        cell.seclectIV.alpha = 0.0;
    }
    [self.cellArray addObject:cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for(NSPayViewTVCell *cell in self.cellArray){
        cell.isSelected = NO;
    }
    self.row = indexPath.row;
    NSPayViewTVCell *cell = [self.walletListTV cellForRowAtIndexPath:indexPath];
    cell.isSelected = YES;
    [self.cellArray removeAllObjects];
    [self.walletListTV reloadData];
}



@end
