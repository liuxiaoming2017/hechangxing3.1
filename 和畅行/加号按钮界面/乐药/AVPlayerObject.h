//
//  AVPlayerObject.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/30.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVPlayerObject : NSObject

@property (nonatomic,copy) NSURL *audioURL;
@property (strong, nonatomic) AVAudioPlayer *avPlayer;

+ (AVPlayerObject *)shareOnce;

@end
