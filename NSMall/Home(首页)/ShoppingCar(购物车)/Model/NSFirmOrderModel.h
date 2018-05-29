//
//  NSFirmOrderModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/29.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAddressItemModel.h"
#import "LZShopModel.h"

@interface NSFirmOrderModel : NSObject<YYModel>
@property (nonatomic)double payment_price;//订单总金额（诺一股）【包含运费】
@property (nonatomic)double payment_score;//订单总金额（人民币）【包含运费】
@property (nonatomic,strong)NSAddressItemModel *defaultAddress;//默认收货地址数据
@property (strong,nonatomic)NSArray<LZShopModel *> *cartList;
@end
