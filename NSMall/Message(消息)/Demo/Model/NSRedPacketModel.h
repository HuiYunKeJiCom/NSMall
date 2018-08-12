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

@property(nonatomic,assign)BOOL is_money_msg;/* 用此来判断是否是红包 */
@property(nonatomic,copy)NSString *rp_amount;/* 红包金额 */
@property (nonatomic,copy)NSString *rp_type;//红包类型【0=个人普通红包，1=群组普通红包，2=群组拼手气红包】
@property (nonatomic,copy)NSString *rp_count;//红包个数

@property (nonatomic,copy)NSString *rp_id;//红包ID
@property (nonatomic,copy)NSString *rp_leave_msg;//红包备注/留言
@property (nonatomic,copy)NSString *money_sponsor_name;//红包左下角信息
@property (nonatomic,copy)NSString *send_username;//发送红包环信用户名


@end
