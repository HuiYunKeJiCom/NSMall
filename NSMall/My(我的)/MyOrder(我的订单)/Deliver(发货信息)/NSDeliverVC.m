//
//  NSDeliverVC.m
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSDeliverVC.h"
#import "ADOrderTopToolView.h"
#import "NSExpressComView.h"
#import "NSGetExpressAPI.h"
#import "NSDeliverParam.h"
#import "NSOrderListVC.h"

@interface NSDeliverVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UIView *bgView;/* 背景View */
@property(nonatomic,strong)UITextField *expressNoTF;/* 快递单号 */
@property(nonatomic,strong)UITextField *expressComTF;/* 快递公司 */
@property(nonatomic,strong)UIButton *confirmBtn;/* 确认按钮 */
@property(nonatomic,strong)NSDeliverParam *param;/* 发货参数 */
@end

@implementation NSDeliverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.param = [NSDeliverParam new];
    self.view.backgroundColor = KBGCOLOR;
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.expressNoTF];
    [self.bgView addSubview:self.expressComTF];
    [self setUpNavTopView];
    [self setupCustomBottomView];
    [self makeConstraints];
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:@"发货信息"];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
    
}

#pragma mark -- 自定义底部视图
- (void)setupCustomBottomView {
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.backgroundColor = KMainColor;
    self.confirmBtn.frame = CGRectMake(0, kScreenHeight-TabBarHeight, kScreenWidth, TabBarHeight);
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(beginDeliver) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmBtn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeConstraints{
    WEAKSELF
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.view.mas_top).with.offset(TopBarHeight);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 80));
    }];
    
    [self.expressNoTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left);
        make.top.equalTo(weakSelf.bgView.mas_top).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 20));
    }];
    
    [self.expressComTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bgView.mas_left);
        make.top.equalTo(weakSelf.expressNoTF.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 20));
    }];
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
        _bgView.backgroundColor = kWhiteColor;
    }
    return _bgView;
}

- (UITextField *)expressNoTF {
    if (!_expressNoTF) {
        _expressNoTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _expressNoTF.font = [UIFont systemFontOfSize:14];
        //        _amountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _expressNoTF.textColor = kBlackColor;
        _expressNoTF.backgroundColor = kWhiteColor;
//        _expressNoTF.font = [UIFont boldSystemFontOfSize:14];
        _expressNoTF.placeholder = @"请输入快递单号";
        _expressNoTF.delegate = self;
        _expressNoTF.tag = 11;
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0, -2, 90, 20)];
        
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 20) FontSize:14];
        nameLab.text = @"快递单号:";
        nameLab.textColor = [UIColor blackColor];
        [paddingView addSubview:nameLab];
        
        _expressNoTF.leftView = paddingView;
        _expressNoTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _expressNoTF;
}

- (UITextField *)expressComTF {
    if (!_expressComTF) {
        _expressComTF = [[UITextField alloc] initWithFrame:CGRectZero];
        _expressComTF.font = [UIFont systemFontOfSize:14];
        //        _expressComTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _expressComTF.textColor = kBlackColor;
        _expressComTF.backgroundColor = kWhiteColor;
//        _expressComTF.font = [UIFont boldSystemFontOfSize:14];
        _expressComTF.delegate = self;
        _expressComTF.tag = 12;
        _expressComTF.placeholder = @"请选择快递公司";
        
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(0,-2, 90, 20)];
        
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 20) FontSize:14];
        nameLab.text = @"快递公司:";
        nameLab.textColor = [UIColor blackColor];
        [paddingView addSubview:nameLab];
        
        _expressComTF.leftView = paddingView;
        _expressComTF.leftViewMode = UITextFieldViewModeAlways;
    }
    return _expressComTF;
}

-(void)chooseExpressCompany{
//    NSLog(@"来这里了");
    [NSGetExpressAPI getExpressList:nil success:^(NSExpressListModel * _Nullable result) {
        NSLog(@"获取快递公司成功");
        NSExpressComView *payView = [[NSExpressComView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}];
        payView.userInteractionEnabled = YES;
        payView.expressNameArr = [NSMutableArray arrayWithArray:result.result];
        __weak typeof(payView) PayView = payView;
        payView.confirmClickBlock = ^{
            [PayView removeView];
            [self selectedExpressModel:PayView.selectModel];
        };
        [payView showInView:self.navigationController.view];
    } failure:^(NSError *error) {
        NSLog(@"获取快递公司失败");
    }];

}

-(void)selectedExpressModel:(NSExpressModel *)expressModel{
    self.expressComTF.text = expressModel.ship_name;
    self.param.shipName = expressModel.ship_name;
    self.param.shipCode = expressModel.ship_code;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.expressNoTF resignFirstResponder];// 使当前文本框失去第一响应者的特权，就会回收键盘了
    
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    if(textField.tag == 12){
        [self chooseExpressCompany];
        return NO;
    }
    return YES;
}

-(void)beginDeliver{
    //调用发货按钮
    self.param.orderId = self.orderId;
    self.param.shipNumber = self.expressNoTF.text;
    
    [NSGetExpressAPI deliveryOrderWithParam:self.param success:^{
        DLog(@"发货成功");
        [Common AppShowToast:@"发货成功"];
        [self delayPop];
    } faulre:^(NSError *error) {
        DLog(@"发货失败");
    }];
}

- (void)delayPop {
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:[NSOrderListVC class]]){
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
        }
        
    });
}

@end
