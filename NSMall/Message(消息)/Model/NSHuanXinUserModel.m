//
//  NSHuanXinUserModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSHuanXinUserModel.h"

@implementation NSHuanXinUserModel
- (instancetype)initWithBuddy:(NSString *)buddy
{
    self = [super init];
    if (self) {
        _buddy = buddy;
        _nickname = @"";
        _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
    }
    
    return self;
}

-(void)getInformationWith:(NSMutableArray <NSFriendItemModel *>*)array{
    for (NSFriendItemModel *item in array) {
        if([item.hx_user_name isEqualToString:_buddy]){
            _user_id = item.user_id;
            _nick_name = item.nick_name;
            _hx_user_name = item.hx_user_name;
            _user_avatar = item.user_avatar;
            _is_blocked = item.is_blocked;
        }
    }
}

-(void)setNickname:(NSString *)nickname{
    if(_nick_name){
        _nickname = _nick_name;
    }
}

-(void)setAvatarURLPath:(NSString *)avatarURLPath{
    if(_user_avatar){
        _avatarURLPath = _user_avatar;
    }
}

@end
