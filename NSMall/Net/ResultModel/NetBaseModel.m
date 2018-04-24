//
//  NetBaseModel.m
//  NSMall
//
//  Created by apple on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NetBaseModel.h"

@implementation NetBaseModel

- (BOOL)success{
    if (_code == 1) {
        return YES;
    }else{
        return NO;
    }
}

@end
