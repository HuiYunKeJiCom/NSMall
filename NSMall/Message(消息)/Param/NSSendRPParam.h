//
//  NSSendRPParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/10.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSendRPParam : NSObject

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@property (nonatomic,copy)NSString *walletId;//付款钱包ID
@property (nonatomic,copy)NSString *tradePassword;//交易密码
@property (nonatomic,copy)NSString *redpacketAmount;//红包金额
@property (nonatomic,copy)NSString *redpacketType;//红包类型【0=个人普通红包，1=群组普通红包，2=群组拼手气红包】
@property (nonatomic,copy)NSString *redpacketCount;//红包个数【个人红包不填，后台默认为1个】
@property (nonatomic,copy)NSString *remarks;//红包备注/留言

@end
