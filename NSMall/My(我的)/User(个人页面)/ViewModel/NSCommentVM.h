//
//  NSCommentVM.h
//  NSMall
//
//  Created by 张锐凌 on 2018/6/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSCommentVMDelegate <NSObject>

-(void)delCommentWith:(NSIndexPath *)indexPath;

@end

@interface NSCommentVM : NSObject
@property (nonatomic,readonly)BaseTableView *commentTV;//懒加载使用，外部需要设定frame
- (void)layoutWithProperty:(NSArray *)propertyies;
@property (nonatomic, weak) id<NSCommentVMDelegate> delegate;
@end
