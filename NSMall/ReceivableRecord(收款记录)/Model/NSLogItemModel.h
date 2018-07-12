//
//  NSLogItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/11.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLogItemModel : NSObject
/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@property (nonatomic,copy)NSString *trade_id;//交易ID
@property (nonatomic)long trade_number;//交易流水号
@property (nonatomic,copy)NSString *user_id;//付款人ID
@property (nonatomic,copy)NSString *user_name;//付款人昵称
@property (nonatomic,copy)NSString *hxuser_name;//付款人环信用户名
@property (nonatomic,copy)NSString *user_image;//付款人头像路径
@property (nonatomic,copy)NSString *trade_time;//交易时间
@property (nonatomic)double amount;//交易金额
@property (nonatomic)double commision;//平台收取佣金
@property (nonatomic,strong)NSString *remarks;//店铺图片
@end
