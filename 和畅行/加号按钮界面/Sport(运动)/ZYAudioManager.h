//
//  ZYAudioManager.h
//  ZYAudioPlaying
//
//  Created by lll on 15/10/12.
//  Copyright © 2015年 lll. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface ZYAudioManager : NSObject
+ (instancetype)defaultManager;

//播放音乐
- (AVAudioPlayer *)playingMusic:(NSString *)filename;
- (void)pauseMusic:(NSString *)filename;
- (void)stopMusic:(NSString *)filename;

//播放音效
- (void)playSound:(NSString *)filename;
- (void)disposeSound:(NSString *)filename;
@end
