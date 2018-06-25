//
//  UserHeaderV.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/21.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserPageModel.h"

@interface UserHeaderV : UIView
@property (nonatomic, copy) dispatch_block_t editBtnClickBlock;/* 评论按钮回调 */
@property (nonatomic, copy) dispatch_block_t shareBtnClickBlock;/* 分享按钮回调 */
@property(nonatomic,strong)UserPageModel *userPageM;/* 数据模型 */
@end
