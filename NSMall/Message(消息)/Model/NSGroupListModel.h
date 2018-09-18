//
//  NSGroupListModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/30.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSGroupModel.h"

@interface NSGroupListModel : NSObject

/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,strong)NSArray<NSGroupModel *> *group;

@end
