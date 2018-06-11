//
//  NSAddressModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAddressItemModel.h"

/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@interface NSAddressModel : NSObject

@property (nonatomic,assign)NSInteger rows;//总条数
@property (nonatomic,assign)NSInteger totalPage;//总页数
@property (nonatomic,assign)NSInteger currentPage;//当前页数
@property (nonatomic,assign)NSInteger pageSize;//显示个数
@property (nonatomic,strong)NSArray<NSAddressItemModel *> *addressList;//收货地址集合数据

@end
