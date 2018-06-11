//
//  NearbyStoreParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@interface NearbyStoreParam : NSObject
@property (nonatomic,copy)NSString *keyword;//搜索关键字【店铺名、店铺简介、店铺地址、店铺标签】
@property (nonatomic,copy)NSString *distance;//筛选距离【默认1千米，单位：千米】
@property (nonatomic,copy)NSString *longitude;//经度【当前位置】
@property (nonatomic,copy)NSString *latitude;//纬度【当前位置】

@end
