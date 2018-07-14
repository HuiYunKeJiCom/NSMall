//
//  NSCommentListModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSCommentItemModel.h"

@interface NSCommentListModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,assign)NSInteger rows;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger totalPage;
@property(nonatomic,strong)NSArray<NSCommentItemModel *> *commentList;

@end
