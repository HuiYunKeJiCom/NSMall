//
//  NSRPDetailVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSRPListModel.h"

@interface NSRPDetailVC : UIViewController
//-(void)setUpDataWithRadpacketID:(NSString *)redpacketID;
-(void)setUpDataWith:(NSRPListModel *)rpListModel;

@end
