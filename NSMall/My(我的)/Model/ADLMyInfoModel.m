//
//  ADLMyInfoModel.m
//  Kart
//
//  Created by 朱鹏 on 17/3/9.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "ADLMyInfoModel.h"

@implementation ADLMyInfoModel

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName num:(NSString *)num {
    
    if (self = [super init]) {
        
        _title = title;
        _imageName = imageName;
        _num = num;
        
    }
    
    return self;
}

@end
