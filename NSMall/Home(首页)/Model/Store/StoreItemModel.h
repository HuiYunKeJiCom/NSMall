//
//  StoreItemModel.h
//  NSMall
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    参看在线API文档
    http://doc.huist.cn/index.php?s=/10&page_id=289
*/

@interface StoreItemModel : NSObject

@property (nonatomic,copy)NSString *store_id;//店铺id
@property (nonatomic,copy)NSString *name;//店铺名称
@property (nonatomic,copy)NSString *business_hours_start;//开始营业时间
@property (nonatomic,copy)NSString *business_hours_end;//结束营业时间
@property (nonatomic,copy)NSString *introduce;//店铺简介描述
@property (nonatomic,copy)NSString *update_time;//创建/更新时间
@property (nonatomic,assign)NSInteger is_like;//店铺是否被当前登录用户点赞过【0=否，1=是】
@property (nonatomic,assign)NSInteger like_number;//店铺点赞人数
@property (nonatomic,copy)NSString *user_phone;//店铺电话
@property (nonatomic,copy)NSString *longitude;//经度
@property(nonatomic,strong)NSString *latitude;// 纬度
@property (nonatomic,copy)NSString *user_address;//店铺地址
@property (nonatomic,copy)NSString *user_id;//卖家ID
@property (nonatomic,copy)NSString *user_name;//卖家昵称
@property (nonatomic,copy)NSString *user_avatar;//卖家头像
@property (nonatomic,copy)NSString *week;//店铺创建/更新时间所属周数
@property (nonatomic,strong)NSArray<NSString *> *storeImageList;//店铺图片
@end
