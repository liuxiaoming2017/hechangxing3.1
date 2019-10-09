//
//  ArmchairAcheTestVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/17.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairAcheTestVC.h"
#import "ArmchairTestResultVC.h"

@interface ArmchairAcheTestVC ()

@property (nonatomic, strong) OGA530Subscribe *subscribe;

@property (nonatomic,strong) UILabel *remindLabel;

@property (nonatomic, assign) BOOL acheStatus;
@end

@implementation ArmchairAcheTestVC
@synthesize remindLabel;



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"酸疼检测";
    
    [self initUI];
    
    self.subscribe = [[OGA530Subscribe alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [self.subscribe setRespondBlock:^(OGA530Respond * _Nonnull respond) {
        
        [weakSelf valueChange:respond];
    }];
    [[OGA530BluetoothManager shareInstance] addSubscribe:self.subscribe];
    
    
    
    
    [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_MassageIntellect success:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [[OGA530BluetoothManager shareInstance] removeSubscribe:self.subscribe];
}

- (void)DidBecomeActive
{
    
    BOOL isBlueToothPoweredOn = [[OGA530BluetoothManager shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        self.rightBtn.selected = NO;
        [UserShareOnce shareOnce].ogaConnected = NO;
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)valueChange:(OGA530Respond *)respond
{
    
    self.rightBtn.selected = respond.powerOn;
    
    if(!respond.powerOn){
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    if (respond.statusAcheIng) {
        self.acheStatus = YES;
    }else if (respond.statusAcheDone) {
        
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@(0),@(0),@(0),@(0),@(0),@(0)]];
    if (respond.achePart > 0 && respond.achePart < 7) {
        [array replaceObjectAtIndex:respond.achePart - 1 withObject:@(respond.acheResult)];
    }
    
    //    1，颈部；2，肩内；3，肩外；4，肩胛骨；5，背部；6，腰部
    if (respond.statusAcheDone && self.acheStatus == YES) {
        
        self.acheStatus = NO;
        
        __weak typeof(self) weakSelf = self;
        [[OGA530BluetoothManager shareInstance] acheAndFatigue:[array[0] integerValue]
                                                    shoulderIn:[array[1] integerValue]
                                                   shoulderOut:[array[2] integerValue]
                                                 shoulderBlade:[array[3] integerValue]
                                                          back:[array[4] integerValue]
                                                         waist:[array[5] integerValue]
                                                        result:^(NSMutableArray * _Nonnull acheArray, NSInteger acheResult, NSInteger fatigueResult) {
                                                        
                    ArmchairTestResultVC *vc = [[ArmchairTestResultVC alloc] initWithacheResult:(int)acheResult withfatigueResult:(int)fatigueResult];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
    }
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    remindLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-116)/2.0, kNavBarHeight+35, 90, 35)];
    remindLabel.font = [UIFont fontWithName:@"PingFang SC" size:17];
    remindLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
    remindLabel.text = @"酸疼检测中";
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remindLabel];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(remindLabel.right, remindLabel.top+5, 50, 25)];
    topView.backgroundColor = [UIColor clearColor];
    [self setupAnimationInLayer:topView.layer withSize:topView.frame.size tintColor:[UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0]];
    [self.view addSubview:topView];
    
    CGFloat height = 251/677.0*(ScreenWidth-40);
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, remindLabel.bottom+55, ScreenWidth-40, height)];
    imageV.image = [UIImage imageNamed:@"体测图"];
    [self.view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(imageV.left,imageV.bottom+55,124.5,22.5);
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"手心握住电极片"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentLeft;
   
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(imageV.left,label.bottom+15,245,150);
    label2.numberOfLines = 0;
    [self.view addSubview:label2];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"①静坐并背靠在按摩椅上 \n②右手自然放于体侧，掌心向下 \n③左手握住金属电极 \n④保持安静 \n⑤全程需要4~5分钟左右"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    label2.attributedText = string2;
    label2.textAlignment = NSTextAlignmentLeft;
}

- (void)setupAnimationInLayer:(CALayer *)layer withSize:(CGSize)size tintColor:(UIColor *)tintColor {
    /*
    NSTimeInterval beginTime = CACurrentMediaTime();
    NSTimeInterval duration = 0.5f;
    
    CGFloat circleSize = size.width / 4.0f;
    CGFloat circlePadding = circleSize / 2.0f;
    
    CGFloat oX = (layer.bounds.size.width - circleSize * 3 - circlePadding * 2) / 2.0f;
    CGFloat oY = (layer.bounds.size.height - circleSize * 1) / 2.0f;
    
    NSArray *timeArr = @[@1.0,@1.5,@2.0];
    //NSArray *beginTime = @[@aa,aa+30,aa+60];
    for (int i = 0; i < 3; i++) {
        CALayer *circle = [CALayer layer];
        
        circle.frame = CGRectMake(oX + (circleSize + circlePadding) * (i % 3), oY, circleSize, circleSize);
        circle.backgroundColor = tintColor.CGColor;
        circle.anchorPoint = CGPointMake(0.5f, 0.5f);
        circle.opacity = 1.0f;
        circle.cornerRadius = circle.bounds.size.width / 2.0f;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
        
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat: 1.0f];
        
        
        animation.duration =[[timeArr objectAtIndex:i] doubleValue];
        animation.autoreverses = NO;
        animation.fillMode = kCAFillModeRemoved;
        animation.repeatCount = MAXFLOAT;
        
        [layer addSublayer:circle];
        [layer addAnimation:animation forKey:@"animation"];

        

    }
     */
    CAReplicatorLayer *containerLayer = [CAReplicatorLayer layer];
    containerLayer.frame = CGRectMake(0,25-10-3,size.width,size.height);
    containerLayer.masksToBounds = YES;
    containerLayer.instanceCount = 3;
    containerLayer.instanceDelay = 1.1 / containerLayer.instanceCount;
    containerLayer.instanceTransform = CATransform3DMakeTranslation(10,0,0);
    [layer addSublayer:containerLayer];
    
    CALayer *subLayer2 = [CALayer layer];
    subLayer2.backgroundColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0].CGColor;
    subLayer2.frame = CGRectMake(0, 0, 7, 7);
    subLayer2.cornerRadius = 7 / 2;
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

//- (void)messageBtnAction:(UIButton *)btn
//{
//    ArmchairTestResultVC *vc = [[ArmchairTestResultVC alloc] initWithacheResult:2 withfatigueResult:3];
//    [self.navigationController pushViewController:vc animated:YES];
//}


@end
