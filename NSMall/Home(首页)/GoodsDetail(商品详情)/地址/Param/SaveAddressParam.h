//
//  SaveAddressParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface SaveAddressParam : NSObject
@property (nonatomic,copy)NSString *addressId;//收货地址ID【编辑操作该参数必填】
@property (nonatomic,copy)NSString *provinceId;//省份/直辖市id
@property (nonatomic,copy)NSString *provinceName;//省份/直辖市名称
@property (nonatomic,copy)NSString *cityId;//市区id
@property (nonatomic,copy)NSString *cityName;//市区名称
@property (nonatomic,copy)NSString *districtId;//区县id
@property (nonatomic,copy)NSString *districtName;//区县名称
@property (nonatomic,copy)NSString *streetId;//街道ID（部分区县有街道时必填）
@property (nonatomic,copy)NSString *streetName;//街道名称（部分区县有街道时必填）
@property (nonatomic,copy)NSString *userAddress;//详细地址
@property (nonatomic,copy)NSString *userTag;//地址标签【家、公司、学校、其他】
@property (nonatomic,copy)NSString *userPhone;//手机号码
@property (nonatomic,copy)NSString *userName;//收件人姓名
@property (nonatomic,copy)NSString *zipCode;//邮编号码【新增不传该参数后台默认为000000】
@property (nonatomic,copy)NSString *isDefault;//是否为默认地址【0=否（新增默认值），1=是】
@end
