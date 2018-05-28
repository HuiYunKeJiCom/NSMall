//
//  TDUserCertifyViewCtrl.m
//  Trade
//
//  Created by FeiFan on 2017/8/30.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDUserCertifyViewCtrl.h"
#import "TDSegmentView.h"
#import "TDUserCertifySubVCBasic.h"
#import "TDUserCertifySubVCPics.h"
#import "TDUserCertifySubVCConfirm.h"
#import "TDUserCertifyDataSource.h"
#import "TDUserCertifyResultCtrl.h"

#import "ADOrderTopToolView.h"

@interface TDUserCertifyViewCtrl () <TDBaseViewControllerDelegate>
@property (nonatomic, strong) TDSegmentView* segmentView;
@property (nonatomic, strong) TDUserCertifySubVCBasic* basicVC;
@property (nonatomic, strong) TDUserCertifySubVCPics* picsVC;
@property (nonatomic, strong) TDUserCertifySubVCConfirm* confirmVC;
@end

@implementation TDUserCertifyViewCtrl

# pragma mark - IBActions 
- (void) segmentAddition {
    NSInteger cur = self.segmentView.curSelectedIndex + 1;
    if (cur >= self.segmentView.items.count) {
        cur = 0;
    }
    self.segmentView.curSelectedIndex = cur;
}

- (void) segmentReduce {
    NSInteger cur = self.segmentView.curSelectedIndex - 1;
    if (cur < 0) {
        cur = 2;
    }
    self.segmentView.curSelectedIndex = cur;
}

// 上传数据
- (void) uploadingDatas {
    //这里要修改
    __weak typeof(self) wself = self;
    [MBProgressHUD mb_showWaitingWithText:KLocalizableStr(@"正在上传数据...") detailText:nil inView:self.view];
    
    [[TDUserCertifyDataSource sharedRealNameCtrl] uploadRealNameDataOnSuccess:^(id data) {
        DLog(@"上传成功回调");
        [MBProgressHUD hideHUDForView:wself.view animated:YES];
        // 上传成功跳转结果界面
        TDUserCertifyResultCtrl* resultVC = [TDUserCertifyResultCtrl new];
        resultVC.certifyResult = TDUserCertifyResultCommitDone;
        [wself.navigationController pushViewController:resultVC animated:YES];
    } orFail:^(NSString *msg) {
        
        [MBProgressHUD hideHUDForView:wself.view animated:YES];
        [MBProgressHUD mb_showOnlyText:@"认证失败!" detail:msg delay:1.5 inView:wself.view];
    }];
}

// 从后台重新获取认证信息
- (void) reloadDatas {
    if ([TDUserCertifyDataSource sharedRealNameCtrl].realNameModel) {
        [self.basicVC reloadDatas];
        [self.picsVC reloadDatas];
    }
}

# pragma mark - transition


/**
 子视图转场
 */
- (void) doTransition {
    [self segmentAddition];
    UIViewController* curPresentVC = [self.childViewControllers firstObject];
    UIViewController* presentedVC = nil;
    
    __weak typeof(self) wself = self;
    
    // 基本信息 -> 上传证件
    if (self.segmentView.curSelectedIndex == 1) {
        presentedVC = self.picsVC;
    }
    // 上传证件 -> 完善信息
    else if (self.segmentView.curSelectedIndex == 2) {
        presentedVC = self.confirmVC;
    }
    // 完善信息 -> 基本信息
    else if (self.segmentView.curSelectedIndex == 0) {
        presentedVC = self.basicVC;
    }

    // 目标界面添加到当前子视图层
    [self addChildViewController:presentedVC];
    __block CGRect frame = CGRectMake(kScreenWidth, TopBarHeight + 70, kScreenWidth, kScreenHeight - TopBarHeight - 70);
    presentedVC.view.frame = frame;
    // 执行转场
    [self transitionFromViewController:curPresentVC toViewController:presentedVC duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        frame.origin.x = 0;
        presentedVC.view.frame = frame;
        frame.origin.x = - kScreenWidth;
        curPresentVC.view.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            // 转场完毕要"完成添加目标界面"和"移除起始界面"
            [presentedVC didMoveToParentViewController:wself];
            [curPresentVC willMoveToParentViewController:nil];
            [curPresentVC removeFromParentViewController];
        }
    }];
}

// 子视图回退转场
- (void) doTransitionBack {
    [self segmentReduce];
    UIViewController* curPresentVC = [self.childViewControllers firstObject];
    UIViewController* presentedVC = nil;
    
    __weak typeof(self) wself = self;
    // 完善信息 -> 上传证件
    if (self.segmentView.curSelectedIndex == 1) {
        presentedVC = self.picsVC;
    }
    // 上传证件 -> 基本信息
    else if (self.segmentView.curSelectedIndex == 0) {
        presentedVC = self.basicVC;
    }
    // 基本信息 -> 完善信息
    else if (self.segmentView.curSelectedIndex == 2) {
        presentedVC = self.confirmVC;
    }

    // 目标界面添加到当前子视图层
    [self addChildViewController:presentedVC];
    __block CGRect frame = CGRectMake(-kScreenWidth, TopBarHeight + 70, kScreenWidth, kScreenHeight - TopBarHeight - 70);
    presentedVC.view.frame = frame;
    // 执行转场
    [self transitionFromViewController:curPresentVC toViewController:presentedVC duration:0.3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        frame.origin.x = 0;
        presentedVC.view.frame = frame;
        frame.origin.x = kScreenWidth;
        curPresentVC.view.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            // 转场完毕要"完成添加目标界面"和"移除起始界面"
            [presentedVC didMoveToParentViewController:wself];
            [curPresentVC willMoveToParentViewController:nil];
            [curPresentVC removeFromParentViewController];
        }
    }];

}


# pragma mark - TDBaseViewControllerDelegate

- (void)viewController:(UIViewController *)viewController clickedLeftBarItem:(UIBarButtonItem *)leftBarItem {
    if (self.segmentView.curSelectedIndex == 0) {
        // 回退到根目录
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self doTransitionBack];
    }
}

# pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeDatas];
    [self initializeViews];
    [self initializeSubVCs];
    [self setUpNavTopView];
    [self reloadDatas];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initializeDatas {
//    self.title = KLocalizableStr(@"实名认证");
    self.view.backgroundColor = KColorMainBackground;
    self.tdDelegate = self;
}

#pragma mark - 导航栏处理
- (void)setUpNavTopView
{
    ADOrderTopToolView *topToolView = [[ADOrderTopToolView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, TopBarHeight)];
    topToolView.backgroundColor = kWhiteColor;
    [topToolView setTopTitleWithNSString:KLocalizableStr(@"实名认证")];
    WEAKSELF
    topToolView.leftItemClickBlock = ^{
        NSLog(@"点击了返回");
        //        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    [self.view addSubview:topToolView];
}

- (void) initializeViews {
    [self.view addSubview:self.segmentView];
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(70);
    }];
}

- (void) initializeSubVCs {
    [self addChildViewController:self.basicVC];
    [self.view addSubview:self.basicVC.view];
    [self.basicVC didMoveToParentViewController:self];
}


# pragma mark - getter

- (TDSegmentView *)segmentView {
    if (!_segmentView) {
        _segmentView = [[TDSegmentView alloc] initWithItems:@[KLocalizableStr(@"基础信息"), KLocalizableStr(@"上传证件"), KLocalizableStr(@"完善信息")]];
        _segmentView.backgroundColor = KColorSubBackground;
        _segmentView.normalColor = UIColorFromRGB(0x8e99a8);
        _segmentView.curSelectedIndex = 0;
    }
    return _segmentView;
}

- (TDUserCertifySubVCBasic *)basicVC {
    if (!_basicVC) {
        _basicVC = [TDUserCertifySubVCBasic new];
        __weak typeof(self) wself = self;
        _basicVC.touchEvent = ^{
            [wself doTransition];
        };
        _basicVC.view.frame = CGRectMake(0, TopBarHeight + 70, kScreenWidth, kScreenHeight - TopBarHeight - 70);
    }
    return _basicVC ;
}

- (TDUserCertifySubVCPics *)picsVC {
    if (!_picsVC) {
        _picsVC = [TDUserCertifySubVCPics new];
        __weak typeof(self) wself = self;
        _picsVC.touchEvent = ^{
            [wself doTransition];
        };
        _picsVC.view.frame = CGRectMake(0, TopBarHeight + 70, kScreenWidth, kScreenHeight - TopBarHeight - 70);
    }
    return _picsVC;
}

- (TDUserCertifySubVCConfirm *)confirmVC {
    if (!_confirmVC) {
        _confirmVC = [TDUserCertifySubVCConfirm new];
        __weak typeof(self) wself = self;
        _confirmVC.touchEvent = ^{
            // 处理上传
            [wself uploadingDatas];
        };
        _confirmVC.view.frame = CGRectMake(0, TopBarHeight + 70, kScreenWidth, kScreenHeight - TopBarHeight - 70);
    }
    return _confirmVC;
}

@end
