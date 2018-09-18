//
//  NSGroupModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSGroupModel : NSObject

/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *group_id;//群组ID
@property (nonatomic,copy)NSString *group_name_json;//群组名称JSON
@property (nonatomic,copy)NSString *group_name;//群组名称
@property (nonatomic,copy)NSString *groupDescription;//群组描述
@property (nonatomic,copy)NSString *owner;//群主(环信username)
@property (nonatomic)NSInteger is_public;//是否是公开群
@property (nonatomic)NSInteger membersonly;//加入群是否需要批准，默认值是0
@property (nonatomic)NSInteger allowinvites;//是否允许群成员邀请别人加入此群。1=允许群成员邀请人加入此群，0=只有群主才可以往群里加人。
@property (nonatomic)NSInteger invite_need_confirm;//被邀请人是否需要确认
@property (nonatomic)NSInteger affiliations_count;//当前群组成员数
@property (nonatomic)NSInteger maxusers;//群组成员最大数（包括群主），默认值200，最大值2000
@end
