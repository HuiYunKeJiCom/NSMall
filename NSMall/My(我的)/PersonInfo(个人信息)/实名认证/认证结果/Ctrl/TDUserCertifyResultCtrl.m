//
//  TDUserCertifyResultCtrl.m
//  Trade
//
//  Created by FeiFan on 2017/8/30.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyResultCtrl.h"
#import "TDUserCertifyViewCtrl.h"
#import "TDUserCertifyDataSource.h"



@interface TDUserCertifyResultCtrl ()
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILabel* statusLabel; // 状态标签
@property (nonatomic, strong) UILabel* contentLabel; // 正文标签
@property (nonatomic, strong) UIButton* sureBtn;
// 保存要上传的数据
@property (nonatomic, copy) TDNameCertifyModel* realNameModel;
@end

@implementation TDUserCertifyResultCtrl

# pragma mark - IBActions

- (IBAction) clickedSureBtn:(id)sender {
    // 审核拒绝的要跳转到认证界面
    if (self.certifyResult == TDUserCertifyResultRefused) {
        TDUserCertifyViewCtrl* userCertifyVC = [TDUserCertifyViewCtrl new];
        [TDUserCertifyDataSource sharedRealNameCtrl].realNameModel = self.realNameModel;
        [self.navigationController pushViewController:userCertifyVC animated:YES];
    }
    // 其他的直接回退
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

# pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeDatas];
    [self initializeViews];
    [self reloadDatas];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initializeDatas {
    self.title = KLocalizableStr(@"实名认证");
    self.view.backgroundColor = KColorMainBackground;
    self.sureBtn.hidden = self.certifyResult == TDUserCertifyResultChecking;
    
    // 按钮标题
    @weakify(self);
    [RACObserve(self, certifyResult) subscribeNext:^(id x) {
        @strongify(self);
        // 审核拒绝
        if ([x integerValue] == TDUserCertifyResultRefused) {
            // 按钮
            [self.sureBtn setTitle:@"重新认证" forState:UIControlStateNormal];
            self.sureBtn.hidden = NO;
            // 图片
            self.imageView.image = [UIImage imageNamed:@"certify_icon_fail"];
            // 状态标题
            self.statusLabel.text = KLocalizableStr(@"认证失败!");
            // 状态正文
            self.contentLabel.text = KLocalizableStr(@"尊敬的用户，您所提交的信息有误被打回，\n不便之处敬请谅解!");
        }
        // 审核通过
        else if ([x integerValue] == TDUserCertifyResultCheckPast) {
            // 按钮
            self.sureBtn.hidden = YES;
            // 图片
            self.imageView.image = [UIImage imageNamed:@"certify_icon_success"];
            // 状态标题
            self.statusLabel.text = KLocalizableStr(@"认证成功!");
            // 状态正文
            self.contentLabel.text = KLocalizableStr(@"尊敬的用户，您所提交的信息认证成功，\n您可在平台进行虚拟币交易!");

        }
        // 正在审核
        else {
            // 按钮
            [self.sureBtn setTitle:@"完成" forState:UIControlStateNormal];
            self.sureBtn.hidden = NO;
            // 图片
            self.imageView.image = [UIImage imageNamed:@"user_icon_waiting"];
            // 状态标题
            self.statusLabel.text = KLocalizableStr(@"");
            // 状态正文
            self.contentLabel.text = KLocalizableStr(@"您的资料提交成功，请耐心等待认证审核.\n审核结果会在1~7个工作日通过信息回复.");

        }
    }];

}

- (void) initializeViews {
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.statusLabel];
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.sureBtn];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(2.f * (1 - 0.76));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.height.mas_equalTo(GetScaleWidth(120));
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.statusLabel.mas_bottom).offset(15);
        make.left.right.equalTo(self.view);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GetScaleWidth(32));
        make.right.mas_equalTo(GetScaleWidth(-32));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(GetScaleWidth(50));
        make.height.mas_equalTo(40);
    }];
}

- (void) reloadDatas {
    // 不是提交完成过来的都要刷新认证结果信息
    //这里需要修改
//    __weak typeof(self) wself = self;
//    if (self.certifyResult != TDUserCertifyResultCommitDone) {
//        [MBProgressHUD mb_showWaitingWithText:nil detailText:nil inView:self.view];
//        [RequestTool appRealNameGetInfoOnSuccess:^(id data) {
//            [MBProgressHUD hideHUDForView:wself.view animated:YES];
//            wself.realNameModel = data;
//            /** 审核状态（1：未审核；2：已审核） */
//            NSInteger status = wself.realNameModel.auditStatus.integerValue;
//            /** 审核结果（1：通过；2：打回） */
//            NSInteger result = wself.realNameModel.auditResult.integerValue;
//            if (status == 1) {
//                wself.certifyResult = TDUserCertifyResultChecking;
//            } else {
//                wself.certifyResult = result == 1 ? TDUserCertifyResultCheckPast : TDUserCertifyResultRefused;
//            }
//        } fail:^(NSString *msg) {
//            [MBProgressHUD hideHUDForView:wself.view animated:YES];
//            [MBProgressHUD mb_showOnlyText:@"获取实名认证信息失败" detail:msg delay:1.5 inView:wself.view];
//        }];
//    }
    
}

# pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [UILabel new];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.font = UIBoldFontSize(16);
        _statusLabel.textColor = KColorMainOrange;
    }
    return _statusLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = UIBoldFontSize(14);
        _contentLabel.textColor = KColorTextFFFFFF;
    }
    return _contentLabel;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setTitleColor:KColorMainBackground forState:UIControlStateNormal];
        [_sureBtn setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        [_sureBtn addTarget:self action:@selector(clickedSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.backgroundColor = KColorMainOrange;
        _sureBtn.layer.cornerRadius = 5;
    }
    return _sureBtn;
}


@end
