//
//  GetListParam.h
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


@interface GetListParam : NSObject
@property (nonatomic,copy)NSString *currentPage;//当前页数（默认第一页）
@property (nonatomic,copy)NSString *pageSize;//显示个数（默认20个）
@end
