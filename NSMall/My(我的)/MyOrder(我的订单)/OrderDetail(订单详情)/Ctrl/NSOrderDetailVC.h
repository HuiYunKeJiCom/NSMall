//
//  NSOrderDetailVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/20.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSOrderDetailVC : UIViewController
-(void)loadDataWithType:(NSString *)type andOrderID:(NSString *)orderID;
@end
