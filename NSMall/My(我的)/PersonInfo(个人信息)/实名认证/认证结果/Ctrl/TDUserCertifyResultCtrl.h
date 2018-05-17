//
//  TDUserCertifyResultCtrl.h
//  Trade
//
//  Created by FeiFan on 2017/8/30.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 认证状态
 */
typedef NS_ENUM(NSInteger, TDUserCertifyResult) {
    TDUserCertifyResultChecking,    // 正在审核
    TDUserCertifyResultCommitDone,  // 提交完成
    TDUserCertifyResultCheckPast,   // 审核通过
    TDUserCertifyResultRefused      // 审核拒绝
};


@interface TDUserCertifyResultCtrl : TDBaseViewController

@property (nonatomic, assign) TDUserCertifyResult certifyResult; // 认证结果状态

@end
