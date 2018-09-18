//
//  NSMemberCVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSHuanXinUserModel.h"

@interface NSMemberCVCell : UICollectionViewCell

@property(nonatomic,strong)NSHuanXinUserModel *model;/* 模型 */
@property(nonatomic,strong)UIImageView *avatarIV;/* 头像 */
@property(nonatomic,strong)UILabel *nickLab;/* 昵称 */
@property(nonatomic,strong)UIButton *delBtn;/* 删除按钮 */
/* 删除 点击回调 */
@property (nonatomic, copy) dispatch_block_t delBtnClickBlock;


@end
