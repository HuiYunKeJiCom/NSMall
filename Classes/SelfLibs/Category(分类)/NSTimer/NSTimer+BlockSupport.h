//
//  NSTimer+BlockSupport.h
//  Delivery
//
//  Created by RanSong on 16/9/2.
//  Copyright © 2016年 RanSong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (BlockSupport)

+ (instancetype)ff_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                           block:(void(^)())block
                                          repeats:(BOOL)repeats;


@end
