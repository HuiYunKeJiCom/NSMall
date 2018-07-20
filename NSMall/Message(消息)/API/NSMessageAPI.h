//
//  NSMessageAPI.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMessageAPI : NSObject

/*
 同意添加好友
 */
+ (void)acceptFriendWithParam:(NSString *)param success:(void (^)(void))success faulre:(void (^)(NSError *))failure;

@end
