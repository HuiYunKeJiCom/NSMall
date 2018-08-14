//
//  NSUserCommentParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/14.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserCommentParam : NSObject

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */
@property (nonatomic,copy)NSString *currentPage;//当前页数（不传默认第一页）
@property (nonatomic,copy)NSString *pageSize;//显示个数（不传默认20个）
@property (nonatomic,copy)NSString *userId;//用户ID
@end
