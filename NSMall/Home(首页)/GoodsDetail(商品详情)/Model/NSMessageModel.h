//
//  NSMessageModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMessageModel : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;
@property(nonatomic,strong)NSString *commentId;/* 评论id */
@property(nonatomic,strong)NSString *userId;/* 用户Id */

- (instancetype)initWithUserName:(NSString *)userName imagePath:(NSString *)imagePath content:(NSString *)content time:(NSString *)time commentId:(NSString *)commentId userId:(NSString *)userId;
@end
