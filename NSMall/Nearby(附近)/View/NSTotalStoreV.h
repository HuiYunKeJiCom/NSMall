//
//  NSTotalStoreV.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/15.
//  Copyright © 2018年 www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSStoreModel.h"

@protocol NSTotalStoreVDelegate <NSObject>

-(void)showTotalStoreView;
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSTotalStoreV : UIView
@property(nonatomic,strong)NSArray<NSStoreModel *> *storeList;/* 店铺数组 */
@property(nonatomic)BOOL isShow;/* 是否全部商家列表 */
@property (nonatomic, weak)id <NSTotalStoreVDelegate>delegate;

@end
