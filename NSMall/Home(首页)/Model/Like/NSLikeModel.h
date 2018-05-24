//
//  NSLikeModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLikeModel : NSObject

/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (nonatomic)NSInteger like_number;//商品点赞人数
@property (nonatomic,assign)Boolean is_like;//当前用户是否已点赞

@end
