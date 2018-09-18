//
//  NSSendRedPacketVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSRedPacketModel.h"

@interface NSSendRedPacketVC : UIViewController
typedef void(^paramBlock)(NSRedPacketModel *param);
@property (nonatomic, copy) paramBlock                   paramBlock;/* 红包参数回调 */
//self.conversation.type
@property(nonatomic)NSInteger EMConversationType;/* 聊天类型 */
@property(nonatomic)NSInteger groupCount;/* 群总人数 */
@end
