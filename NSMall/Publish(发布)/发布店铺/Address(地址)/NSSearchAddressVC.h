//
//  NSSearchAddressVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSSearchAddressVC : UIViewController
typedef void(^stringBlock)(NSString *string);
@property (nonatomic, copy) stringBlock                   stringBlock;/* 保存修改的信息回调 */
@end
