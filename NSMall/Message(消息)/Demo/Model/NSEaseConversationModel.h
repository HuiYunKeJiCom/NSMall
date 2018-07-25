//
//  NSEaseConversationModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/24.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IConversationModel.h"


@interface NSEaseConversationModel : NSObject<IConversationModel>

/** @brief 会话对象 */
@property (strong, nonatomic, readonly) EMConversation *conversation;
/** @brief 会话的标题(主要用户UI显示) */
@property (strong, nonatomic) NSString *title;
/** @brief conversationId的头像url */
@property (strong, nonatomic) NSString *avatarURLPath;
/** @brief conversationId的头像 */
@property (strong, nonatomic) UIImage *avatarImage;


/*!
 @method
 @brief 初始化会话对象模型
 @param conversation    会话对象
 @return 会话对象模型
 */
- (instancetype)initWithConversation:(EMConversation *)conversation;

@end
