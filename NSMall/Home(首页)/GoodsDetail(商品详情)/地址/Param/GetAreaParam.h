//
//  GetAreaParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface GetAreaParam : NSObject

@property (nonatomic,copy)NSString *parentId;//父级ID【该参数为空时默认查找省级数据】

@end
