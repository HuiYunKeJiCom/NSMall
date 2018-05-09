//
//  CertificationParam.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@interface CertificationParam : NSObject
@property (nonatomic,copy)NSString *realName;//姓名
@property (nonatomic,copy)NSString *idcard;//身份证号
@property (nonatomic,copy)NSString *imagePaths;//身份证照片【正反面照片，手持身份证照片，共三张，用逗号分隔】
@end
