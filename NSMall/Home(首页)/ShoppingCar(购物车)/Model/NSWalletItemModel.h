//
//  NSWalletItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/31.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSWalletItemModel : NSObject<YYModel>
@property (copy,nonatomic)NSString *wallet_id;/* 钱包用户关联ID */
@property (copy,nonatomic)NSString *wallet_name;/* 钱包名称 */
@property (copy,nonatomic)NSString *wallet_address;/* 钱包地址 */
@property (copy,nonatomic)NSString *is_default;/* 是否为默认钱包【0=否，1=是】 */
@end
