//
//  ShopAddressParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopAddressParam : NSObject
///地址名称
@property (nonatomic, strong) NSString* address;
///地址坐标
@property (nonatomic) CLLocationCoordinate2D location;
@end
