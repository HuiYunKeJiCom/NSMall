//
//  AdverItemModel.h
//  NSMall
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    参看在线API接口文档
    http://doc.huist.cn/index.php?s=/10&page_id=285
 */

@interface AdvertItemModel : NSObject

@property (nonatomic,copy)NSString *ID;//转义id
@property (nonatomic,copy)NSString *title;//
@property (nonatomic,copy)NSString *type;//
@property (nonatomic,copy)NSString *pic_img;//
@property (nonatomic,assign)CGFloat width;//
@property (nonatomic,assign)CGFloat height;//
@property (nonatomic,copy)NSString *href;//
@property (nonatomic,assign)NSInteger sort;//

@end
