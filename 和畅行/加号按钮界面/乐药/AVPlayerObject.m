//
//  AVPlayerObject.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/30.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "AVPlayerObject.h"

static AVPlayerObject *shareOnce = nil;

@implementation AVPlayerObject

+ (AVPlayerObject *)shareOnce
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shareOnce = [[AVPlayerObject alloc] init];
    });
    return shareOnce;
}

#pragma mark - 音频播放的设置
- (void)setAudioURL:(NSURL *)audioURL{
    if (audioURL) {
        self.avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        //self.avPlayer.delegate = self;
        self.avPlayer.numberOfLoops = -1;
        [self.avPlayer prepareToPlay];
    }
    _audioURL = audioURL;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        [self setsession];
        [self customAddNotification];
    }
    return self;
}

- (void)setsession
{
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&error];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:&error];
    
}

# pragma mark - 注册音频监听事件
- (void)customAddNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioRouteChangeListenerCallback:)
                                                 name:AVAudioSessionRouteChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(otherAppAudioSessionCallBack:)
                                                 name:AVAudioSessionSilenceSecondaryAudioHintNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systermAudioSessionCallBack:)
                                                 name:AVAudioSessionInterruptionNotification object:nil];
}

#pragma mark - 监听 插／拔耳机
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    // AVAudioSessionRouteChangeReasonKey：change reason
    
    switch (routeChangeReason) {
            // new device available
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            NSLog(@"headset input");
            break;
        }
            // device unavailable
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
            NSLog(@"pause play when headset output");
            [self.avPlayer pause];
            break;
        }
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark - 监听音频系统中断响应

- (void)otherAppAudioSessionCallBack:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger interuptType = [[interuptionDict valueForKey:AVAudioSessionSilenceSecondaryAudioHintTypeKey] integerValue];
    
    switch (interuptType) {
        case AVAudioSessionSilenceSecondaryAudioHintTypeBegin:{
            [self.avPlayer pause];
            NSLog(@"pause play when other app occupied session");
            break;
        }
        case AVAudioSessionSilenceSecondaryAudioHintTypeEnd:{
            NSLog(@"occupied session");
            break;
        }
        default:
            break;
    }
}

// phone call or alarm
- (void)systermAudioSessionCallBack:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger interuptType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    
    switch (interuptType) {
            // That interrupted the start, we should pause playback and collection
        case AVAudioSessionInterruptionTypeBegan:{
            [self.avPlayer pause];
            NSLog(@"pause play when phone call or alarm ");
            break;
        }
            // That interrupted the end, we can continue to play and capture
        case AVAudioSessionInterruptionTypeEnded:{
            break;
        }
        default:
            break;
    }
}


@end
