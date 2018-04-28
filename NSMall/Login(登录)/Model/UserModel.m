//
//  UserModel.m
//  NSMall
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

YYModelCodingImplementation

static UserModel *memoryUserModel = nil;

+ (instancetype)userModel{
    if (!memoryUserModel) {
        memoryUserModel = [self modelFromUnarchive];
    }
    return memoryUserModel;
}

+ (instancetype)modelFromUnarchive{
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:kLoginUserInfoPath];
    return userModel;
}

- (BOOL)archive{
    return [NSKeyedArchiver archiveRootObject:self toFile:kLoginUserInfoPath];
}

+ (BOOL)removeArchive{
    memoryUserModel = nil;
    return [[NSFileManager defaultManager] removeItemAtPath:kLoginUserInfoPath error:nil];
}

@end
