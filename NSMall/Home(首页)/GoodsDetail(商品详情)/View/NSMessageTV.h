//
//  NSMessageTV.h
//  NSMall
//
//  Created by 张锐凌 on 2018/5/25.
//  Copyright © 2018年 www. All rights reserved.
//

#import "BaseTableView.h"
#import "NSMessageModel.h"

@protocol NSMessageTVDelegate <NSObject>

@optional

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface NSMessageTV : BaseTableView
@property (weak,nonatomic) id<NSMessageTVDelegate> tbDelegate;
@end
