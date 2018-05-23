//
//  NSCategoryVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/9.
//  Copyright © 2018年 www. All rights reserved.
//

#import "DCBaseSetViewController.h"
#import "CategoryModel.h"

@interface NSCategoryVC : DCBaseSetViewController

typedef void(^modelBlock)(CategoryModel *model);

@property (nonatomic, strong) modelBlock                   stringBlock;/* 选择的类别回调 */

@end
