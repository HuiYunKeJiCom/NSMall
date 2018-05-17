//
//  MBProgressHUD+Extension.m
//  Trade
//
//  Created by FeiFan on 2017/9/5.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

+ (instancetype)mb_showWaitingWithText:(NSString *)text detailText:(NSString *)detailText inView:(UIView *)view {
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:view];
    hud.labelText = text;
    hud.detailsLabelText = detailText;
    [view addSubview:hud];
    [hud show:YES];
    return hud;
}


+ (MB_INSTANCETYPE) mb_showOnlyText:(NSString*)text detail:(NSString*)detail delay:(NSTimeInterval)delay inView:(UIView*)view {
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:view];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.detailsLabelText = detail;
    hud.labelFont = UIBoldFontSize(14);
    hud.detailsLabelFont = UISystemFontSize(14);
    [view addSubview:hud];
    [hud show:YES];
    if (delay > 0) {
        [hud hide:YES afterDelay:delay];
    }
    return hud;
}


@end
