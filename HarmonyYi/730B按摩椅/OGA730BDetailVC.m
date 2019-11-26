//
//  ArmchairDetailVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "OGA730BDetailVC.h"
#import "InsidelayerView.h"
#import "CommandButtonView.h"
#import "HCYSlider.h"
#import "UIButton+ExpandScope.h"

#import "OGA730BAcheTestVC.h"
#import "OGA730BTestResultVC.h"
#import "UIImage+Units.h"
#import "PostButtonView.h"
#import "SongListCell.h"

typedef enum : NSInteger {
    PointDirectTop,
    PointDirectLevel,
    PointDirectBottom,
} PointDirect;

typedef enum : NSInteger {
    SlideDirectBottomToTop,
    SlideDirectTopToBottom,
} SlideDirect;

@interface OGA730BDetailVC ()<HCYSliderDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,CommandButtonDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,GKAudioPlayerDelegate>
{
    CGPoint startSpanPoint;
    PointDirect pointDirect;
    SlideDirect slideDirect;
    BOOL directHasChange ;
    CGFloat panViewMaxY;
    CGFloat panViewMinY;
    NSInteger areaIndex;
    NSInteger actionIndex;
    NSInteger ledIndex;
}

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UIView *upsideView;

@property (nonatomic, strong) UIView *middleView;

@property (nonatomic, strong) UIView *postBottomView;

@property (nonatomic, strong) CALayer *subLayer;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *playBtn;

@property(nonatomic,strong) UIView *styleView;

@property(nonatomic,strong) UIView *qiyaView;

@property (nonatomic, strong) UIView *advancedView; //高级按摩控制界面

@property (nonatomic, assign) BOOL isAdvanced; //是否高级按摩

@property (nonatomic, assign) BOOL isRecommend; //是否推荐按摩

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, strong) UITextView *acupointLabel; //穴位介绍

@property (nonatomic, strong) OGASubscribe_730B *ogaSubscribe;

@property (nonatomic,strong) UILabel *navTimeLabel;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic, strong) NSTimer *longTimer;

@property (nonatomic, assign) BOOL ledFirst;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,copy) NSString *currentSubjectSn;
@property (nonatomic,copy) NSString *selectSongName;//当前播放的乐药
@property (nonatomic,strong) NSIndexPath *currentIndexPath; //拿来做 类型切换 乐药播放时

@end

@implementation OGA730BDetailVC
@synthesize subLayer,nameLabel;

- (void)dealloc
{
    self.tableView = nil;
    self.dataArr = nil;
    self.currentIndexPath = nil;
    self.bgScrollView = nil;
    [kPlayer stop];
}



- (id)initWithType:(BOOL )isAdvanced withTitleStr:(NSString *)titleStr
{
    self = [super init];
    if(self){
        self.isAdvanced = isAdvanced;
        self.titleStr = titleStr;
    }
    return self;
}

- (id)initWithRecommend:(BOOL )isRecommend withTitleStr:(NSString *)titleStr
{
    self = [super init];
    if(self){
        self.isRecommend = isRecommend;
        self.titleStr = titleStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ledFirst = NO;
    
    self.navTitleLabel.text = self.titleStr;
    
    [self initUI];
    
    [self initTopView];
    
    pointDirect = PointDirectLevel;
    slideDirect = SlideDirectTopToBottom;
    panViewMaxY = ScreenHeight-Adapter(100);
    panViewMinY = ScreenHeight-Adapter(275)+Adapter(90);
    
    //按摩椅添加订阅
    self.ogaSubscribe = [[OGASubscribe_730B alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.ogaSubscribe setRespondBlock:^(OGARespond_730B * _Nonnull respond) {
        
        [weakSelf didUpdateValueForChair:respond];
    }];
    [[OGABluetoothManager_730B shareInstance] addSubscribe:self.ogaSubscribe];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    // 设置播放器的代理
    kPlayer.delegate = self;
    kPlayer.noDelegate = NO;
    if(kPlayer.playUrlStr != nil && kPlayer.playerState == 2){
        
    }
}

- (void)YueyaoView
{
    
}

#pragma mark - 获取乐药列表
- (void)requestYueyaoListWithType:(NSString *)typeStr
{
    NSString *subjectSn = [GlobalCommon getSubjectSnFrom:typeStr];
    NSString *aUrlle= [NSString stringWithFormat:@"resources/listBySubject.jhtml?subjectSn=%@&mediaType=%@",subjectSn,@"audio"];
    [GlobalCommon showMBHudWithView:self.view];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:aUrlle parameters:nil successBlock:^(id response) {
        [GlobalCommon hideMBHudWithView:weakSelf.view];
        id status=[response objectForKey:@"status"];
        if([status intValue] == 100){
            NSArray *arr = [response objectForKey:@"data"];
            NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
            
            BOOL isSelectRow = NO;
            NSInteger rowIndex = 0;
            
            
            
            for(NSInteger i =0;i<arr.count;i++){
                NSDictionary *dic = [arr objectAtIndex:i];
                SongListModel *model = [[SongListModel alloc] init];
                model.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                model.productId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productId"]];
                if([[dic objectForKey:@"price"] isKindOfClass:[NSNull class]]){
                    model.price = 0;
                }else{
                    model.price = [[dic objectForKey:@"price"] floatValue];
                }
                model.status = [dic objectForKey:@"status"];
                model.title = [dic objectForKey:@"name"];
                model.source = [[[dic objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
                model.subjectSn = typeStr;
                [arr2 addObject:model];
                
                if(kPlayer.playerState == 2 && kPlayer.playUrlStr){
                    if([model.source isEqualToString:kPlayer.playUrlStr]){
                        isSelectRow = YES;
                        rowIndex = i;
                    }
                }
            }
            
            weakSelf.dataArr = arr2;
            kPlayer.musicArr = arr2;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.delegate tableView:weakSelf.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            });
            
        }else if ([status intValue] == 44)
        {
            [weakSelf showAlertWarmMessage:ModuleZW(@"登录超时，请重新登录")];
            return;
        }else{
            NSString *str = [response objectForKey:@"data"];
            [weakSelf showAlertWarmMessage:str];
            return;
        }
    } failureBlock:^(NSError *error) {
        [GlobalCommon hideMBHudWithView:weakSelf.view];
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
}

#pragma mark - tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Adapter(36);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 30)];
//    titleLabel.font = [UIFont systemFontOfSize:15];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.backgroundColor = UIColorFromHex(0X1E82D2);
//    titleLabel.textColor = [UIColor whiteColor];
//    titleLabel.text = @"Music List";
//
//    return titleLabel;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 30;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SongListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chairList"];
    if(cell == nil){
        cell = [[SongListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chairList"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(self.dataArr.count>0){
        SongListModel *model = [self.dataArr objectAtIndex:indexPath.row];
        
        cell.titleLabel.text = model.title;
        
        cell.currentSelect = NO;
        NSString *imageStr = @"";
//        cell.downloadBtn.hidden = YES;
//        if(indexPath.row == self.currentIndexPath.row){
//            cell.downloadBtn.hidden = NO;
//        }
        
        
        imageStr = @"乐药播放icon";

        [cell downloadChairWithImageStr:imageStr];
        
    
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SongListCell *cell = (SongListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.downloadBtn.hidden = NO;
    if(cell.PlayOrdownload){ //播放暂停
        
        if(self.currentIndexPath && self.currentIndexPath.row != indexPath.row) { //乐药类型切换时,处理正在播放的状态
            [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:self.currentIndexPath];
            self.currentIndexPath = nil;
        }
        
        cell.currentSelect = !cell.currentSelect;
        SongListModel *model = [self.dataArr objectAtIndex:indexPath.row];
        
        if(cell.currentSelect){
            
            [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"乐药暂停icon"] forState:UIControlStateNormal];
            if(![model.subjectSn isEqualToString:self.currentSubjectSn]){ //切换乐药播放列表
                self.currentSubjectSn = model.subjectSn;
               // [self currentPlayYueYaoList];
            }
            
            self.currentIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            
            [self playActionWithModel:model];
            
            self.selectSongName = model.source; //播放链接
        }else{
            [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"乐药播放icon"] forState:UIControlStateNormal];
            //  self.selectSongName = @"";
            [self pauseMusic];
        }
        
    }
}




- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SongListCell *cell = (SongListCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.downloadBtn.hidden = YES;
    if(cell.PlayOrdownload){
        [cell.downloadBtn setBackgroundImage:[UIImage imageNamed:@"乐药播放icon"] forState:UIControlStateNormal];
        cell.currentSelect = NO;
        self.selectSongName = @"";
        [self stopMusic];
    }
    
}

# pragma mark - 播放乐药
- (void)playActionWithModel:(SongListModel *)model
{
    
    NSString *urlStr = model.source;
    
    if(self.selectSongName != nil || ![self.selectSongName isEqualToString:@""]){
        if([urlStr isEqualToString:self.selectSongName]){
            [kPlayer resume];
            return;
        }else{
            if(kPlayer.playerState == 2){
                [self stopMusic];
            }
        }
    }
    kPlayer.model = model;
    kPlayer.playUrlStr = urlStr;
    [kPlayer play];
}

- (void)pauseMusic
{
    
    [kPlayer pause];
    
}

- (void)stopMusic {
    [kPlayer stop];
}

- (void)noteVC
{
    
    [self nextMusic];
}

- (void)nextMusic
{
    NSString *currentUrl = @"";
    if(kPlayer.playUrlStr){
        currentUrl = kPlayer.playUrlStr;
        self.selectSongName = nil;
        [self stopMusic];
    }
    
    if(kPlayer.musicArr.count == 1){ //只购买了一首乐药,循环播放
        [self playActionWithModel:kPlayer.model];
        return;
    }
    
    int index = arc4random() % kPlayer.musicArr.count;
    
    //NSLog(@"yyyy:%@",kPlayer.musicArr);
    
    SongListModel *model = [kPlayer.musicArr objectAtIndex:index];
    
    if([model.source isEqualToString:currentUrl]){
        if(index == kPlayer.musicArr.count -1){
            index = index - 1;
        }else{
            index = index + 1;
        }
        model = [kPlayer.musicArr objectAtIndex:index];
    }
    
    [self playActionWithModel:model];
    
    //播放完一首歌后,切换cell按钮的状态
    
    __block NSInteger row = 0;
    
    [self.dataArr enumerateObjectsUsingBlock:^(SongListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.idStr isEqualToString:model.idStr]){
            row = idx;
            *stop = YES;
        }
    }];
    
    if(self.currentIndexPath.row != row){
        [self.tableView.delegate tableView:self.tableView didDeselectRowAtIndexPath:self.currentIndexPath];
        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        self.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    }
    
    
}

#pragma mark - GKPlayerDelegate
// 播放状态改变
- (void)gkPlayer:(GKAudioPlayer *)player statusChanged:(GKAudioPlayerState)status
{
    switch (status) {
        case GKAudioPlayerStateLoading:{    // 加载中
            
            
        }
            break;
        case GKAudioPlayerStateBuffering: { // 缓冲中
            
            
        }
            break;
        case GKAudioPlayerStatePlaying: {   // 播放中
            
            
            
        }
            break;
        case GKAudioPlayerStatePaused:{     // 暂停
           
        }
            break;
        case GKAudioPlayerStateStoppedBy:{  // 主动停止
            
            
        }
            break;
        case GKAudioPlayerStateStopped:{    // 打断停止
            dispatch_async(dispatch_get_main_queue(), ^{
                [self pauseMusic];
            });
            
        }
            break;
        case GKAudioPlayerStateEnded: {     // 播放结束
            NSLog(@"播放结束了哈哈哈");
            
            // 播放结束，自动播放下一首
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self nextMusic];
            });
            
        }
            break;
        case GKAudioPlayerStateError: {     // 播放出错
            NSLog(@"播放出错了");
            
        }
            break;
        default:
            break;
    }
    
    
}


- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[OGABluetoothManager_730B shareInstance] removeSubscribe:self.ogaSubscribe];
}

# pragma mark - 按摩椅数据回调
- (void)didUpdateValueForChair:(OGARespond_730B *)respond {
    
    //开关
    self.rightBtn.selected = [self chairPowerOnWithRespond:respond];
    
    self.playBtn.selected = respond.modeStop;
    
    if(!self.rightBtn.selected){
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    [self layerAnimationWithPause:respond.modeStop];
    
    //light
    CommandButtonView *comandView300 = (CommandButtonView *)[self.middleView viewWithTag:300];
    //[comandView300 setButtonViewSelect:respond.ledHoodStatus];
   // if(!self.ledFirst){
        ledIndex = (NSInteger)respond.ledHoodStatus;
        if(ledIndex == 0){
            [comandView300 setButtonViewSelect:NO WithImageStr:@""];
        }else{
           [comandView300 setButtonViewSelect:YES WithImageStr:[NSString stringWithFormat:@"led_%ld",ledIndex]];
        }
        
//        self.ledFirst = YES;
//    }
    
    NSLog(@"index:%ld",ledIndex);
    //加热
    CommandButtonView *comandView301 = (CommandButtonView *)[self.middleView viewWithTag:301];
    [comandView301 setButtonViewSelect:respond.massage_StatusWarm];
    
    //按摩强度
    HCYSlider *slider1 = (HCYSlider *)[self.middleView viewWithTag:310];
    slider1.currentSliderValue = respond.massage_MovmentGears;
    //气囊强度
    HCYSlider *slider2 = (HCYSlider *)[self.middleView viewWithTag:311];
    slider2.currentSliderValue = respond.massage_AirGears;

    //时间
    NSString *sec = @"";
    if(respond.massage_SurplusTime<10){
        sec = [NSString stringWithFormat:@"0%lu", (unsigned long)respond.massage_SurplusTime];
    }else{
        sec = [NSString stringWithFormat:@"%lu", (unsigned long)respond.massage_SurplusTime];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@ min",sec];
    self.navTimeLabel.text = [NSString stringWithFormat:@"%@ min",sec];

    /******气压******/
    CommandButtonView *command400 = (CommandButtonView *)[self.qiyaView viewWithTag:400];
    [command400 setButtonViewSelect:respond.massage_StatusAirShoulder];
    CommandButtonView *command401 = (CommandButtonView *)[self.qiyaView viewWithTag:401];
    [command401 setButtonViewSelect:respond.massage_StatusAirArm];
    CommandButtonView *command402 = (CommandButtonView *)[self.qiyaView viewWithTag:402];
    [command402 setButtonViewSelect:respond.massage_StatusAirWaist];
    CommandButtonView *command403 = (CommandButtonView *)[self.qiyaView viewWithTag:403];
    [command403 setButtonViewSelect:respond.massage_StatusAirFoot];
   
    /******高级基础******/
    CommandButtonView *gaoji100 = (CommandButtonView *)[self.advancedView viewWithTag:100];
    [gaoji100 setButtonViewSelect:respond.massage_StatusNeck];
    CommandButtonView *gaoji101 = (CommandButtonView *)[self.advancedView viewWithTag:101];
    [gaoji101 setButtonViewSelect:respond.massage_StatusShoulder];
    CommandButtonView *gaoji102 = (CommandButtonView *)[self.advancedView viewWithTag:102];
    [gaoji102 setButtonViewSelect:respond.massage_StatusBack];
    CommandButtonView *gaoji103 = (CommandButtonView *)[self.advancedView viewWithTag:103];
    [gaoji103 setButtonViewSelect:respond.massage_StatusWaist];
    CommandButtonView *gaoji104 = (CommandButtonView *)[self.advancedView viewWithTag:104];
    [gaoji104 setButtonViewSelect:respond.massage_StatusUpperBody];

//    /******高级特殊******/
    CommandButtonView *gaoji200 = (CommandButtonView *)[self.advancedView viewWithTag:200];
    [gaoji200 setButtonViewSelect:respond.massage_ExecuteShiatsu];
    CommandButtonView *gaoji201 = (CommandButtonView *)[self.advancedView viewWithTag:201];
    [gaoji201 setButtonViewSelect:respond.massage_ExecuteKnead1];
    CommandButtonView *gaoji202 = (CommandButtonView *)[self.advancedView viewWithTag:202];
    [gaoji202 setButtonViewSelect:respond.massage_ExecuteKnead2];
    CommandButtonView *gaoji203 = (CommandButtonView *)[self.advancedView viewWithTag:203];
    [gaoji203 setButtonViewSelect:respond.massage_ExecuteKnead3];
    CommandButtonView *gaoji204 = (CommandButtonView *)[self.advancedView viewWithTag:204];
    [gaoji204 setButtonViewSelect:respond.massage_ExecuteRollBack];
   
}


- (void)commandActionWithModel:(ArmChairModel *)model
{
    NSLog(@"----发送----:%@,%d",model.command,[model.command intValue]);
    
    [[OGABluetoothManager_730B shareInstance] sendShortCommand:model.command success:^(BOOL success) {
        if(success){
            
        }
    }];
}

# pragma mark - CommandButtonDelegate 发送按摩椅指令
- (void)commandActionWithModel:(ArmChairModel *)model withTag:(NSInteger )tag
{
    NSLog(@"----发送----:%@,%d",model.command,[model.command intValue]);
    
    if(tag>=100 && tag<105){
        areaIndex = tag-100;
    }
    if(tag>=200 && tag<205){
        actionIndex = tag-200;
    }
    
    if((tag>=100 && tag<105) || (tag>=200 && tag<205)){
        NSArray *arr = @[@[k730Command_ManualNeckShiatsu,
                            k730Command_ManualNeckKnead1,
                            k730Command_ManualNeckKnead2,
                            k730Command_ManualNeckKnead3,
                            k730Command_ManualNeckRoll],
                          @[k730Command_ManualShoulerShiatsu,
                            k730Command_ManualShoulerKnead1,
                            k730Command_ManualShoulerKnead2,
                            k730Command_ManualShoulerKnead3,
                            k730Command_ManualShoulerRoll],
                          @[k730Command_ManualBackShiatsu,
                            k730Command_ManualBackKnead1,
                            k730Command_ManualBackKnead2,
                            k730Command_ManualBackKnead3,
                            k730Command_ManualBackRoll],
                          @[k730Command_ManualWaistShiatsu,
                            k730Command_ManualWaistKnead1,
                            k730Command_ManualWaistKnead2,
                            k730Command_ManualWaistKnead3,
                            k730Command_ManualWaistRoll],
                          @[k730Command_ManualUpperBodyShiatsu,
                            k730Command_ManualUpperBodyKnead1,
                            k730Command_ManualUpperBodyKnead1,
                            k730Command_ManualUpperBodyKnead1,
                            k730Command_ManualUpperBodyRoll],
                          ];
        NSString *command = arr[areaIndex][actionIndex];
        [[OGABluetoothManager_730B shareInstance] sendShortCommand:command success:nil];
    }else if (tag == 300){
        NSArray *arr = @[k730Command_LedSwitch,
                           k730Command_LedRed,
                           k730Command_LedGreen,
                           k730Command_LedBlue,
                           k730Command_LedYellow,
                           k730Command_LedPurple,
                           k730Command_LedCyan,
                           k730Command_LedWhite];
        
        ledIndex = ledIndex+1;
        if(ledIndex == 8){
            ledIndex = 0;
        }
        NSString *command = arr[ledIndex];
       
        [[OGABluetoothManager_730B shareInstance] sendShortCommand:command success:^(BOOL success) {
            if(success){
                }
        }];
        
    }else{
        [[OGABluetoothManager_730B shareInstance] sendShortCommand:model.command success:^(BOOL success) {
            if(success){
               
            }
        }];
    }
    
    
}

- (void)initUI
{
    
    self.navTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-Adapter(240))/2.0, Adapter(2)+kStatusBarHeight, Adapter(240), 40)];
    self.navTimeLabel.font = [UIFont systemFontOfSize:18];
    self.navTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.navTimeLabel.textColor = [UIColor blackColor];
    self.navTimeLabel.hidden = YES;
    [self.topView addSubview:self.navTimeLabel];
    
    
    if (!self.bgScrollView){
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight-Adapter(100))];
        self.bgScrollView.showsVerticalScrollIndicator = NO;
        
        self.bgScrollView.backgroundColor = [UIColor whiteColor];
        self.bgScrollView.bounces = YES;
        self.bgScrollView.delegate = self;
        [self.view addSubview:self.bgScrollView];
    }
    
    
}

# pragma mark - 头部视图
- (void)initTopView
{
    
    // self.view.backgroundColor = [UIColor whiteColor];
    //头部视图
    self.upsideView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, Adapter(180))];
    [self.bgScrollView addSubview:self.upsideView];
    
    
    CGFloat animationLeft = (ScreenWidth-Adapter(142))/2.0;
    if(self.isRecommend){
        animationLeft = 20;
    }
    
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(animationLeft, Adapter(25), Adapter(142), Adapter(134))];
    animationView.tag = 1024;
    //animationView.backgroundColor = [UIColor orangeColor];
    //NSArray *timeArr = @[@3.0,@2.8,@2.6,@2.4,@2.2];
    NSArray *timeArr = @[@3.0,@3.0,@3.0,@3.0,@3.0];
    for(NSInteger i = 5;i>0;i--){
        UIImageView *animationImageV = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"播放动画%ld",i]];
        animationImageV.size = CGSizeMake(Adapter(image.size.width), Adapter(image.size.height));
        animationImageV.center = CGPointMake(animationView.width/2.0, animationView.height/2.0);
        animationImageV.image = image;
        animationImageV.tag = 600+i;
        [animationView addSubview:animationImageV];
        
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat: M_PI *2];
        animation.duration =[[timeArr objectAtIndex:i-1] doubleValue];
        animation.autoreverses = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT;
        [animationImageV.layer addAnimation:animation forKey:@"animation"];
        
    }
    
    UILabel *timeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (animationView.height-Adapter(35))/2.0-Adapter(7)-Adapter(9), animationView.width, Adapter(35))];
    timeTitleLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
    timeTitleLabel.text = @"Time";
    timeTitleLabel.textAlignment = NSTextAlignmentCenter;
    [animationView addSubview:timeTitleLabel];
    
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, timeTitleLabel.bottom+Adapter(3), animationView.width, Adapter(30))];
    
    self.timeLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
    self.timeLabel.text = @"20 min";
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [animationView addSubview:self.timeLabel];
    
    if (ISPaid) {
        timeTitleLabel.font = [UIFont fontWithName:@"PingFang SC" size:24*[UserShareOnce shareOnce].fontSize];
        self.timeLabel.font = [UIFont fontWithName:@"PingFang SC" size:20*[UserShareOnce shareOnce].fontSize];
    }else{
        timeTitleLabel.font = [UIFont fontWithName:@"PingFang SC" size:24];
        self.timeLabel.font = [UIFont fontWithName:@"PingFang SC" size:20];
    }
    
    if(self.isRecommend){
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(animationView.right+Adapter(20), animationView.top-Adapter(2), ScreenWidth-animationView.right-Adapter(35), Adapter(138)+Adapter(6)) style:UITableViewStylePlain];
        self.tableView.layer.cornerRadius = Adapter(5.0);
        self.tableView.clipsToBounds = YES;
        self.tableView.layer.borderWidth = 1.0;
        self.tableView.layer.borderColor = UIColorAlpha(0X1E82D2, 0.5).CGColor;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.backgroundColor=[UIColor clearColor];
        self.tableView.bounces = NO;
        [self.upsideView addSubview:self.tableView];
        
        NSString *jlbsName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
        [self requestYueyaoListWithType:jlbsName];
    }
    

//    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.playBtn.frame = CGRectMake((animationView.width-20)/2.0, self.timeLabel.bottom+3, 20, 20);
//    [self.playBtn setImage:[UIImage imageNamed:@"按摩_播放"] forState:UIControlStateNormal];
//    [self.playBtn setImage:[UIImage imageNamed:@"按摩_暂停"] forState:UIControlStateSelected];
//    [self.playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.playBtn setHitTestEdgeInsets:UIEdgeInsetsMake(50, 50, 50, 50)];
//    [animationView addSubview:self.playBtn];
    
    [self.upsideView addSubview:animationView];
    
    if(self.isAdvanced){
        [self createAdvancedView];
        
    }
    
    [self createMiddleView];
    
    if(self.isAdvanced){
        [self createQiyaView];
    }
    
    [self createPostBottomView];
    
}

- (void)addAnimation
{
    UIView *animationView = [self.upsideView viewWithTag:1024];
    
    NSArray *timeArr = @[@3.0,@3.0,@3.0,@3.0,@3.0];
    for(NSInteger i = 5;i>0;i--){
        UIImageView *animationImageV = (UIImageView *)[animationView viewWithTag:600+i];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat: M_PI *2];
        animation.duration =[[timeArr objectAtIndex:i-1] doubleValue];
        animation.autoreverses = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT;
        [animationImageV.layer addAnimation:animation forKey:@"animation"];
        
    }
}

# pragma mark - 高级按摩手法
- (void)createAdvancedView
{
    self.advancedView = [[UIView alloc] initWithFrame:CGRectMake(0, self.upsideView.bottom+Adapter(10), ScreenWidth, Adapter(200)+Adapter(30)+Adapter(25))];
    [self.bgScrollView addSubview:self.advancedView];
    
    InsidelayerView *layerView = [[InsidelayerView alloc] initWithFrame:CGRectMake(Adapter(15), 0, ScreenWidth-Adapter(30), self.advancedView.height)];
    [layerView insertSublayerFromeView:self.advancedView];
    
    NSArray *commandArr1 = [self loadDataPlistWithStr:@"基础"];
    NSArray *commandArr2 = [self loadDataPlistWithStr:@"特殊"];
    
    CGFloat btnWidth = Adapter(58.0)+Adapter(10);
    CGFloat btnHeight = Adapter(83.0);
    
    CGFloat buttonMargin = (layerView.width-btnWidth*5)/6.0;
    
    UILabel *jichuLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin+Adapter(15)+Adapter(5), Adapter(5), Adapter(200), Adapter(30))];
   
    jichuLabel.text = @"Back Area";
    if (ISPaid) {
        jichuLabel.font = [UIFont fontWithName:@"PingFang SC" size:17*[UserShareOnce shareOnce].fontSize];
    }else{
        jichuLabel.font = [UIFont fontWithName:@"PingFang SC" size:17];
    }
    jichuLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    jichuLabel.textAlignment = NSTextAlignmentLeft;
    [self.advancedView addSubview:jichuLabel];
    
    UILabel *teshuLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin+Adapter(15)+Adapter(5), Adapter(45)+btnHeight, Adapter(200), Adapter(30))];
    //NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"特殊"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    teshuLabel.textAlignment = NSTextAlignmentLeft;
    teshuLabel.text = @"Action";
    if (ISPaid) {
        teshuLabel.font = [UIFont fontWithName:@"PingFang SC" size:17*[UserShareOnce shareOnce].fontSize];
    }else{
        teshuLabel.font = [UIFont fontWithName:@"PingFang SC" size:17];
    }
    teshuLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
     [self.advancedView addSubview:teshuLabel];
    areaIndex = 0;
    actionIndex = 0;
    for(NSInteger i=0;i<commandArr1.count;i++){
        
        ArmChairModel *model = [commandArr1 objectAtIndex:i];
        
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin+btnWidth)*i+buttonMargin+Adapter(15), Adapter(10)+Adapter(28), btnWidth, btnHeight) withModel:model];
        commandView.tag = 100+i;
        commandView.delegate = self;
        [self.advancedView addSubview:commandView];
    }
    for(NSInteger i=0;i<commandArr2.count;i++){
        
        ArmChairModel *model = [commandArr2 objectAtIndex:i];
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin+btnWidth)*i+buttonMargin+Adapter(15), Adapter(20)+btnHeight+Adapter(28)+Adapter(25), btnWidth, btnHeight) withModel:model];
        commandView.tag = 200+i;
        commandView.delegate = self;
        [self.advancedView addSubview:commandView];
    }
}

# pragma mark - 中间视图
- (void)createMiddleView
{
    //中间视图
    self.middleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.isAdvanced ? self.advancedView.bottom+Adapter(10) : self.upsideView.bottom+Adapter(10), ScreenWidth, Adapter(190)+Adapter(45))];
    [self.bgScrollView addSubview:self.middleView];
    
    InsidelayerView *layerView2 = [[InsidelayerView alloc] initWithFrame:CGRectMake(Adapter(15), 0, ScreenWidth-Adapter(30), self.middleView.height)];
    [layerView2 insertSublayerFromeView:self.middleView];
    
    self.bgScrollView.contentSize = CGSizeMake(1, self.middleView.bottom + Adapter(20));
    
    CGFloat buttonMargin = (ScreenWidth-Adapter(30)-Adapter(73)*2)/3.0;
    NSArray *commandArr = @[k730Command_Warm,k730Command_Warm];
    NSArray *arr = [self loadDataPlistWithStr:@"加热"];
    for(NSUInteger i =0;i<arr.count;i++){
        ArmChairModel *model = [arr objectAtIndex:i];
        model.command = [commandArr objectAtIndex:i];
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake(buttonMargin+Adapter(15)+(Adapter(70)+buttonMargin)*i, Adapter(15), Adapter(70)+Adapter(20), Adapter(83)) withModel:model];
        commandView.tag = 300+i;
        commandView.delegate = self;
        [self.middleView addSubview:commandView];
    }
    
    
    
    CGFloat commandBottom = Adapter(15)+Adapter(83);
    
    NSArray *titleArr = @[@"Massage Intensity",@"Air Intensity"];
    for(NSInteger i = 0; i<titleArr.count;i++){
        
        HCYSlider *slider1 = [[HCYSlider alloc]initWithFrame:CGRectMake(layerView2.left, commandBottom+Adapter(10)+(Adapter(23)+Adapter(10)+Adapter(23))*i, ScreenWidth-layerView2.left*2, Adapter(15)+Adapter(16)) withTag:200+i];
        slider1.currentValueColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
        if(i==0){
            slider1.maxValue = 5;
        }else{
            slider1.maxValue = 3;
        }
        slider1.tag = 310+i;
        slider1.delegate = self;
        [self.middleView addSubview:slider1];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake((ScreenWidth-Adapter(240))/2.0,slider1.bottom,Adapter(240),Adapter(23));
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[titleArr objectAtIndex:i] attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16*[UserShareOnce shareOnce].fontSize],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        
        label.attributedText = string;
        label.textAlignment = NSTextAlignmentCenter;
        [self.middleView addSubview:label];
    }
}

#pragma mark - 气压视图
- (void)createQiyaView
{
    
    //气压视图
    self.qiyaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.middleView.bottom+Adapter(10), ScreenWidth, Adapter(145))];
    [self.bgScrollView addSubview:self.qiyaView];
    
    [self.bgScrollView setContentSize:CGSizeMake(1, self.qiyaView.bottom+Adapter(20))];
    
    InsidelayerView *layerView = [[InsidelayerView alloc] initWithFrame:CGRectMake(Adapter(15), 0, ScreenWidth-Adapter(30), self.qiyaView.height)];
    [layerView insertSublayerFromeView:self.qiyaView];
    
    CGFloat buttonMargin = (layerView.width-Adapter(53)*4)/5.0;
    
    UILabel *qiyaLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin+Adapter(15), Adapter(10), Adapter(200), Adapter(35))];
    //    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"气压"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    //    qiyaLabel.attributedText = string;
    qiyaLabel.text = @"Compression";
    if (ISPaid) {
        qiyaLabel.font = [UIFont fontWithName:@"PingFang SC" size:17*[UserShareOnce shareOnce].fontSize];
    }else{
        qiyaLabel.font = [UIFont fontWithName:@"PingFang SC" size:17];
    }
    qiyaLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    qiyaLabel.textAlignment = NSTextAlignmentLeft;
    [self.qiyaView addSubview:qiyaLabel];
    
    
    
    //NSArray *nameArr = @[@"气压_全身",@"气压_肩颈",@"气压_手臂",@"气压_腰臂",@"气压_小腿"];
    
    NSArray *qiyaModelArr = [self loadDataPlistWithStr:@"气压"];
    
    for(NSInteger i = 0; i<qiyaModelArr.count;i++){
        ArmChairModel *model = [qiyaModelArr objectAtIndex:i];
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin+Adapter(53))*i+buttonMargin+Adapter(15), qiyaLabel.bottom, Adapter(53), Adapter(83)) withModel:model];
        commandView.tag = 400+i;
        commandView.delegate = self;
        [self.qiyaView addSubview:commandView];
    }
    
}

#pragma mark - 坐姿调节底部视图
- (void)createPostBottomView
{
    
    //遮罩
    self.styleView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.styleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.styleView.opaque = NO;
    self.styleView.tag = 8888;
    self.styleView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.styleView];
    self.styleView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.styleView addGestureRecognizer:tap];
    
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-Adapter(90), ScreenWidth, Adapter(20))];
    layerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:layerView];



    InsidelayerView *insidelayerView = [[InsidelayerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Adapter(20))];
    [insidelayerView insertSublayerFromeView:layerView];
    [layerView addSubview:insidelayerView];
    
    self.postBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-Adapter(100), ScreenWidth, Adapter(275)-Adapter(90))];
    self.postBottomView.backgroundColor = [UIColor whiteColor];

    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2.0-Adapter(6), Adapter(5), Adapter(12), Adapter(5))];
    imageV.image = [UIImage imageNamed:@"气压_上拉"];
    imageV.tag = 2019;
    [self.postBottomView addSubview:imageV];
    
    [self.view addSubview:self.postBottomView];
    
    CAShapeLayer *layer = [self createMaskLayerWithView:self.postBottomView];
    self.postBottomView.layer.mask = layer;
    
    
    NSArray *nameArr = [self loadDataPlistWithStr:@"姿势"];
    CGFloat buttonMargin = (self.postBottomView.width-Adapter(120)*2)/3.0;
    CGFloat buttonMargin2 = (self.postBottomView.width-Adapter(90)*4)/5.0;
    
//    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2.0, 15, 200, 15)];
//    tipLabel.font = [UIFont systemFontOfSize:14];
//    tipLabel.textAlignment = NSTextAlignmentLeft;
//    tipLabel.textColor = UIColorFromHex(0X1E82D2);
//    tipLabel.text = @"Tips:Long press";
//    [self.postBottomView addSubview:tipLabel];
    
    for(NSInteger i=0;i<nameArr.count;i++){
        
        ArmChairModel  *model = [nameArr objectAtIndex:i];
        if(i<2){
            PostButtonView *commandView = [[PostButtonView alloc] initWithFrame:CGRectMake((buttonMargin+Adapter(120))*i+buttonMargin, Adapter(15), Adapter(120), Adapter(40)) withModel:model];
            commandView.tag = 500+i;
           
            [self.postBottomView addSubview:commandView];
            
            UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
            longPress.minimumPressDuration = 0.5; //定义按的时间
            [commandView addGestureRecognizer:longPress];
        }else{
            
            NSInteger j = (i-2)/4;
            NSInteger k = (i-2)%4;
            
            PostButtonView *commandView = [[PostButtonView alloc] initWithFrame:CGRectMake((buttonMargin2+Adapter(90))*k+buttonMargin2, Adapter(90)+Adapter(15)+Adapter(90)*j, Adapter(90), Adapter(40)) withModel:model];
            commandView.tag = 500+i;
            [self.postBottomView addSubview:commandView];
            
            UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
            longPress.minimumPressDuration = 0.5; //定义按的时间
            [commandView addGestureRecognizer:longPress];
        }
    }
    
    
    UIPanGestureRecognizer *panpress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panScroll:)];
    panpress.delegate = self;
    [self.postBottomView addGestureRecognizer:panpress];
    
    
    
}

- (void)longAction:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            //向上-按下
            [self startTImer:gestureRecognizer.view.tag-500];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            //向上-抬起
            [self removeTimer];
        }
            break;
        default:
            break;
    }
}

- (void)startTImer:(NSInteger)index {
    
    if (self.longTimer) {
        [self.longTimer invalidate];
        self.longTimer = nil;
    }
    self.longTimer = [NSTimer timerWithTimeInterval:0.2 target:self selector:@selector(longCommandAction:) userInfo:@{@"index":@(index)} repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.longTimer forMode:NSDefaultRunLoopMode];
}

- (void)removeTimer {
    
    if (self.longTimer) {
        [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_AdjustStop success:nil];
        [self.longTimer invalidate];
        self.longTimer = nil;    }
}

- (void)longCommandAction:(NSTimer *)timer {
    
    NSInteger index = [timer.userInfo[@"index"] integerValue];
    NSLog(@"tap:%ld",index);
    NSArray *array = @[k730Command_BackUpLegDown, k730Command_BackDownLegUp, k730Command_LegUp, k730Command_LegDown, k730Command_LegStretch, k730Command_LegShrink];
    [[OGABluetoothManager_730B shareInstance] sendLongCommand:array[index] success:nil];
}


- (void)tapAction:(UIGestureRecognizer *)gesture
{
    [self shanglaAnimation];
}

# pragma mark - scrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"yyyyyyy:%f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y > Adapter(180)){
        self.navTitleLabel.hidden = YES;
        self.navTimeLabel.hidden = NO;
    }else{
        self.navTimeLabel.hidden = YES;
        self.navTitleLabel.hidden = NO;
    }
}

#pragma mark - PanGesture
- (void)panScroll:(UIGestureRecognizer*)gestureRecognizer{
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            startSpanPoint = [gestureRecognizer locationInView:self.view];
            
            if(self.postBottomView.frame.origin.y == panViewMinY){
                slideDirect = SlideDirectTopToBottom;
                
            }else{
                slideDirect = SlideDirectBottomToTop;
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            if(pointDirect == PointDirectTop){
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    CGRect postBottomViewFrame = self.postBottomView.frame;
                    postBottomViewFrame.origin.y = self->panViewMinY;
                    self.postBottomView.frame = postBottomViewFrame;
                    self.styleView.alpha = 0.5;
                    UIImageView *imageV = [self.postBottomView viewWithTag:2019];
                    imageV.image = [UIImage imageNamed:@"气压_下拉"];
                } completion:^(BOOL finished) {
                    
                }];
                
            }else{
                
                if(self.postBottomView.frame.origin.y < panViewMaxY){
                    [self shanglaAnimation];
                    
                }
            }
            
            pointDirect = PointDirectLevel;
            directHasChange = NO;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gestureRecognizer locationInView:self.view];
            CGFloat distance = startSpanPoint.y - point.y;
            [self panGesChange:distance];
        }
            break;
        default:
            break;
    }
    
}

- (void)shanglaAnimation{
    [UIView animateWithDuration:0.1 animations:^{
        CGRect postBottomViewFrame = self.postBottomView.frame;
        postBottomViewFrame.origin.y = self->panViewMaxY;
        self.postBottomView.frame = postBottomViewFrame;
        self.styleView.alpha = 0;
        UIImageView *imageV = [self.postBottomView viewWithTag:2019];
        imageV.image = [UIImage imageNamed:@"气压_上拉"];
    } completion:^(BOOL finished) {
        
    }];
}

-(void)panGesChange:(CGFloat)distance
{
    if(distance >0){
        
        if(pointDirect == PointDirectBottom){
            directHasChange = YES;
        }else if(pointDirect == PointDirectLevel){
            directHasChange = NO;
        }
        pointDirect = PointDirectTop;
        
        if(self.postBottomView.frame.origin.y == panViewMinY){
            
        }else{
            
            CGRect postBottomViewFrame = self.postBottomView.frame;
            CGFloat directTopY =  panViewMaxY - distance;
            if (directTopY >= panViewMinY) {
                if(slideDirect == SlideDirectBottomToTop){
                    postBottomViewFrame.origin.y = directTopY;
                }else {
                    if(!directHasChange){
                        postBottomViewFrame.origin.y = directTopY;
                    }
                }
                self.postBottomView.frame = postBottomViewFrame;
            }
        }
        
    }else if(distance<0){
        
        if(pointDirect == PointDirectTop){
            directHasChange = YES;
        }else if(pointDirect == PointDirectLevel){
            directHasChange = NO;
        }
        pointDirect = PointDirectBottom;
        
        if(self.postBottomView.frame.origin.y < panViewMaxY){
            
            CGRect postBottomViewFrame = self.postBottomView.frame;
            
            CGFloat directBottomY = panViewMinY - distance ;
            if (directBottomY <= panViewMaxY){
                if(slideDirect == SlideDirectBottomToTop){
                    if(!directHasChange){
                        postBottomViewFrame.origin.y = directBottomY;
                    }
                }else{
                    postBottomViewFrame.origin.y = directBottomY;
                }
            }
            self.postBottomView.frame = postBottomViewFrame;
        }
    }
}


#pragma mark - 播放，暂停
- (void)playAction:(UIButton *)button
{
    // __weak typeof(self) weakSelf = self;
    [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_Stop success:^(BOOL success) {
        if (success) {
            // weakSelf.playBtn.selected = !weakSelf.playBtn.selected;
            // [weakSelf layerAnimationWithPause:weakSelf.playBtn.selected];
        }
    }];
    
}
# pragma mark - 动画的开始，暂停
- (void)layerAnimationWithPause:(BOOL )select
{
    UIView *animationView = [self.upsideView viewWithTag:1024];
    CALayer *layer = animationView.layer;
    
    if(select){
        if(layer.speed == 1.0){
            NSLog(@"暂停啦暂停啦");
            CFTimeInterval pausedTime = [layer
                                         convertTime:CACurrentMediaTime() fromLayer:nil];
            layer.speed = 0.0;
            layer.timeOffset = pausedTime;
        }
        
    }else{
        //继续layer上面的动画
        if(layer.speed == 0.0){ //动画处于暂停状态，让他开始 避免重复
            NSLog(@"开始开始开始");
            CFTimeInterval pausedTime = [layer timeOffset];
            layer.speed = 1.0;
            layer.timeOffset = 0.0;
            layer.beginTime = 0.0;
            CFTimeInterval timeSincePause = [layer
                                             convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
            layer.beginTime = timeSincePause;
        }
        
    }
}

- (void)DidBecomeActive
{
    
    BOOL isBlueToothPoweredOn = [[OGABluetoothManager_730B shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        self.rightBtn.selected = NO;
        [UserShareOnce shareOnce].ogaConnected = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    //animation
    UIView *animationView = [self.upsideView viewWithTag:1024];
    CALayer *layer = animationView.layer;
    if([layer animationForKey:@"animation"]){
        //继续layer上面的动画
        if(layer.speed == 0.0){ //动画处于暂停状态，让他开始 避免重复
            NSLog(@"开始开始开始");
            CFTimeInterval pausedTime = [layer timeOffset];
            layer.speed = 1.0;
            layer.timeOffset = 0.0;
            layer.beginTime = 0.0;
            CFTimeInterval timeSincePause = [layer
                                             convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
            layer.beginTime = timeSincePause;
        }
    }else{
        [self addAnimation];
    }
}

-(void)insertSublayerWithImageView:(UIImageView *)imageV
{
    if(!subLayer){
        subLayer=[CALayer layer];
        CGRect fixframe = imageV.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=8;
        subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        subLayer.masksToBounds=NO;
        subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        subLayer.shadowRadius = 4;//阴影半径，默认3
        [self.postBottomView.layer insertSublayer:subLayer below:imageV.layer];
    }else{
        subLayer.frame = imageV.frame;
    }
    
}

- (CAShapeLayer *)createMaskLayerWithView :(UIView *)view
{
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    CGFloat viewHeight = CGRectGetHeight(view.frame);
    
    CGFloat topMargin = Adapter(10);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint point1 = CGPointMake(0, topMargin);
    CGPoint point2 = CGPointMake(viewWidth/2.0-topMargin, topMargin);
    CGPoint point3 = CGPointMake(viewWidth/2.0+topMargin, topMargin);
    CGPoint point4 = CGPointMake(viewWidth, topMargin);
    CGPoint point5 = CGPointMake(viewWidth, viewHeight);
    CGPoint point6 = CGPointMake(0, viewHeight);
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addArcWithCenter:CGPointMake(view.width/2.0, topMargin) radius:topMargin startAngle:0 endAngle:M_PI clockwise:NO];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path addLineToPoint:point5];
    [path addLineToPoint:point6];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor redColor].CGColor;
    layer.strokeColor = [UIColor orangeColor].CGColor;
    //    layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //    layer.shadowOffset = CGSizeMake(0,1);
    //    layer.shadowOpacity = 0.4;
    //    layer.shadowRadius = 4;
    
    layer.path = path.CGPath;
    return layer;
}

# pragma mark - HCYSliderDelegate 按摩强度加减指令
- (void)HCYSliderButtonAction:(BOOL)add withTag:(NSInteger)tag
{
    if(tag == 200){ //按摩强度
        if(add){    //加
            [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_MovementStrong success:nil];
        }else{      //减
            [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_MovementWeak success:nil];
        }
    }else if (tag == 201){ //气囊强度
        if(add){    //加
            [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_AirStrong success:nil];
        }else{      //减
            [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_AirWeak success:nil];
        }
    }
}


//# pragma mark - 解决侧滑返回指定控制器
- (void)didMoveToParentViewController:(UIViewController*)parent
{
    
    NSMutableArray *tempArr = self.navigationController.viewControllers.mutableCopy;
    for(UIViewController *vc in self.navigationController.viewControllers){
        
        if([vc isKindOfClass:[OGA730BAcheTestVC class]] || [vc isKindOfClass:[OGA730BTestResultVC class]]){
            [tempArr removeObject:vc];
        }
        
    }
    self.navigationController.viewControllers = tempArr;
    
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    return YES;
}

@end
