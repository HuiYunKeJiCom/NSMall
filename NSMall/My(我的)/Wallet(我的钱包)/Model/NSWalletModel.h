//
//  NSWalletModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletItemModel.h"

@interface NSWalletModel : NSObject<YYModel>
@property (strong,nonatomic)NSArray<WalletItemModel *> *walletList;
@end
