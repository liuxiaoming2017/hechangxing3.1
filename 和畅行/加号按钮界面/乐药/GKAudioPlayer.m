//
//  GKAudioPlayer.m
//  GKWYMusic
//
//  Created by gaokun on 2018/4/24.
//  Copyright © 2018年 gaokun. All rights reserved.
//  播放器中所以关于FSAudioStream的类都需要在主线程中进行（类中要求的），防止可能造成的崩溃

#import "GKAudioPlayer.h"
#import "GKTimer.h"

#import <MediaPlayer/MediaPlayer.h>

@interface GKAudioPlayer()

@property (nonatomic, strong) FSAudioStream *audioStream;

@property (nonatomic, strong) NSTimer       *playTimer;
@property (nonatomic, strong) NSTimer       *bufferTimer;

@property (nonatomic,assign) BOOL isBackground;

@property (nonatomic,assign) NSTimeInterval totalTime;

@property (nonatomic,assign) NSTimeInterval currentTime;

@end

@implementation GKAudioPlayer
@synthesize indexNum,noDelegate;

+ (instancetype)sharedInstance {
    static GKAudioPlayer *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [GKAudioPlayer new];
    });
    return player;
}

- (instancetype)init {
    if (self = [super init]) {
        self.playerState = GKAudioPlayerStateStopped;
        [self setupLockScreenControlInfo];
    }
    return self;
}

- (void)setPlayUrlStr:(NSString *)playUrlStr {
    if (![_playUrlStr isEqualToString:playUrlStr]) {
        
        // 切换数据，清除缓存
      //  [self removeCache];
        
        _playUrlStr = playUrlStr;
        
        if(!playUrlStr){
            return;
        }
        
        if ([playUrlStr hasPrefix:@"http"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.audioStream.url = [NSURL URLWithString:playUrlStr];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.audioStream.url = [NSURL fileURLWithPath:playUrlStr];
            });
        }
    }
}

- (void)setPlayerProgress:(float)progress {
    if (progress == 0) progress = 0.001;
    if (progress == 1) progress = 0.999;
    
    FSStreamPosition position = {0};
    position.position = progress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream seekToPosition:position];
    });
}

- (void)setPlayerPlayRate:(float)playRate {
    if (playRate < 0.5) playRate = 0.5f;
    if (playRate > 2.0) playRate = 2.0f;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream setPlayRate:playRate];
    });
}

- (void)play {
    if (self.playerState == GKAudioPlayerStatePlaying) return;
    [self setupLockScreenMediaInfo];
    NSAssert(self.playUrlStr, @"url不能为空");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream play];
    });
    
    [self startTimer];
    
    // 如果缓冲未完成
    if (self.bufferState != GKAudioBufferStateFinished) {
        self.bufferState = GKAudioBufferStateNone;
        [self startBufferTimer];
    }
}

- (void)playFromProgress:(float)progress {
    FSSeekByteOffset offset = {0};
    offset.position = progress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream playFromOffset:offset];
    });
    
    [self startTimer];
    
    // 如果缓冲未完成
    if (self.bufferState != GKAudioBufferStateFinished) {
        self.bufferState = GKAudioBufferStateNone;
        [self startBufferTimer];
    }
}

- (void)pause {
    if (self.playerState == GKAudioPlayerStatePaused) return;
    
    self.playerState = GKAudioPlayerStatePaused;
    
    [self setupPlayerState:self.playerState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream pause];
    });
    
    [self stopTimer];
}

- (void)resume {
    if (self.playerState == GKAudioPlayerStatePlaying) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 这里恢复播放不能用play，需要用pause
        [self.audioStream pause];
    });
    
    [self startTimer];
}

- (void)stop {
    if (self.playerState == GKAudioPlayerStateStoppedBy) return;
    self.playUrlStr = nil;
    self.playerState = GKAudioPlayerStateStoppedBy;
    [self setupPlayerState:self.playerState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream stop];
    });
    
    [self stopTimer];
}

- (void)startTimer {
    if (self.playTimer) return;
    self.playTimer = [GKTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

- (void)startBufferTimer {
    if (self.bufferTimer) return;
    self.bufferTimer = [GKTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(bufferTimerAction:) userInfo:nil repeats:YES];
}

- (void)stopBufferTimer {
    if (self.bufferTimer) {
        [self.bufferTimer invalidate];
        self.bufferTimer = nil;
    }
}

- (void)timerAction:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        FSStreamPosition cur = self.audioStream.currentTimePlayed;
        
       self.currentTime = cur.playbackTimeInSeconds * 1000;
        
       self.totalTime = self.audioStream.duration.playbackTimeInSeconds * 1000;
        
       // NSTimeInterval progress = cur.position;
        
        //NSLog(@"total:%f,currentTime:%f",(float)self.totalTime / 1000,(float)self.currentTime / 1000);
        
        [self setupLockScreenMediaInfo];
        
//        if ([self.delegate respondsToSelector:@selector(gkPlayer:currentTime:totalTime:progress:)]) {
//            [self.delegate gkPlayer:self currentTime:currentTime totalTime:totalTime progress:progress];
//        }
//
//        if ([self.delegate respondsToSelector:@selector(gkPlayer:totalTime:)]) {
//            [self.delegate gkPlayer:self totalTime:totalTime];
//        }
    });
    
}

- (void)bufferTimerAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        float preBuffer      = (float)self.audioStream.prebufferedByteCount;
        float contentLength  = (float)self.audioStream.contentLength;
        
        // 这里获取的进度不能准确地获取到1
        float bufferProgress = contentLength > 0 ? preBuffer / contentLength : 0;
        
        //    NSLog(@"缓冲进度%.2f", bufferProgress);
        
        // 为了能使进度准确的到1，这里做了一些处理
        int buffer = (int)(bufferProgress + 0.5);
        
        if (bufferProgress > 0.9 && buffer >= 1) {
            self.bufferState = GKAudioBufferStateFinished;
            [self stopBufferTimer];
            // 这里把进度设置为1，防止进度条出现不准确的情况
            bufferProgress = 1.0f;
            
            NSLog(@"缓冲结束了，停止进度");
        }else {
            self.bufferState = GKAudioBufferStateBuffering;
        }
        
//        if ([self.delegate respondsToSelector:@selector(gkPlayer:bufferProgress:)]) {
//            [self.delegate gkPlayer:self bufferProgress:bufferProgress];
//        }
    });
}

- (void)removeCache {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.audioStream.configuration.cacheDirectory error:nil];
        
        for (NSString *filePath in arr) {
            if ([filePath hasPrefix:@"FSCache-"]) {
                NSString *path = [NSString stringWithFormat:@"%@/%@", self.audioStream.configuration.cacheDirectory, filePath];
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
    });
}

- (void)setupPlayerState:(GKAudioPlayerState)state {
    if ([self.delegate respondsToSelector:@selector(gkPlayer:statusChanged:)]) {
        [self.delegate gkPlayer:self statusChanged:state];
    }
}

#pragma mark - 懒加载
- (FSAudioStream *)audioStream {
    if (!_audioStream) {
        FSStreamConfiguration *configuration = [FSStreamConfiguration new];
        configuration.enableTimeAndPitchConversion = YES;
        NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *folderPath = [path stringByAppendingPathComponent:@"musicCache"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
        if(!fileExists)
        {
            [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        configuration.cacheDirectory = folderPath;
        _audioStream = [[FSAudioStream alloc] initWithConfiguration:configuration];
        _audioStream.strictContentTypeChecking = NO;
        _audioStream.defaultContentType = @"audio/x-m4a";
        
        __weak __typeof(self) weakSelf = self;
        
        _audioStream.onCompletion = ^{
            NSLog(@"完成");
        };
        
        
        
        _audioStream.onStateChange = ^(FSAudioStreamState state) {
            switch (state) {
                case kFsAudioStreamRetrievingURL:       // 检索url
                    NSLog(@"检索url");
                    weakSelf.playerState = GKAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamBuffering:           // 缓冲
                    NSLog(@"缓冲中。。");
                    weakSelf.playerState = GKAudioPlayerStateBuffering;
                    weakSelf.bufferState = GKAudioBufferStateBuffering;
                    break;
                case kFsAudioStreamSeeking:             // seek
                    NSLog(@"seek中。。");
                    weakSelf.playerState = GKAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamPlaying:             // 播放
                    NSLog(@"播放中。。");
                    weakSelf.playerState = GKAudioPlayerStatePlaying;
                    break;
                case kFsAudioStreamPaused:              // 暂停
                    NSLog(@"播放暂停");
                    weakSelf.playerState = GKAudioPlayerStatePaused;
                    break;
                case kFsAudioStreamStopped:              // 停止
                    
                    // 切换歌曲时主动调用停止方法也会走这里，所以这里添加判断，区分是切换歌曲还是被打断等停止
                    if (weakSelf.playerState != GKAudioPlayerStateStoppedBy && weakSelf.playerState != GKAudioPlayerStateEnded) {
                        NSLog(@"播放停止被打断");
                        weakSelf.playerState = GKAudioPlayerStateStopped;
                    }
                    break;
                case kFsAudioStreamRetryingFailed:              // 检索失败
                    NSLog(@"检索失败");
                    weakSelf.playerState = GKAudioPlayerStateError;
                    break;
                case kFsAudioStreamRetryingStarted:             // 检索开始
                    NSLog(@"检索开始");
                    weakSelf.playerState = GKAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamFailed:                      // 播放失败
                    NSLog(@"播放失败");
                    weakSelf.playerState = GKAudioPlayerStateError;
                    break;
                case kFsAudioStreamPlaybackCompleted:           // 播放完成
                {
                    NSLog(@"播放完成");
                    weakSelf.playerState = GKAudioPlayerStateEnded;
                    if(weakSelf.noDelegate){
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf playNextMusic];
                        });
                    }
                    
                }
                   
                    break;
                case kFsAudioStreamRetryingSucceeded:           // 检索成功
                    NSLog(@"检索成功");
                    weakSelf.playerState = GKAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamUnknownState:                // 未知状态
                    NSLog(@"未知状态");
                    weakSelf.playerState = GKAudioPlayerStateError;
                    break;
                case kFSAudioStreamEndOfFile:                   // 缓冲结束
                    {
                        NSLog(@"缓冲结束");
                        
                        if (self.bufferState == GKAudioBufferStateFinished) return;
                        // 定时器停止后需要再次调用获取进度方法，防止出现进度不准确的情况
                        [weakSelf bufferTimerAction:nil];
                        
                        [weakSelf stopBufferTimer];
                    }
                    break;
                    
                default:
                    break;
            }
            if(!weakSelf.noDelegate){
                [weakSelf setupPlayerState:weakSelf.playerState];
            }
        };
    }
    return _audioStream;
}

# pragma mark - 下一首
- (void)playNextMusic
{
    NSString *currentUrl = @"";
    
    if(self.playUrlStr){
        currentUrl = self.playUrlStr;
        [self stop];
    }
    
    SongListModel *model = [[SongListModel alloc] init];
    
    if(self.musicArr.count == 1){
        model = [self.musicArr objectAtIndex:0];
    }else{
        int index = arc4random() % self.musicArr.count;
        model = [self.musicArr objectAtIndex:index];
        if([model.source isEqualToString:currentUrl]){
            if(index == self.musicArr.count -1){
                index = index - 1;
            }else{
                index = index + 1;
            }
            model = [self.musicArr objectAtIndex:index];
        }
    }
    
    self.model = model;
    self.playUrlStr = model.source;
    [self play];
    
}

# pragma mark -  锁屏界面开启和监控远程控制事件
- (void)setupLockScreenControlInfo{
    
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    
    // 锁屏播放
    [commandCenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"锁屏暂停后点击播放");
        if(self.playerState == GKAudioPlayerStatePaused){
            [self resume];
        }else{
            [self play];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    // 锁屏暂停
    [commandCenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        NSLog(@"锁屏正在播放点击后暂停");
        
        if(self.playerState == GKAudioPlayerStatePlaying) {
            [self pause];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [commandCenter.stopCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self pause];
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 播放和暂停按钮（耳机控制）
    MPRemoteCommand *playPauseCommand = commandCenter.togglePlayPauseCommand;
    playPauseCommand.enabled = YES;
    [playPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        if (self.playerState == GKAudioPlayerStatePlaying) {
            [self pause];
        }else {
            [self play];
        }
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    // 上一曲
//    MPRemoteCommand *previousCommand = commandCenter.previousTrackCommand;
//    [previousCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//        [self playNextMusic];
//
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
//
//    // 下一曲
//    MPRemoteCommand *nextCommand = commandCenter.nextTrackCommand;
//    nextCommand.enabled = YES;
//    [nextCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            [self playNextMusic];
//        });
//
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
    
    //在控制台拖动进度条调节进度（仿QQ音乐的效果）
//    [commandCenter.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
////        CMTime totlaTime = weakSelf.avPlayer.currentItem.duration;
////        MPChangePlaybackPositionCommandEvent * playbackPositionEvent = (MPChangePlaybackPositionCommandEvent *)event;
////        [weakSelf.avPlayer seekToTime:CMTimeMake(totlaTime.value*playbackPositionEvent.positionTime/CMTimeGetSeconds(totlaTime), totlaTime.timescale) completionHandler:^(BOOL finished) {
////        }];
//        return MPRemoteCommandHandlerStatusSuccess;
//    }];
    
}

# pragma mark -  移除观察者
- (void)removeObserver{

    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.likeCommand removeTarget:self];
    [commandCenter.dislikeCommand removeTarget:self];
    [commandCenter.bookmarkCommand removeTarget:self];
    [commandCenter.nextTrackCommand removeTarget:self];
    [commandCenter.skipForwardCommand removeTarget:self];
    [commandCenter.changePlaybackPositionCommand removeTarget:self];
    commandCenter = nil;
}

# pragma mark - 播放控制和监测
- (void)setupLockScreenMediaInfo {
    MPNowPlayingInfoCenter *playingCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *playingInfo = [NSMutableDictionary new];
    NSString *iconStr = @"和畅依";
    if(self.model.subjectSn){
      NSString  *titleStr = [self.model.subjectSn substringFromIndex:self.model.subjectSn.length-1];
        iconStr = [NSString stringWithFormat:@"%@icon",titleStr];
    }
   // playingInfo[MPMediaItemPropertyAlbumTitle] = iconStr;
    playingInfo[MPMediaItemPropertyTitle]      = self.model.title;
    //playingInfo[MPMediaItemPropertyArtist]     = @"爱你一万年";
    
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:iconStr]];
    playingInfo[MPMediaItemPropertyArtwork] = artwork;
    
    //NSLog(@"total:%f,currentTime:%f",(float)self.totalTime / 1000,(float)self.currentTime / 1000);
    
    // 当前播放的时间
    playingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = [NSNumber numberWithFloat:(float)self.currentTime / 1000];
    // 进度的速度
    playingInfo[MPNowPlayingInfoPropertyPlaybackRate] = [NSNumber numberWithFloat:1.0];
    // 总时间
    playingInfo[MPMediaItemPropertyPlaybackDuration] = [NSNumber numberWithFloat:(float)self.totalTime / 1000];
    if (@available(iOS 10.0, *)) {
        playingInfo[MPNowPlayingInfoPropertyPlaybackProgress] = [NSNumber numberWithFloat:(float)self.currentTime / 1000];
    } else {
        // Fallback on earlier versions
    }
    playingCenter.nowPlayingInfo = playingInfo;
}

- (void)addObservers {
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(removePlayerPlayerLayer)
                   name:UIApplicationDidEnterBackgroundNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(resetPlayerPlayerLayer)
                   name:UIApplicationWillEnterForegroundNotification
                 object:nil];
    
}

- (void)removePlayerPlayerLayer
{
    NSLog(@"进入后台");
    self.isBackground = YES;
}

- (void)resetPlayerPlayerLayer
{
    NSLog(@"进入前台");
    self.isBackground = NO;
}

# pragma mark - 展示锁屏歌曲信息：图片、歌词、进度、演唱者 播放速率
- (void)showLockScreenTotaltime:(float)totalTime andCurrentTime:(float)currentTime andRate:(NSInteger)rate andLyricsPoster:(BOOL)isShow{
    
    NSMutableDictionary * songDict = [[NSMutableDictionary alloc] init];
    //设置歌曲题目
    [songDict setObject:@"" forKey:MPMediaItemPropertyTitle];
    //设置歌手名
    //[songDict setObject:@"韩安旭" forKey:MPMediaItemPropertyArtist];
    //设置专辑名
    // [songDict setObject:@"harmonyYi" forKey:MPMediaItemPropertyAlbumTitle];
    //设置歌曲时长
    [songDict setObject:[NSNumber numberWithDouble:totalTime]  forKey:MPMediaItemPropertyPlaybackDuration];
    //设置已经播放时长
    [songDict setObject:[NSNumber numberWithDouble:currentTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    //设置播放速率
    //注意：MPNowPlayingInfoCenter的rate 与 self.player.rate 是不同步的，也就是说[self.player pause]暂停播放后的速率rate是0，但MPNowPlayingInfoCenter的rate还是1，就会造成 在锁屏界面点击了暂停按钮，这个时候进度条表面看起来停止了走动，但是其实还是在计时，所以再点击播放的时候，锁屏界面进度条的光标会发生位置闪动， 所以我们需要在暂停或播放时保持播放速率一致
    [songDict setObject:[NSNumber numberWithInteger:rate] forKey:MPNowPlayingInfoPropertyPlaybackRate];
    
    //    UIImage * lrcImage = [UIImage imageNamed:@"backgroundImage5.jpg"];
    //    //设置显示的海报图片
    //    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:lrcImage]
    //                 forKey:MPMediaItemPropertyArtwork];
    
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSArray *icons = [infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"];
    [songDict setObject:[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:[icons lastObject]]]
                 forKey:MPMediaItemPropertyArtwork];
    
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
    
}


@end
