//
//  ADPayTypeModel.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/4/13.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADPayTypeModel : NSObject
/** 支付方式ID */
@property (nonatomic, copy) NSString      *payment_id;
/** 支付方式名称 */
@property (nonatomic, copy) NSString      *payment_name;
@end
