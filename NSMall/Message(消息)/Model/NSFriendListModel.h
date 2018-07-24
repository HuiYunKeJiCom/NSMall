//
//  NSFriendListModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSFriendItemModel.h"

@interface NSFriendListModel : NSObject

/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */
@property (nonatomic,strong)NSArray<NSFriendItemModel *> *list;

@end
