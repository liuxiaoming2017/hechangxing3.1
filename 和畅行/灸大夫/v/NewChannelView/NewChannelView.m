//
//  NewChannelView.m
//  MoxaYS
//
//  Created by xuzengjun on 16/10/19.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import "NewChannelView.h"
//#import "TYWaveProgressView.h"
//#import "BtteryView.h"
#import "UIImage+Util.h"
#import "BatteryView.h"
#import <moxibustion/BlueToothCommon.h>


@interface NewChannelView()
//@property (retain,nonatomic) TYWaveProgressView *WaveProgressView;
//@property (retain,nonatomic) BtteryView *btteryView;
@property (retain,nonatomic) UIView     *mMoxaHead;
@property (retain,nonatomic) UIImageView   *foucsePoint;
@property (retain,nonatomic) BatteryView   *electricityView;
@property (retain,nonatomic) UILabel     *tempLable;
@property (retain,nonatomic) UILabel     *channalLable;
@property (retain,nonatomic) UILabel     *tiemLable;
@property (retain,nonatomic) UIButton    *swicthBtn;
@property (assign,nonatomic) int channalnum;
@property (assign,nonatomic) BOOL showWarnning;

@property (assign, nonatomic) BOOL moveLock;
@property (assign, nonatomic) BOOL moveFlag;
@property (assign, nonatomic) BOOL intersectFlag;
@property (assign, nonatomic) BOOL isInScrollview;
@property (assign, nonatomic) CGPoint originalPosition;
@property (assign, nonatomic) CGPoint originalCenterPosition;

@end

@implementation NewChannelView
@synthesize mGestureDelegate;

@synthesize states;
@synthesize wendu;
@synthesize shiJian;
@synthesize electricity;
@synthesize mochinUUid;
//@synthesize IsWaveing;
@synthesize foucsePoint;
@synthesize electricityView;
@synthesize tempLable;
@synthesize channalLable;
@synthesize tiemLable;
@synthesize swicthBtn;
@synthesize mHasFirstWork;
@synthesize channelmode;
@synthesize channalnum;
//@synthesize mHasReadChannelData;
@synthesize tempArry;
@synthesize showWarnning;

//@synthesize referView;
//@synthesize parentView;
//@synthesize moveLock;
//@synthesize moveFlag;
//@synthesize intersectFlag;
//@synthesize isInScrollview;
//@synthesize originalPosition;
//@synthesize originalCenterPosition;

- (NewChannelView *)instanceWithFrame:(CGRect)frame channelNo:(int)no Mode:(int)mode{
    channelmode = mode;
    channalnum = no;
    
//    isInScrollview = YES;
//    moveFlag = NO;
//    intersectFlag = NO;
    
    NewChannelView *view = [self initWithFrame:frame];
    view.tag = no;
    mHasFirstWork = no;
//    mHasReadChannelData = no;
    tempArry = [[NSMutableArray alloc] init];
    showWarnning = NO;
    return view;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat x ,y ,width,height;
        CGFloat waveWidth;
        width = frame.size.width;
        height = frame.size.height;
        if(width > height){
            waveWidth = height - 10;
        }else{
            waveWidth = width - 10;
        }
        x = (frame.size.width - waveWidth)/2;
        y = (frame.size.height - waveWidth)/2;
        _mMoxaHead = [[UIView alloc] initWithFrame:CGRectMake(x, y, waveWidth, waveWidth)];
        if (channelmode == MODE_I9){
            [self setBgroundColor:@"i9MoxaHead" View_:_mMoxaHead];
        }else{
            [self setBgroundColor:@"68MoxaHead" View_:_mMoxaHead];
        }
        channalLable = [[UILabel alloc] initWithFrame:CGRectMake((waveWidth - waveWidth/3)/2, 10, waveWidth/3, waveWidth/2 - 10)];
        if(iPhone4 || iPhone5){
             channalLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:40.0];
        }else{
             channalLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:55.0];
        }
//        channalLable.font = [UIFont systemFontOfSize:40.0];
        channalLable.textAlignment = NSTextAlignmentCenter;
        if(channelmode == MODE_68){
            channalLable.text = [NSString stringWithFormat:@"%d",channalnum+1];
        }
        channalLable.textColor = [UIColor grayColor];
        [_mMoxaHead addSubview:channalLable];
        tiemLable = [[UILabel alloc] initWithFrame:CGRectMake((waveWidth - waveWidth/4*3)/2, waveWidth/2, waveWidth/4*3, waveWidth/2 - 10)];
        tiemLable.textAlignment = NSTextAlignmentCenter;
        tiemLable.textColor = [UIColor grayColor];
        if(iPhone4 || iPhone5){
            tiemLable.font = [UIFont systemFontOfSize:15.0];
        }else{
            tiemLable.font = [UIFont systemFontOfSize:18.0];
        }
      
        tiemLable.text = ModuleZW(@"未工作");
        [_mMoxaHead addSubview:tiemLable];
        [self addSubview:_mMoxaHead];
       
        [self setBackgroundColor:[UIColor whiteColor]];
        UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(SingleTap:)];
        [singleTapGesture setNumberOfTapsRequired:1];
        [self addGestureRecognizer:singleTapGesture];
        
        UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc]
                                                        initWithTarget:self action:@selector(handleLongPress:)];
        longPressReger.minimumPressDuration = 0.7;
        [self addGestureRecognizer:longPressReger];
        
        foucsePoint = [[UIImageView alloc] initWithFrame:CGRectMake(height/25,height - 23, 20, 20)];
        foucsePoint.image = [UIImage imageNamed:@"foucsepoint@2x"];
        [self addSubview:foucsePoint];
        foucsePoint.hidden = YES;
        
//        if(iPhone4 || iPhone5){
//            tempLable = [[UILabel alloc] initWithFrame:CGRectMake(width - 2 - waveWidth/5*2,2, waveWidth/5*2, waveWidth/6)];
//        }else{
//            if(channelmode == MODE_68){
//                tempLable = [[UILabel alloc] initWithFrame:CGRectMake(width - 2 - waveWidth/2,2, waveWidth/2, waveWidth/6)];
//            }else{
//                tempLable = [[UILabel alloc] initWithFrame:CGRectMake(width - 2 - waveWidth/3,2, waveWidth/3, waveWidth/6)];
//            }
//        }
        
        if(iPhone4 || iPhone5){
            tempLable = [[UILabel alloc] initWithFrame:CGRectMake(width/30,2, waveWidth/5*2, waveWidth/6)];
        }else{
            if(channelmode == MODE_68){
                tempLable = [[UILabel alloc] initWithFrame:CGRectMake(width/30,2, waveWidth/2, waveWidth/6)];
            }else{
                tempLable = [[UILabel alloc] initWithFrame:CGRectMake(width/30,2, waveWidth/3, waveWidth/6)];
            }
        }
        
//        [tempLable setBackgroundColor:[UIColor blueColor]];
        tempLable.textAlignment = NSTextAlignmentLeft;
        tempLable.textColor = [UIColor grayColor];
        if(iPhone4 || iPhone5){
            tempLable.font = [UIFont systemFontOfSize:15.0];
        }else{
            tempLable.font = [UIFont systemFontOfSize:18.0];
        }
        [self addSubview:tempLable];
        
        if (channelmode == MODE_I9) {
//            electricityView = [[BatteryView alloc] initWithFrame:CGRectMake(height/25,height/25, 25, 12)];
            electricityView = [[BatteryView alloc] initWithFrame:CGRectMake(width - 25 - 4,height/25, 25, 12)];
            [electricityView setBackgroundColor:[UIColor whiteColor]];
//            electricityView.image = [UIImage imageNamed:@"ic_electricity_02_green"];
            [self addSubview:electricityView];
            
            swicthBtn = [[UIButton alloc] initWithFrame:CGRectMake(width - 25 - 4,height - 28, 25, 25)];
            [swicthBtn setImage:[UIImage imageNamed:@"switch_ongrey"] forState:UIControlStateNormal];
            [swicthBtn.imageView.layer addAnimation:[self AlphaLight:1.0] forKey:@"close"];
            [swicthBtn addTarget:self action:@selector(swicthBtnOnclink:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:swicthBtn];
        }
        _waitSetwendu = -1;
        states = CHANNEL_NOLINK;
    }
    return self;
}

-(void)setBgroundColor:(NSString *)name View_:(UIView *)v{
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    v.layer.contents = (id)image.CGImage;
}



//-(TYWaveProgressView *)CreateWaveView:(CGRect)frame{
//    CGFloat offestx = frame.size.height/10;
//    TYWaveProgressView *waveProgressView = [[TYWaveProgressView alloc]initWithFrame:frame];
//    waveProgressView.waveViewMargin = UIEdgeInsetsMake(offestx, offestx, offestx, offestx);
//    waveProgressView.backgroundImageView.image = [UIImage imageNamed:@"bg"];
//    waveProgressView.numberLabel.text = @"";
////    waveProgressView.numberLabel.font = [UIFont boldSystemFontOfSize:70];
////    waveProgressView.numberLabel.textColor = [UIColor whiteColor];
//    //    waveProgressView.unitLabel.text = @"%";
//    //    waveProgressView.unitLabel.font = [UIFont boldSystemFontOfSize:20];
//    //    waveProgressView.unitLabel.textColor = [UIColor whiteColor];
////    waveProgressView.explainLabel.text = @"分钟";
////    waveProgressView.explainLabel.font = [UIFont systemFontOfSize:20];
////    waveProgressView.explainLabel.textColor = [UIColor whiteColor];
//    waveProgressView.percent = 0.00;
//    [waveProgressView stopWave];
//    return waveProgressView;
//}

-(CABasicAnimation *) AlphaLight:(float)time
{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    return animation;
}

//-(void)StartWave{
////    NSLog(@"-StartWave--");
//    [_WaveProgressView setIsWaveing:YES];
//    [_WaveProgressView startWave];
//}
//
//-(void)StopWave{
////    NSLog(@"-StopWave--");
//    [_WaveProgressView setIsWaveing:NO];
//    [_WaveProgressView stopWave];
//}

//-(void)setNeedStop:(BOOL)tag{
//    [_WaveProgressView setNeedStop:tag];
//}


-(void)ShowWarnning{
    showWarnning = YES;
    if (channelmode == MODE_I9){
        if(wendu >= 45 && wendu < 48){
            [self setBgroundColor:@"i9MoxaHead_yellow" View_:_mMoxaHead];
        }else if(wendu >= 48){
            [self setBgroundColor:@"i9MoxaHead_red" View_:_mMoxaHead];
        }
    }else{
        if(wendu >= 45 && wendu < 48){
            [self setBgroundColor:@"68MoxaHead_yellow" View_:_mMoxaHead];
        }else if(wendu >= 48){
            [self setBgroundColor:@"68MoxaHead_red" View_:_mMoxaHead];
        }
    }
//    _WaveProgressView.backgroundImageView.image = [UIImage imageNamed:@"warnBg@2x.png"];
//    [_WaveProgressView.backgroundImageView.layer addAnimation:[self AlphaLight:1.0] forKey:@"warn"];
}

-(void)StopWarnning{
    showWarnning = NO;
    if (channelmode == MODE_I9){
        [self setBgroundColor:@"i9MoxaHead" View_:_mMoxaHead];
    }else{
        [self setBgroundColor:@"68MoxaHead" View_:_mMoxaHead];
    }
//    [_WaveProgressView.backgroundImageView.layer removeAnimationForKey:@"warn"];
//    _WaveProgressView.backgroundImageView.image = [UIImage imageNamed:@"bg"];
}

-(void)showFocse{
    foucsePoint.hidden = NO;
}

-(void)hideFocse{
    foucsePoint.hidden = YES;
}

//操作流程的方法
- (int)getWenDu {
    return wendu;
}

- (int)getShiJian {
    return shiJian;
}

- (int)getStates {
    return states;
}


- (void)setStates:(int)s{
    states = s;
    if(states == CHANNEL_NOLINK)
    {
        tiemLable.text = @"未连接";
        if(showWarnning == YES){
            [self StopWarnning];
        }
        [swicthBtn setImage:[UIImage imageNamed:@"switch_ongrey"] forState:UIControlStateNormal];
        [swicthBtn.imageView.layer addAnimation:[self AlphaLight:1.0] forKey:@"close"];
    }
    else if(states == CHANNEL_STOP)
    {
        tiemLable.text = ModuleZW(@"未工作");
        if(showWarnning == YES){
            [self StopWarnning];
        }
        if (channelmode == MODE_I9){
            [self setBgroundColor:@"i9MoxaHead" View_:_mMoxaHead];
        }else{
            [self setBgroundColor:@"68MoxaHead" View_:_mMoxaHead];
        }
        [swicthBtn setImage:[UIImage imageNamed:@"switch_ongrey"] forState:UIControlStateNormal];
        [swicthBtn.imageView.layer addAnimation:[self AlphaLight:1.0] forKey:@"close"];
//        [self updateShiJian:shiJian];
    }
    else if(states == CHANNEL_WORK)
    {
        [self updateShiJian:shiJian];
        if(wendu < 45){
            [self StopWarnning];
            if (channelmode == MODE_I9){
                [self setBgroundColor:@"i9MoxaHeadblue" View_:_mMoxaHead];
            }
        }else{
            [self ShowWarnning];
        }
        [swicthBtn.imageView.layer removeAnimationForKey:@"close"];
        [swicthBtn setImage:[UIImage imageNamed:@"switch_onblue"] forState:UIControlStateNormal];
    }else if(states == CHANNEL_LINKING){
        tiemLable.text = ModuleZW(@"连接中");
        if(showWarnning == YES){
            [self StopWarnning];
        }
        [swicthBtn setImage:[UIImage imageNamed:@"switch_ongrey"] forState:UIControlStateNormal];
        [swicthBtn.imageView.layer addAnimation:[self AlphaLight:1.0] forKey:@"close"];
    }
}

- (void)updateWenDu:(int)du {
    if(du < 38){
        wendu = 38;
    }else if(du > 56){
        wendu = 56;
    }else{
        wendu = du;
    }
    tempLable.text = [NSString stringWithFormat:@"%d℃",wendu];
    if(wendu < 45){
        tempLable.textColor = [UIColor grayColor];
    }else if(wendu >= 45 && wendu < 48){
        tempLable.textColor = [UIColor colorWithRed:236.0/255.0 green:169.0/255.0 blue:57.0/255.0 alpha:1.0];
    }else if(wendu >= 48){
        tempLable.textColor = [UIColor colorWithRed:237.0/255.0 green:100.0/255.0 blue:104.0/255.0 alpha:1.0];
    }
}

- (void)updateShiJian:(int)sec{
    shiJian = sec;
    int m = sec/60;
    int s = sec%60;
    tiemLable.text = [NSString stringWithFormat:@"%02d:%02d",m,s];
//    if(_SettedTime != 0){

//        CGFloat t = (CGFloat)sec/_SettedTime;
////        NSLog(@"--sec = %d   _SettedTime = %d -updateShiJian--t =%f  _WaveProgressView.percent = %f",sec,_SettedTime,t,_WaveProgressView.percent);
//        if(_WaveProgressView.percent == t && [_WaveProgressView getIsHeighest]){
//            [self StopWave];
//        }else{
//            _WaveProgressView.percent = t;
//            if([_WaveProgressView getIsWaveing] == YES){//&& [_WaveProgressView getNeedStop] == NO
//                [_WaveProgressView startWave];
//            }
//        }
//    }
}

-(void)setChannelNum:(int)num{
    self.tag = num;
    channalLable.text = [NSString stringWithFormat:@"%d",num+1];
//    [_btteryView setChannelNum:num];
}

- (void)updateElectricity:(int)electry{
    [self setBattery:electry];
}

-(void)setBattery:(int)electry{
    if(electry > 0){
//        if(electry <= 20){
//            [electricityView setImage:[UIImage imageNamed:@"ic_electricity_red"]];
//        }else if(electry > 20 && electry <= 40){
//            [electricityView setImage:[UIImage imageNamed:@"ic_electricity_yellow"]];
//        }else if(electry > 40 && electry <= 60){
//            [electricityView setImage:[UIImage imageNamed:@"ic_electricity_cyan"]];
//        }else if(electry > 60 && electry <= 80){
//            [electricityView setImage:[UIImage imageNamed:@"ic_electricity_01_green"]];
//        }else if(electry > 80){
//            [electricityView setImage:[UIImage imageNamed:@"ic_electricity_02_green"]];
//        }
        [electricityView setCurrentNum:electry];
    }
}

#pragma SingleTap & LongPress
-(void)SingleTap:(UITapGestureRecognizer*)recognizer
{
//    if(foucsePoint.hidden == NO){
    if(channelmode == MODE_68){
        if(states == CHANNEL_WORK)
        {
            // 工作->停止
            states = CHANNEL_STOP;
        }
        else if(states == CHANNEL_STOP)
        {
            // 停止->工作
            states = CHANNEL_WORK;
        }
    }
//    }
    if(mGestureDelegate)
    {
        [mGestureDelegate singleClick:self];
    }
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
//    if(channelmode == MODE_68){
        NSLog(@"handleLongPress");
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
        {
            NSLog(@"longpress");
            if(states == CHANNEL_NOLINK)
                return;
            //        if(moveFlag == YES)
            //            return;
            if(mGestureDelegate)
            {
                [mGestureDelegate longPress:self];
            }
        }
//    }
//    else if (channelmode == MODE_I9){
//        if(mGestureDelegate)
//        {
//            [mGestureDelegate longPress:self];
//        }
//    }
}

-(void)resetAnimation{
    [swicthBtn.imageView.layer removeAnimationForKey:@"close"];
    [swicthBtn setImage:[UIImage imageNamed:@"switch_ongrey"] forState:UIControlStateNormal];
    [swicthBtn.imageView.layer addAnimation:[self AlphaLight:1.0] forKey:@"close"];
}

-(void)swicthBtnOnclink:(UIButton *)sender{
    if(states == CHANNEL_WORK)
    {
        // 工作->停止
        states = CHANNEL_STOP;
//        [swicthBtn setImage:[UIImage imageNamed:@"switch_ongrey"] forState:UIControlStateNormal];
//        [swicthBtn.imageView.layer addAnimation:[self AlphaLight:1.0] forKey:@"close"];
    }
    else if(states == CHANNEL_STOP)
    {
        // 停止->工作
        states = CHANNEL_WORK;
//        [swicthBtn.imageView.layer removeAnimationForKey:@"close"];
//        [swicthBtn setImage:[UIImage imageNamed:@"switch_onblue"] forState:UIControlStateNormal];
    }
    if(mGestureDelegate)
    {
        [mGestureDelegate OneSwitchBtnOnclink:self];
    }
}

//#pragma mark - DRAG AND DROP
//
//-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    NSLog(@"touchesBegan");
//    intersectFlag = NO;
//    UITouch *touch = [touches anyObject];
//    NSLog(@"--touch.view.frame.size.width = %f  self.frame.size.width = %f",touch.view.frame.size.width,self.frame.size.width);
//    if (![self getLock])   // 120为小窗口的宽度（简单起见这里使用硬编码示例），用来判断触控范围;仅当取到touch的view是小窗口时，我们才响应触控
//    {
//        [self setLock];
//        isInScrollview = YES;
//        originalCenterPosition = self.center;
//        [parentView bringSubviewToFront:self];
//        originalPosition = [touch locationInView:self];
//        NSLog(@"--touchesBegan-originalPosition = %@",NSStringFromCGPoint(originalPosition));
//    }
//    else
//    {
//        isInScrollview = NO;
//    }
//    
//    [super touchesBegan:touches withEvent:event];
//}
//
//
//-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    if (!isInScrollview)    // 仅当取到touch的view是小窗口时，我们才响应触控，否则直接return
//    {
//        return;
//    }
//    if(states == CHANNEL_NOLINK)
//        return;
//    
//    UITouch *touch = [touches anyObject];
//    CGPoint currentPosition = [touch locationInView:self];
//    NSLog(@"--touchesMoved-currentPosition = %@  self.center = %@",NSStringFromCGPoint(currentPosition),NSStringFromCGPoint(self.center));
//    //偏移量
//    float offsetX = currentPosition.x - originalPosition.x;
//    float offsetY = currentPosition.y - originalPosition.y;
//    NSLog(@"---offsetX = %f,offsetY = %f",offsetX,offsetY);
//    if(offsetX != 0 || offsetY != 0)// || offsetX < -0 || offsetY < -0)
//        moveFlag = YES;
//    //移动后的中心坐标
//    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
//    
//    //x轴左右极限坐标
//    if (self.center.x > (referView.frame.size.width-self.frame.size.width/2))
//    {
//        CGFloat x = referView.frame.size.width-self.frame.size.width/2;
//        self.center = CGPointMake(x, self.center.y);
//    }
//    else if (self.center.x < self.frame.size.width/2)
//    {
//        CGFloat x = self.frame.size.width/2;
//        self.center = CGPointMake(x, self.center.y);
//    }
//    
//    //y轴上下极限坐标
//    CGFloat dy = 0;
//    if (self.center.y > (dy+referView.frame.size.height-self.frame.size.height/2))
//    {
//        CGFloat x = self.center.x;
//        CGFloat y = dy+referView.frame.size.height-self.frame.size.height/2;
//        self.center = CGPointMake(x, y);
//    }
//    else if (self.center.y <= dy+self.frame.size.height/2)
//    {
//        CGFloat x = self.center.x;
//        CGFloat y = dy+self.frame.size.height/2;
//        self.center = CGPointMake(x, y);
//    }
//    if([mGestureDelegate isTrackIntersect:self])
//    {
//        NSLog(@"intersect");
//        if(intersectFlag != YES)
//        {
//            intersectFlag = YES;
////            double delayInSeconds = 0.7;
////            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
////            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
////                // code to be executed on the main queue after delay
////                if(intersectFlag == YES)
////                    [mGestureDelegate copyTrackDatas:self];
////            });
//        }
//    }
//    else
//    {
//        intersectFlag = NO;
//    }
//}
//
//-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    NSLog(@"touchesEnded");
//    moveFlag = NO;
//    intersectFlag = NO;
//    [self clearLock];
//    if (!isInScrollview)    // 仅当取到touch的view是小窗口时，我们才响应触控，否则直接return
//    {
//        return;
//    }
//    [UIView animateWithDuration:1.0f  delay:0
//         usingSpringWithDamping:0.3 initialSpringVelocity:0.6
//                        options:UIViewAnimationOptionCurveEaseIn animations:^{
//                            //这里书写动画相关代码
//                            self.center = originalCenterPosition;
//                        } completion:^(BOOL finished) {
//                            //动画结束后执行的代码块
//                        }];
//    [super touchesEnded:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesCancelled");
//    if (moveFlag) {
//        moveFlag = NO;
//        intersectFlag = NO;
//        [self clearLock];
//        if (!isInScrollview)    // 仅当取到touch的view是小窗口时，我们才响应触控，否则直接return
//        {
//            return;
//        }
//        [UIView animateWithDuration:1.0f  delay:0
//             usingSpringWithDamping:0.3 initialSpringVelocity:0.6
//                            options:UIViewAnimationOptionCurveEaseIn animations:^{
//                                //这里书写动画相关代码
//                                self.center = originalCenterPosition;
//                            } completion:^(BOOL finished) {
//                                //动画结束后执行的代码块
//                            }];
//        [super touchesEnded:touches withEvent:event];
//    }
//}
//
//-(BOOL)getLock
//{
//    return moveLock;
//}
//
//-(void)setLock
//{
//    moveLock = YES;
//}
//
//-(void)clearLock
//{
//    moveLock = NO;
//}
//

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
