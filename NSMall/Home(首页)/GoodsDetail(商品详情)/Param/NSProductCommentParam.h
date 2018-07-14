//
//  NSProductCommentParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSProductCommentParam : NSObject
/*
 参照在线API接口
 http://doc.huist.cn/index.php?s=/10&page_id=289
 */

@property (nonatomic,copy)NSString *currentPage;//当前页数（不传默认第一页）
@property (nonatomic,copy)NSString *pageSize;//显示个数（不传默认20个）
@property (nonatomic,copy)NSString *productId;//商品ID
@end
