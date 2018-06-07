//
//  XMGAudioTool.m
//  02-播放音效
//
//  Created by xiaomage on 15/12/18.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "ADAudioTool.h"
#import <AVFoundation/AVFoundation.h>


@implementation ADAudioTool

static NSMutableDictionary *_soudIDs;

+ (void)initialize
{
    _soudIDs = [NSMutableDictionary dictionary];
}


+ (void)playSoundWithSoundName:(NSString *)soundName
{
    // 1.创建soundID = 0
    SystemSoundID soundID = 0;
    
    // 2.从字典中取出soundID
    soundID = [_soudIDs[soundName] unsignedIntValue];;
    
    // 3.判断soundID是否为0
    if (soundID == 0) {
        // 3.1生成soundID
        CFURLRef url = (__bridge CFURLRef)[[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        AudioServicesCreateSystemSoundID(url, &soundID);
        
        // 3.2将soundID保存到字典中
        [_soudIDs setObject:@(soundID) forKey:soundName];
        
    }
    
    // 4.播放音效
    AudioServicesPlaySystemSound(soundID);
}

@end
