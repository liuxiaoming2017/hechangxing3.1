//
//  i9_UISetTTViewForRollerController.m
//  MoxaYS
//
//  Created by xuzengjun on 17/8/9.
//  Copyright © 2017年 jiudaifu. All rights reserved.
//

#import "i9_UISetTTViewForRollerController.h"
#import "UIViewController+CWPopup.h"
#import "i9_MoxaMainViewController.h"
#import <moxibustion/BlueToothCommon.h>

@interface i9_UISetTTViewForRollerController ()
@property (weak, nonatomic) IBOutlet UILabel *moxaNumLable;
@property (weak, nonatomic) IBOutlet UILabel *wenduRemind;
@property (weak, nonatomic) IBOutlet UIPickerView *wenduPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *timePicker;
@property (weak, nonatomic) IBOutlet UIButton *synWendu;
@property (weak, nonatomic) IBOutlet UIButton *synTime;
@property (weak, nonatomic) IBOutlet UIButton *openBtn;
@property (retain,nonatomic) NSMutableArray *wenduArray;
@property (retain,nonatomic) NSMutableArray *shijianArray;
@property (retain, nonatomic) NewChannelView *channelView;
@property (weak, nonatomic) UIViewController *vcontrol;
@property (assign, nonatomic) BOOL isWenDuAll;
@property (assign, nonatomic) BOOL isShiJianAll;
@property (assign, nonatomic) int wenduArrynum;
@end

@implementation i9_UISetTTViewForRollerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // Do any additional setup after loading the view.
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if([_vcontrol isKindOfClass:i9_MoxaMainViewController.class]){
        i9_MoxaMainViewController *vc = (i9_MoxaMainViewController *)_vcontrol;
        vc.settingsBoudIsShow = NO;
    }
}

-(void)initView{
    _isWenDuAll = NO;
    _isShiJianAll = NO;
    _wenduPicker.delegate = self;
    _wenduPicker.dataSource = self;
    _wenduArrynum = MAX_WENDU - 38 + 1;
    _wenduArray = [NSMutableArray arrayWithCapacity:_wenduArrynum];
    for (int wdval = 38; wdval < MAX_WENDU+1; wdval++) {
        [_wenduArray addObject:[NSString stringWithFormat:@"%d", wdval]];
    }
    
    _timePicker.delegate = self;
    _timePicker.dataSource = self;
    _shijianArray = [NSMutableArray arrayWithCapacity:70];
    for (int sjval = 1; sjval < 70+1; sjval++) {
        [_shijianArray addObject:[NSString stringWithFormat:@"%d", sjval]];
    }
    [self showStartMode];
    
    _synWendu.layer.borderColor = RGB(49, 141, 214).CGColor;
    _synWendu.layer.borderWidth =1.0;
    _synWendu.layer.cornerRadius =5.0;
    [_synWendu setTitle:ModuleZW(@"同步温度") forState:(UIControlStateNormal)];
    
    _synTime.layer.borderColor = RGB(49, 141, 214).CGColor;
    _synTime.layer.borderWidth =1.0;
    _synTime.layer.cornerRadius =5.0;
     [_synTime setTitle:ModuleZW(@"同步时间") forState:(UIControlStateNormal)];
    
    _openBtn.layer.borderColor = RGB(49, 141, 214).CGColor;
    _openBtn.layer.borderWidth =1.0;
    _openBtn.layer.cornerRadius =8.0;
    [_openBtn setTitle:ModuleZW(@"确定") forState:(UIControlStateNormal)];
}

-(void)seti9ChannelView:(NewChannelView*)view BlurView:(UIViewController*)blueView{
    _channelView = view;
    _vcontrol = blueView;
}

- (IBAction)synWenduOnClinck:(id)sender {
    if(_isWenDuAll){
        _isWenDuAll = NO;
    }else{
        _isWenDuAll = YES;
    }
    [self showStartMode];
}

- (IBAction)synTempOnClinck:(id)sender {
    if(_isShiJianAll){
        _isShiJianAll = NO;
    }else{
        _isShiJianAll = YES;
    }
    [self showStartMode];
}

# pragma mark - 设置灸头信息 确定按钮
- (IBAction)startBtnOnclinck:(id)sender {
    int wdVal = [_wenduPicker selectedRowInComponent:0]%_wenduArrynum+38;
    int sjVal = ([_timePicker selectedRowInComponent:0]%70+1)*60;
    [_vcontrol dismissPopupViewControllerAnimated:YES completion:^{
        if(_setTTDelegate != nil)// && [_setTTDelegate respondsToSelector:@selector(whenSetTT:WenDu:shiJian:allset:)])
        {
            int val = 0;
            if (_isShiJianAll) {
                val = 2;
            }
            if (_isWenDuAll) {
                if (val == 2) {
                    val = 3;
                }else {
                    val = 1;
                }
            }
            [_setTTDelegate wheni9SetTT:_channelView WenDu:wdVal shiJian:sjVal allset:val];
        }
    }];
}

- (IBAction)cancleBtnOnclink:(id)sender {
    [_vcontrol dismissPopupViewControllerAnimated:YES completion:nil];
}

-(void)showStartMode{
    if(_isWenDuAll == NO){
        [_synWendu setSelected:NO];
    }else{
        [_synWendu setSelected:YES];
    }
    if(_isShiJianAll == NO){
        [_synTime setSelected:NO];
    }else{
        [_synTime setSelected:YES];
    }
}

-(void)setWenDuVal:(int)wdVal setShiJianVal:(int)sjVal _channal:(int)channal{
    sjVal = (sjVal == 0)?1:sjVal;
    [_wenduPicker selectRow:(wdVal-38) inComponent:0 animated:NO];
    [_timePicker selectRow:(sjVal-1) inComponent:0 animated:NO];
    _moxaNumLable.text = [NSString stringWithFormat:ModuleZW(@"%d号灸头"),channal];
    [self showWenduStats];
}

-(void)showWenduStats{
    int wdVal = [_wenduPicker selectedRowInComponent:0]%_wenduArrynum+38;
    if(wdVal < 45){
        _wenduRemind.text = ModuleZW(@"温度正常");
        _wenduRemind.textColor = RGB(49, 141, 214);
        _wenduRemind.hidden = YES;
    }else if(wdVal >= 45 && wdVal < 48){
        _wenduRemind.text = ModuleZW(@"温度微高");
        _wenduRemind.textColor = RGB(49, 141, 214);
        _wenduRemind.hidden = NO;
    }else if(wdVal >= 48){
        _wenduRemind.text = ModuleZW(@"温度过高");
        _wenduRemind.textColor = [UIColor redColor];
        _wenduRemind.hidden = NO;
    }
}

#pragma mark pickerview function
/* return cor of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 16384;
}

/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //求余赋值使扩大后的数与数组值 相同 ，制造循环效果
    if(pickerView == _wenduPicker)
        return [NSString stringWithFormat:@"%@℃",[_wenduArray objectAtIndex:(row%_wenduArrynum)]];
    else
        return [NSString stringWithFormat:@"%@'",[_shijianArray objectAtIndex:(row%70)]];
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSUInteger max = 16384;
    if(pickerView == _wenduPicker)
    {
        NSUInteger base = (max/2)-(max/2)%_wenduArrynum;
        [pickerView selectRow:[pickerView selectedRowInComponent:0]%_wenduArrynum+base inComponent:0 animated:false];
    }
    else
    {
        NSUInteger base = (max/2)-(max/2)%70;
        [pickerView selectRow:[pickerView selectedRowInComponent:0]%70+base inComponent:0 animated:false];
    }
    [self showWenduStats];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if(!pickerLabel)
    {
        if(pickerView == _wenduPicker)
        {
            pickerLabel = [[UILabel alloc] init];
            pickerLabel.text = [_wenduArray objectAtIndex:(row%_wenduArrynum)];
            if([pickerLabel.text compare:@"48"] >=0){
                pickerLabel.textColor = [UIColor redColor];
            }else{
                pickerLabel.textColor = RGB(49, 141, 214);
            }
            
        }else if(pickerView == _timePicker){
            pickerLabel = [[UILabel alloc] init];
            pickerLabel.text = [_shijianArray objectAtIndex:(row%70)];
            pickerLabel.textColor = RGB(49, 141, 214);
        }
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.font = [UIFont systemFontOfSize:23];
    return pickerLabel;
    
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0;
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
