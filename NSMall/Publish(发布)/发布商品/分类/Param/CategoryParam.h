//
//  CategoryParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface CategoryParam : NSObject
@property (nonatomic,copy)NSString *parentId;//父级Id【此参数为空时，返回一次性返回所有分类（树结构），不为空时，返回此父ID所属子类别】
@end
