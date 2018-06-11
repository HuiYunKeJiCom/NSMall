//
//  GetAddressParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface GetAddressParam : NSObject

@property (nonatomic,copy)NSString *pageSize;//显示个数（默认20个）
@property (nonatomic,copy)NSString *currentPage;//当前页数（默认第一页）
@property (nonatomic,copy)NSString *addressId;//地址ID【用于查找要修改的地址信息】
@property (nonatomic,copy)NSString *isDefault;//是否只查找默认地址【0=否，1=是,不传该参数查找所有】（查找默认地址时此参数必传）

@end
