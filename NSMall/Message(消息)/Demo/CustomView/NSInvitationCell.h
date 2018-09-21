//
//  NSInvitationCell.h
//  NSMall
//
//  Created by 张锐凌 on 2018/9/19.
//  Copyright © 2018年 www. All rights reserved.
//

#import <EaseUI/EaseUI.h>

@interface NSInvitationCell : EaseBaseMessageCell

@property(nonatomic,strong)UIButton *agreeBtn;/* 同意按钮 */
@property(nonatomic,strong)UIButton *refuseBtn;/* 拒绝按钮 */
@property(nonatomic,strong)UILabel *stateLab;/* 状态 */
/* 同意 点击回调 */
@property (nonatomic, copy) dispatch_block_t agreeBtnClickBlock;
/* 拒绝 点击回调 */
@property (nonatomic, copy) dispatch_block_t refuseBtnClickBlock;
@property(nonatomic,strong)NSDictionary *extDict;/* 扩展字典 */
@end
