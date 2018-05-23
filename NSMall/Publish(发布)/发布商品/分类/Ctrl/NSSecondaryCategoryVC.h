//
//  NSSecondaryCategoryVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/12.
//  Copyright © 2018年 www. All rights reserved.
//

#import "DCBaseSetViewController.h"
#import "CategoryModel.h"
#import "NSCategoryTableViewCell.h"
#import "ADOrderTopToolView.h"

@interface NSSecondaryCategoryVC : DCBaseSetViewController

-(void)getDataWithCategoryModel:(CategoryModel *)model;
@end
