//
//  YWAddressInfoModel.h
//  YWChooseAddress
//
//  Created by Candy on 2018/2/8.
//  Copyright © 2018年 com.zhiweism. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YWAddressInfoModel : NSObject

@property (nonatomic, copy) NSString * addressId;            // 收货地址ID【该参数为空时新增，反之修改】
@property (nonatomic, copy) NSString * label;            // 地址标签【家、公司、其他】
@property (nonatomic, copy) NSString * trueName;             // 收件人姓名
@property (nonatomic, copy) NSString * areaId;             // 所属区域ID【省、市ID省略，只需要传县区ID】
@property (nonatomic, copy) NSString * areaName;    
//@property (nonatomic, copy) NSString * areaAddress;         // 地区（四川省成都市武侯区）
@property (nonatomic, copy) NSString * detailAddress;       // 详细地址（如：红牌楼街道下一站都市B座406）
@property (nonatomic, copy) NSString * mobile;            // 手机号
@property (nonatomic, copy) NSString * telephone;            // 座机号
@property (nonatomic, copy) NSString * postCode;            // 邮编号码【后台默认000000】
@property (nonatomic, copy) NSString * isDefault;            // 是否为默认地址【0=否（默认），1=是】
//@property (nonatomic, assign) BOOL     isDefaultAddress;    // 是否是默认地址

@end
