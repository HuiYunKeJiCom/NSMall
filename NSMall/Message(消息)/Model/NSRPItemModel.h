//
//  NSRPItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSRPItemModel : NSObject

/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic)NSInteger is_lucky;//是否手气最佳【0=否，1=是】
@property (nonatomic,copy)NSString *receive_user_id;//抢红包者ID
@property (nonatomic,copy)NSString *receive_user_name;//抢红包者昵称
@property (nonatomic,copy)NSString *receive_hxuser_name;//抢红包者环信用户名
@property (nonatomic,copy)NSString *receive_user_image;//抢红包者头像路径
@property (nonatomic,copy)NSString *receive_time;//抢红包时间
@property (nonatomic)double receive_amount;//抢到的红包金额
@property (nonatomic)double commision;//平台收取佣金
@property (nonatomic,copy)NSString *remarks;//红包备注/留言

@end
