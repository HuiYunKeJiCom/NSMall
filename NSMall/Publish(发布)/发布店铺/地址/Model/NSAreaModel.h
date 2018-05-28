//
//  NSAreaModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAreaItemModel.h"

@interface NSAreaModel : NSObject
/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (nonatomic,strong)NSArray<NSAreaItemModel *> *result;//

@end
