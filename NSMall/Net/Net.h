//
//  Net.h
//  NSMall
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetWorking.h"

extern AFHTTPSessionManager *httpManager;

@interface Net : NSObject

+ (AFHTTPSessionManager *)httpManager;

@end
