//
//  OGA730BAcheTestVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/11/18.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "OGA730BAcheTestVC.h"
#import "OGA730BTestResultVC.h"
#import "JWProgressView.h"

@interface OGA730BAcheTestVC ()

@property (nonatomic, strong) OGASubscribe_730B *subscribe;

@property (nonatomic,strong) UILabel *remindLabel;

@property (nonatomic, assign) BOOL acheStatus;

@property (nonatomic, strong) NSMutableArray *acheArray;

@property (nonatomic, strong) JWProgressView *progressView;

@property (nonatomic, strong) NSTimer *countdownTimer;

@end

@implementation OGA730BAcheTestVC
@synthesize remindLabel,acheArray,progressView;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"Chair Doctor";
    
    [self initUI2];
    
    self.subscribe = [[OGASubscribe_730B alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [self.subscribe setRespondBlock:^(OGARespond_730B * _Nonnull respond) {
        
        [weakSelf valueChange:respond];
    }];
    [[OGABluetoothManager_730B shareInstance] addSubscribe:self.subscribe];
    
   acheArray = [NSMutableArray arrayWithArray:@[@(2),@(2),@(1),@(2),@(2),@(2)]];
    
   
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_DetectionAche success:nil];
    
    });
    
    [self startTimer];
    
}

- (void)startTimer
{
    if (self.countdownTimer) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
    self.countdownTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(changeProgressValue) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countdownTimer forMode:NSDefaultRunLoopMode];
}

- (void)removeTimer
{
    if (self.countdownTimer) {
        [self.countdownTimer invalidate];
        self.countdownTimer = nil;
    }
}

- (void)changeProgressValue
{
    
    if(progressView.progressValue >= 0.98){
        [self removeTimer];
        return;
    }
    
    progressView.progressValue = ((int)((progressView.progressValue * 230.0f) + 1.01) % 230) / 230.0f;
    
    //progressView.contentText=[NSString stringWithFormat:@"%f",progressView.progressValue];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self removeTimer];
    
    [[OGABluetoothManager_730B shareInstance] removeSubscribe:self.subscribe];
}

- (void)DidBecomeActive
{
    
    BOOL isBlueToothPoweredOn = [[OGABluetoothManager_730B shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        self.rightBtn.selected = NO;
        [UserShareOnce shareOnce].ogaConnected = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)valueChange:(OGARespond_730B *)respond
{
    
    self.rightBtn.selected = [self chairPowerOnWithRespond:respond];;
    
    if(!self.rightBtn.selected ){
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    if (respond.acheStatus == kDetectionAcheStatusDoing) {
        self.acheStatus = YES;
    }
    // 酸痛检测结果
    if (respond.acheStatus == kDetectionAcheStatusDoing) { // 检测进行中
        
        if (respond.achePart2 >= kDetectionAchePartNeck && respond.achePart2 <= kDetectionAchePartWaist) { // 当前检测完成w部位
            
            if (respond.achePart == kDetectionAchePartOther) { // 记录检测完成的酸痛值
                
                if (respond.achePart2 == kDetectionAchePartBack) {
                    
                    [acheArray replaceObjectAtIndex:4 withObject:@(respond.ache)];
                }else if (respond.achePart2 == kDetectionAchePartWaist) {
                    
                    [acheArray replaceObjectAtIndex:5 withObject:@(respond.ache)];
                } else {
                    [acheArray replaceObjectAtIndex:respond.achePart2 - 1 withObject:@(respond.ache)];
                }
            }
        }
    }
    
    //    1，颈部；2，肩内；3，肩外；4，肩胛骨；5，背部；6，腰部
    if (respond.acheStatus == kDetectionAcheStatusDone && self.acheStatus == YES) {
        
        self.acheStatus = NO;
        
//        self.endTimeStr = [GlobalCommon getCurrentTimes];
//        NSString *timeStr = [self dateTimeDifferenceWithStartTime:self.startTimeStr endTime:self.endTimeStr];
//        [self showAlertWarmMessage:timeStr];
        
        __weak typeof(self) weakSelf = self;
        [[OGABluetoothManager_730B shareInstance] acheAndFatigue:[acheArray[0] integerValue]
                                                    shoulderIn:[acheArray[1] integerValue]
                                                   shoulderOut:[acheArray[2] integerValue]
                                                 shoulderBlade:[acheArray[3] integerValue]
                                                          back:[acheArray[4] integerValue]
                                                         waist:[acheArray[5] integerValue]
                                                        result:^(NSMutableArray * _Nonnull acheArray, NSInteger acheResult, NSInteger fatigueResult) {
                                                            
                                                            
                                                            OGA730BTestResultVC *vc = [[OGA730BTestResultVC alloc] initWithacheResult:(int)acheResult withfatigueResult:(int)fatigueResult];
                                                            [weakSelf.navigationController pushViewController:vc animated:YES];
                                                        }];
        
    }
}

- (void)initUI
{
    remindLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-Adapter(116))/2.0, kNavBarHeight+25+30, Adapter(90), Adapter(35))];
    if (ISPaid) {
        remindLabel.font = [UIFont fontWithName:@"PingFang SC" size:17*[UserShareOnce shareOnce].fontSize];
    }else{
        remindLabel.font = [UIFont fontWithName:@"PingFang SC" size:17];
    }
    
    remindLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
    remindLabel.text = @"Testing";
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remindLabel];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(remindLabel.right, remindLabel.top+Adapter(5), Adapter(50), Adapter(25))];
    topView.backgroundColor = [UIColor clearColor];
    [self setupAnimationInLayer:topView.layer withSize:topView.frame.size tintColor:[UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0]];
    [self.view addSubview:topView];
    
    CGFloat height = 251/677.0*(ScreenWidth-Adapter(40));
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(Adapter(20), remindLabel.bottom+30, ScreenWidth-Adapter(40), height)];
    imageV.image = [UIImage imageNamed:@"体测图"];
    [self.view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(Adapter(6),imageV.bottom+35,ScreenWidth-Adapter(12),Adapter(22.5));
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Hold the electrode piece with your palm"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17*[UserShareOnce shareOnce].padSizeFloat],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentLeft;
    
    
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = [UIColor clearColor];
    textView.frame = CGRectMake(label.left,label.bottom+Adapter(5),ScreenWidth-label.left*2,Adapter(200));
    [textView setEditable:NO];
    [self.view addSubview:textView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"①Sit still and lean back against the chair. \n②Put the right hand naturally on side of your body, with palm downward. \n③Hold the electrode in your left hand. \n④Keep quiet. \n⑤It takes about 3~4 minutes."attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16*[UserShareOnce shareOnce].padSizeFloat],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    textView.attributedText = string2;
    textView.textAlignment = NSTextAlignmentLeft;
}

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    
    CAReplicatorLayer *containerLayer = [CAReplicatorLayer layer];
    containerLayer.frame = CGRectMake(0,Adapter(25)-Adapter(10)-Adapter(3),size.width,size.height);
    containerLayer.masksToBounds = YES;
    containerLayer.instanceCount = 3;
    containerLayer.instanceDelay = 1.1 / containerLayer.instanceCount;
    containerLayer.instanceTransform = CATransform3DMakeTranslation(Adapter(10),0,0);
    [layer addSublayer:containerLayer];
    
    CALayer *subLayer2 = [CALayer layer];
    subLayer2.backgroundColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0].CGColor;
    subLayer2.frame = CGRectMake(0, 0, Adapter(7), Adapter(7));
    subLayer2.cornerRadius = Adapter(7) / 2;
    subLayer2.transform = CATransform3DMakeScale(0, 0, 0);
    [containerLayer addSublayer:subLayer2];
    //opacity  transform.scale
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = @(1);
    animation2.toValue = @(0.1);
    animation2.repeatCount = HUGE;
    animation2.duration = 1.1;
    [subLayer2 addAnimation:animation2 forKey:nil];
}

- (void)initUI2
{
    
    
    CGFloat width = ScreenWidth*0.5;
    if(ISPaid){
        width = ScreenWidth*0.45;
    }
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-width)/2.0, kNavBarHeight+35, width, width)];
    imageV.image = [UIImage imageNamed:@"体测图2"];
    [self.view addSubview:imageV];
    
    progressView = [[JWProgressView alloc]initWithFrame:CGRectMake(imageV.left, imageV.top, imageV.width, imageV.height)];
    [self.view addSubview:progressView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(Adapter(6),imageV.bottom+35,ScreenWidth-Adapter(12),Adapter(22.5));
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Hold the electrode piece with your palm"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17*[UserShareOnce shareOnce].padSizeFloat],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentLeft;
    
    
    UITextView *textView = [[UITextView alloc] init];
    textView.backgroundColor = [UIColor clearColor];
    textView.frame = CGRectMake(label.left,label.bottom+Adapter(5),ScreenWidth-label.left*2,Adapter(200));
    [textView setEditable:NO];
    [self.view addSubview:textView];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"①Sit still and lean back against the chair. \n②Put the right hand naturally on side of your body, with palm downward. \n③Hold the electrode in your left hand.\n④Keep quiet. \n⑤It takes about 3~4 minutes."attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16*[UserShareOnce shareOnce].padSizeFloat],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    textView.attributedText = string2;
    textView.textAlignment = NSTextAlignmentLeft;
}



//- (void)messageBtnAction:(UIButton *)btn
//{
//    OGA730BTestResultVC *vc = [[OGA730BTestResultVC alloc] initWithacheResult:3 withfatigueResult:2];
//    [self.navigationController pushViewController:vc animated:YES];
//}

-(NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startD =[date dateFromString:startTime];
    
    NSDate *endD = [date dateFromString:endTime];
    
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    
    NSTimeInterval value = end - start;
    
    int second = (int)value %60;//秒
    
    int minute = (int)value /60%60;
    
    int house = (int)value % (24 * 3600)/3600;
    
    int day = (int)value / (24 * 3600);
    
    NSString *str;
    
    if (day != 0) {
        
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
        
    }else if (day==0 && house != 0) {
        
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
        
    }else if (day== 0 && house== 0 && minute!=0) {
        
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
        
    }else{
        
        str = [NSString stringWithFormat:@"耗时%d秒",second];
        
    }
    
    return str;
    
}
@end
