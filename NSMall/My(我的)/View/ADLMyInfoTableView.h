//
//  ADLMyInfoTableView.h
//  Kart
//
//  Created by 朱鹏 on 17/3/9.
//  Copyright © 2017年 朱鹏. All rights reserved.
//

#import "BaseTableView.h"
#import "ADLMyInfoModel.h"

@protocol ADLMyInfoTableViewDelegate <NSObject>

@optional

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ADLMyInfoTableView : BaseTableView
@property (weak,nonatomic) id<ADLMyInfoTableViewDelegate> tbDelegate;
@property (nonatomic, strong) UserModel              *userModel;
@end
