//
//  NSCommentItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSReplyItemModel.h"

@interface NSCommentItemModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *comment_id;//评论id
@property (nonatomic,copy)NSString *content;//评论内容
@property (nonatomic,copy)NSString *create_time;//创建时间
@property (nonatomic,copy)NSString *user_id;//评论人ID
@property (nonatomic,copy)NSString *user_name;//评论人昵称
@property (nonatomic,copy)NSString *user_avatar;//评论人头像
@property (nonatomic,strong)NSArray *commentImageList;//评论图片
@property (nonatomic,strong)NSArray<NSReplyItemModel*> *replyList;//回复列表
@end
