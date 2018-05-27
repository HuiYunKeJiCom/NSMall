//
//  SearchParam.h
//  NSMall
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    参照在线API接口
    http://doc.huist.cn/index.php?s=/10&page_id=289
 */

@interface SearchParam : NSObject

@property (nonatomic,copy)NSString *currentPage;//
@property (nonatomic,copy)NSString *pageSize;//
@property (nonatomic,copy)NSString *keyword;//
@property (nonatomic,copy)NSString * searchType;//
@property (nonatomic,copy)NSString *categoryId;//
@property (nonatomic,copy)NSString *sort;//
@property (nonatomic,copy)NSString *sortType;//
@property (nonatomic,copy)NSString *userId;//

@end
