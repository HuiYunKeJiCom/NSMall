//
//  NSRedPacketModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRedPacketModel : NSObject

/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@property (nonatomic,copy)NSString *redpacket_id;//红包ID
@property (nonatomic,copy)NSString *remarks;//红包备注/留言



@end
