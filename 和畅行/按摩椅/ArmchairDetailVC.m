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

typedef enum : NSInteger {
    PointDirectTop,
    PointDirectLevel,
    PointDirectBottom,
} PointDirect;

typedef enum : NSInteger {
    SlideDirectBottomToTop,
    SlideDirectTopToBottom,
} SlideDirect;

@interface ArmchairDetailVC ()<HCYSliderDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate,CommandButtonDelegate>
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

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, strong) OGA530Subscribe *ogaSubscribe;

@end

@implementation ArmchairDetailVC
@synthesize subLayer;

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = self.titleStr;
    
    [self initUI];
    
    [self initTopView];
    
    pointDirect = PointDirectLevel;
    slideDirect = SlideDirectTopToBottom;
    panViewMaxY = ScreenHeight-100;
    panViewMinY = ScreenHeight-275+90;
    
    //按摩椅添加订阅
    self.ogaSubscribe = [[OGA530Subscribe alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.ogaSubscribe setRespondBlock:^(OGA530Respond * _Nonnull respond) {

        [weakSelf didUpdateValueForChair:respond];
    }];
    [[OGA530BluetoothManager shareInstance] addSubscribe:self.ogaSubscribe];

}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[OGA530BluetoothManager shareInstance] removeSubscribe:self.ogaSubscribe];
}

# pragma mark - 按摩椅数据回调
- (void)didUpdateValueForChair:(OGA530Respond *)respond {
    
    //开关
    self.rightBtn.selected = respond.powerOn;
    self.playBtn.selected = respond.pause;
    
    
    //背部加热
    CommandButtonView *comandView300 = (CommandButtonView *)[self.middleView viewWithTag:300];
    [comandView300 setButtonViewSelect:respond.executeWarmBack];
    //脚底滚轮
    CommandButtonView *comandView301 = (CommandButtonView *)[self.middleView viewWithTag:301];
    [comandView301 setButtonViewSelect:respond.executeRollFoot];
    
    //时间
    NSString *minute = [NSString stringWithFormat:@"%d", respond.timeMinute];
    NSString *sec = @"";
    if(respond.timeSecond<10){
         sec = [NSString stringWithFormat:@"0%d", respond.timeSecond];
    }else{
         sec = [NSString stringWithFormat:@"%d", respond.timeSecond];
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@:%@",minute,sec];
    
    
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
    CommandButtonView *gaoji201 = (CommandButtonView *)[self.advancedView viewWithTag:200];
    [gaoji201 setButtonViewSelect:respond.executeWaistBackRoll];
    CommandButtonView *gaoji202 = (CommandButtonView *)[self.advancedView viewWithTag:200];
    [gaoji202 setButtonViewSelect:respond.statusKneeMassage];
    CommandButtonView *gaoji203 = (CommandButtonView *)[self.advancedView viewWithTag:200];
    [gaoji203 setButtonViewSelect:respond.executeLegWarm];
    CommandButtonView *gaoji204 = (CommandButtonView *)[self.advancedView viewWithTag:200];
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
}

# pragma mark - CommandButtonDelegate
- (void)commandActionWithModel:(ArmChairModel *)model
{
    
    [[OGA530BluetoothManager shareInstance] sendCommand:model.command success:nil];
}


- (void)initUI
{
    if (!self.bgScrollView){
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight-100)];
        self.bgScrollView.showsVerticalScrollIndicator = NO;
        
        self.bgScrollView.backgroundColor = [UIColor colorWithRed:239/255.0 green:243/255.0 blue:246/255.0 alpha:1.0];
        self.bgScrollView.bounces = YES;
        self.bgScrollView.delegate = self;
        self.bgScrollView.contentSize = CGSizeMake(1, ScreenHeight-kNavBarHeight-100);
        [self.view addSubview:self.bgScrollView];
    }
    
    //高级,专属里面没有收藏按钮
    NSArray *zhuanshuArr = [self loadDataPlistWithStr:@"专属"];
    BOOL isZhuanshu = NO;
    for(ArmChairModel *model in zhuanshuArr){
        if([self.armchairModel.name isEqualToString:model.name]){
            isZhuanshu = YES;
            break;
        }
    }
    NSLog(@"yyyy:%d",[zhuanshuArr containsObject:self.armchairModel]);
    if(!self.isAdvanced && !isZhuanshu){
        UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        likeBtn.frame = CGRectMake(self.rightBtn.left-42, 2+kStatusBarHeight, 37, 40);
        [likeBtn setImage:[UIImage imageNamed:@"按摩收藏_未"] forState:UIControlStateNormal];
        [likeBtn setImage:[UIImage imageNamed:@"按摩收藏_已"] forState:UIControlStateSelected];
        BOOL isSelect = [[CacheManager sharedCacheManager] selectArmchairModel:self.armchairModel];
        likeBtn.selected = isSelect;
        [likeBtn addTarget:self action:@selector(likeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:likeBtn];
    }
    
}

# pragma mark - 头部视图
- (void)initTopView
{

   // self.view.backgroundColor = [UIColor whiteColor];
    //头部视图
    self.upsideView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 180)];
    [self.bgScrollView addSubview:self.upsideView];
    
    
    InsidelayerView *layerView = [[InsidelayerView alloc] initWithFrame:CGRectMake(25, 34, 80, 90)];
    [layerView insertSublayerFromeView:self.upsideView];
    [self.upsideView addSubview:layerView];
    
    
    UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-142)/2.0, 25, 142, 134)];
    animationView.tag = 1024;
    //animationView.backgroundColor = [UIColor orangeColor];
    //NSArray *timeArr = @[@3.0,@2.8,@2.6,@2.4,@2.2];
    NSArray *timeArr = @[@3.0,@3.0,@3.0,@3.0,@3.0];
    for(NSInteger i = 5;i>0;i--){
        UIImageView *animationImageV = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"播放动画%ld",i]];
        CGSize size = image.size;
        animationImageV.size = size;
        animationImageV.center = CGPointMake(animationView.width/2.0, animationView.height/2.0);
        animationImageV.image = image;
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
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((animationView.width-81)/2.0, (animationView.height-35)/2.0-7, 81, 35)];
    self.timeLabel.font = [UIFont fontWithName:@"PingFang SC" size:30];
    self.timeLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
    self.timeLabel.text = @"15:00";
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    [animationView addSubview:self.timeLabel];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playBtn.frame = CGRectMake((animationView.width-20)/2.0, self.timeLabel.bottom+3, 20, 20);
    [self.playBtn setImage:[UIImage imageNamed:@"按摩_播放"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"按摩_暂停"] forState:UIControlStateSelected];
    [self.playBtn addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [animationView addSubview:self.playBtn];
    
    [self.upsideView addSubview:animationView];
    
    if(self.isAdvanced){
        [self createAdvancedView];
        
    }
    
    [self createMiddleView];
    
    [self createQiyaView];
    
    [self createPostBottomView];
    
}

# pragma mark - 高级按摩手法
- (void)createAdvancedView
{
    self.advancedView = [[UIView alloc] initWithFrame:CGRectMake(0, self.upsideView.bottom+10, ScreenWidth, 200+30)];
    [self.bgScrollView addSubview:self.advancedView];
    
    InsidelayerView *layerView = [[InsidelayerView alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, self.advancedView.height)];
    [layerView insertSublayerFromeView:self.advancedView];
    
    NSArray *commandArr1 = [self loadDataPlistWithStr:@"基础"];
    NSArray *commandArr2 = [self loadDataPlistWithStr:@"特殊"];
    
    CGFloat btnWidth = 58.0;
    CGFloat btnHeight = 83.0;
    
    CGFloat buttonMargin = (layerView.width-btnWidth*5)/6.0;
    
    UILabel *jichuLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin+15, 5, 81, 30)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"按摩手法"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    jichuLabel.attributedText = string;
    jichuLabel.textAlignment = NSTextAlignmentLeft;
    [self.advancedView addSubview:jichuLabel];
    
    UILabel *teshuLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin+15, 45+btnHeight, 81, 30)];
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"特殊"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    teshuLabel.attributedText = string2;
    teshuLabel.textAlignment = NSTextAlignmentLeft;
   // [self.advancedView addSubview:teshuLabel];
    
    for(NSInteger i=0;i<commandArr1.count;i++){
        
        ArmChairModel *model = [commandArr1 objectAtIndex:i];
        
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin+btnWidth)*i+buttonMargin+15, 10+28, btnWidth, btnHeight) withModel:model];
        commandView.tag = 100+i;
        commandView.delegate = self;
        [self.advancedView addSubview:commandView];
    }
    for(NSInteger i=0;i<commandArr2.count;i++){
        
        ArmChairModel *model = [commandArr2 objectAtIndex:i];
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin+btnWidth)*i+buttonMargin+15, 20+btnHeight+28, btnWidth, btnHeight) withModel:model];
        commandView.tag = 200+i;
        commandView.delegate = self;
        [self.advancedView addSubview:commandView];
    }
}

# pragma mark - 中间视图
- (void)createMiddleView
{
    //中间视图
    self.middleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.isAdvanced ? self.advancedView.bottom+10 : self.upsideView.bottom+10, ScreenWidth, 190)];
    [self.bgScrollView addSubview:self.middleView];
    
    InsidelayerView *layerView2 = [[InsidelayerView alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, self.middleView.height)];
    [layerView2 insertSublayerFromeView:self.middleView];
    
    CGFloat buttonMargin = (ScreenWidth-30-53*2)/3.0;
    NSArray *commandArr = @[k530Command_BackWarm,k530Command_FootRoll];
    NSArray *arr = [self loadDataPlistWithStr:@"背部脚底"];
    for(NSUInteger i =0;i<arr.count;i++){
        ArmChairModel *model = [arr objectAtIndex:i];
        model.command = [commandArr objectAtIndex:i];
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake(buttonMargin+15+(70+buttonMargin)*i, 15, 70, 83) withModel:model];
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
    
    CGFloat commandBottom = 15+83;
    
    NSArray *titleArr = @[@"按摩强度",@"气囊强度"];
    for(NSInteger i = 0; i<titleArr.count;i++){
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(25,commandBottom+10+(23+10)*i,70,23);
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[titleArr objectAtIndex:i] attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
        
        label.attributedText = string;
        label.textAlignment = NSTextAlignmentCenter;
        [self.middleView addSubview:label];
        
        HCYSlider *slider1 = [[HCYSlider alloc]initWithFrame:CGRectMake(label.right+5, label.top+4, layerView2.right-10-label.right-10, 15)];
        slider1.currentValueColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
        slider1.maxValue = 5;
        slider1.delegate = self;
        [self.middleView addSubview:slider1];
    }
}

#pragma mark - 气压视图
- (void)createQiyaView
{
    
    //气压视图
    self.qiyaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.middleView.bottom+10, ScreenWidth, 145)];
    [self.bgScrollView addSubview:self.qiyaView];
    
    [self.bgScrollView setContentSize:CGSizeMake(1, self.qiyaView.bottom+20)];
    
    InsidelayerView *layerView = [[InsidelayerView alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth-30, self.qiyaView.height)];
    [layerView insertSublayerFromeView:self.qiyaView];
    
    CGFloat buttonMargin = (layerView.width-53*5)/6.0;
    
    UILabel *qiyaLabel = [[UILabel alloc] initWithFrame:CGRectMake(buttonMargin+15, 10, 81, 35)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"气压"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    qiyaLabel.attributedText = string;
    qiyaLabel.textAlignment = NSTextAlignmentLeft;
    [self.qiyaView addSubview:qiyaLabel];
    
    
    
    //NSArray *nameArr = @[@"气压_全身",@"气压_肩颈",@"气压_手臂",@"气压_腰臂",@"气压_小腿"];
    
    NSArray *qiyaModelArr = [self loadDataPlistWithStr:@"气压"];
    
    for(NSInteger i = 0; i<qiyaModelArr.count;i++){
        ArmChairModel *model = [qiyaModelArr objectAtIndex:i];
        CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin+53)*i+buttonMargin+15, qiyaLabel.bottom, 53, 83) withModel:model];
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
    
    
    UIView *layerView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-90, ScreenWidth, 20)];
    layerView.backgroundColor = [UIColor orangeColor];
  //  [self.view addSubview:layerView];
    
    InsidelayerView *insidelayerView = [[InsidelayerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    [insidelayerView insertSublayerFromeView:layerView];
    [layerView addSubview:insidelayerView];
    
    self.postBottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-100, ScreenWidth, 275-90)];
    self.postBottomView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2.0-6, 5, 12, 5)];
    imageV.image = [UIImage imageNamed:@"气压_上拉"];
    imageV.tag = 2019;
    [self.postBottomView addSubview:imageV];
    
    [self.view addSubview:self.postBottomView];
    
    CAShapeLayer *layer = [self createMaskLayerWithView:self.postBottomView];
    self.postBottomView.layer.mask = layer;
    
//    self.postBottomView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    self.postBottomView.layer.shadowOffset = CGSizeMake(0,1);
//    self.postBottomView.layer.shadowOpacity = 0.4;
//    self.postBottomView.layer.shadowRadius = 4;
    
    NSArray *nameArr = [self loadDataPlistWithStr:@"姿势"];
    CGFloat buttonMargin = (self.postBottomView.width-56*3)/4.0;
    CGFloat buttonMargin2 = (self.postBottomView.width-56*4)/5.0;
    for(NSInteger i=0;i<nameArr.count;i++){
        
        ArmChairModel  *model = [nameArr objectAtIndex:i];
        if(i<3){
            CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin+56)*i+buttonMargin, 15, 56, 58) withModel:model];
            commandView.tag = 500+i;
            commandView.delegate = self;
            [self.postBottomView addSubview:commandView];
        }else{
            
            NSInteger j = (i-3)/4;
            NSInteger k = (i-3)%4;
            
            CommandButtonView *commandView = [[CommandButtonView alloc] initWithFrame:CGRectMake((buttonMargin2+56)*k+buttonMargin2, 90+15+90*j, 56, 58) withModel:model];
            commandView.delegate = self;
            commandView.tag = 500+i;
            [self.postBottomView addSubview:commandView];
        }
    }
    
    
    UIPanGestureRecognizer *panpress = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panScroll:)];
    panpress.delegate = self;
    [self.postBottomView addGestureRecognizer:panpress];
    
    NSLog(@"****%f",self.postBottomView.frame.origin.y);
    
}

# pragma mark - 手势收藏按钮
- (void)likeBtnAction:(UIButton *)button
{
    NSLog(@"name:%@",self.armchairModel.name);
    
    button.selected = !button.selected;
    if(button.selected){
        NSArray *arr = [[CacheManager sharedCacheManager] getArmchairModel];
        if(arr.count>0){
            [[CacheManager sharedCacheManager] insertArmchairModel:self.armchairModel];
        }
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
    NSLog(@"yyyyyyy:%f",scrollView.contentOffset.y);
    if(scrollView.contentOffset.y > 180){
        self.navTitleLabel.text = @"15:00";
    }else{
        self.navTitleLabel.text = @"高级按摩";
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
    __weak typeof(self) weakSelf = self;
    [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_Pause success:^(BOOL success) {
        if (success) {
            weakSelf.playBtn.selected = !weakSelf.playBtn.selected;
            [weakSelf layerAnimationWithPause:weakSelf.playBtn.selected];
        }
    }];
    
}

- (void)layerAnimationWithPause:(BOOL )select
{
    UIView *animationView = [self.upsideView viewWithTag:1024];
    CALayer *layer = animationView.layer;
    
    if(select){
        CFTimeInterval pausedTime = [layer
                                     convertTime:CACurrentMediaTime() fromLayer:nil];
        layer.speed = 0.0;
        layer.timeOffset = pausedTime;
    }else{
        //继续layer上面的动画
        CFTimeInterval pausedTime = [layer timeOffset];
        layer.speed = 1.0;
        layer.timeOffset = 0.0;
        layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [layer
                                         convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        layer.beginTime = timeSincePause;
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
    
    CGFloat topMargin = 10;
    
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
//    layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    layer.shadowOffset = CGSizeMake(0,1);
//    layer.shadowOpacity = 0.4;
//    layer.shadowRadius = 4;
    
    layer.path = path.CGPath;
    return layer;
}

# pragma mark - HCYSliderDelegate
- (void)HCYSliderButtonAction:(NSString *)str
{
    
}

@end
