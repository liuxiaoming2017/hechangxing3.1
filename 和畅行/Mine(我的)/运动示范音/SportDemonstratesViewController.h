//
//  SportDemonstratesViewController.h
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/12.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "SayAndWriteController.h"
#import <AVFoundation/AVFoundation.h>
#import "DownLoadHandlers.h"
#import "MBProgressHUD.h"

@interface SportDemonstratesViewController : SayAndWriteController

{
    NSTimer* playTime;
    NSTimer* playmp3;
    DownLoadHandlers *_downloadHanlder;
    ProgressIndicator *_progress;
    // AVAudioPlayer *mp3;
    
    
}
@property (nonatomic, copy) NSString *fileurl;
@property(nonatomic,strong) NSMutableArray* LeMedicArray;
@property (nonatomic, strong) UIButton* bfztbutton;
@property( nonatomic,strong) UITableView *LeMdicinaTab;
@end
