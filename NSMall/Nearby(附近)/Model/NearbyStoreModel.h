//
//  NearbyStoreModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSStoreModel.h"

/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@interface NearbyStoreModel : NSObject
@property (nonatomic,strong)NSArray<NSStoreModel *> *storeList;//商品标签集合参数
@end
