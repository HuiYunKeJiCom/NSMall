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
typedef void(^stringBlock)(NSString *string);

@property (nonatomic, copy) stringBlock                   stringBlock;/* 选择的类别回调 */

-(void)getDataWithCategoryModel:(CategoryModel *)model;
@end
