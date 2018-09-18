//
//  NSCreateGroupParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/22.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCreateGroupParam : NSObject<YYModel>

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@property (nonatomic,copy)NSString *groupName;//群组名称
@property (nonatomic,copy)NSString *groupDescription;//群组描述
@property (nonatomic,copy)NSString *hxuserNames;//群成员环信username（不包含群主，一次最多选择60个人，格式：[“test1”,”test2”]）
@property(nonatomic)BOOL isPublic;/* 是否是公开群，默认值是false */
@property(nonatomic)BOOL membersOnly;/* 加入群是否需要批准，默认值是false */
@property(nonatomic)BOOL allowinvites;/* 是否允许群成员邀请别人加入此群，默认值是true */
@property(nonatomic)BOOL isNeedConfirm;/* 被邀请人是否需要确认，默认值是false */
@property (nonatomic,copy)NSString *maxusers;//群组成员最大数（包括群主），默认值200，最大值2000
@property (nonatomic,copy)NSString *groupNameJson;//群组名称JSON

@end
