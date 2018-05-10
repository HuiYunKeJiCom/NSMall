//
//  ChatViewController.h
//  浙江社交
//
//  Created by gyh on 16/1/26.
//  Copyright © 2016年 lideliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewController : UIViewController
/**
 *  聊天信息
 */
@property (nonatomic , strong) EMMessage *message;

/**
 *  聊天好友
 */
@property (nonatomic , copy) NSString * fromname;
@end
