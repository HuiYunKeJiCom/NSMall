//
//  AppVersionModel.h
//  NSMall
//
//  Created by 张锐凌 on 2018/7/17.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppVersionModel : NSObject

/*
 参见在线接口文档
 http://doc.huist.cn/index.php?s=/10&page_id=203
 */

@property (nonatomic,copy)NSString *ID;//版本ID
@property (nonatomic,copy)NSString *version;//APP版本编号
@property (nonatomic,copy)NSString *versionCode;//APP版本号
@property (nonatomic)NSInteger appType;//APP类型【0=Android，1=iOS】
@property (nonatomic,copy)NSString *downloadUrl;//APP安装文件下载路径

@end
