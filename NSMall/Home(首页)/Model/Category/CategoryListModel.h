//
//  CategoryShellModel.h
//  NSMall
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryModel.h"

@interface CategoryListModel : NSObject<YYModel>

@property (nonatomic,strong)NSArray<CategoryModel *> *categoryList;//

@end
