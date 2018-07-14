//
//  NSPublishCommentParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/14.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPublishCommentParam : NSObject
/*
 参照在线API接口
 http://doc.huist.cn/index.php?s=/10&page_id=289
 */

@property (nonatomic,copy)NSString *productId;//商品ID
@property (nonatomic,copy)NSString *content;//商品评论
@end
