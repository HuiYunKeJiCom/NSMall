//
//  ProductListItemModel.h
//  NSMall
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 映射模型，参考在线文档
 http://doc.huist.cn/index.php?s=/10&page_id=287
 */

@interface ProductListItemModel : NSObject<YYModel>

@property (nonatomic,copy)NSString *product_id;//
@property (nonatomic,copy)NSString *name;//
@property (nonatomic,copy)NSString *show_price;//
@property (nonatomic,copy)NSString *show_score;//
@property (nonatomic,copy)NSString *introduce;//
@property (nonatomic,copy)NSString *label_name;//
@property (nonatomic,copy)NSString *update_time;//
@property (nonatomic,assign)NSInteger is_like;//
@property (nonatomic,assign)NSInteger like_number;//
@property (nonatomic,assign)NSInteger favorite_number;//
@property (nonatomic,assign)NSInteger comment_number;//
@property (nonatomic,copy)NSString *user_id;//
@property (nonatomic,copy)NSString *user_name;//
@property (nonatomic,copy)NSString *user_avatar;//
@property (nonatomic,copy)NSString *weak;//
@property (nonatomic,strong)NSArray<NSString *> *productImageList;//

@end
