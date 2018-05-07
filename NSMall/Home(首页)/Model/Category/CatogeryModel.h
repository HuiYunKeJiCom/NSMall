//
//  CatogeryModel.h
//  NSMall
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    商品分类的模型，参考在线API文档
    http://doc.huist.cn/index.php?s=/10&page_id=286
 */

@interface CatogeryModel : NSObject

@property (nonatomic,copy)NSString *ID;//转义id
@property (nonatomic,copy)NSString *name;//
@property (nonatomic,copy)NSString *parent_id;//
@property (nonatomic,assign)NSInteger type;//
@property (nonatomic,copy)NSString *is_parent;//
@property (nonatomic,assign)NSInteger sort;//
@property (nonatomic,strong)NSArray<CatogeryModel *> *children;//

@end
