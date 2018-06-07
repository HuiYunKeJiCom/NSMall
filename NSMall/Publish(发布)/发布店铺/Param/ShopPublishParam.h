//
//  ShopPublishParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/7.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopPublishParam : NSObject
/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@property (nonatomic,copy,nonnull)NSString *storeName;//店铺名称
@property (nonatomic,copy,nonnull)NSString *introduce;//店铺简介描述
@property (nonatomic,copy,nonnull)NSString *mobile;//联系人电话
@property (nonatomic,copy,nonnull)NSString *businessHoursStart;//开始营业时间 【格式：09：00】
@property (nonatomic,copy,nonnull)NSString *businessHoursEnd;//结束营业时间【格式：22：00】
@property (nonatomic,copy,nonnull)NSString *longitude;//经度【地图选取位置后返回的值】
@property (nonatomic,copy,nonnull)NSString *latitude;//纬度【地图选取位置后返回的值】
@property (nonatomic,copy,nonnull)NSString *address;//店铺地址【地图选取位置后返回的值或者手工编辑】
@property (nonatomic,copy,nonnull)NSString *labelId;//标签ID【多个标签用逗号分隔】
@property (nonatomic,copy,nonnull)NSString *imagePath;//店铺图片路径【多张图片用逗号分隔】
@end
