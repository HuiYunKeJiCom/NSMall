//
//  NSExpressComView.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSExpressComView.h"
#import "NSExpressTVCell.h"

@interface NSExpressComView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,BaseTableViewDelegate>
@property (nonatomic, weak) UIView *contentView;
//@property(nonatomic,strong)UILabel *payTitle;/* 付款标题 */
//@property(nonatomic,strong)UILabel *payLab;/* 付款金额 */
@property(nonatomic,strong)NSMutableArray *cellArray;/* 保存地址列表Cell */
@property(nonatomic,strong)BaseTableView *expressListTV;/* 快递公司列表 */
@property (nonatomic) NSInteger row;
@end

@implementation NSExpressComView

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
    
    self.expressListTV = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.expressListTV.x = 0;
    self.expressListTV.y = CGRectGetMaxY(titleLab.frame)+12;
    self.expressListTV.size = CGSizeMake(kScreenWidth, GetScaleWidth(40)*4);
    //    self.walletListTV.backgroundColor = kRedColor;
    self.expressListTV.delegate = self;
    self.expressListTV.dataSource = self;
    self.expressListTV.isLoadMore = YES;
    self.expressListTV.isRefresh = NO;
    self.expressListTV.delegateBase = self;
    [self.expressListTV registerClass:[NSExpressTVCell class] forCellReuseIdentifier:@"NSExpressTVCell"];
    [self.contentView addSubview:self.expressListTV];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor = KMainColor;
    confirmBtn.x = 18;
    confirmBtn.y = kATTR_VIEW_HEIGHT-44-15;
    confirmBtn.size = CGSizeMake(kScreenWidth-36, 44);
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmPay) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 5;//设置那个圆角的有多圆
    confirmBtn.layer.masksToBounds = YES;//设为NO去试试
    [self.contentView addSubview:confirmBtn];
    
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
    for(NSExpressTVCell *cell in self.cellArray){
        if(cell.isSelected){
            self.selectModel = cell.expressModel;
        }
    }
    !_confirmClickBlock ? : _confirmClickBlock();
}

-(void)setSelectModel:(NSExpressModel *)selectModel{
    _selectModel = selectModel;
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

-(void)setExpressNameArr:(NSMutableArray<NSExpressModel *> *)expressNameArr{
    _expressNameArr = expressNameArr;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expressNameArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return GetScaleWidth(40);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSExpressTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NSExpressTVCell"];
    NSExpressModel *model = self.expressNameArr[indexPath.row];
    cell.expressModel = model;
    if(indexPath.row ==self.row && cell.isSelected){
        cell.seclectIV.alpha = 1.0;
    }else{
        cell.seclectIV.alpha = 0.0;
    }
    [self.cellArray addObject:cell];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for(NSExpressTVCell *cell in self.cellArray){
        cell.isSelected = NO;
    }
    self.row = indexPath.row;
    NSExpressTVCell *cell = [self.expressListTV cellForRowAtIndexPath:indexPath];
    cell.isSelected = YES;
    [self.cellArray removeAllObjects];
    [self.expressListTV reloadData];
}


@end
