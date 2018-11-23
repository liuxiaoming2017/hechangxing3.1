//
//  HomeViewController.m
//  MoxaAdvisor
//
//  Created by wangdong on 14/11/25.
//  Copyright (c) 2014年 jiudaifu. All rights reserved.
//

#import "i9_MoxaMainViewController.h"
#import "MoxaSettingViewController.h"
#import "OMGToast.h"
#import "UIButton+ImageWithLable.h"
#import "UIImage+Util.h"
#import "KeyBoardManager.h"
#import "I9_BlueToothListViewController.h"
#import "ChannelScrollView.h"
#import "FindBackPasswordViewController.h"
#import "PubFunc.h"
#import "ConfigUtil.h"
#import "i9_UISetTTViewForRollerController.h"

#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "NewChannelView.h"
#import "UIClickLabel.h"
#import <moxibustion/i9_BluetoothUtil.h>
#import "UIViewController+CWPopup.h"
#import "CMPopTipView.h"
#import "BaseControlViewController.h"
#import "RemindRegAlertView.h"
#import "MBProgressHUD.h"
#import "MoxiHeadInfView_i9.h"
#import "i9_UISetTTViewController.h"

#import <moxibustion/moxibustion.h>

#import "GuidanceView.h"

#import "ZYGASINetworking.h"

#import "NSObject+SBJson.h"

@interface i9_MoxaMainViewController () <MoxiHeadInfView_i9_Delegate,NewChannelViewGestureDelegate,moxibustionDelegate, UIClickLabelDelegate, CMPopTipViewDelegate,AVAudioPlayerDelegate, RemindRegDelegate, MBProgressHUDDelegate,i9_UISetTTDelegate>

@property (retain, nonatomic) UIClickLabel *indicatorLab;
@property (retain, nonatomic) UIActivityIndicatorView *searchIndicator;
@property (retain, nonatomic) UIButton *coverIndicatorBtn;

@property (retain, nonatomic) UIButton *recipelListBtn;

@property (retain, nonatomic) ChannelScrollView *channelViewHolder;
@property (weak, nonatomic) IBOutlet UIView *moxaBottomBgView;
@property (weak, nonatomic) IBOutlet UIButton *lampSwitchBtn;  //开关按钮
@property (weak, nonatomic) IBOutlet UIButton *recipelBtn;     //计划按钮
@property (weak, nonatomic) IBOutlet UIButton *soundBtn;       //声音按钮
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;     //设置按钮

@property (retain,nonatomic) MoxiHeadInfView_i9 *headinfView;

@property (retain, nonatomic) CMPopTipView *popTipView;

@property (retain, nonatomic) NSMutableArray *musicArray;
@property (retain, nonatomic) NSMutableArray *treatMArray;
@property (strong, nonatomic) NSString *deviceName;

@property (retain, nonatomic)NSMutableArray *channelArray;
@property (retain, nonatomic) NSMutableArray *xueweiGroupArray;
@property (retain, nonatomic) NSMutableArray *yijiuSelectArray;
@property (retain, nonatomic) NSMutableArray *moxaTTArray;
@property (assign, nonatomic) int normalTemp, normalTime;
@property (assign, nonatomic) BOOL hasNewTT;

@property (retain, nonatomic)NSString    *mPasswordStr;             //在已经连接到设备之后，首先获取密码,进行密码验证
@property (retain, nonatomic)NSString    *mModifyPassword;          //想要修改的密码， 暂存一下
@property (retain, nonatomic)NSMutableArray    *lastConnAddrArr;             //上次连接的地址
@property (retain, nonatomic)NSMutableDictionary  *macPwDic;        //mac和pw对应的map
@property (retain, nonatomic) AVAudioPlayer *audioPlayer;
@property (retain, nonatomic) NSTimer *mLightOffTimer;

@property (retain, nonatomic) NSTimer *mBehavorTimer;
@property (retain, nonatomic) NSTimer *mBehavor98Timer;
@property (retain, nonatomic) NSString *mPatientId;

@property (assign, nonatomic) BOOL bIsBecome;

@property (assign, nonatomic) BOOL bIsAJi9;
@property (assign, nonatomic) BOOL bGetAllDatasForAJi9;
@property (retain, nonatomic) NSMutableArray *cellLenghtArry;

@property (strong, nonatomic) RemindRegAlertView *remindRegView;
@property (strong, nonatomic) MBProgressHUD *progressView;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *mobileNum;
@property (strong, nonatomic) NSString *devNameSuffix;
@property (strong, nonatomic) NSMutableArray *outArray;
@property (assign, nonatomic) int webResult;
@property (retain, nonatomic) NSMutableArray *localRecipldata;
@property (assign, nonatomic) BOOL mRemindRegViewIsShow;
@property (assign, nonatomic) BOOL mRemindModifPasswordIsShow;

@property (retain, nonatomic) NSString *interTime;

@property (retain, nonatomic) NSString *blackTime;
@property (assign, nonatomic) BOOL hasPlayStartVoice;
@property (assign, nonatomic) uint32_t focuseAddress;
@property (assign, nonatomic) uint32_t heightTempAddress;
@property (retain, nonatomic) NSString *nameOfCheckPwd;
@property (assign, nonatomic) int shortTime;
@property (assign, nonatomic) int lowestTemp;
@property (retain, nonatomic) NSMutableArray *overPlanArry;

@property (assign, nonatomic) BOOL hasStartMoxa;
@property (retain, nonatomic) NSString *Guid;
@property (retain, nonatomic) NSMutableArray *hasRecodeChannal;

@property (retain,nonatomic) i9_UISetTTViewController *mSetAlertView;
@property (assign,nonatomic)  int autoUplaodRecodeflag;

@property (strong,nonatomic) GuidanceView *guideView;

@end

@implementation i9_MoxaMainViewController

@synthesize xueweiGroupArray;
@synthesize yijiuSelectArray;
@synthesize mPasswordStr;
@synthesize mModifyPassword;
@synthesize lastConnAddrArr;
@synthesize audioPlayer;
@synthesize mLightOffTimer;
@synthesize mBehavorTimer;
@synthesize isFirstIn;
@synthesize isSwitching;
@synthesize mPassword_state;          //蓝牙窗口状态
@synthesize mCurrChannel;
@synthesize mCurrWenDu;
@synthesize bVoiceOn;
@synthesize bIsFirstPlay;
@synthesize bLampState;
@synthesize cellLenghtArry = _cellLenghtArry;
@synthesize localRecipldata = _localRecipldata;
@synthesize mRemindRegViewIsShow = _mRemindRegViewIsShow;
@synthesize mRemindModifPasswordIsShow = _mRemindModifPasswordIsShow;
@synthesize hasPlayStartVoice = _hasPlayStartVoice;
@synthesize focuseAddress;
@synthesize heightTempAddress;
@synthesize nameOfCheckPwd;
@synthesize shortTime;
@synthesize lowestTemp;
@synthesize overPlanArry;
@synthesize Guid = _Guid;
@synthesize hasRecodeChannal = _hasRecodeChannal;
@synthesize mSetAlertView ;
@synthesize autoUplaodRecodeflag;
@synthesize hasStartMoxa = _hasStartMoxa;
@synthesize settingsBoudIsShow;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [moxibustion getInstance].mDataDelegate = self;
    [moxibustion getInstance].work;
    
    _mRemindRegViewIsShow = NO;
    _hasPlayStartVoice = NO;
    autoUplaodRecodeflag = 0;
    settingsBoudIsShow = NO;
    _hasStartMoxa = NO;
    yijiuSelectArray = [NSMutableArray new];
    _hasRecodeChannal = [NSMutableArray new];
    _Guid = nil;

    shortTime = 0;
    lowestTemp = 0;

    self.topView.backgroundColor = UIColorFromHex(0x1e82d2);
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.preBtn.hidden = NO;
    
    [self initView];
    [self initViewAndDatas];
}


-(void)initViewAndDatas {
    _bIsAJi9 = true;
    isSwitching = false;
    isFirstIn = true;
    bIsFirstPlay = true;
    _bIsBecome = false;
    focuseAddress = 0x0;
    
    [self loadHistoryLastAndPw];
   // _musicArray = [NSArray arrayWithObjects:@"moxastart", @"moxaend2", @"wd53", @"wd54", @"wd55", @"wd56", nil];
    _musicArray = [[NSMutableArray alloc] init];
    [_musicArray addObject:@"moxastart"];
    [_musicArray addObject:@"moxaend2"];
    [_musicArray addObject:@"wd53"];
    [_musicArray addObject:@"wd54"];
    [_musicArray addObject:@"wd55"];
    [_musicArray addObject:@"wd56"];
    _channelArray = [[NSMutableArray alloc] init];
    [self setlampState:false update:YES];

    xueweiGroupArray = [[NSMutableArray alloc]init];
    _cellLenghtArry = [[NSMutableArray alloc]init];
    lastConnAddrArr = [[NSMutableArray alloc]init];
    
    [self readMoxaTTDatas];
    _normalTemp = 38;
    _normalTime = 1;
    [self createBehavorTimerTask];
}

-(void)initView{
    int height,height2;
    if(iPhone4){
        height = (SCREEN_HEI - 64)/4*1;
        height2 = (SCREEN_HEI - 64)/4*3;
    }else if(iPhone5){
        height = (SCREEN_HEI - 64)/5*1;
        height2 = (SCREEN_HEI - 64)/5*4;
    }
    else{
        height = (SCREEN_HEI - 64)/6*1;
        height2 = (SCREEN_HEI - 64)/6*5;
    }
    
    height = 45;
    height2=SCREEN_HEI - height - self.topView.bottom;
    
    _headinfView = [[MoxiHeadInfView_i9 alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_WID, height)];
    _headinfView.backgroundColor = UIColorFromHex(0x1e82d2);
    
    
    _headinfView.delegate = self;
    [self.view addSubview:_headinfView];
    
    
    UILabel *remnderlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _headinfView.bottom, ScreenWidth, 40)];
    remnderlabel.font = [UIFont systemFontOfSize:16];
    remnderlabel.textAlignment = NSTextAlignmentLeft;
    remnderlabel.textColor = [UIColor orangeColor];
    remnderlabel.text = @" 温馨提示:儿童灸疗温度不宜超过39℃";
    [self.view addSubview:remnderlabel];
    
    
    _channelViewHolder = [[ChannelScrollView alloc] initWithFrame:CGRectMake(0, remnderlabel.bottom, SCREEN_WID, ScreenHeight-remnderlabel.bottom)];
    _channelViewHolder.viewArry = _channelArray;
    [_channelViewHolder setBackgroundColor:[UIColor colorWithRed:(235 / 255.0) green:(235 / 255.0) blue:(235 / 255.0) alpha:1.0]];
    [self.view addSubview:_channelViewHolder];
    
    
    [self showGuidanceView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _interTime = [PubFunc getCurrentDateInterval];
    _mRemindModifPasswordIsShow = YES;
    if(isFirstIn)
    {
        NSArray *arrayOfViews = [[NSBundle mainBundle]loadNibNamed:@"moxaTopView" owner:self options:nil];
        NSLog(@"---arrayOfViews.count = %lu",(unsigned long)arrayOfViews.count);
        UIView *view =  [[[NSBundle mainBundle]loadNibNamed:@"moxaTopView" owner:self options:nil] lastObject];
        view.frame = CGRectMake(ScreenWidth/2.0-100, kStatusBarHeight, 200, 44);
        NSLog(@"---view = %@",[view description]);
        _indicatorLab = (UIClickLabel*)[view viewWithTag:1];
        [_indicatorLab setTextColor:[UIColor whiteColor]];
        [_indicatorLab addUnderLine:@"设备搜寻中"];
        _searchIndicator = (UIActivityIndicatorView *)[view viewWithTag:2];
        [_searchIndicator setHidden:YES];
        _coverIndicatorBtn = (UIButton*)[view viewWithTag:3];
        _recipelListBtn = [self creatMoxaRightBtn];
        [_coverIndicatorBtn addTarget:self action:@selector(onClickBleBtn:) forControlEvents:UIControlEventTouchUpInside];
        //self.navigationItem.titleView = view;
        
        [self.topView addSubview:view];
        
        [_recipelListBtn addTarget:self action:@selector(onClickRecipelListBtn:) forControlEvents:UIControlEventTouchUpInside];
        _recipelListBtn.frame = CGRectMake(ScreenWidth-37-14, 2+kStatusBarHeight, 40, 40);
        [self.topView addSubview:_recipelListBtn];
        
        // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_recipelListBtn];
        
        isFirstIn = false;
    }
    [_headinfView.mChoosePlanBtn setTitle:@"当前无灸疗计划" forState:UIControlStateNormal];
}


- (UIButton *)creatMoxaRightBtn{
    UIImage *image2 = [UIImage imageNamed:@"btn_recipelst_normal.png"];
    UIImage *image1 = [UIImage imageNamed:@"btn_recipelst_normal.png"];  //@"btn_recipelst_pressed.png"
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 32, 32);
    [btn setImage:image1 forState:UIControlStateNormal];
    [btn setImage:image2 forState:UIControlStateHighlighted];
    return btn;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _blackTime = [PubFunc getCurrentDateInterval];
    _mRemindModifPasswordIsShow = NO;
    [self createBehavor98TimerTask];
}


-(void)freshIndicatorLab{
    if([[moxibustion getInstance] getBluetoothConnectState] == CONNECT_ON){
        BTDevItem * item = [[moxibustion getInstance] getConnectDevice];
        if([PubFunc isEmpty:item.u_Name]){
            [_indicatorLab addUnderLine:@"未连接"];
            [self showGuidanceView];
        }else{
            [self hideGuidanceView];
            [_indicatorLab addUnderLine:[NSString stringWithFormat:@"%@-%@",@"已连接AJi9",item.u_Name]];
            
        }
    }else if( [[moxibustion getInstance] getBluetoothConnectState] == CONNECT_OFF)
    {
        [_indicatorLab addUnderLine:@"未连接"];
        [self showGuidanceView];
    }
    else{
        [_indicatorLab addUnderLine:@"连接中"];
    }
}

# pragma mark - 周围没有搜索到设备或者没有打开蓝牙显示指导视图
- (void)showGuidanceView
{
    if(!self.guideView){
        self.guideView = [[GuidanceView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight)];
        self.guideView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.guideView];
    }else{
        self.guideView.hidden = NO;
    }
   
}

- (void)hideGuidanceView
{
    if(self.guideView){
        self.guideView.hidden = YES;
    }
}

-(void)reduceOneChannelView:(DeviceModel *)device{
    for (int i = 0 ; i < _channelArray.count;i++) {
        NewChannelView *view = [_channelArray objectAtIndex:i];
        i9_JaExecuteStru *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
        if(stru.deviceitem.u_DevAdress == device.u_DevAdress){
            [_channelArray removeObject:view];
            [[[moxibustion getInstance] getExecuteStruLst] removeObjectAtIndex:i];
            _channelViewHolder.viewArry = _channelArray;
            [_channelViewHolder freshChannelView];
            if(device.u_DevAdress == focuseAddress){
                [view hideFocse];
                NewChannelView *view2 = [_channelArray objectAtIndex:0];
                i9_JaExecuteStru *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:0];
                focuseAddress = stru.deviceitem.u_DevAdress;
                [view2 showFocse];
            }
            return;
        }
    }

}

-(void)addOneChannelView{
    NewChannelView *view = [self CreateChannelView];
    _channelViewHolder.viewArry = _channelArray;
    [_channelViewHolder addChannelView:view];
}

-(NewChannelView *)CreateChannelView{
    int num = -1;
    int wid,hei;
    if(iPhone4 || iPhone5){
        wid = (_channelViewHolder.frame.size.width-2)/2;
        hei = (_channelViewHolder.frame.size.height-2)/2 - 3;
    }else{
        wid = (_channelViewHolder.frame.size.width-2)/2;
        hei = (_channelViewHolder.frame.size.height-2)/3 + 5;
    }
    NewChannelView *channelview = [[NewChannelView alloc]instanceWithFrame:CGRectMake(0, 0, wid, hei) channelNo:num Mode:MODE_I9];
    [channelview updateWenDu:_normalTemp];
    [channelview updateShiJian:_normalTime*60];
    channelview.mGestureDelegate = self;
    [_channelArray addObject:channelview];
    
    i9_JaExecuteStru *exeStru = [[i9_JaExecuteStru alloc] init];
    [exeStru setContrlStateTempv:_normalTemp Timev:_normalTime Statev:JAEXECUTE_STATE_UNKNOWN];
    [exeStru setSetBakStateTempv:_normalTemp Timev:_normalTime Statev:JAEXECUTE_STATE_UNKNOWN];
    [[[moxibustion getInstance] getExecuteStruLst] addObject:exeStru];
    return channelview;
}

-(void)ShowSettingsBoud:(NewChannelView*)view{
    int alertViewheight;
    int alertViewY;
    if(iPhone4){
        alertViewheight = (SCREEN_HEI - SCREEN_TOP_BAR_HEI - 50)/10*7;
    }
    else if(iPhone5){
        alertViewheight = (SCREEN_HEI - SCREEN_TOP_BAR_HEI - 50)/10*6;
    }
    else{
        alertViewheight = (SCREEN_HEI - SCREEN_TOP_BAR_HEI - 50)/10*5;
    }
    if (iPhoneX) {
        alertViewY = SCREEN_HEI - 50 - alertViewheight-33;
        
    }else{
        alertViewY = SCREEN_HEI - 50 - alertViewheight;
    }
    mSetAlertView = [[i9_UISetTTViewForRollerController alloc] initWithNibName:@"i9_UISetTTViewForRoller" bundle:nil];
    mSetAlertView.setTTDelegate = self;
    settingsBoudIsShow = YES;
    [self presentPopupViewControllerwithRect:mSetAlertView Posation:CGRectMake(0, alertViewY, SCREEN_WID, alertViewheight) animated:YES completion:^(void) {
        [mSetAlertView seti9ChannelView:view BlurView:self];
        [mSetAlertView setWenDuVal:[view getWenDu] setShiJianVal:[view getShiJian]/60 _channal:view.tag+1];
    }];
}

-(void)LongPressShack{
    NewChannelView *view = [self getViewByAddress:focuseAddress];
    i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:view];
    [[moxibustion getInstance] sendCommend:CMD_GETSHAKEMOTOR JaExecuteStru_:stru ISUserComm_:YES];
}

#pragma ChannelViewGestureDelegate
-(void)singleClick:(NewChannelView*)view
{
    i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:view];
    if(stru.deviceitem.u_DevAdress != focuseAddress){
        NewChannelView *fview = [self getViewByAddress:focuseAddress];
        [fview hideFocse];
        focuseAddress = stru.deviceitem.u_DevAdress;
        [view showFocse];
    }
    if(settingsBoudIsShow == NO){
        [self ShowSettingsBoud:view];
    }
}

-(void)longPress:(NewChannelView*)view
{
    i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:view];
    if(stru.deviceitem.u_DevAdress != focuseAddress){
        NewChannelView *fview = [self getViewByAddress:focuseAddress];
        [fview hideFocse];
        focuseAddress = stru.deviceitem.u_DevAdress;
        [view showFocse];
    }
    if(view.states == CHANNEL_STOP || view.states == CHANNEL_WORK){
        
        i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:view];
        [[moxibustion getInstance] sendCommend:CMD_GETSHAKEMOTOR JaExecuteStru_:stru ISUserComm_:YES];
        [self performSelector:@selector(LongPressShack) withObject:nil afterDelay:0.5];  //连续震动3次，为了统一android的要求
        [self performSelector:@selector(LongPressShack) withObject:nil afterDelay:1];
    }
}

-(CGFloat) distanceBetweenPoints:(CGPoint) first seconed:(CGPoint) second
{
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
}

- (BOOL)isTrackIntersect:(NewChannelView*)view
{
    for (NewChannelView *v in _channelArray)
    {
        if(v.tag != view.tag)
        {
            if([self distanceBetweenPoints:v.center seconed:view.center] < v.frame.size.width-10)
            {
                return YES;
            }
        }
    }
    return NO;
}

-(void)OneSwitchBtnOnclink:(NewChannelView *)view{
    i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:view];
    if(stru.deviceitem.u_DevAdress != focuseAddress){
        NewChannelView *fview = [self getViewByAddress:focuseAddress];
        [fview hideFocse];
        focuseAddress = stru.deviceitem.u_DevAdress;
        [view showFocse];
    }
    
    if([view getStates] == CHANNEL_NOLINK)
    {
        if([[moxibustion getInstance] getBluetoothConnectState] == CONNECT_OFF)
        {
            [OMGToast showWithText:@"请连接灸大夫隔物灸仪" duration:1.5f];
        }
        else
        {
            [OMGToast showWithText:@"请连接灸头" duration:1.5f];
        }
    }
    else if([view getStates] == CHANNEL_WORK)
    {
        stru.mSendTemp = stru.mCtrlTemp;
        stru.mSendTime = stru.mCtrlTime;
        [[moxibustion getInstance] sendCommend:CMD_OPENCHANNEL JaExecuteStru_:stru ISUserComm_:YES];
        //记录开始时间，不用教正时间
        [[moxibustion getInstance] recordStartTimePoint:stru.deviceitem.u_DevAdress EXEStru:stru NeedCheck:false];
        
        stru.mCtrlState = JAEXECUTE_STATE_RUN;
        [self updateChannelViewData:view ExeStru:stru NeedAnim:false];
        int wdVal = stru.mCtrlTemp;
        if(wdVal >= WARNNING_WENDU)
        {
            int index = [self getWarnningIndex:wdVal];
            [self playMedia:_musicArray[index+2]];
            mCurrWenDu = wdVal;
            heightTempAddress = stru.deviceitem.u_DevAdress;
            [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
            [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
        }
    }
    else if([view getStates] == CHANNEL_STOP)
    {
        [[moxibustion getInstance] sendCommend:CMD_CLOSECHANNEL JaExecuteStru_:stru ISUserComm_:YES];
        
        stru.mCtrlState = JAEXECUTE_STATE_IDLE;
        [self updateChannelViewData:view ExeStru:stru NeedAnim:false];
    }
}


CGFloat i9distanceBetweenPoints (CGPoint first, CGPoint second)
{
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};

-(void)OpenAllChannel{
    int wdVal = 0;
    if([[moxibustion getInstance] getBluetoothOpenState] != STATE_ON){
        [OMGToast showWithText:@"请打开手机蓝牙" duration:1.5f];
        return;
    }
    if([[moxibustion getInstance] getBluetoothConnectState] != CONNECT_ON){
        [OMGToast showWithText:@"请连接灸头" duration:1.5f];
         return;
    }
    for (int i = 0; i < _channelArray.count; i++)
    {
        NewChannelView *view = [_channelArray objectAtIndex:i];
        i9_JaExecuteStru *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
        if (stru.mCtrlState != JAEXECUTE_STATE_RUN){
            stru.mSendTemp = stru.mCtrlTemp;
            stru.mSendTime = stru.mCtrlTime;
            [[moxibustion getInstance] sendCommend:CMD_OPENCHANNEL JaExecuteStru_:stru ISUserComm_:YES];
            if(wdVal < stru.mCtrlTemp){
                wdVal = stru.mCtrlTemp;
                heightTempAddress = stru.deviceitem.u_DevAdress;
            }
            [[moxibustion getInstance] recordStartTimePoint:stru.deviceitem.u_DevAdress EXEStru:stru NeedCheck:false];
            stru.mCtrlState = JAEXECUTE_STATE_RUN;
            [self updateChannelViewData:view ExeStru:stru NeedAnim:false];
        }
    }
    if(wdVal >= WARNNING_WENDU)
    {
        int index = [self getWarnningIndex:wdVal];
        [self playMedia:_musicArray[index+2]];
        mCurrWenDu = wdVal;
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    }
}

# pragma mark - 设置灸头温度时间的代理回调
-(void)wheni9SetTT:(NewChannelView*)view WenDu:(int)wdVal shiJian:(int)sjVal allset:(int)forall
{
    [self whenSetTT:view WenDu:wdVal shiJian:sjVal allset:forall start:true warn:true];
    [self saveLastLowestTempAndTime:wdVal shiJian:sjVal];
    
    //[self setUpNetwork];
}

-(void)whenSetTT:(NewChannelView*)view WenDu:(int)wdVal shiJian:(int)sjVal allset:(int)forall start:(BOOL)enable warn:(BOOL)warn_
{
    int channel = [_channelArray indexOfObject:view];
    NewChannelView *channelView;
    i9_JaExecuteCommClass  *commC;
    i9_JaExecuteStru *stru;
    [self saveLastLowestTempAndTime:wdVal shiJian:sjVal];
    for (int i = 0; i < _channelArray.count; i++)
    {
        channelView = [_channelArray objectAtIndex:i];
        i9_JaExecuteStru *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
        if(i == channel || forall == 3)
        {
            DeviceModel *item = stru.deviceitem;
            if (stru.mCtrlTemp != wdVal)
            {
                stru.mCtrlTemp = wdVal;
                stru.mSendTemp = wdVal;
                [[moxibustion getInstance] sendCommend:CMD_SETTEMP JaExecuteStru_:stru ISUserComm_:YES];
            }
            stru.mCtrlTime = sjVal;
            stru.mSetTime = sjVal;
            stru.mRemainSec = sjVal;
            stru.mTotalSec = sjVal;
            stru.mSendTime = sjVal;
            [[moxibustion getInstance] sendCommend:CMD_SETTIME JaExecuteStru_:stru ISUserComm_:YES];
            if(stru.mCtrlTime != 0 && [channelView getStates] != CHANNEL_NOLINK && enable)
            {
                stru.mSendTime = stru.mCtrlTime;
                [[moxibustion getInstance] sendCommend:CMD_OPENCHANNEL JaExecuteStru_:stru ISUserComm_:YES];
                stru.mCtrlState = JAEXECUTE_STATE_RUN;
            }else{
                if(stru.mCtrlTime == 0){
                    [OMGToast showWithText:@"请设置温度" duration:1.5f];
                }
            }
            //记录开始时间，不用校正时间
            if(stru.mCtrlState == JAEXECUTE_STATE_RUN)
                [[moxibustion getInstance] recordStartTimePoint:i  EXEStru:stru NeedCheck:false];
            
            [self setMoxaTTDatas:stru];
        }
        else {
            if (forall == 1) {
                // all wendu
                channelView = [self getViewByAddress:stru.deviceitem.u_DevAdress];
                stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
                if (stru.mCtrlTemp != wdVal)
                {
                    stru.mCtrlTemp = wdVal;
                    stru.mSendTemp = wdVal;
                    [[moxibustion getInstance] sendCommend:CMD_SETTEMP JaExecuteStru_:stru ISUserComm_:YES];
                }
                // 设置好就启动 wangdong
                if(stru.mCtrlTime != 0 && [channelView getStates] != CHANNEL_NOLINK && enable)
                {
                    stru.mSendTemp = stru.mCtrlTemp;
                    stru.mSendTime = stru.mCtrlTime;
                    [[moxibustion getInstance] sendCommend:CMD_OPENCHANNEL JaExecuteStru_:stru ISUserComm_:YES];
                    stru.mCtrlState = JAEXECUTE_STATE_RUN;
                }
                else{
                    if(stru.mCtrlTime == 0){
                        [OMGToast showWithText:@"请设置温度" duration:1.5f];
                    }
                }
                //记录开始时间，不用校正时间
                if(stru.mCtrlState == JAEXECUTE_STATE_RUN)
                    [[moxibustion getInstance] recordStartTimePoint:i  EXEStru:stru NeedCheck:false];
                
                [self setMoxaTTDatas:stru];
                
            }else if (forall == 2) {
                // all shijian
                channelView = [self getViewByAddress:stru.deviceitem.u_DevAdress];
                stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
                stru.mCtrlTime = sjVal;
                stru.mSetTime = sjVal;
                stru.mRemainSec = sjVal;
                stru.mTotalSec = sjVal;
                stru.mSendTime = sjVal;
                [[moxibustion getInstance] sendCommend:CMD_SETTIME JaExecuteStru_:stru ISUserComm_:YES];
                if(stru.mCtrlTime != 0 && [channelView getStates] != CHANNEL_NOLINK && enable)
                {
                    stru.mSendTemp = stru.mCtrlTemp;
                    stru.mSendTime = stru.mCtrlTime;
                    [[moxibustion getInstance] sendCommend:CMD_OPENCHANNEL JaExecuteStru_:stru ISUserComm_:YES];
                    stru.mCtrlState = JAEXECUTE_STATE_RUN;
                }else{
                    if(stru.mCtrlTime == 0){
                        [OMGToast showWithText:@"请设置温度" duration:1.5f];
                    }
                }
                //记录开始时间，不用校正时间
                if(stru.mCtrlState == JAEXECUTE_STATE_RUN)
                    [[moxibustion getInstance] recordStartTimePoint:i  EXEStru:stru NeedCheck:false];
                
                [self setMoxaTTDatas:stru];
            }
        }
        
    }
    [self saveMoxaTTDatas];
    
    if(wdVal >= WARNNING_WENDU && warn_)
    {
        int index = [self getWarnningIndex:wdVal];
        [self playMedia:_musicArray[index+2]];
        mCurrWenDu = wdVal;
        i9_JaExecuteStru *jstru = [self getExecuteStruBychannalView:view];
        heightTempAddress = jstru.deviceitem.u_DevAdress;
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    }
}

-(void)saveLastLowestTempAndTime:(int)wdVal shiJian:(int)sjVal{
    if(shortTime == 0 || shortTime < sjVal){
        shortTime = sjVal;
        [ConfigUtil setMoxaLastTime:[NSString stringWithFormat:@"%d",shortTime]];
    }
    if(lowestTemp == 0 || lowestTemp > wdVal){
        lowestTemp = wdVal;
        [ConfigUtil setMoxaLastTemp:[NSString stringWithFormat:@"%d",lowestTemp]];
    }
}

- (void)delayMethod {
//    int index = mCurrWenDu-WARNNING_WENDU;
    int index = [self getWarnningIndex:mCurrWenDu];
    if(index > 3)return;
    if([PubFunc isAlert]){
        return;
    }
    NSArray *strArray = [NSArray arrayWithObjects:@"您设置的温度已进入高温区\n有可能导致灸疗部位起水泡！",
                         @"您设置的温度比较高\n很有可能导致灸疗部位起水泡的哦!",
                         @"您设置的温度已经很高了\n很容易导致灸疗部位起水泡哦!",
                         @"您设置的温度已经到顶了\n灸疗部位很容易起水泡哦!",nil
                         ];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:strArray[index] delegate:self
                                          cancelButtonTitle:@"重新设置" otherButtonTitles:@"确定", nil];
    
    alert.tag = 4;
    [alert show];
}

-(int)getWarnningIndex:(int)wendu{
    if(wendu == 48){
        return 0;
    }else if (wendu > 48 && wendu <= 52){
        return 1;
    }else if (wendu > 52 && wendu <= 55){
        return 2;
    }else if (wendu == 56){
        return 3;
    }
    return 0;
}

-(void)trackCommunicationfresh{
    [self freshIndicatorLab];
    if([self checkHasMoxaNotWork]){
        [_headinfView.mSwitch setTitle:@"一键开" forState:UIControlStateNormal];
    }else{
        [_headinfView.mSwitch setTitle:@"全部关" forState:UIControlStateNormal];
    }
}

-(void)trackCommunicationMoxaComplete{
    [self playMedia:_musicArray[1]];
}

-(void)UpdateChannalNew:(i9_JaExecuteStru *)stru NeedAnim:(BOOL)flag{
    int index = (int)[[[moxibustion getInstance] getExecuteStruLst] indexOfObject:stru];
    if(_channelArray.count>0){
        NewChannelView *view = [_channelArray objectAtIndex:index];
        [self updateChannelViewData:view ExeStru:stru NeedAnim:flag];
    }
    
}

//处理发送失败
-(void)sendCommFailProcess:(i9_JaExecuteCommClass*)commC
{
    if(commC == nil)
    {
        return;
    }
    
    int channel = commC.strucDataL&0xff;
    if(commC.strucCmd == CMD_SETTEMP)
    {
        //设置温度没回应
        i9_JaExecuteStru  *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:channel];
        if(stru != nil)
        {
            //更新控制显示
            stru.mCtrlTemp = stru.mSetTemp;
            [self updateChannelViewData:[_channelArray objectAtIndex:channel] ExeStru:stru NeedAnim:false];
        }
    }
    else if(commC.strucCmd == CMD_SETTIME)
    {
        //设置时间没回应
        i9_JaExecuteStru  *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:channel];
        if(stru != nil)
        {
            //更新控制显示
            stru.mCtrlTime = stru.mSetTime;
            [self updateChannelViewData:[_channelArray objectAtIndex:channel] ExeStru:stru NeedAnim:false];
        }
    }
    else if(commC.strucCmd == CMD_READCHANNEL)
    {
        //读通道状态无回应
    }
    else if(commC.strucCmd == CMD_OPENCHANNEL)
    {
        //开始灸疗无回应
        i9_JaExecuteStru  *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:channel];
        if(stru != nil)
        {
            //更新控制显示
            stru.mCtrlState = stru.mSetState;
            [self updateChannelViewData:[_channelArray objectAtIndex:channel] ExeStru:stru NeedAnim:false];
        }
    }
    else if(commC.strucCmd == CMD_CLOSECHANNEL)
    {
        //关闭灸疗无回应
        i9_JaExecuteStru  *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:channel];
        if(stru != nil)
        {
            //更新控制显示
            stru.mCtrlState = stru.mSetState;
            [self updateChannelViewData:[_channelArray objectAtIndex:channel] ExeStru:stru NeedAnim:false];
        }
    }
    else if(commC.strucCmd == CMD_GETPASSWORD)
    {
        //获取密码失败， 断开连接
        mPassword_state = WPASSWORD_HIDE;
    }
    else if(commC.strucCmd == CMD_HASCHANNELD)
    {
        //读取是否存在灸头失败
        if(mPassword_state == WPASSWORD_CHECK)
        {
            //找回密码失败
            [self popUpMsgForPassword:@"找回密码失败"];
        }
        else if(mPassword_state == WPASSWORD_MODIFY)
        {
            //设置密码失败
            [self popUpMsgForPassword:@"设置密码失败"];
        }
    }
    else if(commC.strucCmd == CMD_SETPASSWORD)
    {
        //设置密码失败
        [self popUpMsgForPassword:@"设置密码失败"];
    }
    else if(commC.strucCmd == CMD_LIGHT)
    {
        
    }
}

//更新某个通道数据
-(void) updateChannelViewData:(NewChannelView *)view ExeStru:(i9_JaExecuteStru*)stru NeedAnim:(bool) bAnim
{
    i9_JaExecuteStru *currStru = stru;
    int sec = currStru.mCtrlTime;
    int temp = currStru.mCtrlTemp;
    int electry = currStru.mCtrlElectricity;
    if(currStru.mSetState == JAEXECUTE_STATE_UNKNOWN || currStru.mCtrlState == JAEXECUTE_STATE_NOSET)
    {
        if([view getStates] == CHANNEL_STOP || [view getStates] == CHANNEL_WORK)
        {
        }
        [view setStates:CHANNEL_NOLINK];
    }else if(currStru.mSetState == JAEXECUTE_STATE_WAIT){
        [view setStates:CHANNEL_LINKING];
    }
    else if(currStru.mCtrlState == JAEXECUTE_STATE_IDLE)
    {
        [view updateWenDu:temp];
        [view updateShiJian:sec];
        [view updateElectricity:electry];
        if([view getStates] == CHANNEL_NOLINK)
        {
        }
        else if([view getStates] == CHANNEL_WORK)
        {
        }
        [view setStates:CHANNEL_STOP];
    }
    else if(currStru.mCtrlState == JAEXECUTE_STATE_RUN)
    {
        sec = currStru.mRemainSec;
        [view updateWenDu:temp];
        [view updateShiJian:sec];
        [view updateElectricity:electry];
        if([view getStates] == CHANNEL_NOLINK)
        {
        }
        else if([view getStates] == CHANNEL_STOP)
        {
        }
        [view setStates:CHANNEL_WORK];
    }
}

-(void) updatePasswordState:(NSString *)name
{
    if(mPassword_state == WPASSWORD_CHECK)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"您正在连接灸大夫隔物灸仪AJi9-%@网络",name] message:@"请输入3位数字" delegate:self
                         cancelButtonTitle:@"取消" otherButtonTitles:@"确定", @"找回密码失败", nil];
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
        [[alert textFieldAtIndex:0] addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        alert.tag = 1;
        [alert show];
    }
    else if(mPassword_state == WPASSWORD_MODIFY)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"设置灸大夫隔物灸仪密码" message:@"请输入6位数字\n(必须把所有灸头拨下来)" delegate:self
                         cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
        [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeDecimalPad];
        [[alert textFieldAtIndex:0] addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        alert.tag = 2;
        [alert show];
    }
    else if(mPassword_state == WPASSWORD_HIDE)
    {
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 3) {
        textField.text = [textField.text substringToIndex:3];
    }
}

- (BOOL)isPureInt:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex == 0)
        {
           
        }
        else if(buttonIndex ==1)
        {
            UITextField *tf = [alertView textFieldAtIndex:0];
            NSString *passwordStr = [tf text];
            if([passwordStr length] != 3)
            {
                [self popUpMsgForPassword:@"请输入3位数字"];
                [tf setText:@""];
            }
            else if(![self isPureInt:passwordStr]){
                [self popUpMsgForPassword:@"必须输入数字(0~9)"];
                [tf setText:@""];
            }
            else
            {
                BTDevItem *tempItem = [[moxibustion getInstance] getSearchedDevice];
                if([passwordStr isEqualToString:[[moxibustion getInstance] getDevicePassWord:tempItem]])
                {
                    [[moxibustion getInstance] connectOneDevices:tempItem];
                }
                else
                {
                    [self popUpMsgForPassword:@"密码错误"];
                    [tf setText:@""];
                }
            }
        }
        else{
            FindBackPasswordViewController *vc = [[FindBackPasswordViewController alloc] initWithNibName:@"FindBackPasswordView" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if(alertView.tag == 4)
    {
        [self stopMedia];
        if(buttonIndex == 0)
        {
            NewChannelView *view ;
            if(focuseAddress != heightTempAddress){
                NewChannelView *fview = [self getViewByAddress:focuseAddress];
                [fview hideFocse];
                focuseAddress = heightTempAddress;
                view = [self getViewByAddress:focuseAddress];
                [view showFocse];
            }else{
                view = [self getViewByAddress:focuseAddress];
            }
            [self ShowSettingsBoud:view];
        }
    }
    else if(alertView.tag == 5){
        if(buttonIndex == 1){
            if([[moxibustion getInstance] getBluetoothConnectState] == YES){
                [[moxibustion getInstance] clearAllCommend];
                if(![self checkAllChannelClose])
                {
                    [self closeAllChannel];
                }
            }
        }
    }else if(alertView.tag == 6){
     
    }
}

-(void)DisConnectAllDeivce{
    [[moxibustion getInstance] disConnect];
    [self setlampState:false update:YES];
}


//加载保存的配置
-(void) loadHistoryLastAndPw
{
    bVoiceOn = [BlueToothCommon getMoxaVoiceEn];  
}

/*
 * for check or set password
 */
- (void)dimissAlert:(NSTimer*)theTimer
{
    NSString *str = nil;
    //弹出框
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    [theTimer invalidate];
    if(mPassword_state == WPASSWORD_CHECK){
        str = nameOfCheckPwd;
    }
}

- (void)popUpMsgForPassword:(NSString *) _message
{
    //时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(dimissAlert:)
                                   userInfo:promptAlert
                                    repeats:false];
    [promptAlert show];
}

-(void)scanfedToinitView:(NSString *)meshname{
    nameOfCheckPwd = meshname;
    mPassword_state = WPASSWORD_CHECK;
    [self updatePasswordState:meshname];
}

# pragma mark - 错误信息回调接口
-(void)errorMessge:(error_type)msgType _Messge:(NSString *)msg{
    NSLog(@"msgType = %d msg = %@",msgType,msg );
    int typeMsg = msgType;
    if(typeMsg == 66){
        return;
      
    }
    if (msgType == TEMPERATURE_ABNORMAL || msgType == FIRMWARECODE_ABNORMAL || msgType == BATTERY_ABNORMAL){
        NSString *device_name = [[moxibustion getInstance] getConnectDevice].u_Name;
        if(!device_name){
            device_name = @"";
        }
        NSString *type = [NSString stringWithFormat:@"%d",msgType];
        NSDictionary *paraDic = @{@"member":[UserShareOnce shareOnce].username,@"deviceSn":device_name,@"exceTime":[Tools time_dateToString:[NSDate date]],@"exceDesc":msg,@"msgType":type};
        NSLog(@"paradic:%@",paraDic);
        
        NSString *urlStr = @"member/mox/moxexceptiondataupload.jhtml";
        
        [self requestNetworkDataWithdic:paraDic urlStr:urlStr];
        
        
    }
}

# pragma mark - 设置灸疗信息回调接口
-(void)moxibustInfo:(NSMutableArray *)infoData{
    
    NSLog(@"infoData######## = %@",infoData);

    NSDictionary *paraDic = @{@"member":[UserShareOnce shareOnce].username,@"device_name":[[moxibustion getInstance] getConnectDevice].u_Name,@"moxa_info":infoData};
    
    
    
    NSLog(@"paradic:%@",paraDic);

    NSString *urlStr = @"member/mox/moxexceptiondataupload.jhtml";

    [self requestNetworkDataWithdic:paraDic urlStr:urlStr];
}



-(i9_JaExecuteStru *)getExecuteStruBychannalView:(NewChannelView *)channalView{
    int index = (int)[_channelArray indexOfObject:channalView];
    return [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:index];
}

//描述：接收到数据
-(void)commendReturn:(int)cmd Device_Address:(uint32_t) address ExeStru:(i9_JaExecuteStru *)exeStru{
            if (cmd == CMD_ACKSETTEMP)
            {
                //更新小机端设置，和控制信息
                if (exeStru != nil) {
                    NewChannelView *channalView = [self getViewByAddress:address];
                    if(channalView.wendu != exeStru.mSetTemp){
                        exeStru.mCtrlTemp = exeStru.mSetTemp;
                        channalView.wendu = exeStru.mSetTemp;
                    }
                }
            }
            else if(cmd == CMD_ACKREAD_NOSET)
            {
                NewChannelView *channalView = [self getViewByAddress:address];
                [self updateChannelViewData:channalView ExeStru:exeStru NeedAnim:false];
            }
            else if(cmd == CMD_ACKREAD_ON)
            {
                //更新小机端设置，和控制信息
                NewChannelView *view = [self getViewByAddress:address];
                i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:view];

                    [self updateChannelViewData:view ExeStru:stru NeedAnim:false];
            }
            else if(cmd == CMD_ACKREAD_WORK)
            {
                NewChannelView *view = [self getViewByAddress:address];
                i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:view];
                [self updateChannelViewData:view ExeStru:stru NeedAnim:false];

            }
            else if(cmd == CMD_ACKOPENNOSET)
            {
                NewChannelView *view = [self getViewByAddress:address];
                i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:view];
                [self updateChannelViewData:nil ExeStru:stru NeedAnim:false];
            }
            else if(cmd == CMD_ACKOPENSUCESS)
            {
                NewChannelView *channelView= [self getViewByAddress:address];
                i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:channelView];
                channelView.waitSetwendu = -1;
                [self updateChannelViewData:channelView ExeStru:stru NeedAnim:false];
            }
            else if(cmd == CMD_ACKCLOSE)
            {
                NewChannelView *channelView= [self getViewByAddress:address];
                i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:channelView];
                channelView.waitSetwendu = -1;
                [self updateChannelViewData:channelView ExeStru:stru NeedAnim:false];
                [self resetAnimation];
            }
            else if(cmd == CMD_ACKSETPASSWORD)
            {
                if([moxibustion getInstance].isSetPwd){
                    [OMGToast showWithText:@"设置密码成功" duration:1.5f];
                    [moxibustion getInstance].isSetPwd = NO;
                }
            }
            else if(cmd == CMD_ACKELECTRICITY)
            {
                NewChannelView *view = [self getViewByAddress:address];
                i9_JaExecuteStru *stru = [self getExecuteStruBychannalView:view];
                [view updateElectricity:stru.mSetElectricity];
            }
            else if(cmd == CMD_ASKSHAKEMOTOR)
            {

            }else if(cmd == CMD_ASKGETDEVICENAME){
                int num = exeStru.channalNum;
                NewChannelView *view = [self getViewByAddress:address];
                [view setChannelNum:num - 1];
            }else if(cmd == CMD_ASKSETDEVICENUMBER){
            }
}

# pragma mark - //描述：搜索蓝牙的状态变化， 开始搜索， 搜索到一个，搜索结束
-(void) findBtDeviceStateChange:(int) findState
{
    if (findState == FIND_STATE_START)
    {
    }
    else if(findState == FIND_STATE_NEW)
    {
        [self hideGuidanceView];
    }
    else if(findState == FIND_STATE_END)
    {
        UIViewController *controll = [self.navigationController  topViewController];
        if([controll isKindOfClass:[i9_MoxaMainViewController class]])
        {
            [_searchIndicator stopAnimating];
        }
        else if([controll isKindOfClass:[I9_BlueToothListViewController class]])
        {
            [(I9_BlueToothListViewController *)controll updateDeviceList];
        }
    }
}

//描述：蓝牙的打开关闭状态改变
-(void) btOpenDeviceStateChange:(int) state
{
    if(state == STATE_OFF)
    {
        NSMutableArray *executeStruLst = [[moxibustion getInstance] getExecuteStruLst];
        for (int i = 0; i < [executeStruLst count]; i++) {
            i9_JaExecuteStru *exeStru = [executeStruLst objectAtIndex:i];
            exeStru.mSetState = JAEXECUTE_STATE_UNKNOWN;
            [self updateChannelViewData:[_channelArray objectAtIndex:i] ExeStru:exeStru NeedAnim:NO];
        }
        [PubFunc ViewClearChildView:_channelViewHolder];
    }
    else if(state == STATE_ON)
    {
        
    }
    else if(state == STATE_ONING)
    {
        
    }
}

-(void)allShack{
    [[moxibustion getInstance] sendCommend:CMD_GETSHAKEMOTOR JaExecuteStru_:nil ISUserComm_:YES];
}

-(NewChannelView *)checkHasChannel:(DeviceModel *)deviceitem{
    for (int i = 0; i < _channelArray.count; i++) {
        i9_JaExecuteStru *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
        NewChannelView *view = [_channelArray objectAtIndex:i];
        if(deviceitem.u_DevAdress == stru.deviceitem.u_DevAdress){
            return view;
        }
    }
    return nil;
}

# pragma mark - 蓝牙与设备断开连接
-(void)btConnectDeviceReturnLogin:(BOOL)clearView{
    [self freshIndicatorLab];
    if(clearView){
        [_channelArray removeAllObjects];
        _channelViewHolder.viewArry = _channelArray;
        [_channelViewHolder freshChannelView];
    }
}

//描述：蓝牙的连接状态改变
-(void) btConnectDeviceStateChange:(int)state DeviceModel:(DeviceModel *)deviceitem
{
    if(state == CONNECT_ON)
    {
        if(_channelArray.count == 0){
            focuseAddress = deviceitem.u_DevAdress;
        }
        NewChannelView *view = [self checkHasChannel:deviceitem];
        if(view == nil){
            [self addOneChannelView];
            for (int i = 0; i < _channelArray.count; i++) {
                NewChannelView *tview = [_channelArray objectAtIndex:i];
                if(tview.states == CHANNEL_NOLINK){
                    [tview setStates:CHANNEL_STOP];
                    i9_JaExecuteStru *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
                    stru.deviceitem = deviceitem;
                    break;
                }
            }
        }else{
            [self getExecuteStruBychannalView:view].deviceitem = deviceitem;
        }
        
        //构造一条获取密码的命令，获得蓝牙设备的密码
        if(!_hasPlayStartVoice){
            _hasPlayStartVoice = YES;
            [self playMedia:_musicArray[0]];
        }
        UIViewController *controll = [self.navigationController  topViewController];
        if([controll isKindOfClass:[I9_BlueToothListViewController class]])
        {

        }
    }
    else if(state == CONNECT_ONING)
    {
    }
    else if(state == CONNECT_OFF)
    {
        if(deviceitem != nil){
            [self reduceOneChannelView:deviceitem];
        }
    }
}

# pragma mark - 连接成功且 mesh 网络登录成功后的回调
- (BOOL)btConnectDeviceAndloginSuccess {
    
    
    
    [self connectSuccessUploadNetwork];
    
    UIViewController *controll = [self.navigationController  topViewController];
    if([controll isKindOfClass:[I9_BlueToothListViewController class]])
    {
        [(I9_BlueToothListViewController *)controll ChangeNameSuccess];
        return NO;
    }else{
        return YES;
    }
}


# pragma mark - 连接成功传给后台数据
- (void)connectSuccessUploadNetwork
{
    //连接成功后的操作
    NSString *device_name = [[moxibustion getInstance] getConnectDevice].u_Name;
    if(!device_name){
        device_name = @"";
    }
    
    NSDictionary *paraDic = @{@"member":[UserShareOnce shareOnce].username,@"deviceSn":device_name,@"startTime":[Tools time_dateToString:[NSDate date]]};
    
    NSString *urlStr = @"member/mox/moxdataupload.jhtml";
    [self requestNetworkDataWithdic:paraDic urlStr:urlStr];

}

# pragma mark - 数据上传
- (void)requestNetworkDataWithdic:(NSDictionary *)paraDic urlStr:(NSString *)urlStr
{
    NSArray *arr = [NSArray arrayWithObject:paraDic];
    
    NSString *jsonString = [self jsonStringWithArr:arr];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:jsonString forKey:@"data"];
    [dic setObject:@"1234" forKey:@"qdbs"];
    [dic setObject:[UserShareOnce shareOnce].username forKey:@"member"];
    
    [ZYGASINetworking POST_Path:urlStr params:dic completed:^(id JSON, NSString *stringData) {
        NSLog(@"###:%@,***%@",JSON,stringData);
    } failed:^(NSError *error) {
        
    }];
}

- (NSString *)jsonStringWithArr:(NSArray *)arr
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arr
                                                       options:0
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
}

#pragma
- (void)selectBtnOnclinck:(id)sender{
    UIButton *btn = (UIButton *)sender;
    int index = (int)btn.tag;
    if([[yijiuSelectArray objectAtIndex:index] boolValue] == TRUE){
        [yijiuSelectArray setObject:[NSNumber numberWithBool:NO] atIndexedSubscript:index];
        [btn setSelected:NO];
    }else{
        [yijiuSelectArray setObject:[NSNumber numberWithBool:YES] atIndexedSubscript:index];
        [btn setSelected:YES];
    }
}

-(int)CalculationCellHeight:(NSString *)text{
    int height = 43;
    CGSize size = [text boundingRectWithSize:CGSizeMake(SCREEN_WID - 80, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil] context:nil].size;
    if(size.height > 43){
        height += size.height + 4;
    }
    return height;
}

-(BOOL)checkHasMoxaWork{
    for (int i = 0; i < _channelArray.count; i++)
    {
        i9_JaExecuteStru *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
        if (stru.mCtrlState == JAEXECUTE_STATE_RUN){
            return YES;
        }
    }
    return NO;
}

-(BOOL)checkHasMoxaNotWork{
    for (int i = 0; i < _channelArray.count; i++)
    {
        i9_JaExecuteStru *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
        if (stru.mCtrlState != JAEXECUTE_STATE_RUN){
            return YES;
        }
    }
    return NO;
}

# pragma mark - 点击进入设置界面
- (void)onClickRecipelListBtn:(id)sender {
    
    if(!self.guideView.hidden){
        return;
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    MoxaSettingViewController *vc = [[MoxaSettingViewController alloc]initWithNibName:@"MoxaSetting" bundle:nil];
    vc.bVoiceOn = bVoiceOn;
    vc.fatherVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
 * 关闭所有通过
 */
-(void)closeAllChannel{
    [[moxibustion getInstance] sendCommend:CMD_CLOSECHANNEL JaExecuteStru_:nil ISUserComm_:YES];
    int no = 0;
    for (NewChannelView *view in _channelArray){
        i9_JaExecuteStru *exeStru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:no];
        if(exeStru.mCtrlState == JAEXECUTE_STATE_RUN){
            exeStru.mCtrlState = JAEXECUTE_STATE_IDLE;
            [self updateChannelViewData:view ExeStru:exeStru NeedAnim:false];
        }
        if(++no >= _channelArray.count)break;
    }
}

/*
 * 检测是不是所有通道都关闭啦
 */
-(BOOL) checkAllChannelClose
{
    BOOL  isAllClose = true;
    for (int no = 0; no < _channelArray.count; no++){
        
        i9_JaExecuteStru *exeStru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:no];
        if(exeStru.mCtrlState == JAEXECUTE_STATE_RUN)
        {
            isAllClose = false;
            break;
        }
    }
    return isAllClose;
}

#pragma
#pragma onclick
- (void)onClickReturnBtn:(id)sender {
    [self stopMedia];
    [[moxibustion getInstance] releaseRes];
    [self destroyLightOffTimerTask];
    [self destroyBehavorTimerTask];
    AVAudioSession * session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

//开关按钮监听
- (IBAction)onClickLampSwitch:(id)sender {
    [[moxibustion getInstance] clearAllCommend];
    if([[moxibustion getInstance] getBluetoothConnectState] == CONNECT_ON && [moxibustion getInstance].bCompleteAuthentication){
        
        if(bLampState){
            if(![self checkAllChannelClose])
            {
                // 关闭所有通道，这个时候灯还不会关闭
                [self closeAllChannel];
                [self createLightOffTimerTask];
                
            }else{
                [self createLightOffTimerTask];
            }
        }
        return;
    }
    if(!bLampState){
        [[moxibustion getInstance] atuoDiscoverConnect];
    }
}

# pragma mark - 点击进入连接设备列表
- (void)onClickBleBtn:(id)sender {
    
    if([[moxibustion getInstance] getBluetoothConnectState] == CONNECT_ON
       || [[moxibustion getInstance] getBluetoothConnectState] == CONNECT_OFF){
        if (SUPPORT_YES == [[moxibustion getInstance] getBluetoothSupportState]
            && STATE_ON == [[moxibustion getInstance] getBluetoothOpenState])
        {
            NSLog(@"--onClickBleBtn-4-");
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
            [self.navigationItem setBackBarButtonItem:backItem];
            I9_BlueToothListViewController *vc = [[I9_BlueToothListViewController alloc]initWithNibName:@"I9_BlueToothListView" bundle:nil];
            vc.deviceNetName = [[moxibustion getInstance] getConnectDevice].u_Name;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)controlSound{
    bVoiceOn = !bVoiceOn;
    if(bVoiceOn){
        [OMGToast showWithText:@"声音已经打开" duration:1.5f];
    }else{
        [self stopMedia];
        [OMGToast showWithText:@"声音已经关闭" duration:1.5f];
    }
    [BlueToothCommon setMoxaVoiceEn:bVoiceOn];
}

-(void)SetPassWord:(NSString *)pwd ISsetpwd_:(BOOL)flag{
     [[moxibustion getInstance] setPassWord:pwd];
}


//设置按钮监听
- (IBAction)onClickSettingBtn:(id)sender {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
    
    MoxaSettingViewController *vc = [[MoxaSettingViewController alloc]initWithNibName:@"MoxaSetting" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onClickDoGuideBtn:(id)sender {

}

//计划按钮监听
- (IBAction)onClickRecipelBtn:(id)sender {
}

/*
 *
 */
- (void)playMedia:(NSString*)name{
    if(bVoiceOn){
        
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        [audioPlayer prepareToPlay];
        audioPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
        [audioPlayer play]; //播放
        audioPlayer.delegate = self;
    }
}

- (void)playStartMedia:(NSString*)name{
    if(bVoiceOn){
        if(bIsFirstPlay)
        {
            bIsFirstPlay = false;
            NSString *musicPath = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
            NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [audioPlayer prepareToPlay];
            audioPlayer.numberOfLoops = 0; //设置音乐播放次数  -1为一直循环
            [audioPlayer play]; //播放
            audioPlayer.delegate = self;
        }
    }
}

- (void)stopMedia {
    if (audioPlayer != nil) {
        [audioPlayer stop];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:NO error:nil];
    }
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:NO error:nil];
}

/*O
 *
 */
- (void)setlampState:(BOOL)on update:(BOOL)update {
    bLampState = on;
}

/*
 *
 */
- (void)warnningAlertView:(int)index {
    if(index > 3)return;
    NSArray *strArray = [NSArray arrayWithObjects:@"您设置的温度已进入高温区\n有可能导致灸疗部位起水泡！",
                         @"您设置的温度比较高\n很有可能导致灸疗部位起水泡的哦!",
                         @"您设置的温度已经很高了\n很容易导致灸疗部位起水泡哦!",
                         @"您设置的温度已经到顶了\n灸疗部位很容易起水泡哦!",nil
                         ];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:strArray[index] delegate:self
                                          cancelButtonTitle:@"重新设置" otherButtonTitles:@"确定", nil];
    
    //alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alert.tag = 4;
    [alert show];
}

/*
 * 创建关闭蓝牙灯及灸头定时任务
 */

- (void)createLightOffTimerTask{
    mLightOffTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(LightOffTimeOut:) userInfo:nil repeats:NO];
}

- (void)destroyLightOffTimerTask{
    if(mLightOffTimer != nil){
        [mLightOffTimer invalidate];
        mLightOffTimer = nil;
    }
}

-(void)LightOffTimeOut: (NSTimer *)timer {
    mLightOffTimer = nil;
}

-(void)resetAnimation{
    for (int i = 0; i < _channelArray.count; i++)
    {
        i9_JaExecuteStru *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
        if (stru.mCtrlState != JAEXECUTE_STATE_RUN){
            NewChannelView *view  = [_channelArray objectAtIndex:i];
            [view resetAnimation];
        }
    }
}

/*
 * 创建灸疗数据定时任务(10分内认为是同一次数据)
 */
- (void)createBehavorTimerTask{
    mBehavorTimer = [NSTimer scheduledTimerWithTimeInterval:10*60 target:self selector:@selector(behavorTimerOut:) userInfo:nil repeats:YES];
}

- (void)destroyBehavorTimerTask{
    if(mBehavorTimer != nil){
        [mBehavorTimer invalidate];
        mBehavorTimer = nil;
        if (!_bIsAJi9) {
        }
    }
}

-(void)behavorTimerOut:(NSTimer *)timer {
    [self destroyBehavorTimerTask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 * 增加用户灸疗数据
 */
- (void)addUserBehavor {
    NSLog(@"--addUserBehavor--");
    if (_treatMArray == nil) {
        _treatMArray = [NSMutableArray arrayWithCapacity:10];
    }
    for (NewChannelView *channel in _channelArray) {
        if ([channel getStates] == CHANNEL_WORK) {
            int time = [channel getShiJian]/60;
            if(time == 0){
                time += 1;
            }
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:[NSString stringWithFormat:@"%d",[channel getWenDu]] forKey:@"wendu"];
            [dic setObject:[NSString stringWithFormat:@"%d",time] forKey:@"shijian"];
            [dic setObject:[NSString stringWithFormat:@"%d",channel.tag + 1] forKey:@"channal"];
            [_treatMArray addObject:dic];
            [_hasRecodeChannal removeAllObjects];
            [_hasRecodeChannal addObject:[NSString stringWithFormat:@"%d",channel.tag + 1]];
        }
    }
}

#pragma mark - CMPopTipViewDelegate
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    _popTipView = nil;
}

- (void)dismissPopWin {
    if (_popTipView != nil) {
        [_popTipView dismissAnimated:YES];
        _popTipView = nil;
    }
}

- (void)showPopWin:(UIView*)view msgText:(NSString*)msgText_ {
    if (_popTipView == nil) {
        _popTipView = [[CMPopTipView alloc]initWithMessage:msgText_];
        _popTipView.delegate = self;
        _popTipView.disableTapToDismiss = NO;
        _popTipView.textColor = RGBA(0x00, 0x00, 0x00, 1);
        _popTipView.animation = arc4random() % 2;
        [_popTipView presentPointingAtView:view inView:self.view animated:YES];
    }else {
        [self dismissPopWin];
    }
}


#pragma -- get, append and uploading AJ98 datas
- (void)uploadingDatasForAJ98 {
}

/*
 *
 */
- (void)createBehavor98TimerTask{
    _bGetAllDatasForAJi9 = false;
    if (_bIsAJi9) {
        _mBehavor98Timer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(behavor98TimerOut:) userInfo:nil repeats:YES];
    }
}

- (void)destroyBehavor98TimerTask{
    if(_mBehavor98Timer != nil){
        [_mBehavor98Timer invalidate];
        _mBehavor98Timer = nil;
        if (_bIsAJi9 && !_bGetAllDatasForAJi9) {
            _bGetAllDatasForAJi9 = true;
            [self uploadingDatasForAJ98];
        }
    }
}

-(void)behavor98TimerOut:(NSTimer *)timer {
}

/*
 * 保存 灸疗温度时间 大数据
 * ["", "48c", "30m"]
 */
- (void)saveMoxaTTDatas {
}

/*
 * 设置 灸疗温度时间 大数据
 * ["", "48c", "30m"]
 */


- (void)setMoxaTTDatas:(i9_JaExecuteStru *)stru;{
    if (_moxaTTArray == nil) {
        _moxaTTArray = [[NSMutableArray alloc]initWithCapacity:60];
    }
    NSMutableString *jsonStr = [[NSMutableString alloc]initWithString:@"["];
    [jsonStr appendFormat:@"\"\""];
    [jsonStr appendString:@","];
    [jsonStr appendFormat:@"\"%d%@\"", stru.mCtrlTemp, @"c"];
    [jsonStr appendString:@","];
    [jsonStr appendFormat:@"\"%d%@\"", stru.mCtrlTime/60, @"m"];
    [jsonStr appendFormat:@"]"];
    _hasNewTT = true;
    if ([_moxaTTArray count] >= 60) {
        [_moxaTTArray removeObjectAtIndex:0];
    }
    [_moxaTTArray addObject:jsonStr];
}

/*
 * 获取 灸疗温度时间 大数据
 */
- (void)readMoxaTTDatas {
}

/*
 * 从 灸疗温度时间 大数据 分析出 频度最高的温度时间
 */
- (void)parseMoxaTTDatas:(int *)c time:(int *)t {
    NSMutableArray *mArray = _moxaTTArray;
    
    NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithCapacity:20];
    for (NSString *s in mArray) {
        NSArray *keyArray = [mDic allKeys];
        if (![keyArray containsObject:s]) {
            [mDic setValue:@"1" forKey:s];
        }else {
            NSString *countStr = [mDic objectForKey:s];
            int count = [countStr intValue];
            countStr = [NSString stringWithFormat:@"%d", ++count];
            [mDic setValue:countStr forKey:s];
        }
    }
    
    if ([mDic count] > 0) {
        int maxCount = 0;
        NSString *keyStr = nil;
        NSArray *valArray = [mDic allValues];
        NSArray *keyArray = [mDic allKeys];
        int loop = (int)[valArray count];
        for (int i = 0; i < loop; i++) {
            int count = [[valArray objectAtIndex:i] intValue];
            if (count > maxCount) {
                maxCount = count;
                keyStr = [keyArray objectAtIndex:i];
            }
        }
        @try {
            NSData *jsonData = [keyStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error = nil;
            NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
            if (error == nil) {
                NSString *temp = [array objectAtIndex:1];
                NSString *time = [array objectAtIndex:2];
                if (c != NULL) {
                    *c = [[temp substringToIndex:2] intValue];
                }
                if (t != NULL) {
                    NSUInteger location = [time rangeOfString:@"m"].location;
                    if(location != NSNotFound) {
                        *t = [[time substringToIndex:location] intValue];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            *c = 45;
            *t = 30;
        }
        @finally {
            
        }
    }
}

/*
 *
 */
- (void)loginRegProcess {
    if (_mRemindRegViewIsShow == NO) {
        _mRemindRegViewIsShow = YES;
        NSUInteger location = [_deviceName rangeOfString:@"-"].location;
        if (location != NSNotFound) {
            _devNameSuffix = [_deviceName substringFromIndex:(location+1)];
        }
        int count = [ConfigUtil getRemindRegCount];
        [ConfigUtil setRemindRegCount:++count];
        _remindRegView = [[RemindRegAlertView alloc]initWithNibName:@"RemindRegAlertView" bundle:nil];
        [_remindRegView setBlurView:self];
        _remindRegView.type = 3;
        _remindRegView.password = _devNameSuffix;
        [self presentPopupViewController:_remindRegView animated:YES dismiss:false completion:^{
            _remindRegView.clickDelegate = self;
            [[KeyBoardManager sharedInstance]configViewControl:self responderView:_remindRegView.view, nil];
        }];
    }
}


#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {

}

- (void)registerProcess:(NSString*)number {
    _progressView = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_progressView];
    
    _progressView.delegate = self;
    _progressView.tag = 2;
    _progressView.labelText = @"正在请求注册...";
    
    [_progressView showWhileExecuting:@selector(requestRegisterTask:) onTarget:self withObject:number animated:YES];
    
}

- (void)autoLoginProcess {
    _progressView = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_progressView];
    
    _progressView.delegate = self;
    _progressView.tag = 3;
    _progressView.labelText = @"正在登录···";
    
    [_progressView showWhileExecuting:@selector(requestLoginTask) onTarget:self withObject:nil animated:YES];
}

- (void)requestRegisterTask:(NSString*)number {

}

- (void)requestLoginTask {
  
}

-(NewChannelView *)getChannelViewByUUid:(NSString *)uuid{
    for (int i = 0; i < _channelArray.count; i++) {
        NewChannelView *view = [_channelArray objectAtIndex:i];
        if([view.mochinUUid isEqualToString:uuid]){
            return view;
        }
    }
    return nil;
}

#pragma mark ----MoxiHeadInfView_i9_Delegate

- (void)SwitchBtnOnclink:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if([btn.titleLabel.text isEqualToString:@"一键开"]){
        [self OpenAllChannel];
    }else if([btn.titleLabel.text isEqualToString:@"全部关"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否要关闭所有灸头" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 5;
        [alert show];
    }
}

- (void)choosePlanBtnOnclink:(id)sender{
}

- (void)moxaRecodeOnclink:(id)sender{
}
-(NewChannelView *)getViewByAddress:(uint32_t)address{
    for (int i = 0; i < _channelArray.count; i++) {
        NewChannelView *view = [_channelArray objectAtIndex:i];
        i9_JaExecuteStru *stru = [[[moxibustion getInstance] getExecuteStruLst] objectAtIndex:i];
        if(stru.deviceitem.u_DevAdress == address){
            return view;
        }
    }
    return nil;
}

-(void)setWenduAndStart{
    NewChannelView *view = [self getViewByAddress:focuseAddress];
    if(view.waitSetwendu == -1){
        view.waitSetwendu = view.tempSetwendu;
    }
    [self whenSetTT:view WenDu:view.waitSetwendu shiJian:(view.shiJian) allset:NO start:true warn:true];
}

// 亲，您可以在此处根据您的症状、疾病添加计划再进行灸疗哦！知道啦，真烦人

- (void)dealloc {
    NSLog(@"");
}

@end
