//
//  ADReceivingAddressViewController.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/3/9.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAddressItemModel.h"

typedef void(^AddressBlock)(NSAddressItemModel *model);

@interface ADReceivingAddressViewController : UIViewController

/** 保存收货地址信息后的地址信息回调 **/
@property (nonatomic, copy) AddressBlock                   addressBlock;
@end
