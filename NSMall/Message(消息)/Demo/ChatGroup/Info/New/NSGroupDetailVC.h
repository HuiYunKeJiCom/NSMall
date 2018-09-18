//
//  NSGroupDetailVC.h
//  NSMall
//
//  Created by 张锐凌 on 2018/8/28.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSGoodsTableView.h"

@protocol NSGroupDetailVCDelegate <NSObject>

@optional

- (void)deleteAllMessages:(UIButton *)btn;

@end

@interface NSGroupDetailVC : UIViewController

//-(void)setUpDataWithGroupId:(NSString *)groupId;
@property(nonatomic,strong)UIButton *exitBtn;/* 删除并退出 */
@property (strong, nonatomic) NSGoodsTableView   *otherTableView;/* 群名称 */
-(void)setUpDataWithConversation:(EMConversation *)conversation;
@property (weak, nonatomic) id<NSGroupDetailVCDelegate> delegate;
@property(nonatomic,strong)NSString *groupOwn;/* 群主环信用户名 */
@end
