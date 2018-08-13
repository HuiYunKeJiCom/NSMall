//
//  NetBaseModel.h
//  NSMall
//
//  Created by apple on 2018/4/23.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetBaseModel : NSObject

@property (nonatomic,assign)NSInteger code;//
@property (nonatomic,copy)NSString *message;//
@property (nonatomic,strong)NSMutableDictionary *data;//

@property (nonatomic,readonly)BOOL success;//

@end
