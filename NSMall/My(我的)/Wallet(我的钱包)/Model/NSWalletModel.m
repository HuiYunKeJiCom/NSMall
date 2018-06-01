//
//  NSWalletModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSWalletModel.h"

@implementation NSWalletModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"walletList":[WalletItemModel class]};
}
@end
