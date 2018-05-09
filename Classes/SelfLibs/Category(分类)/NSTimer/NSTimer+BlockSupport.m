//
//  NSTimer+BlockSupport.m
//  Delivery
//
//  Created by RanSong on 16/9/2.
//  Copyright © 2016年 RanSong. All rights reserved.
//

#import "NSTimer+BlockSupport.h"

@implementation NSTimer (BlockSupport)

+(instancetype)ff_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)())block repeats:(BOOL)repeats
{
     return [self scheduledTimerWithTimeInterval:interval
                                          target:self
                                        selector:@selector(blockAction:)
                                        userInfo:[block copy]
                                         repeats:repeats];
}

+ (void)blockAction:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
