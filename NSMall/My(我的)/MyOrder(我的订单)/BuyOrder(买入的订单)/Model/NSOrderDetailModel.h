//
//  NSOrderDetailModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAddressItemModel.h"

@interface NSOrderDetailModel : NSObject<YYModel>

@property (nonatomic,strong)NSAddressItemModel *defaultAddress;//默认收货地址数据
@end
