//
//  i9_UISetTTViewController.m
//  MoxaYS
//
//  Created by xuzengjun on 17/6/7.
//  Copyright © 2017年 jiudaifu. All rights reserved.
//

#import "i9_UISetTTViewController.h"
#import "ASValueTrackingSlider.h"
#import "UIViewController+CWPopup.h"

@interface i9_UISetTTViewController () <ASValueTrackingSliderDelegate>
@property (weak, nonatomic) IBOutlet UILabel *moxaNumLable;
@property (weak, nonatomic) IBOutlet UILabel *tempRemindLable;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *tempSlider;
@property (weak, nonatomic) IBOutlet UIButton *reduceTemp;
@property (weak, nonatomic) IBOutlet UIButton *addTemp;
@property (weak, nonatomic) IBOutlet ASValueTrackingSlider *timeSlider;
@property (weak, nonatomic) IBOutlet UIButton *reduceTime;
@property (weak, nonatomic) IBOutlet UIButton *addTime;
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;
@property (weak, nonatomic) IBOutlet UILabel *minTemp;
@property (weak, nonatomic) IBOutlet UILabel *maxTemp;
@property (weak, nonatomic) IBOutlet UILabel *minTime;
@property (weak, nonatomic) IBOutlet UILabel *maxTime;

@property (retain, nonatomic) NewChannelView *channelView;
@property (retain, nonatomic) UIViewController *vcontrol;
@property (assign, nonatomic) BOOL didChangeData;
@end

@implementation i9_UISetTTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _didChangeData = NO;
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)initView{
    NSNumberFormatter *tempFormatter = [[NSNumberFormatter alloc] init];
    [tempFormatter setPositiveSuffix:@"°C"];
    [tempFormatter setNegativeSuffix:@"°C"];
     [_tempSlider setNumberFormatter:tempFormatter];
    _tempSlider.maximumValue = 56;
    _tempSlider.minimumValue = 38;
    _tempSlider.delegate = self;
    _tempSlider.popUpViewCornerRadius = 0.0;
    [_tempSlider setMaxFractionDigitsDisplayed:0];
    _tempSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    _tempSlider.font = [UIFont systemFontOfSize:18];
    _tempSlider.textColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:1];
    _minTemp.text = @"38°C";
    _maxTemp.text = @"56°C";
//    [_tempSlider setValue:122];
    
    NSNumberFormatter *timeFormatter = [[NSNumberFormatter alloc] init];
    [timeFormatter setPositiveSuffix:@"min"];
    [timeFormatter setNegativeSuffix:@"min"];
    [_timeSlider setNumberFormatter:timeFormatter];
    _timeSlider.maximumValue = 70;
    _timeSlider.minimumValue = 1;
    _timeSlider.delegate = self;
    _timeSlider.popUpViewCornerRadius = 0.0;
    [_timeSlider setMaxFractionDigitsDisplayed:0];
    _timeSlider.popUpViewColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:0.7];
    _timeSlider.font = [UIFont systemFontOfSize:18];
    _timeSlider.textColor = [UIColor colorWithHue:0.55 saturation:0.8 brightness:0.9 alpha:1];
    _minTime.text = @"1min";
    _maxTime.text = @"70min";
//    [_timeSlider setValue:122];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    int sjVal = roundf(_timeSlider.value) * 60;
    int wdVal = roundf(_tempSlider.value);
    [_setTTDelegate wheni9SetTT:_channelView WenDu:wdVal shiJian:sjVal allset:0 NeedWork_:_didChangeData];
}

- (IBAction)reduceTempOnclink:(id)sender {
    if(!_didChangeData){
        _didChangeData = YES;
    }
    CGFloat temp = _tempSlider.value;
    temp -= 1;
    if(temp < 38){
        temp = 38;
    }
    [_tempSlider setValue:temp];
    [self showWenduStats];
}

- (IBAction)addTempOnclink:(id)sender {
    if(!_didChangeData){
        _didChangeData = YES;
    }
    CGFloat temp = _tempSlider.value;
    temp += 1;
    if(temp > 56){
        temp = 56;
    }
    [_tempSlider setValue:temp];
    [self showWenduStats];
}

- (IBAction)reduceTimeOnclink:(id)sender {
    if(!_didChangeData){
        _didChangeData = YES;
    }
    CGFloat time = _timeSlider.value;
    time -= 1;
    if(time < 1){
        time = 1;
    }
    [_timeSlider setValue:time];
}

- (IBAction)addTimeOnclink:(id)sender {
    if(!_didChangeData){
        _didChangeData = YES;
    }
    CGFloat time = _timeSlider.value;
    time += 1;
    if(time > 70){
        time = 70;
    }
    [_timeSlider setValue:time];
}

- (IBAction)hideBtnOnclink:(id)sender {
    [_vcontrol dismissPopupViewControllerAnimated:YES completion:nil];
}

-(void)seti9ChannelView:(NewChannelView*)view BlurView:(UIViewController*)blueView{
    _channelView = view;
    _vcontrol = blueView;
}

-(void)setWenDuVal:(int)wdVal setShiJianVal:(int)sjVal _channal:(int)channal{
    [_timeSlider setinitValue:sjVal];
    [_tempSlider setinitValue:wdVal];
    _moxaNumLable.text = [NSString stringWithFormat:@"%d号灸头",channal];
    [self showWenduStats];
}

- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider{

}

- (void)sliderDidChangeData:(ASValueTrackingSlider *)slider{
    if(!_didChangeData){
        _didChangeData = YES;
    }
    [self showWenduStats];
}

-(void)showWenduStats{
    if(_tempSlider.value < 45){
        _tempRemindLable.text = @"状态：温度正常";
    }else if(_tempSlider.value >= 45 && _tempSlider.value < 48){
        _tempRemindLable.text = @"状态：温度微高";
    }else if(_tempSlider.value >= 48){
        _tempRemindLable.text = @"状态：温度过高";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
