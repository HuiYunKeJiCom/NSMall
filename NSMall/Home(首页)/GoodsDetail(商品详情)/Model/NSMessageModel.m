//
//  NSMessageModel.m
//  NSMall
//
//  Created by 张锐凌 on 2018/5/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "NSMessageModel.h"

@implementation NSMessageModel
- (instancetype)initWithUserName:(NSString *)userName imagePath:(NSString *)imagePath content:(NSString *)content time:(NSString *)time commentId:(NSString *)commentId{
    if (self = [super init]) {
        
        _userName = userName;
        _imagePath = imagePath;
        _content = content;
        _time = time;
        _commentId = commentId;
    }
    
    return self;
}
@end
