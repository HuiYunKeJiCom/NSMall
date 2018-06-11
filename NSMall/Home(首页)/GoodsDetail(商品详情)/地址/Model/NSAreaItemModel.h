//
//  NSAreaItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAreaItemModel : NSObject
/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */
@property (nonatomic,copy)NSString *ID;//区域ID
@property (nonatomic,copy)NSString *name;//区域名称
@property (nonatomic,copy)NSString *parent_id;//父级ID
@property (nonatomic,assign)NSInteger level;//区域等级【1=省/直辖市，2=地级市，3=区县，4=镇/街道】
@property (nonatomic,assign)NSInteger sort;//排序号

@property (nonatomic, assign) BOOL  isSelected;
@end
