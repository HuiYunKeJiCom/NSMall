//
//  NSAddressVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import "DCBaseSetViewController.h"

@interface NSAddressVC : DCBaseSetViewController
typedef void(^stringBlock)(NSString *string);
@property (nonatomic, copy) stringBlock                   stringBlock;/* 保存修改的信息回调 */
@end
