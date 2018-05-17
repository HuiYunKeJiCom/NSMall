//
//  TDUserCertifySubVCBasic.h
//  Trade
//
//  Created by FeiFan on 2017/8/30.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDUserCertifySubVCBasic : UIViewController

// 提交输入的回调
@property (nonatomic, copy) void (^ touchEvent) (void);

// 重载数据源
- (void) reloadDatas;

@end
