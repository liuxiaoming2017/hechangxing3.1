//
//  MeridianIdentifierViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/12.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "MeridianIdentifierViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "LPPopup.h"
#import "MLAudioRecorder.h"
#import "SBJson.h"

#import "CustomNavigationController.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "ResultSpeakController.h"

#define MENU_POPOVER_FRAME  CGRectMake(8, 0, 140, 88)
#define kTabsHeight 46.5
#define LeftWidth 36.5
#define SingWidth 2
#define SflowviewHeight 64
@class STSegmentedControl;

@interface MeridianIdentifierViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    UIButton *recordButton;
    int timeNStager;
    BOOL IsShiFan ;
    NSTimer* playTime;
    NSTimer* playmp3;
    NSTimer * bianshiTime;
    NSTimer * bianshiTime1;
    NSTimer * bianshiTime2;
    NSTimer *timerACC;
    AVAudioRecorder *RecorderAcc;
    STSegmentedControl *segmentImg;
    MBProgressHUD* _progress;
    UIView *yincangView;
    UIImageView *imageHong;
}
@property (nonatomic,strong) MLAudioRecorder *recorder;
@property (nonatomic,strong) UIButton* Recordbtn;
@property (nonatomic,strong) UIImageView* RotateImg;
@property (nonatomic, copy) NSString *filePath;
@property( nonatomic,strong) UIImageView* ZhiShiImgView;
@property( nonatomic,strong) UIImageView* ZhiShiImgView1;
@property( nonatomic,strong) UIImageView* ZhiShiImgView2;
@property( nonatomic,strong) UIImageView* ZhiShiImgView3;
@property( nonatomic,strong) UIImageView *image1;
@property( nonatomic,strong) UIImageView *image2;
@property( nonatomic,strong) UIImageView *image3;
@property( nonatomic,strong) UIImageView *image4;
@property( nonatomic,strong) UIImageView *image5;
@property( nonatomic,strong) UIImageView *image6;
@property( nonatomic,strong) UIImageView *image7;

/**soundCount*/
@property (nonatomic,assign) CGFloat soundCount;
@end

@implementation MeridianIdentifierViewController


-(void)goBack:(UIButton *)btn{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 重构代码 适配iPhone6 ~ 机型 hai
    
    self.navTitleLabel.text = @"经络功能状态评估";
    
    UIView* UpView = [[UIView alloc] init];
    UpView.frame = CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight);
    [self.view addSubview:UpView];
    
    
    // 背景图片
    UIImageView* UpImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"0闻音辨2识11960_01"]];
    //     UpImgView.frame = CGRectMake(0, 0, ScreenWidth, UpImgView.bounds.size.height);
    UpImgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight * 0.69);
    [UpView addSubview:UpImgView];

    
    // 哆
    UIImageView *duoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Wybs_duo_1.png"]];
    CGFloat duoX = (ScreenWidth - 160) * 0.5;
    duoView.frame = CGRectMake(duoX, 60, 160, 160);
    NSLog(@"%f -------  %f",duoView.bounds.size.width, duoView.bounds.size.height);
    _image1 = duoView;
    [UpView addSubview:duoView];
//    [duoView release];
    
    // 哆音标背景框
    UIImageView *yinBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Wybs_PinYinImg.png"]];
    CGFloat yinX = (ScreenWidth - 100) * 0.5;
    yinBgView.frame = CGRectMake(yinX, duoView.bottom+45, 100, 45);
    NSLog(@"================= %.0f",yinBgView.bounds.size.width);
    [UpView addSubview:yinBgView];
//    [yinBgView release];
    
    // 哆音标
    UIImageView *yinView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Wybs_duo"]];
    yinView.frame = yinBgView.bounds;
    _image2 = yinView;
    [yinBgView addSubview:yinView];
//    [yinView release];
    
    
    // 文字背景框
    UIImageView *wenBgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Wybs_WinZhi_Img_bg.png"]];
    
    wenBgView.frame = CGRectMake(20, yinBgView.bottom+60, ScreenWidth-20*2, 60);
    [UpView addSubview:wenBgView];
//    [wenBgView release];
    
    // 文字
    NSArray *array = @[@"WinZhi_Img_duo_1.png",@"WinZhi_Img_ruai_1.png",@"WinZhi_Img_mi_1.png",@"WinZhi_Img_sao_1.png",@"WinZhi_Img_la_1.png"];
    
    CGFloat marin = 10.0;
    CGFloat wenX = wenBgView.bounds.size.width / array.count;
    for (int i = 0; i < array.count; i++) {
        UIImageView *wenView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:array[i]]];
        wenView.frame = CGRectMake(wenX * i + marin, 4, wenBgView.height-8, wenBgView.height-8);
        
        if (i == 0) {
            _image3 = wenView;
        }else if (i == 1) {
            _image4 = wenView;
        }else if (i == 2) {
            _image5 = wenView;
        }else if (i == 3) {
            _image6 = wenView;
        }else if (i == 4) {
            _image7 = wenView;
        }else{
            
        }
        
        [wenBgView addSubview:wenView];

    }
    
    
    // 开始
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"2_0-126.png"] forState:UIControlStateNormal];
    CGFloat startBtnX = (ScreenWidth - 260) * 0.5;
    button.frame = CGRectMake(startBtnX, UpImgView.bottom+(ScreenHeight-UpImgView.bottom-kNavBarHeight-260/3.9)/2.0, 260,260/3.9);
    
    button.tag=10004;
    [button addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
    
    [UpView addSubview:button];
    
    
    
    
    timeNStager=0;
    bianshiTime=[NSTimer scheduledTimerWithTimeInterval:0.6f target:self selector:@selector(runTimeBianshi) userInfo:nil repeats:YES];
    [bianshiTime setFireDate:[NSDate distantFuture]];
    bianshiTime1=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimeBianshi1) userInfo:nil repeats:YES];
    [bianshiTime1 setFireDate:[NSDate distantFuture]];
    bianshiTime2=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimeBianshi2) userInfo:nil repeats:YES];
    [bianshiTime2 setFireDate:[NSDate distantFuture]];
    UIView *diView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 51, self.view.frame.size.width, 51)];
    [self.view addSubview:diView];
    UIImageView *diImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    diImage.image = [UIImage imageNamed:@"我的11_102.png"];
    [diView addSubview:diImage];
    float width = 0;
    width = (self.view.frame.size.width - 39 * 5) / 5;

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showLoginView)
     name:@"showLoginView"
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showQianHuanLogin:)
     name:@"QianHuanLogin"
     object:nil];
    yincangView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 51, self.view.frame.size.width, 51)];
    [self.view addSubview:yincangView];
    yincangView.hidden = YES;
    
//    [UpView release];
}

-(void)showQianHuanLogin:(NSNotification*)NotiSuc
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)showLoginView {
    LoginViewController *login = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:login animated:YES];

}


-(void)LeftBtnActive:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    [btn setImage:[UIImage imageNamed:@"演示中1.png"] forState:UIControlStateNormal];
    btn.enabled=NO;
    IsShiFan=YES;
    yincangView.hidden = NO;
    UIButton* btn1=(UIButton*)[self.view viewWithTag:10004];
    //[btn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    btn1.enabled=NO;
    self.ZhiShiImgView.hidden=NO;
    [bianshiTime1 setFireDate:[NSDate distantPast]];
    
}
- (void)audio
{
    recordButton.selected = YES;
    yincangView.hidden = NO;
    
    NSError *error1 = nil;
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance]; //得到AVAudioSession单例对象
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error1];//设置类别,表示该应用同时支持播放和录音
    [audioSession setActive:YES error: &error1];//启动音频会话管理,此时会阻断后台音乐的播放.
    
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //  [recordSetting setValue:[NSNumber numberWithFloat:9600] forKey:AVEncoderBitRateKey];
    //AVEncoderBitRateKey
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd-mm:hh:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@",locationString);
//    [dateformatter release];
    // NSString* path=[self getPathOfDocuments];
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageDir = [path stringByAppendingPathComponent:@"wybs"];
    imageDir = [NSString stringWithFormat:@"%@/Caches/%@", path, [UserShareOnce shareOnce].username];
    [self addSkipBackupAttributeToItemAtPath:imageDir];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    self.filePath=[imageDir stringByAppendingPathComponent:[NSString stringWithFormat:@"HY%@.aac",locationString]];
    NSLog(@"filepath===%@",self.filePath);
    // NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    //urlPlay = url;
    
    NSError *error;
    //初始化
    RecorderAcc = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    
    
    //开启音量检测
    RecorderAcc.meteringEnabled = YES;
    RecorderAcc.delegate = self;
    
    //判断设备是否支持录音
    [self luyinWithrecording];
}
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    // assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
- (void)detectionVoices
{
    [RecorderAcc updateMeters];//刷新音量数据
    //获取音量的平均值
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [RecorderAcc peakPowerForChannel:0]));
//    NSLog(@"声音大小：%lf",lowPassResults);
    self.soundCount += lowPassResults;
    
    
    //最大50  0
    //图片 小-》大
}
- (IBAction)record:(id)sender
{
    self.soundCount = 0;
    recordButton = (UIButton*)sender;
    if (recordButton.selected) {
        recordButton.selected = NO;
        timeNStager=0;
        UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
        btn.enabled=YES;
        // IsShiFan=false;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        _image1.image=[UIImage imageNamed:@"Wybs_duo_1.png"];
        _image3.image=[UIImage imageNamed:@"WinZhi_Img_duo_1.png"];
        _image4.image=[UIImage imageNamed:@"WinZhi_Img_ruai_1.png"];
        _image5.image=[UIImage imageNamed:@"WinZhi_Img_mi_1.png"];
        _image6.image=[UIImage imageNamed:@"WinZhi_Img_sao_1.png"];
        _image7.image=[UIImage imageNamed:@"WinZhi_Img_la_1.png"];
        _image2.image=[UIImage imageNamed:@"Wybs_duo.png"];
        [recordButton setImage:[UIImage imageNamed:@"2_0-126.png"] forState:UIControlStateNormal];
        double cTime = RecorderAcc.currentTime;
        if (cTime > 2) {//如果录制时间<2 不发送
            NSLog(@"发出去");
        }else {
            //删除记录的文件
            [RecorderAcc deleteRecording];
            //删除存储的
        }
        [RecorderAcc stop];
        [timerACC invalidate];
        yincangView.hidden = YES;
    }else{
        
        if([self checkPermission]){
            [self audio];
        }else{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                if(granted){
                    [self audio];
                }else{
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请打开麦克风权限" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
                    [alertVC addAction:alertAct1];
                    [self presentViewController:alertVC animated:YES completion:NULL];
                }
            }];
        }
        
    }
}

-(BOOL)checkPermission
{
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    return permission == AVAudioSessionRecordPermissionGranted;
    
}

- (void)luyinWithrecording{
    if (timeNStager!=0) {
        //取消录音
        
        timeNStager=0;
        // IsShiFan=false;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        _image1.image=[UIImage imageNamed:@"Wybs_duo_1.png"];
        _image3.image=[UIImage imageNamed:@"WinZhi_Img_duo_1.png"];
        _image4.image=[UIImage imageNamed:@"WinZhi_Img_ruai_1.png"];
        _image5.image=[UIImage imageNamed:@"WinZhi_Img_mi_1.png"];
        _image6.image=[UIImage imageNamed:@"WinZhi_Img_sao_1.png"];
        _image7.image=[UIImage imageNamed:@"WinZhi_Img_la_1.png"];
        _image2.image=[UIImage imageNamed:@"Wybs_duo.png"];
        [recordButton setImage:[UIImage imageNamed:@"2_0-126.png"] forState:UIControlStateNormal];
        double cTime = RecorderAcc.currentTime;
        if (cTime > 2) {//如果录制时间<2 不发送
            NSLog(@"发出去");
        }else {
            //删除记录的文件
            [RecorderAcc deleteRecording];
            //删除存储的
        }
        [RecorderAcc stop];
        [timerACC invalidate];
        
    }
    else
    {
        
        UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
        btn.enabled=NO;
        self.RotateImg.hidden=YES;
        [bianshiTime setFireDate:[NSDate distantPast]];
        [recordButton setImage:[UIImage imageNamed:@"2_06 -11122.png"] forState:UIControlStateNormal];
        //创建录音文件，准备录音
        if ([RecorderAcc prepareToRecord]) {
            //开始
            [RecorderAcc record];
        }
        
        timerACC = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(detectionVoices) userInfo:nil repeats:YES];
        
    }
    
}

-(void)runTimeBianshi1
{
    timeNStager++;
    if (timeNStager==5) {
        timeNStager=0;
        [bianshiTime1 setFireDate:[NSDate distantFuture]];
        [bianshiTime setFireDate:[NSDate distantPast]];
        [self ShiFanYinPlay];
    }
    
}
-(void)ShiFanYinPlay
{
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"WY_bssf.mp3" ofType:@"wav"];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    if ([UserShareOnce shareOnce].mp3)
    {
        if ([UserShareOnce shareOnce].mp3.playing) {
            [[UserShareOnce shareOnce].mp3 pause];
        }

        [UserShareOnce shareOnce].mp3 =nil;
    }
    [UserShareOnce shareOnce].mp3 = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    [[UserShareOnce shareOnce].mp3 setDelegate:self];//设置代理
    [UserShareOnce shareOnce].mp3.volume = 0.9;//播放音量
    [[UserShareOnce shareOnce].mp3 prepareToPlay];
    playmp3= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(paly) userInfo:nil repeats:NO];
    
}
-(void) paly
{
    [[UserShareOnce shareOnce].mp3 play];//播放音乐
    [playmp3 invalidate];
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"finish");//设置代理的AVAudioPlayer对象每次播放结束都会触发这个函数
}
-(void)runTimeBianshi2
{
    timeNStager++;
    if (timeNStager==5) {
        timeNStager=0;
        self.ZhiShiImgView2.hidden=YES;
        self.ZhiShiImgView3.hidden=YES;
        UIButton* btn1=(UIButton*)[self.view viewWithTag:10007];
        btn1.enabled=YES;
        [btn1 setImage:[UIImage imageNamed:@"演示前1.png"] forState:UIControlStateNormal];
        UIButton* btn=(UIButton*)[self.view viewWithTag:10004];
        btn.enabled=YES;
        yincangView.hidden = YES;
        [bianshiTime2 setFireDate:[NSDate distantFuture]];
    }
}
-(void)runTimeBianshi
{
    if (timeNStager==0)
    {
        if (IsShiFan)
        {
            self.ZhiShiImgView.hidden=YES;
            self.ZhiShiImgView1.hidden=NO;
        }
        _image1.image=[UIImage imageNamed:@"Wybs_duo_2.png"];
        _image3.image=[UIImage imageNamed:@"WinZhi_Img_duo_2.png"];
        _image2.image=[UIImage imageNamed:@"Wybs_duo.png"];
        timeNStager++;
        return;
    }
    if (timeNStager==1)
    {
        _image1.image=[UIImage imageNamed:@"Wybs_duo_3.png"];
        //_image3.image=[UIImage imageNamed:@"WinZhi_Img_duo_2.png"];
        //[segmentImg setImage:[UIImage imageNamed:@"bs_6_1_duo.png"] forSegmentAtIndex:0];
        timeNStager++;
        return;
    }
    
    if (timeNStager==2) {
        _image1.image=[UIImage imageNamed:@"Wybs_ruai_1.png"];
        _image3.image=[UIImage imageNamed:@"WinZhi_Img_duo_1.png"];
        _image4.image=[UIImage imageNamed:@"WinZhi_Img_ruai_2.png"];
        _image2.image=[UIImage imageNamed:@"Wybs_ruai.png"];
        // [segmentImg setImage:[UIImage imageNamed:@"bs_6_2_ruai.png"] forSegmentAtIndex:1];
        timeNStager++;
        return;
    }
    if (timeNStager==3) {
        _image1.image=[UIImage imageNamed:@"Wybs_ruai_2.png"];
        // _image4.image=[UIImage imageNamed:@"WinZhi_Img_ruai_2.png"];
        // [segmentImg setImage:[UIImage imageNamed:@"bs_6_1_ruai.png"] forSegmentAtIndex:1];
        timeNStager++;
        return;
    }
    if (timeNStager==4) {
        
        _image1.image=[UIImage imageNamed:@"Wybs_ruai_3.png"];
        //[segmentImg setImage:[UIImage imageNamed:@"bs_6_2_ruai.png"] forSegmentAtIndex:1];
        timeNStager++;
        return;
    }
    if (timeNStager==5) {
        
        _image1.image=[UIImage imageNamed:@"Wybs_mi_1.png"];
        _image4.image=[UIImage imageNamed:@"WinZhi_Img_ruai_1.png"];
        _image5.image=[UIImage imageNamed:@"WinZhi_Img_mi_2.png"];
        
        _image2.image=[UIImage imageNamed:@"Wybs_mi.png"];
        // [segmentImg setImage:[UIImage imageNamed:@"bs_6_2_mi.png"] forSegmentAtIndex:2];
        timeNStager++;
        return;
    }
    if (timeNStager==6) {
        
        _image1.image=[UIImage imageNamed:@"Wybs_mi_2.png"];
        //[segmentImg setImage:[UIImage imageNamed:@"bs_6_1_mi.png"] forSegmentAtIndex:2];
        timeNStager++;
        return;
    }
    if (timeNStager==7) {
        
        _image1.image=[UIImage imageNamed:@"Wybs_mi_3.png"];
        //[segmentImg setImage:[UIImage imageNamed:@"bs_6_2_mi.png"] forSegmentAtIndex:2];
        timeNStager++;
        return;
    }
    
    if (timeNStager==8) {
        
        _image1.image=[UIImage imageNamed:@"Wybs_sao_1.png"];
        _image5.image=[UIImage imageNamed:@"WinZhi_Img_mi_1.png"];
        _image6.image=[UIImage imageNamed:@"WinZhi_Img_sao_2.png"];
        
        _image2.image=[UIImage imageNamed:@"Wybs_sao.png"];
        // [segmentImg setImage:[UIImage imageNamed:@"bs_6_2_sao.png"] forSegmentAtIndex:3];
        timeNStager++;
        return;
    }
    if (timeNStager==9) {
        
        _image1.image=[UIImage imageNamed:@"Wybs_sao_2.png"];
        
        timeNStager++;
        return;
    }
    if (timeNStager==10) {
        
        _image1.image=[UIImage imageNamed:@"Wybs_sao_3.png"];
        
        timeNStager++;
        return;
    }
    
    if (timeNStager==11) {
        _image1.image=[UIImage imageNamed:@"Wybs_la_1.png"];
        _image6.image=[UIImage imageNamed:@"WinZhi_Img_sao_1.png"];
        _image7.image=[UIImage imageNamed:@"WinZhi_Img_la_2.png"];
        _image2.image=[UIImage imageNamed:@"Wybs_la.png"];
        //[segmentImg setImage:[UIImage imageNamed:@"bs_6_2_la.png"] forSegmentAtIndex:4];
        timeNStager++;
        return;
    }
    if (timeNStager==12) {
        
        _image1.image=[UIImage imageNamed:@"Wybs_la_2.png"];
        
        timeNStager++;
        return;
    }
    if (timeNStager==13) {
        
        _image1.image=[UIImage imageNamed:@"Wybs_la_3.png"];
//        [segmentImg setImage:[UIImage imageNamed:@"bs_6_2_la.png"] forSegmentAtIndex:4];
        timeNStager++;
        return;
    }
    if (timeNStager==14) {
        
        _image1.image=[UIImage imageNamed:@"Wybs_duo_1.png"];
        _image7.image=[UIImage imageNamed:@"WinZhi_Img_la_1.png"];
        _image2.image=[UIImage imageNamed:@"Wybs_duo.png"];
        //_image7.image=[UIImage imageNamed:@"WinZhi_Img_la_2.png"];
        // [segmentImg setImage:[UIImage imageNamed:@"bs_6_3_la.png"] forSegmentAtIndex:4];
        timeNStager=0;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        //if (RecorderAcc.isRecording)
        {
            
            //self.RotateImg.hidden=NO;
            UIButton* btn=(UIButton*)[self.view viewWithTag:10004];
            
            [btn setImage:[UIImage imageNamed:@"2_0-126.png"] forState:UIControlStateNormal];
            
            if (IsShiFan)
            {
                IsShiFan=NO;
                self.ZhiShiImgView1.hidden=YES;
                self.ZhiShiImgView2.hidden=NO;
                self.ZhiShiImgView3.hidden=NO;
                //UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
                
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                
                BOOL bRet = [fileMgr fileExistsAtPath:self.filePath];
                if (bRet) {
                    NSError *err;
                    [fileMgr removeItemAtPath:self.filePath error:&err];
                }
                [bianshiTime2 setFireDate:[NSDate distantPast]];
                return;
            }
            else{
                double cTime = RecorderAcc.currentTime;
                if (cTime > 2) {//如果录制时间<2 不发送
                    NSLog(@"发出去");
                }else {
                    //删除记录的文件
                    [RecorderAcc deleteRecording];
                    //删除存储的
                }
                [RecorderAcc stop];
                [timerACC invalidate];
            }
            
            NSLog(@" soundCount : %f",self.soundCount);
            if ( self.soundCount < 0.6) {
                [self soundTooLow];
            }else{
                if([GlobalCommon isManyMember]){
                    SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
                    __weak typeof(self) weakSelf = self;
                    [subMember receiveSubIdWith:^(NSString *subId) {
                        NSLog(@"%@",subId);
                        if ([subId isEqualToString:@"user is out of date"]) {
                            //登录超时
                            
                        }else{
                            [weakSelf testMp3Upload];
                            NSLog(@"选中的子账户id为：%@",subId);
                        }
                        [subMember hideHintView];
                    }];
                }else{
                    [self testMp3Upload];
                }
               
                
            }
    
        }
    }
}
-(void)testMp3Upload
{
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    
    //NSString *aUrlle= [NSString stringWithFormat:@"%@/member/fileUpload/upload.jhtml?fileType=media&convert=convert&memberChildId=%@",UrlPre,[MemberUserShance shareOnce].idNum];
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/fileUpload/diagnosis.jhtml?convert=convert&memberChildId=%@",UrlPre,[MemberUserShance shareOnce].idNum];
    NSLog(@"aurlle===%@",aUrlle);
    //aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    aUrlle = [aUrlle stringByRemovingPercentEncoding];
    NSURL *url1 = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url1];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setFile:self.filePath forKey:@"file"];   //可以上传图片
    [request setDidFailSelector:@selector(requestUpLoadError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestUpLoadCompleted:)];
    [request startAsynchronous];
//    [request release];
}
- (void)requestUpLoadCompleted:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
       
        LPPopup *popup = [LPPopup popupWithText:@"您的录音已成功上传，正在进行分析。分析报告审核完成后，会发送至您的手机上，请注意查收。"];
        imageHong.hidden = NO;
        CGPoint point=self.view.center;
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        BOOL bRet = [fileMgr fileExistsAtPath:self.filePath];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:self.filePath error:&err];
        }
        UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
        btn.enabled=YES;
        yincangView.hidden = YES;
        self.filePath = nil;
        recordButton.selected = NO;
        
        NSInteger code = [[[dic objectForKey:@"data"] objectForKey:@"code"] integerValue];
        NSString *codeStr = [self stringWithCode:code];
        NSString *aUrlle= [NSString stringWithFormat:@"%@/member/service/reshow.jhtml?sn=%@&device=1",URL_PRE,codeStr];
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = aUrlle;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        
        UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
        btn.enabled=YES;
        LPPopup *popup = [LPPopup popupWithText:@"抱歉，由于长时间无法连接到网络，系统将您的录音放在了“我的”的“未发出声的文件”里，您可以选择手工上传或删除。"];
        timeNStager=0;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        [self.Recordbtn setImage:[UIImage imageNamed:@"bs_an_kaishishibian.png"] forState:UIControlStateNormal];
        [self.recorder stopRecording];
        CGPoint point=self.view.center;
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
        self.filePath = nil;
        yincangView.hidden = YES;
        recordButton.selected = NO;
        return;
        
    }
}
- (void)requestUpLoadError:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
    btn.enabled=YES;
    LPPopup *popup = [LPPopup popupWithText:@"抱歉，由于长时间无法连接到网络，系统将您的录音放在了“我的”的“未发出声的文件”里，您可以选择手工上传或删除。"];
    CGPoint point=self.view.center;
    point.y=point.y+130;
    [popup showInView:self.view
        centerAtPoint:point
             duration:5.0f
           completion:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    recordButton.selected = NO;
    self.filePath = nil;
    yincangView.hidden = YES;
    return;
}

- (NSString *)stringWithCode:(NSInteger )code
{
    NSArray *codeArr = @[@"21", @"24", @"22", @"25", @"23",
                         @"18", @"17", @"16", @"19", @"20",
                         @"28", @"27", @"26", @"29", @"30",
                         @"32", @"31", @"34", @"33", @"35",
                         @"37", @"40", @"36", @"38", @"39"];
    NSInteger codeIndex = [[codeArr objectAtIndex:code] integerValue];
    NSString *codeStr = @"";
    if(codeIndex>=16&&codeIndex<=20){
        codeStr = [NSString stringWithFormat:@"JLBS-G%ld",codeIndex-15];
    }else if (codeIndex>=21&&codeIndex<=25){
        codeStr = [NSString stringWithFormat:@"JLBS-S%ld",codeIndex-20];
    }else if (codeIndex>=26&&codeIndex<=30){
        codeStr = [NSString stringWithFormat:@"JLBS-J%ld",codeIndex-25];
    }else if (codeIndex>=31&&codeIndex<=35){
        codeStr = [NSString stringWithFormat:@"JLBS-Z%ld",codeIndex-30];
    }else if (codeIndex>=36&&codeIndex<=40){
        codeStr = [NSString stringWithFormat:@"JLBS-Y%ld",codeIndex-35];
    }else{
        codeStr = @"";
    }
    return codeStr;
}

- (void)soundTooLow{
    
    [self hudWasHidden];
    LPPopup *popup = [LPPopup popupWithText:@"抱歉，未采集到有效声音。请提高音调！"];
    CGPoint point=self.view.center;
    point.y=point.y+130;
    [popup showInView:self.view
        centerAtPoint:point
             duration:5.0f
           completion:nil];
    
    recordButton.selected = NO;
    return;
}

- (void)requestConverAndParseError:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
}
- (void)requestConverAndParseCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        
        LPPopup *popup = [LPPopup popupWithText:@"您的录音已成功上传，正在进行分析。分析报告审核完成后，会发送至您的手机上，请注意查收。"];
        CGPoint point=self.view.center;
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        BOOL bRet = [fileMgr fileExistsAtPath:self.filePath];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:self.filePath error:&err];
        }
        
        timeNStager=0;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        [self.Recordbtn setImage:[UIImage imageNamed:@"bs_an_kaishishibian.png"] forState:UIControlStateNormal];
        [self.recorder stopRecording];
    }
    else
    {
        LPPopup *popup = [LPPopup popupWithText:@"抱歉，由于长时间无法连接到网络，系统将您的录音放在了“更多”的“闻音文件”里，您可以选择手工上传或删除。"];
        CGPoint point=self.view.center;
        timeNStager=0;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        [self.Recordbtn setImage:[UIImage imageNamed:@"bs_an_kaishishibian.png"] forState:UIControlStateNormal];
        [self.recorder stopRecording];
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
    }
}

-(void)showHUD
{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    [self.view bringSubviewToFront:_progress];
    _progress.delegate = self;
    _progress.label.text = @"加载中...";
    [_progress showAnimated:YES];
}

- (void)hudWasHidden
{
    
    
    [_progress removeFromSuperview];

    _progress = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
