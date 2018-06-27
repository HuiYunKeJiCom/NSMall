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

@property (nonatomic,copy)NSString *currentPage;//当前页数（不传默认第一页）
@property (nonatomic,copy)NSString *pageSize;//显示个数（不传默认20个）
@property (nonatomic,copy)NSString *keyword;//搜索关键字
@property (nonatomic,copy)NSString * searchType;//搜索类型【0=商品（默认值），1=店铺】
@property (nonatomic,copy)NSString *categoryId;//分类ID【该参数在搜索类型为商品时可用】
@property (nonatomic,copy)NSString *sort;//排序字段【该参数在搜索类型为商品时可用】
@property (nonatomic,copy)NSString *sortType;//排序方式【ASC=顺序，DESC=倒序（默认值）】【该参数在搜索类型为商品时可用】
@property (nonatomic,copy)NSString *userId;//商品/店铺所属用户ID

@end
