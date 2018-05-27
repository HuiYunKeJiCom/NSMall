//
//  NSCollectModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCollectModel : NSObject
/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (nonatomic)NSInteger favorite_number;//商品收藏人数
@property (nonatomic,assign)Boolean is_collect;//当前用户是否已收藏
@end
