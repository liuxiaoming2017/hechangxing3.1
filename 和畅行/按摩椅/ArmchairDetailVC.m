//
//  ArmchairDetailVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairDetailVC.h"
#import "InsidelayerView.h"
#import "CommandButtonView.h"
#import "HCYSlider.h"
#import "UIButton+ExpandScope.h"

#import "ArmchairAcheTestVC.h"
#import "ArmchairTestResultVC.h"
#import "UIImage+Units.h"
typedef enum : NSInteger {
    PointDirectTop,
    PointDirectLevel,
    PointDirectBottom,
} PointDirect;

typedef enum : NSInteger {
    SlideDirectBottomToTop,
    SlideDirectTopToBottom,
} SlideDirect;

@interface ArmchairDetailVC ()<HCYSliderDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,CommandButtonDelegate,UIGestureRecognizerDelegate>
{
    CGPoint startSpanPoint;
    PointDirect pointDirect;
    SlideDirect slideDirect;
    BOOL directHasChange ;
    CGFloat panViewMaxY;
    CGFloat panViewMinY;
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

@property (nonatomic, strong) OGA530Subscribe *ogaSubscribe;

@property (nonatomic,strong) UILabel *navTimeLabel;

@property (nonatomic,strong) UILabel *nameLabel;
@end

@implementation ArmchairDetailVC
@synthesize subLayer,nameLabel;

- (void)dealloc
{
    
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
    
    self.navTitleLabel.text = self.titleStr;
    
    [self initUI];
    
    [self initTopView];
    
    pointDirect = PointDirectLevel;
    slideDirect = SlideDirectTopToBottom;
    panViewMaxY = ScreenHeight-Adapter(100);
    panViewMinY = ScreenHeight-Adapter(185);
    self.startTimeStr = [GlobalCommon getCurrentTimes];
    //按摩椅添加订阅
    self.ogaSubscribe = [[OGA530Subscribe alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.ogaSubscribe setRespondBlock:^(OGA530Respond * _Nonnull respond) {

        [weakSelf didUpdateValueForChair:respond];
    }];
    [[OGA530BluetoothManager shareInstance] addSubscribe:self.ogaSubscribe];

    self.view.backgroundColor = [UIColor whiteColor];
    
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[OGA530BluetoothManager shareInstance] removeSubscribe:self.ogaSubscribe];
}

# pragma mark - 按摩椅数据回调
- (void)didUpdateValueForChair:(OGA530Respond *)respond {
    
    //开关
    self.rightBtn.selected = respond.powerOn;
    self.playBtn.selected = respond.pause;
    if(!respond.powerOn){
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    [self layerAnimationWithPause:respond.pause];
    
    //背部加热
    CommandButtonView *comandView300 = (CommandButtonView *)[self.middleView viewWithTag:300];
    [comandView300 setButtonViewSelect:respond.executeWarmBack];
    //脚底滚轮
    CommandButtonView *comandView301 = (CommandButtonView *)[self.middleView viewWithTag:301];
    [comandView301 setButtonViewSelect:respond.executeRollFoot];
    
    //按摩强度
    HCYSlider *slider1 = (HCYSlider *)[self.middleView viewWithTag:310];
    slider1.currentSliderValue = respond.status4DStrength;
    //气囊强度
    HCYSlider *slider2 = (HCYSlider *)[self.middleView viewWithTag:311];
    slider2.currentSliderValue = respond.statusAirStrength;
    
    //时间
    NSString *minute = [NSString stringWithFormat:@"%d", respond.timeMinute];
    NSString *sec = @"";
    if(respond.timeSecond<10){
         sec = [NSString stringWithFormat:@"0%d", respond.timeSecond];
    }else{
         sec = [NSString stringWithFormat:@"%d", respond.timeSecond];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",minute,sec];
    self.navTimeLabel.text = [NSString stringWithFormat:@"%@:%@",minute,sec];
    
    /******气压******/
    CommandButtonView *command400 = (CommandButtonView *)[self.qiyaView viewWithTag:400];
    [command400 setButtonViewSelect:respond.executeAirFullbody];
    CommandButtonView *command401 = (CommandButtonView *)[self.qiyaView viewWithTag:401];
    [command401 setButtonViewSelect:respond.statusAirShoulder];
    CommandButtonView *command402 = (CommandButtonView *)[self.qiyaView viewWithTag:402];
    [command402 setButtonViewSelect:respond.statusAirArm];
    CommandButtonView *command403 = (CommandButtonView *)[self.qiyaView viewWithTag:403];
    [command403 setButtonViewSelect:respond.statusAirSeat];
    CommandButtonView *command404 = (CommandButtonView *)[self.qiyaView viewWithTag:404];
    [command404 setButtonViewSelect:respond.executeAirKnee];
    
    /******高级基础******/
    CommandButtonView *gaoji100 = (CommandButtonView *)[self.advancedView viewWithTag:100];
    [gaoji100 setButtonViewSelect:(respond.statusKnead1 || respond.statusKnead2)? YES: NO];
    CommandButtonView *gaoji101 = (CommandButtonView *)[self.advancedView viewWithTag:101];
    [gaoji101 setButtonViewSelect:(respond.statusKnock1 || respond.statusKnock2)? YES: NO];
    CommandButtonView *gaoji102 = (CommandButtonView *)[self.advancedView viewWithTag:102];
    [gaoji102 setButtonViewSelect:(respond.statusShiatsu1 || respond.statusShiatsu2)? YES: NO];
    CommandButtonView *gaoji103 = (CommandButtonView *)[self.advancedView viewWithTag:103];
    [gaoji103 setButtonViewSelect:respond.statusRoll? YES: NO];
    CommandButtonView *gaoji104 = (CommandButtonView *)[self.advancedView viewWithTag:104];
    [gaoji104 setButtonViewSelect:(respond.statusClap1 || respond.statusClap2)? YES: NO];
    
    /******高级特殊******/
    CommandButtonView *gaoji200 = (CommandButtonView *)[self.advancedView viewWithTag:200];
    [gaoji200 setButtonViewSelect:respond.executeNeckShoulder4D];
    CommandButtonView *gaoji201 = (CommandButtonView *)[self.advancedView viewWithTag:201];
    [gaoji201 setButtonViewSelect:respond.executeWaistBackRoll];
    CommandButtonView *gaoji202 = (CommandButtonView *)[self.advancedView viewWithTag:202];
    [gaoji202 setButtonViewSelect:respond.statusKneeMassage];
    CommandButtonView *gaoji203 = (CommandButtonView *)[self.advancedView viewWithTag:203];
    [gaoji203 setButtonViewSelect:respond.executeLegWarm];
    CommandButtonView *gaoji204 = (CommandButtonView *)[self.advancedView viewWithTag:204];
    [gaoji204 setButtonViewSelect:(respond.statusSweden1 || respond.statusSweden2)? YES: NO];
    
    /******按摩椅姿势调节******/
    CommandButtonView *postView500 = (CommandButtonView *)[self.postBottomView viewWithTag:500];
    [postView500 setButtonViewSelect:respond.chairAngleStatus2];
    CommandButtonView *postView501 = (CommandButtonView *)[self.postBottomView viewWithTag:501];
    [postView501 setButtonViewSelect:respond.chairAngleStatus1];
    CommandButtonView *postView502 = (CommandButtonView *)[self.postBottomView viewWithTag:502];
    [postView502 setButtonViewSelect:respond.chairAngleStatus3];
    CommandButtonView *postView503 = (CommandButtonView *)[self.postBottomView viewWithTag:503];
    [postView503 setButtonViewSelect:respond.statusPostBackDown];
    CommandButtonView *postView504 = (CommandButtonView *)[self.postBottomView viewWithTag:504];
    [postView504 setButtonViewSelect:respond.statusPostLegUp];
    CommandButtonView *postView505 = (CommandButtonView *)[self.postBottomView viewWithTag:505];
    [postView505 setButtonViewSelect:respond.statusPostBackUp];
    CommandButtonView *postView506 = (CommandButtonView *)[self.postBottomView viewWithTag:506];
    [postView506 setButtonViewSelect:respond.statusPostLegDown];
    
    
    NSDictionary *dic = [self acupointSringWithIndex:respond.statusMovmentYCoor];
    nameLabel.text = [dic objectForKey:@"name"];
    self.acupointLabel.text = [dic objectForKey:@"introduce"];
    
    //穴位
    NSLog(@"斜方-风池:%@,斜方-肩中:%@,斜方-肩井:%@,阔背-心俞:%@,腰背-肾俞:%@,臀大肌-环中:%@,臀大肌-环跳:%@",respond.statusXieFangFengChi ? @"YES":@"NO",respond.statusXieFangJianZhong?@"YES":@"NO",respond.statusXieFangJianJing ? @"YES":@"NO",respond.statusKuoBeiXinShu?@"YES":@"NO",respond.statusYaoBeiShenShu ? @"YES":@"NO",respond.statusTunDaJiHuanZhong?@"YES":@"NO",respond.statusTunDaJiHuanTiao ? @"YES":@"NO");
}

# pragma mark - CommandButtonDelegate 发送按摩椅指令
- (void)commandActionWithModel:(ArmChairModel *)model
{
    NSLog(@"----发送----:%@,%d",model.command,[model.command intValue]);
    
    [[OGA530BluetoothManager shareInstance] sendCommand:model.command success:^(BOOL success) {
        if(success){
            NSLog(@"++++指令成功了++++");
        }
    }];
}


- (void)initUI
{
    CGFloat fontSizeFloat = 1;
    if (ISPaid) {
        fontSizeFloat = [UserShareOnce shareOnce].fontSize;
    }
    
    self.navTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-Adapter(240))/2.0, 2+kStatusBarHeight, Adapter(240), 40)];
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
        self.bgScrollView.contentSize = CGSizeMake(1, ScreenHeight-kNavBarHeight-Adapter(100));
        [self.view addSubview:self.bgScrollView];
    }
    
    //高级,专属里面没有收藏按钮
    NSArray *zhuanshuArr = [self loadHomeData];
    BOOL isZhuanshu = NO;
    for(ArmChairModel *model in zhuanshuArr){
        if([self.armchairModel.name isEqualToString:model.name]){
            isZhuanshu = YES;
            break;
        }
    }
    
    if(!self.isAdvanced && !isZhuanshu && !self.isRecommend){
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        likeBtn.frame = CGRectMake(self.rightBtn.left-Adapter(42), Adapter(2)+kStatusBarHeight, Adapter(37), Adapter(40));
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"按摩收藏_未"] forState:UIControlStateNormal];
        [likeBtn setBackgroundImage:[UIImage imageNamed:@"按摩收藏_已"] forState:UIControlStateSelected];
        BOOL isSelect = [[CacheManager sharedCacheManager] selectArmchairModel:self.armchairModel];
        likeBtn.selected = isSelect;
        [likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:likeBtn];
    }
    
}

# pragma mark - 头部视图
- (void)initTopView
{
    
    CGFloat fontSizeFloat = 1;
    if (ISPaid) {
        fontSizeFloat = [UserShareOnce shareOnce].fontSize;
    }

   // self.view.backgroundColor = [UIColor whiteColor];
    //头部视图
    self.upsideView = [[UIView alloc] initWithFrame:CGRectMake(0, Adapter(10), ScreenWidth, Adapter(180))];
    [self.bgScrollView addSubview:self.upsideView];
    
    
    InsidelayerView *layerView = [[InsidelayerView alloc] initWithFrame:CGRectMake(Adapter(25), Adapter(21), Adapter(125), Adapter(138))];
    [layerView insertSublayerFromeView:self.upsideView];
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Adapter(8), layerView.width, Adapter(15))];
    nameLabel.font = [UIFont fontWithName:@"PingFang SC" size:15*fontSizeFloat];
    nameLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    //titleLabel.backgroundColor = [UIColor redColor];
    nameLabel.text = @"肩中俞/肩井";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [layerView addSubview:nameLabel];
    
    self.acupointLabel = [[UITextView alloc] initWithFrame:CGRectMake(Adapter(8), nameLabel.bottom, layerView.width-Adapter(16), layerView.height-nameLabel.bottom-Adapter(5))];
    self.acupointLabel.font = [UIFont fontWithName:@"PingFang SC" size:14*fontSizeFloat];
    self.acupointLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    self.acupointLabel.userInteractionEnabled = NO;
    //self.acupointLabel.backgroundColor = [UIColor orangeColor];
    self.acupointLabel.text = @"保健功效：宣肺解表，散风活络、缓解肩部酸痛。调气行血，解郁散结。";
    [self.acupointLabel setContentInset:UIEdgeInsetsMake(-5, 0, 0, 0)];
    //self.acupointLabel.numberOfLines = 0;
    self.acupointLabel.textAlignment = NSTextAlignmentLeft;
    [layerView addSubview:self.acupointLabel];
    
    [self.upsideView addSubview:layerView];
    
    CGFloat animationLeft = layerView.right+Adapter(30) > (ScreenWidth-Adapter(142))/2.0 ? layerView.right+Adapter(30) : (ScreenWidth-Adapter(142))/2.0;
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(animationLeft, Adapter(25), Adapter(142), Adapter(134))];
    animationView.tag = 1024;
    //animationView.backgroundColor = [UIColor orangeColor];
    //NSArray *timeArr = @[@3.0,@2.8,@2.6,@2.4,@2.2];
    NSArray *timeArr = @[@3.0,@3.0,@3.0,@3.0,@3.0];
    for(NSInteger i = 5;i>0;i--){
        UIImageView *animationImageV = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"播放动画%ld",i]];
        CGSize size = CGSizeMake(Adapter(image.size.width), Adapter(image.size.height));
        animationImageV.size = size;
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
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((animationView.width-Adapter(81))/2.0, (animationView.height-Adapter(35))/2.0-Adapter(7), Adapter(81), Adapter(35))];
    self.timeLabel.font = [UIFont fontWithName:@"PingFang SC" size:30*fontSizeFloat];
    self.timeLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
    self.timeLabel.text = @"15:00";
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [animationView addSubview:self.timeLabel];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake((animationView.width-Adapter(20))/2.0, self.timeLabel.bottom+Adapter(3), Adapter(20), Adapter(20));
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"按摩_播放"] forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"按摩_暂停"] forState:UIControlStateSelected];
    [self.playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn setHitTestEdgeInsets:UIEdgeInsetsMake(Adapter(50), Adapter(50), Adapter(50), Adapter(50))];
    [animationView addSubview:self.playBtn];
    
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
    CGFloat fontSizeFloat = 1;
    if (ISPaid) {
        fontSizeFloat = [UserShareOnce shareOnce].fontSize;
    }
    
    self.advancedView = [[UIView alloc] initWithFrame:CGRectMake(0, self.upsideView.bottom+Adapter(10), ScreenWidth, Adapter(230))];
    [self.bgScrollView addSubview:self.advancedView];
    
    InsidelayerView *layerView = [[InsidelayerView alloc] initWithFrame:CGRectMake(Adapter(15), 0, ScreenWidth-Adapter(30), self.advancedView.height)];
    [layerView insertSublayerFromeView:self.advancedView];
    
    NSArray *commandArr1 = [self loadDataPlistWithStr:@"基础"];
    NSArray *commandArr2 = [self loadDataPlistWithStr:@"特殊"];
    
    CGFloat btnWidth = Adapter(68);
    CGFloat btnHeight = Adapter(83.0);
    
    CGFloat buttonMargin = (layerView.width-btnWidth*5)/6.0;
    
    UILabel *jichuLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin+Adapter(15), Adapter(5), Adapter(81), Adapter(30))];
    //NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"按摩手法"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    jichuLabel.text = @"按摩手法";
    jichuLabel.font = [UIFont fontWithName:@"PingFang SC" size:17*fontSizeFloat];
    jichuLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    jichuLabel.textAlignment = NSTextAlignmentLeft;
    [self.advancedView addSubview:jichuLabel];
    
    UILabel *teshuLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin+Adapter(15), Adapter(45)+btnHeight, Adapter(81), Adapter(30))];
    //NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"特殊"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    teshuLabel.textAlignment = NSTextAlignmentLeft;
    teshuLabel.text = @"特殊";
    teshuLabel.font = [UIFont fontWithName:@"PingFang SC" size:17*fontSizeFloat];
    teshuLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
   // [self.advancedView addSubview:teshuLabel];
    
    for(NSInteger i=0;i<commandArr1.count;i++){
        
        ArmChairModel *model = [commandArr1 objectAtIndex:i];
        
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin+btnWidth)*i+buttonMargin+Adapter(15), Adapter(38), btnWidth, btnHeight) withModel:model];
        commandView.tag = 100+i;
        commandView.delegate = self;
        [self.advancedView addSubview:commandView];
    }
    for(NSInteger i=0;i<commandArr2.count;i++){
        
        ArmChairModel *model = [commandArr2 objectAtIndex:i];
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin+btnWidth)*i+buttonMargin+Adapter(15), Adapter(20)+btnHeight+Adapter(28), btnWidth, btnHeight) withModel:model];
        commandView.tag = 200+i;
        commandView.delegate = self;
        [self.advancedView addSubview:commandView];
    }
}

# pragma mark - 中间视图
- (void)createMiddleView
{
    
    CGFloat fontSizeFloat = 1;
    if (ISPaid) {
        fontSizeFloat = [UserShareOnce shareOnce].fontSize;
    }
    
    //中间视图
    self.middleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.isAdvanced ? self.advancedView.bottom+Adapter(10) : self.upsideView.bottom+Adapter(10), ScreenWidth, Adapter(190))];
    [self.bgScrollView addSubview:self.middleView];
    
    InsidelayerView *layerView2 = [[InsidelayerView alloc] initWithFrame:CGRectMake(Adapter(15), 0, ScreenWidth-Adapter(30), self.middleView.height)];
    [layerView2 insertSublayerFromeView:self.middleView];
    
    CGFloat buttonMargin = (ScreenWidth-Adapter(30)-Adapter(73)*2)/3.0;
    NSArray *commandArr = @[k530Command_BackWarm,k530Command_FootRoll];
    NSArray *arr = [self loadDataPlistWithStr:@"背部脚底"];
    for(NSUInteger i =0;i<arr.count;i++){
        ArmChairModel *model = [arr objectAtIndex:i];
        model.command = [commandArr objectAtIndex:i];
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake(buttonMargin+Adapter(15)+(Adapter(70)+buttonMargin)*i, Adapter(15), Adapter(90), Adapter(83)) withModel:model];
        commandView.tag = 300+i;
        commandView.delegate = self;
        [self.middleView addSubview:commandView];
    }
    
//    CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake(buttonMargin+15, 15, 70, 83) withTitle:@"背部加热"];
//    commandView.tag = 300;
//    [self.middleView addSubview:commandView];
//
//    CommandButtonView *commandView2 = [[CommandButtonView alloc] initWithFrame:CGRectMake(commandView.right+buttonMargin, 15, 70, 83) withTitle:@"脚底滚轮"];
//    commandView2.tag = 301;
//    [self.middleView addSubview:commandView2];
    
    CGFloat commandBottom = Adapter(98);
    
    NSArray *titleArr = @[@"按摩强度",@"气囊强度"];
    for(NSInteger i = 0; i<titleArr.count;i++){
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(Adapter(25),commandBottom+Adapter(10)+Adapter(33)*i,Adapter(70),Adapter(23));
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[titleArr objectAtIndex:i] attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16*fontSizeFloat],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        
        label.attributedText = string;
        label.textAlignment = NSTextAlignmentCenter;
        [self.middleView addSubview:label];
        
       // HCYSlider *slider1 = [[HCYSlider alloc]initWithFrame:CGRectMake(label.right+5, label.top+4, layerView2.right-10-label.right-10, 15) withTag:200+i];
        HCYSlider *slider1 = [[HCYSlider alloc]initWithFrame:CGRectMake(label.right-Adapter(5), label.top-Adapter(4), layerView2.right-Adapter(10)-label.right+Adapter(10), Adapter(31)) withTag:200+i];
        slider1.currentValueColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
        //slider1.backgroundColor = [UIColor orangeColor];
        slider1.maxValue = 5;
        slider1.tag = 310+i;
        slider1.delegate = self;
        [self.middleView addSubview:slider1];
    }
}

#pragma mark - 气压视图
- (void)createQiyaView
{
    CGFloat fontSizeFloat = 1;
    if (ISPaid) {
        fontSizeFloat = [UserShareOnce shareOnce].fontSize;
    }
    //气压视图
    self.qiyaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.middleView.bottom+Adapter(10), ScreenWidth, Adapter(145))];
    [self.bgScrollView addSubview:self.qiyaView];
    
    [self.bgScrollView setContentSize:CGSizeMake(1, self.qiyaView.bottom+Adapter(20))];
    
    InsidelayerView *layerView = [[InsidelayerView alloc] initWithFrame:CGRectMake(Adapter(15), 0, ScreenWidth-Adapter(30), self.qiyaView.height)];
    [layerView insertSublayerFromeView:self.qiyaView];
    
    CGFloat buttonMargin = (layerView.width-Adapter(53)*5)/6.0;
    
    UILabel *qiyaLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin+Adapter(15), Adapter(10), Adapter(81), Adapter(35))];
//    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"气压"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
//    qiyaLabel.attributedText = string;
    qiyaLabel.text = @"气压";
    qiyaLabel.font = [UIFont fontWithName:@"PingFang SC" size:17*fontSizeFloat];
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
    
    self.postBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-Adapter(100), ScreenWidth, Adapter(185))];
    self.postBottomView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2.0-Adapter(6), Adapter(5), Adapter(12), Adapter(5))];
    imageV.image = [UIImage imageNamed:@"气压_上拉"];
    imageV.tag = 2019;
    [self.postBottomView addSubview:imageV];
    
    [self.view addSubview:self.postBottomView];
    
    CAShapeLayer *layer = [self createMaskLayerWithView:self.postBottomView];
    self.postBottomView.layer.mask = layer;
    
    
    /*
    self.postBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-100, ScreenWidth, 275-90)];
    self.postBottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.postBottomView];
    
    
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, self.postBottomView.height-10)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(0,1);
    bottomView.layer.shadowOpacity = 0.4;
    bottomView.layer.shadowRadius = 4;
    [self.postBottomView addSubview:bottomView];
    
    UIImageView *circleV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-20)/2.0, 0, 20, 20)];
    circleV.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    circleV.layer.shadowOffset = CGSizeMake(0,1);
    circleV.layer.shadowOpacity = 0.4;
    circleV.layer.shadowRadius = 4;
    circleV.backgroundColor = [UIColor whiteColor];
    circleV.layer.cornerRadius = 10.0;
    
    [self.postBottomView addSubview:circleV];
    */
    

    
    NSArray *nameArr = [self loadDataPlistWithStr:@"姿势"];
    CGFloat buttonMargin = (self.postBottomView.width-Adapter(56)*3)/4.0;
    CGFloat buttonMargin2 = (self.postBottomView.width-Adapter(56)*4)/5.0;
    for(NSInteger i=0;i<nameArr.count;i++){
        
        ArmChairModel  *model = [nameArr objectAtIndex:i];
        if(i<3){
            CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin+Adapter(56))*i+buttonMargin, Adapter(15), Adapter(56), Adapter(58)) withModel:model];
            commandView.tag = 500+i;
            commandView.delegate = self;
            [self.postBottomView addSubview:commandView];
        }else{
            
            NSInteger j = (i-3)/4;
            NSInteger k = (i-3)%4;
            
            CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin2+Adapter(56))*k+buttonMargin2, Adapter(105)+Adapter(90)*j, Adapter(56), Adapter(58)) withModel:model];
            commandView.delegate = self;
            commandView.tag = 500+i;
            [self.postBottomView addSubview:commandView];
        }
    }
    
    
    UIPanGestureRecognizer *panpress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panScroll:)];
    panpress.delegate = self;
    [self.postBottomView addGestureRecognizer:panpress];
    
    //NSLog(@"****%f",self.postBottomView.frame.origin.y);
    
}

# pragma mark - 手势收藏按钮
- (void)likeBtnAction:(UIButton *)button
{
    NSLog(@"name:%@",self.armchairModel.name);
    
    button.selected = !button.selected;
    if(button.selected){
//        NSArray *arr = [[CacheManager sharedCacheManager] getArmchairModel];
//        if(arr.count>0){
            [[CacheManager sharedCacheManager] insertArmchairModel:self.armchairModel];
      //  }
    }else{
        [[CacheManager sharedCacheManager] deleteArmchairModel:self.armchairModel];
    }
    
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
    [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_Pause success:^(BOOL success) {
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
    
    BOOL isBlueToothPoweredOn = [[OGA530BluetoothManager shareInstance] isBlueToothPoweredOn];
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
            [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_MassageStrengthAdd success:nil];
        }else{      //减
            [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_MassageStrength success:nil];
        }
    }else if (tag == 201){ //气囊强度
        if(add){    //加
            [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_AirStrengthAdd success:nil];
        }else{      //减
            [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_AirStrength success:nil];
        }
    }
}

- (NSDictionary *)acupointSringWithIndex:(int )index
{
    
   
    NSNumber *numberIndex = [NSNumber numberWithInt:index];
    
    NSDictionary *dic2 = @{
                           [NSNumber numberWithInteger:0]:@{@"name":@"环中/环跳",@"introduce":@"保健功效："},
                            [NSNumber numberWithInteger:1]:@{@"name":@"八髎穴",@"introduce":@"保健功效："},
                           [NSNumber numberWithInteger:2]:@{@"name":@"膀胱俞",@"introduce":@"保健功效：清热利湿，通淋止痛"},
                           [NSNumber numberWithInteger:3]:@{@"name":@"肾俞",@"introduce":@"保健功效：生精化髓，纳气归根，益肾壮阳，腰强利水祛湿"},
                           [NSNumber numberWithInteger:4]:@{@"name":@"肾俞",@"introduce":@"保健功效：生精化髓，纳气归根，益肾壮阳，腰强利水祛湿"},
                           [NSNumber numberWithInteger:5]:@{@"name":@"脾俞",@"introduce":@"保健功效：升清降浊，帮助消化"},
                           [NSNumber numberWithInteger:6]:@{@"name":@"肝俞",@"introduce":@"保健功效：疏肝解郁，清降肝火"},
                           [NSNumber numberWithInteger:7]:@{@"name":@"肝俞",@"introduce":@"保健功效：疏肝解郁，清降肝火"},
                           [NSNumber numberWithInteger:8]:@{@"name":@"心俞",@"introduce":@"保健功效：补气养血，滋养心神，清心火，益心气，宁心神"},
                           [NSNumber numberWithInteger:9]:@{@"name":@"心俞",@"introduce":@"保健功效：补气养血，滋养心神，清心火，益心气，宁心神"},
                           [NSNumber numberWithInteger:10]:@{@"name":@"肺俞",@"introduce":@"保健功效：祛风解表，润肺益气"},
                           [NSNumber numberWithInteger:11]:@{@"name":@"肩井/肩中",@"introduce":@"保健功效：宣肺解表，散风活络、缓解肩部酸痛。调气行血，解郁散结"},
                           [NSNumber numberWithInteger:12]:@{@"name":@"肩井/肩中",@"introduce":@"保健功效：宣肺解表，散风活络、缓解肩部酸痛。调气行血，解郁散结"},
                           [NSNumber numberWithInteger:13]:@{@"name":@"风池/天柱",@"introduce":@"保健功效：平肝息风，疏风解表，祛风通络，提神醒脑，缓解眼睛疲劳与肩部酸痛"},
                           
                           
                           };
    NSDictionary *dic = [dic2 objectForKey:numberIndex];
    NSLog(@"dic:%@",dic);
    return dic;
}


//# pragma mark - 解决侧滑返回指定控制器
- (void)didMoveToParentViewController:(UIViewController*)parent
{
    
    NSMutableArray *tempArr = self.navigationController.viewControllers.mutableCopy;
    for(UIViewController *vc in self.navigationController.viewControllers){
        
        if([vc isKindOfClass:[ArmchairAcheTestVC class]] || [vc isKindOfClass:[ArmchairTestResultVC class]]){
                [tempArr removeObject:vc];
            }
        
    }
    self.navigationController.viewControllers = tempArr;
    
    
}


//-(void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    self.endTimeStr = [GlobalCommon getCurrentTimes];
//    NSString *userSign = [UserShareOnce shareOnce].uid;
//    NSString *memberId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
//    if(!self.isAdvanced){
//        //高级按摩
//        NSString *userSign = [UserShareOnce shareOnce].uid;
//        NSString *memberId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
//        
//        NSString *deviceStr = [NSString stringWithFormat:@"%@mchair/advanced",DATAURL_PRE];
//        NSDictionary *deviceDic = @{ @"body":@{
//                                             @"id":@"",
//                                             @"memberChild":memberId,
//                                             @"memberId":userSign,
//                                             @"subject":@"1",
//                                             @"massageName":@"0",
//                                             @"classifyId":@"0",
//                                             @"blackHeat":@"1-2",
//                                             @"soleRoller":@"1-2",
//                                             @"rounie":@"1",
//                                             @"qiaoji":@"1",
//                                             @"zhiya":@"1",
//                                             @"tuina":@"1",
//                                             @"paida":@"1",
//                                             @"jianjing4":@"1",
//                                             @"yaobugunya":@"1",
//                                             @"xigaianmo":@"0",
//                                             @"xiaotuijiare":@"1",
//                                             @"ruidian":@"1",
//                                             @"body":@"1",
//                                             @"jianjing":@"1",
//                                             @"shoubi":@"1",
//                                             @"yaotun":@"1",
//                                             @"xiaotui":@"1",
//                                             @"zeroG":@"1",
//                                             @"takeIn":@"1",
//                                             @"spreadOn":@"1",
//                                             @"daobei":@"1",
//                                             @"taitui":@"1",
//                                             @"shengbei":@"1",
//                                             @"jiangtui":@"1",
//                                             @"startDate": self.startTimeStr,
//                                             @"endDate":self.endTimeStr}
//                                     };
//        
//        [[BuredPoint sharedYHBuriedPoint] submitWithUrl:deviceStr dic:deviceDic successBlock:^(id  _Nonnull response) {
//            NSLog(@"%@",response);
//        } failureBlock:^(NSError * _Nonnull error) {
//        }];
//        
//    }else{
//        //普通按摩
//        
//        NSString *deviceStr = [NSString stringWithFormat:@"%@mchair/effect",DATAURL_PRE];
//        NSString *effectId = [GlobalCommon getChairEffecttIDWithString:self.titleStr];
//        NSDictionary *deviceDic = @{ @"body":@{
//                                             @"id":@"",
//                                             @"memberChild":memberId,
//                                             @"memberId":userSign,
//                                             @"effectId":effectId,
//                                             @"blackHeat":@"0",
//                                             @"soleRoller":@"0",
//                                             @"qinangStrength":@"1-2",
//                                             @"massageStrength":@"1-2",
//                                             @"zeroG":@"1",
//                                             @"takeIn":@"1",
//                                             @"spreadOn":@"1",
//                                             @"daobei":@"1",
//                                             @"taitui":@"1",
//                                             @"shengbei":@"1",
//                                             @"jiangtui":@"1",
//                                             @"startDate":self.startTimeStr,
//                                             @"endDate":self.endTimeStr}
//                                     };
//        
//        [[BuredPoint sharedYHBuriedPoint] submitWithUrl:deviceStr dic:deviceDic successBlock:^(id  _Nonnull response) {
//            NSLog(@"%@",response);
//        } failureBlock:^(NSError * _Nonnull error) {
//        }];
//    }
//    
//}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    return YES;
}

@end
