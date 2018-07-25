//
//  NSEaseConversationModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSEaseConversationModel.h"
#import <Hyphenate/EMMessage.h>
#import "UserProfileManager.h"


#if ENABLE_LITE == 1
#import <HyphenateLite/EMConversation.h>
#else
#import <Hyphenate/EMConversation.h>
#endif

@implementation NSEaseConversationModel
- (instancetype)initWithConversation:(EMConversation *)conversation
{
    self = [super init];
    if (self) {
        _conversation = conversation;
        UserModel *userModel = [UserModel modelFromUnarchive];
        EMMessage *latestMessage = _conversation.lastReceivedMessage;
        NSDictionary *ext = latestMessage.ext;
        
        //        _title = _conversation.conversationId;
        if (conversation.type == EMConversationTypeChat) {
            //            _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];

                    _title = [ext objectForKey:@"nick"];
                    NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:[ext objectForKey:@"avatar_url"]]];
                    _avatarImage =  [UIImage imageWithData:data];
        }
        else{
            _title = [ext objectForKey:@"nick"];
            _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
        }
    }
    
    return self;
}

-(void)getInformationWith:(NSMutableArray <NSFriendItemModel *>*)array{
    EMMessage *latestMessage = _conversation.latestMessage;
   
    UserModel *userModel = [UserModel modelFromUnarchive];
    if([userModel.hx_user_name isEqualToString:latestMessage.from]){
        for (NSFriendItemModel *item in array) {
            if([item.hx_user_name isEqualToString:latestMessage.to]){
                _title = item.nick_name;
                NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:item.user_avatar]];
                _avatarImage =  [UIImage imageWithData:data];
            }
        }
    }

}
@end
