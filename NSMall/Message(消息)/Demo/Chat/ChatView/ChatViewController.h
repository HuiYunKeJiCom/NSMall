/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "NSHuanXinUserModel.h"

@interface ChatViewController : EaseMessageViewController <EaseMessageViewControllerDelegate, EaseMessageViewControllerDataSource>


- (void)showMenuViewController:(UIView *)showInView
                  andIndexPath:(NSIndexPath *)indexPath
                   messageType:(EMMessageBodyType)messageType;

- (void)reloadDingCellWithAckMessageId:(NSString *)aMessageId;

@property(nonatomic,strong)NSHuanXinUserModel *hxModel;/* 自定义model */
@property(nonatomic)NSInteger groupCount;/* 群总人数 */
@property(nonatomic,strong)NSString *groupOwn;/* 群主环信用户名 */
@end
