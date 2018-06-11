//
//  LabelItemModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/8.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参看在线API接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@interface LabelItemModel : NSObject
@property (nonatomic,copy)NSString *label_id;//标签ID
@property (nonatomic,copy)NSString *label_name;//标签名称
@property (nonatomic,copy)NSString *sort;//标签排序号
@end
