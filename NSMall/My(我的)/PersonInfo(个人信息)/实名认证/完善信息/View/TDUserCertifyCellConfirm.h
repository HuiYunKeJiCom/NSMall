//
//  TDUserCertifyCellConfirm.h
//  Trade
//
//  Created by FeiFan on 2017/8/31.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDUserCertifyDataConfirm.h"

@interface TDUserCertifyCellConfirm : UITableViewCell

@property (nonatomic, assign) TDUserDertifyConfirmState state;

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) UIButton* agreementBtn;
@property (nonatomic, strong) UIButton* disagreementBtn;
@property (nonatomic, strong) UIView* lineView;

@end
