//
//  NSRPRecordModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/13.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSRecordItemModel.h"

@interface NSRPRecordModel : NSObject

@property (nonatomic,assign)NSInteger rows;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,assign)NSInteger pageSize;
@property (nonatomic,assign)NSInteger totalPage;
@property (nonatomic,copy)NSString *user_id;//当前用户ID
@property (nonatomic,copy)NSString *user_name;//当前用户昵称
@property (nonatomic,copy)NSString *hx_user_name;//当前用户环信用户名
@property (nonatomic,copy)NSString *user_image;//当前用户头像路径
@property (nonatomic)double amount_total;//收到红包总金额
@property (nonatomic)NSInteger redpacket_total;//收到红包数量
@property (nonatomic)NSInteger lucky_total;//手气最佳数量
@property (nonatomic,strong)NSArray<NSRecordItemModel *> *list;

@end
