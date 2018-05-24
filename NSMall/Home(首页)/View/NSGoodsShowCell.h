//
//  NSGoodsShowCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/14.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "ProductListItemModel.h"

@interface NSGoodsShowCell : BaseTableCell
@property (strong, nonatomic) ProductListItemModel *productModel;
@property (nonatomic, copy) dispatch_block_t likeBtnClickBlock;/* 喜欢按钮回调 */
@property (nonatomic, copy) dispatch_block_t commentBtnClickBlock;/* 评论按钮回调 */
@property (nonatomic, copy) dispatch_block_t shareBtnClickBlock;/* 分享按钮回调 */
@property (nonatomic, assign) BOOL isLike;
@property(nonatomic,strong)UIButton *likeBtn;/* 喜欢按钮 */
@end
