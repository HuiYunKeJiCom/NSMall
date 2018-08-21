//
//  NSDeliverParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDeliverParam : NSObject

@property (copy,nonatomic)NSString *orderId;/* 订单ID */
@property (copy,nonatomic)NSString *shipNumber;/* 快递单号 */
@property (copy,nonatomic)NSString *shipCode;/* 快递公司标识 */
@property (copy,nonatomic)NSString *shipName;/* 快递公司名称 */

@end
