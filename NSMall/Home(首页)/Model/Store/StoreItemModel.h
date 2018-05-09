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

@property (nonatomic,copy)NSString *store_id;//
@property (nonatomic,copy)NSString *name;//
@property (nonatomic,copy)NSString *business_hours_start;//
@property (nonatomic,copy)NSString *business_hours_end;//
@property (nonatomic,copy)NSString *introduce;//
@property (nonatomic,copy)NSString *update_time;//
@property (nonatomic,assign)NSInteger is_like;//
@property (nonatomic,assign)NSInteger like_number;//
@property (nonatomic,copy)NSString *user_phone;//
@property (nonatomic,copy)NSString *longitude;//
@property (nonatomic,copy)NSString *user_address;//
@property (nonatomic,copy)NSString *user_id;//
@property (nonatomic,copy)NSString *user_name;//
@property (nonatomic,copy)NSString *user_avatar;//
@property (nonatomic,copy)NSString *week;//
@property (nonatomic,strong)NSArray<NSString *> *storeImageList;//
@end
