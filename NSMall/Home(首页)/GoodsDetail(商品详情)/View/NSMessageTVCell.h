//
//  NSMessageTVCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableCell.h"
#import "NSMessageModel.h"

@interface NSMessageTVCell : BaseTableCell
@property (strong, nonatomic) UIImageView    *userIV;
@property (strong, nonatomic) UILabel        *userNameLb;
@property (strong, nonatomic) UILabel        *contentLb;
@property (strong, nonatomic) UILabel        *timeLb;

@property (nonatomic, copy) dispatch_block_t delBtnClickBlock;/* 分享按钮回调 */

@property (strong, nonatomic) NSMessageModel *messageModel;
@end
