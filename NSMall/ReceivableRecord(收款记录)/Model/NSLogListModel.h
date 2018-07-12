//
//  NSLogListModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSLogItemModel.h"

@interface NSLogListModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *day;//交易ID
@property (nonatomic,strong)NSArray<NSLogItemModel *> *list;
@end
