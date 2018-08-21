//
//  NSExpressModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSExpressModel : NSObject

@property (copy,nonatomic)NSString *ship_code;/* 快递公司标识【用于查询订单物流信息】 */
@property (copy,nonatomic)NSString *ship_name;/* 快递公司名称 */

@end
