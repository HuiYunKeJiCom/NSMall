//
//  AdvertListModel.h
//  NSMall
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdvertItemModel.h"

@interface AdvertListModel : NSObject<YYModel>

/*
    参看在线API接口文档
    http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (nonatomic,strong)NSArray<AdvertItemModel *> *advertList;//

@end
