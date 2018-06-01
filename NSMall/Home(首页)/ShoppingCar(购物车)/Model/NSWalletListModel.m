//
//  NSWalletListModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSWalletListModel.h"

@implementation NSWalletListModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{@"walletList":[NSWalletItemModel class]};
}
@end
