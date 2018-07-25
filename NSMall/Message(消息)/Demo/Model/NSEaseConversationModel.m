//
//  NSEaseConversationModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/7/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSEaseConversationModel.h"
#import <Hyphenate/EMMessage.h>

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
        
        EMMessage *latestMessage = _conversation.latestMessage;
        NSDictionary *ext = latestMessage.ext;
        UserModel *userModel = [UserModel modelFromUnarchive];
        
        //        _title = _conversation.conversationId;
        if (conversation.type == EMConversationTypeChat) {
            //            _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
            if([latestMessage.from isEqualToString:userModel.hx_user_name]){
                _title = userModel.user_name;
                NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:userModel.pic_img]];
                _avatarImage =  [UIImage imageWithData:data];
            }else{
                _title = [ext objectForKey:@"nick"];
                NSData *data = [NSData  dataWithContentsOfURL:[NSURL URLWithString:[ext objectForKey:@"avatar_url"]]];
                _avatarImage =  [UIImage imageWithData:data];
            }
            
            
        }
        else{
            _title = [ext objectForKey:@"nick"];
            _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
        }
    }
    
    return self;
}
@end
