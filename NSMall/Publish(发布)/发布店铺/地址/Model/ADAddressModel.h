//
//  ADAddressModel.h
//  AdelMall
//
//  Created by 张锐凌 on 2018/4/2.
//  Copyright © 2018年 Adel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADAddressModel : NSObject
/** id */
@property (nonatomic, copy) NSString      *address_id;
/** 地址标签【家、公司、其他】 */
@property (nonatomic, copy) NSString      *label;
/** 所属区域id【省、市、区】 */
@property (nonatomic, copy) NSString      *area_id;
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
/** 邮编号码 */
@property (nonatomic, copy) NSString      *post_code;
/** 是否为默认地址【0=否，1=是】 */
@property (nonatomic, copy) NSString      *is_default;
@end
