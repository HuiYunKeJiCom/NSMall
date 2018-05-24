//
//  ADBuildOrderModel.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/4/13.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADBuildOrderModel : NSObject
/** 订单创建时间 */
@property (nonatomic, copy) NSString      *addTime;
/** 支付金额 */
@property (nonatomic, copy) NSString      *payPrice;
/** 地址标签【家、公司、其他】 */
@property (nonatomic, copy) NSString      *label;
/** 所属区域【省、市、区】 */
@property (nonatomic, copy) NSString      *area_name;
/** 详细地址 */
@property (nonatomic, copy) NSString      *detail_address;
/** 手机号码 */
@property (nonatomic, copy) NSString      *mobile;
/** 座机号 */
@property (nonatomic, copy) NSString      *telephone;
/** 收件人姓名 */
@property (nonatomic, copy) NSString      *trueName;
/** 支邮编号码 */
@property (nonatomic, copy) NSString      *post_code;
/** 订单号【已根据商家拆分】 */
@property (nonatomic, copy) NSString      *orderId;
@end
