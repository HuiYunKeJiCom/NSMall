//
//  NSAddressItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@interface NSAddressItemModel : NSObject

@property (nonatomic,copy)NSString *address_id;//收货地址id
@property (nonatomic,copy)NSString *province_id;//省份/直辖市id
@property (nonatomic,copy)NSString *province_name;//省份/直辖市名称
@property (nonatomic,copy)NSString *city_id;//市区id
@property (nonatomic,copy)NSString *city_name;//市区名称
@property (nonatomic,copy)NSString *district_id;//区县id
@property (nonatomic,copy)NSString *district_name;//区县名称
@property (nonatomic,copy)NSString *street_id;//街道ID（北京、天津、河北才有该值）
@property (nonatomic,copy)NSString *street_name;//街道名称（北京、天津、河北才有该值）
@property (nonatomic,copy)NSString *user_address;//详细地址
@property (nonatomic,copy)NSString *user_tag;//地址标签【家、公司、学校、其他】
@property (nonatomic,copy)NSString *user_phone;//手机号码
@property (nonatomic,copy)NSString *user_name;//收件人姓名
@property (nonatomic,copy)NSString *user_zipcode;//邮编号码
@property (nonatomic,assign)NSInteger is_default;//是否为默认地址【0=否，1=是】

@end
