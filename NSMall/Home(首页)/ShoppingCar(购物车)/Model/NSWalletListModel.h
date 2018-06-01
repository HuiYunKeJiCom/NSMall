//
//  NSWalletListModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSWalletItemModel.h"

@interface NSWalletListModel : NSObject<YYModel>
@property (copy,nonatomic)NSString *orderId;/* 订单ID【多个ID用逗号分隔】 */
@property (strong,nonatomic)NSArray<NSWalletItemModel *> *walletList;
@end
