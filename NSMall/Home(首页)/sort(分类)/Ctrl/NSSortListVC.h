//
//  NSSortListVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/26.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseViewCtrl.h"
#import "SearchParam.h"

@interface NSSortListVC : BaseViewCtrl
@property(nonatomic,copy)NSString *titleString;/* 列表 标题 由分类页面或首页传过来*/
@property(nonatomic,strong)SearchParam *param;/* 搜索参数 */
@end
