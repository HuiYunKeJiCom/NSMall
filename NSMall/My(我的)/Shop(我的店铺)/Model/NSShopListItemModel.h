//
//  NSShopListItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/18.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelItemModel.h"

@interface NSShopListItemModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *store_id;//店铺id
@property (nonatomic,copy)NSString *name;//店铺名称
@property (nonatomic,copy)NSString *business_hours_start;//开始营业时间
@property (nonatomic,copy)NSString *business_hours_end;//结束营业时间
@property (nonatomic,copy)NSString *introduce;//店铺简介描述
@property (nonatomic,copy)NSString *user_phone;//店铺电话
@property (nonatomic)double longitude;//经度
@property (nonatomic)double latitude;//纬度
@property (nonatomic,copy)NSString *address;//店铺地址
@property (nonatomic,strong)NSArray *storeImageList;//店铺图片
@property (nonatomic,strong)NSArray<LabelItemModel *> *labelList;//
@end
