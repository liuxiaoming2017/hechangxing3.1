//
//  LeMedicineViewController.h
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/12.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "SayAndWriteController.h"
#import <AVFoundation/AVFoundation.h>
//#import "CustomViewController.h"
#import "DownloadHandler.h"
#import "MBProgressHUD.h"

@interface LeMedicineViewController : SayAndWriteController

{
    NSTimer* playTime;
    NSTimer* playmp3;
    DownloadHandler *_downloadHanlder;
    ProgressIndicator *_progress;
    // AVAudioPlayer *mp3;
    MBProgressHUD* progress_;
    
}
@property (nonatomic, retain) NSString *fileurl;
@property(nonatomic,retain) NSMutableArray* LeMedicArray;
@property(nonatomic,retain) NSMutableArray* LeMedicArrayId;
@property (nonatomic, retain) UIButton* bfztbutton;
@property( nonatomic,retain) UITableView *LeMdicinaTab;

@end
