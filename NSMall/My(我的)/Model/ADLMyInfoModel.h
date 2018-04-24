//
//  ADLMyInfoModel.h
//  Kart
//
//  Created by 朱鹏 on 17/3/9.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADLMyInfoModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *num;

- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName num:(NSString *)num;

@end
