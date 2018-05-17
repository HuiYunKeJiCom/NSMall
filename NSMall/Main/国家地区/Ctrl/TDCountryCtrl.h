//
//  TDCountryCtrl.h
//  Trade
//
//  Created by FeiFan on 2017/9/8.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "TDBaseViewController.h"

@class TDCountryCodesModel;

@interface TDCountryCtrl : UIViewController

// 选择了国家码数据的回调
@property (nonatomic, copy) void (^ didSelectedCountryModel) (TDCountryCodesModel* model);

@end
