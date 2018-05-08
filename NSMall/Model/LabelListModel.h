//
//  LabelListModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabelItemModel.h"

@interface LabelListModel : NSObject
/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (nonatomic,strong)NSArray<LabelItemModel *> *labelList;//
@end
