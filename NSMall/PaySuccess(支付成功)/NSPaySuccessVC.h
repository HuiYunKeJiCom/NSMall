//
//  NSPaySuccessVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/19.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPageModel.h"

@interface NSPaySuccessVC : UIViewController
-(void)setUpDataWithModel:(UserPageModel *)userPageM andAmount:(NSString *)amount;
@end
