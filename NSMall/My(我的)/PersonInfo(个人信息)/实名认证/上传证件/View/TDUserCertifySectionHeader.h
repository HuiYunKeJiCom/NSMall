//
//  TDUserCertifySectionHeader.h
//  Trade
//
//  Created by FeiFan on 2017/9/8.
//  Copyright © 2017年 FeiFan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TDUserCertifySectionHeaderPadding 10 // title间隔

static CGFloat const TDUserCertifySectionHeaderTitleFontSize = 13.f; // 字体大小

@interface TDUserCertifySectionHeader : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel* titleLabel;

@end


@interface TDUserCertifySectionHeaderDouble : UITableViewHeaderFooterView

@property (nonatomic, strong) UILabel* titleLabel1;
@property (nonatomic, strong) UILabel* titleLabel2;


@end
