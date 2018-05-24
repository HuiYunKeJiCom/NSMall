//
//  ADPaymentOrderView.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/5.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADBuildOrderModel;
@interface ADPaymentOrderView : UIView
/** 订单模型 */
@property(nonatomic,strong)ADBuildOrderModel *buildOrderModel;
@end
