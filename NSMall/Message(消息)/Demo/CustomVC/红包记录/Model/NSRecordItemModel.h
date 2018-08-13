//
//  NSRecordItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRecordItemModel : NSObject

/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *redpacket_id;//红包ID
@property (nonatomic)NSInteger redpacket_number;//红包流水号
@property (nonatomic,copy)NSString *send_user_id;//发送人ID
@property (nonatomic,copy)NSString *send_user_name;//发送人昵称
@property (nonatomic,copy)NSString *send_hxuser_name;//发送人环信用户名
@property (nonatomic,copy)NSString *send_user_image;//发送人头像路径
@property (nonatomic,copy)NSString *send_time;//发送时间
@property (nonatomic)double redpacket_amount;//红包金额
@property (nonatomic)NSInteger redpacket_count;//红包个数
@property (nonatomic)NSInteger redpacket_type;//红包类型【0=个人普通红包，1=群组普通红包，2=群组拼手气红包】
@property (nonatomic,copy)NSString *remarks;//红包备注/留言
@property (nonatomic,copy)NSString *receive_time;//抢红包时间
@property (nonatomic)double receive_amount;//抢到的红包金额
@property (nonatomic)double commision;//平台收取佣金
@end
