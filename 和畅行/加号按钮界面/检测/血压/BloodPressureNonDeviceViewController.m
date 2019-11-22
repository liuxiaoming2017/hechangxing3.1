//
//  BloodPressureNonDeviceViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/9/25.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "BloodPressureNonDeviceViewController.h"
#import "AdvisoryTableViewCell.h"
#import "LoginViewController.h"

#import "SubMemberView.h"
#import "NSObject+SBJson.h"
#import "ZHPickView.h"
#import "AppDelegate.h"
#import "ArchivesController.h"
#import "LJRuler.h"



#define NUMBERS @"0123456789n"

#define kLow @"血压值偏低，建议均衡营养，坚持锻炼，改善体质。"
#define kNomal @"血压值正常，建议继续保持当下的健康生活方式，并定期测量血压。"
#define kHigh @"血压值正常稍高，请采取健康的生活方式，戒烟限酒，限制钠盐的摄入，加强锻炼，密切关注血压。"
#define kHigher @"血压值偏高，请戒烟限酒，限制钠盐的摄入，加强锻炼。"
#define kMoreHigher @"血压值过高，请严格调整作息，控制饮食。若身体不适，请注意及时就诊。"
#define kHighest @"血压值严重偏高。请注意及时就诊，配合治疗。"


@interface BloodPressureNonDeviceViewController ()<UITextFieldDelegate,MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate,LJRulerDelegate,ZHPickViewDelegate>

@property (nonatomic,strong) UILabel *dataLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *SBPLabel;
@property (nonatomic,strong) UILabel *DBPLabel;
@property (nonatomic,strong) UILabel *rateLabel;
@property (nonatomic,strong) UILabel *datatypeLabel;
@property (nonatomic,strong) NSDate *timedate;
@property (nonatomic,strong)UIView *bottomView ;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,copy)  NSString *dateString;
@property (nonatomic,copy)  NSString *timeString;
@property (nonatomic,strong) LJRuler *highRuler;
@property (nonatomic,strong) LJRuler *lowRuler;
@property (nonatomic,strong) LJRuler *rateRuler;



@end

@implementation BloodPressureNonDeviceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = ModuleZW(@"血压录入");
    [self initWithController];
    [self bounceView];
}

#pragma mark ------ 弹出视图
-(void)bounceView{
    //弹出视图
   
    _showView = [[UIView alloc]initWithFrame:CGRectMake(Adapter(30), Adapter(100), self.view.frame.size.width - Adapter(60), self.view.frame.size.height - Adapter(190))];
    _showView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    _showView.hidden = YES;
    
    
}



#pragma mark ------- 初始化界面
-(void)initWithController{
    
    
    UIScrollView *myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavBarHeight + Adapter(10), ScreenWidth, ScreenHeight - kNavBarHeight)];
    myScrollView.backgroundColor = RGB_AppWhite;
    [self.view addSubview:myScrollView];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    [dateFormatter1 setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *dateString1 = [dateFormatter1 stringFromDate:currentDate];
    self.dateString = dateString;
    self.timeString = dateString1;
    NSArray *buttonTitleArray = @[ ModuleZW(@"  日期"),ModuleZW(@"  测量时间")];
    NSArray *titleArray = @[dateString,dateString1];
    
    for (int i = 0; i < 3; i++) {
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Adapter(10), Adapter(10), ScreenWidth - Adapter(20), Adapter(100))];
        backImageView.backgroundColor = [UIColor whiteColor];
        backImageView.userInteractionEnabled = YES;
        backImageView.layer.cornerRadius = Adapter(10);
        backImageView.layer.masksToBounds = YES;
        if(i == 1) {
            backImageView.top = Adapter(130) ;
            backImageView.height = Adapter(230);
            UILabel *bloodLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(30), Adapter(10), Adapter(300), Adapter(30))];
            bloodLabel.text = ModuleZW(@"血压");
            bloodLabel.font = [UIFont systemFontOfSize:16];
            bloodLabel.textColor = RGB_TextGray;
            [backImageView addSubview:bloodLabel];
            NSArray *leftArray = @[ModuleZW(@"收缩压"),ModuleZW(@"舒张压")];
             NSArray *rightArray = @[@"120mmHg",@"80mmHg"];
            
            for (int k = 0; k < 2; k++) {
                
                UILabel *leftlabel =  [[UILabel alloc]initWithFrame:CGRectMake(0,bloodLabel.bottom + Adapter(10) + Adapter(84)*k, backImageView.width/2 - Adapter(5), Adapter(30))];
                leftlabel.text = leftArray[k];
                leftlabel.textAlignment = NSTextAlignmentRight;
                leftlabel.font  =  [UIFont systemFontOfSize:14];
                [backImageView addSubview:leftlabel];
                
                UILabel *rightlabel =  [[UILabel alloc]initWithFrame:CGRectMake(backImageView.width/2 + Adapter(5),bloodLabel.bottom + Adapter(10) + Adapter(84)*k, leftlabel.width, Adapter(30))];
                rightlabel.text = rightArray[k];
                rightlabel.font  =  [UIFont systemFontOfSize:19];
                [backImageView addSubview:rightlabel];
                if(k == 0){
                    self.SBPLabel = rightlabel;
                }else{
                    self.DBPLabel = rightlabel;
                }
                
                LJRuler *ruler = [[LJRuler alloc] initWithFrame:CGRectMake(Adapter(40), leftlabel.bottom + Adapter(10) , backImageView.width - Adapter(80), Adapter(34))];
                ruler.rulerColor = [UIColor whiteColor];
                ruler.delegate = self;
                
                ruler.scaleAverage = 1;
                
                ruler.tag = 1000 + k;
                if(k == 0){
                    ruler.scaleCount = 300;
                    ruler.mixscaleCount = 40;
                    ruler.currentValue = 120;

                    self.highRuler = ruler;
                }else{
                    ruler.scaleCount = 200;
                    ruler.mixscaleCount = 30;
                    ruler.currentValue = 80;
                    self.lowRuler = ruler;
                }
        
                
                [backImageView addSubview:ruler];
            }
            
          
            
        }else if(i == 2) {
            backImageView.top = Adapter(370) ;
            backImageView.height = Adapter(150);
            
            UILabel *bloodLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(30), Adapter(10), Adapter(300), Adapter(30))];
            bloodLabel.text = ModuleZW(@"心率");
            bloodLabel.font = [UIFont systemFontOfSize:16];
            bloodLabel.textColor = RGB_TextGray;
            [backImageView addSubview:bloodLabel];
            
            UILabel *leftlabel =  [[UILabel alloc]initWithFrame:CGRectMake(Adapter(5),bloodLabel.bottom + Adapter(10) ,backImageView.width/2 - Adapter(5), Adapter(30))];
            leftlabel.text = ModuleZW(@"心率");
            leftlabel.textAlignment = NSTextAlignmentRight;
            leftlabel.font  =  [UIFont systemFontOfSize:14];
            [backImageView addSubview:leftlabel];
            
            UILabel *rightlabel =  [[UILabel alloc]initWithFrame:CGRectMake(backImageView.width/2 + Adapter(5),bloodLabel.bottom + Adapter(10) , leftlabel.width, Adapter(30))];
            rightlabel.text = @"60BBPM";
            rightlabel.font  =  [UIFont systemFontOfSize:19];
            [backImageView addSubview:rightlabel];
            self.rateLabel = rightlabel;
            
            LJRuler *ruler = [[LJRuler alloc] initWithFrame:CGRectMake(Adapter(40), leftlabel.bottom + Adapter(10) , backImageView.width - Adapter(80), Adapter(34))];
            ruler.rulerColor = [UIColor whiteColor];
            ruler.delegate = self;
            ruler.tag  = 1002;
            ruler.scaleCount = 140;
            ruler.mixscaleCount = 30;
            
            ruler.scaleAverage = 1;
            ruler.currentValue = 60;
            [backImageView addSubview:ruler];
            self.rateRuler = ruler;
        }
        [self insertSublayerWithImageView:backImageView with:myScrollView];
        if (i == 0){
            for (int j  = 0; j < 2; j++) {
                UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.frame = CGRectMake(0, 0 +backImageView.height*j/2 , backImageView.width, backImageView.height/2 );
                [button setTitle:buttonTitleArray[j] forState:(UIControlStateNormal)];
                [button setImage:[UIImage imageNamed:@""] forState:(UIControlStateNormal)];
                [button setTitleColor:RGB_TextGray forState:(UIControlStateNormal)];
                [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.currentImage.size.width,0,0)];
                [button.titleLabel setFrame:CGRectMake(Adapter(20), 0, button.width - Adapter(20), button.height)];
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, backImageView.width - Adapter(40) , 0, -backImageView.width + Adapter(40))];
                [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    if(j == 0){
                        [self  layoutDataViewWithType:1];
                    }else{
                        [self  layoutDataViewWithType:2];
                    }
                }];
                [backImageView addSubview:button];
                
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(button.width - Adapter(30), button.height/2 - Adapter(10), Adapter(12), Adapter(20))];
                imageView.image = [UIImage imageNamed:@"1我的_09"];
                imageView.userInteractionEnabled = YES;
                [button addSubview:imageView];
                
                UILabel *dataLable = [[UILabel alloc]initWithFrame:CGRectMake(backImageView.width - Adapter(200), 0, Adapter(150), backImageView.height/2)];
                dataLable.font = [UIFont systemFontOfSize:16];
                dataLable.textAlignment = NSTextAlignmentRight;
                dataLable.text = titleArray[j];
                [button addSubview:dataLable];
                if(j == 0){
                    self.dataLabel = dataLable;
                }else{
                    self.timeLabel = dataLable;
                }
                
            }
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, backImageView.height/2 - Adapter(0.25), backImageView.width, Adapter(0.5))];
            lineView.backgroundColor = UIColorFromHex(0XD6D6D6);
            [backImageView addSubview:lineView];
        }
        [myScrollView addSubview:backImageView];
    
    }
    myScrollView.contentSize = CGSizeMake(0, Adapter(530) + Adapter(60));
    
    UIButton *suerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    suerButton.frame = CGRectMake(ScreenWidth/2 - Adapter(45), ScreenHeight - Adapter(60), Adapter(90), Adapter(30));
    [suerButton setTitle:ModuleZW(@"确定") forState:(UIControlStateNormal)];
    [suerButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [suerButton setBackgroundColor:RGB_ButtonBlue];
    suerButton.layer.cornerRadius = Adapter(15);
    suerButton.layer.masksToBounds = YES;
    [suerButton addTarget:self action:@selector(saveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:suerButton];
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _highRuler.currentValue = 120 - _highRuler.mixscaleCount;
    _lowRuler.currentValue = 80 - _lowRuler.mixscaleCount;
    _rateRuler.currentValue = 70 - _rateRuler.mixscaleCount;
    _highRuler.isScroll = NO;
    _lowRuler.isScroll = NO;
    _rateRuler.isScroll = NO;
}


- (void)ruler:(LJRuler *)ruler didScroll:(LJRulerScrollView *)scrollView {
    
    switch (ruler.tag) {
        case 1000:
            if(scrollView.currentValue +ruler.mixscaleCount >scrollView.scaleCount){
                 self.SBPLabel.text = [NSString stringWithFormat:@"%dmmHg", (int)scrollView.scaleCount];
            } else{
                 self.SBPLabel.text = [NSString stringWithFormat:@"%dmmHg", (int)(scrollView.currentValue +ruler.mixscaleCount)];
            }
            break;
        case 1001:
            if(scrollView.currentValue +ruler.mixscaleCount >scrollView.scaleCount){
                self.DBPLabel.text = [NSString stringWithFormat:@"%dmmHg", (int)scrollView.scaleCount];
            }else{
                self.DBPLabel.text = [NSString stringWithFormat:@"%dmmHg", (int)(scrollView.currentValue +ruler.mixscaleCount)];
            }
            break;
        case 1002:
            if(scrollView.currentValue +ruler.mixscaleCount >scrollView.scaleCount){
                self.rateLabel.text = [NSString stringWithFormat:@"%dBPM", (int)scrollView.scaleCount];
            }else{
                self.rateLabel.text = [NSString stringWithFormat:@"%dBPM", (int)(scrollView.currentValue +ruler.mixscaleCount)];
            }
            break;
            
        default:
            break;
    }
   
}



-(void)layoutDataViewWithType: (int) typeInt{
    
    if(!_backView){
        UIView *backView  = [[UIView alloc]initWithFrame:self.view.bounds];
        backView.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self.view addSubview:backView];
        _backView = backView;
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(Adapter(10), ScreenHeight - Adapter(290), ScreenWidth - Adapter(20), Adapter(280))];
        bottomView.backgroundColor = [UIColor whiteColor];
        bottomView.layer.cornerRadius = 15;
        [backView addSubview:bottomView];
        self.bottomView = bottomView;
        
        UILabel *dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(30), Adapter(10), Adapter(100), Adapter(30))];
        dataLabel.textColor = RGB_TextGray;
        dataLabel.font = [UIFont systemFontOfSize:14];
        [bottomView addSubview:dataLabel];
        _datatypeLabel = dataLabel;
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(bottomView.width/2 - Adapter(0.25),bottomView.height - Adapter(36), Adapter(0.5), Adapter(32))];
        lineView.backgroundColor = RGB(230, 230, 230);
        [bottomView addSubview:lineView];
        
        
        if(typeInt == 1){
            dataLabel.text = ModuleZW(@"日期");
            self.datePicker.datePickerMode =  UIDatePickerModeDate;
            self.datePicker.tag = 111;
        }else{
            dataLabel.text = ModuleZW(@"测量时间");
            self.datePicker.datePickerMode =  UIDatePickerModeTime;
            self.datePicker.tag = 112;
        }
        [self.datePicker setMaximumDate:[NSDate date]];
        
        NSArray *buttonTitleArray = @[ModuleZW(@"取消"),ModuleZW(@"确定")];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(Adapter(40) + (bottomView.width/2-Adapter(40))*i  , bottomView.height - Adapter(40), (bottomView.width - Adapter(80))/2, Adapter(40));
            [button setTitle:buttonTitleArray[i] forState:(UIControlStateNormal)];
            [button setTitleColor:UIColorFromHex(0Xffa200) forState:(UIControlStateNormal)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16*[UserShareOnce shareOnce].fontSize*0.8]];
            [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if(i == 1){
                    if([_datatypeLabel.text isEqualToString: ModuleZW(@"日期")]){
                        self.dataLabel.text = self.dateString;
                    }else{
                        self.timeLabel.text = self.timeString;
                    }
                }
                [UserShareOnce shareOnce].canChageSize = YES;
                backView.hidden = YES;
            }];
            [bottomView addSubview:button];
        }
    }else{
        _backView.hidden = NO;
        if(typeInt == 1){
            _datatypeLabel.text = ModuleZW(@"日期");
            self.datePicker.datePickerMode =  UIDatePickerModeDate;
            self.datePicker.tag = 111;
        }else{
            _datatypeLabel.text = ModuleZW(@"测量时间");
            self.datePicker.datePickerMode =  UIDatePickerModeTime;
            self.datePicker.tag = 112;
        }
        NSString *str = [NSString stringWithFormat:@"%@ %@",_dataLabel.text,_timeLabel.text];
        _dateString = _dataLabel.text;
        _timeString = _timeLabel.text;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm"];
        NSDate *tempDate = [dateFormatter dateFromString:str];
        [self.datePicker setDate:tempDate animated:YES];
    }
}

-(UIDatePicker *)datePicker{
    if(!_datePicker){
        [UserShareOnce shareOnce].canChageSize = NO;
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.frame = CGRectMake(Adapter(30), Adapter(40), _bottomView.width - Adapter(60), Adapter(200));
        if([UserShareOnce shareOnce].languageType){
            self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"us"];
        }else{
            self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        }
        [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [_bottomView addSubview:self.datePicker];
    }
    return _datePicker;
}

- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    //设置时间格式
    if(datePicker.tag == 111){
        formatter.dateFormat = @"yyyy/MM/dd";
        NSString *dateStr = [formatter  stringFromDate:datePicker.date];
        self.dateString = dateStr;
    }else{
        formatter.dateFormat = @"HH:mm";
        NSString *dateStr = [formatter  stringFromDate:datePicker.date];
        self.timeString = dateStr;
    }
    
}

#pragma mark ------- 提交数据
-(void)saveClick:(UIButton *)button{
 
    
    if(self.highRuler.isScroll == YES||self.lowRuler.isScroll == YES||self.rateRuler.isScroll == YES){
        return;
    }
 
    //得到子账户的id
    NSString *subId = [NSString stringWithFormat:@"%@", [MemberUserShance shareOnce].idNum];
    
    NSInteger highCount = [self.SBPLabel.text integerValue];
    NSInteger lowCount = [self.DBPLabel.text integerValue];
    NSInteger pulseCount = [self.rateLabel.text integerValue];
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",_dataLabel.text,_timeLabel.text];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSDate *tempDate = [dateFormatter dateFromString:str];
    long  timeSp = (long)[tempDate timeIntervalSince1970];
    
    //提交数据
//    NSString *aUrl = [NSString stringWithFormat:@"%@/member/uploadData.jhtml",URL_PRE];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
//    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
//    [request addPostValue:subId forKey:@"memberChildId"];
//    [request addPostValue:@(30) forKey:@"datatype"];
//    [request addPostValue:@(highCount) forKey:@"highPressure"];
//    [request addPostValue:@(lowCount) forKey:@"lowPressure"];
//    [request addPostValue:@(pulseCount) forKey:@"pulse"];
//    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
//    [request addPostValue:@(timeSp) forKey:@"createDate"];
//
//    [request setTimeOutSeconds:20];
//    [request setRequestMethod:@"POST"];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requestError:)];
//    [request setDidFinishSelector:@selector(requestCompleted:)];
//    [request startAsynchronous];
    
   
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [dic setObject:subId forKey:@"memberChildId"];
    [dic setObject:@(30) forKey:@"datatype"];
    [dic setObject:@(highCount) forKey:@"highPressure"];
    [dic setObject:@(lowCount) forKey:@"lowPressure"];
    [dic setObject:@(pulseCount) forKey:@"pulse"];
    [dic setObject:[UserShareOnce shareOnce].token forKey:@"token"];
    [dic setObject:@(timeSp) forKey:@"createDate"];
    
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithCookieType:1 urlString:@"member/uploadData.jhtml" headParameters:nil parameters:dic successBlock:^(id response) {
        [weakSelf requestCompleted:response];
    } failureBlock:^(NSError *error) {
        [weakSelf showAlertWarmMessage:ModuleZW(@"提交数据失败")];
    }];

}






-(void)requestCompleted:(NSDictionary *)dic{
//    NSString* reqstr=[request responseString];
//    NSDictionary * dic=[reqstr JSONValue];
    //NSDictionary *dataDic = dic[@"data"];
    NSNumber *state = dic[@"status"];
    if (state.integerValue == 100) {
        NSLog(@"数据提交成功");
        //弹出视图，展现结果
        NSInteger highCount = [self.SBPLabel.text integerValue];
        NSInteger lowCount = [self.DBPLabel.text integerValue];
        NSInteger pulseCount = [self.rateLabel.text integerValue];
        
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.tag = 331;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        UIView *view2 = [[UIView alloc] initWithFrame:self.view.frame];
        view2.backgroundColor = [UIColor clearColor];
        view2.tag = 332;
        self.view.userInteractionEnabled = YES;
        view.userInteractionEnabled = YES;
        view2.userInteractionEnabled = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width-Adapter(40), Adapter(180))];
        imageView.center = self.view.center;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"bounceView"];
        

        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sureBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
        [sureBtn setTitle: ModuleZW(@"返回检测") forState:UIControlStateNormal];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        sureBtn.frame = CGRectMake(Adapter(20), kScreenSize.height/2+Adapter(90), imageView.frame.size.width * 0.5, Adapter(40));
        [sureBtn addTarget:self action:@selector(confirmBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:sureBtn];
        
        UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [lookBtn setBackgroundImage:[UIImage imageNamed:@"look"] forState:UIControlStateNormal];
        [lookBtn setTitle:ModuleZW(@"查看档案") forState:UIControlStateNormal];
        lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        lookBtn.frame = CGRectMake(CGRectGetMaxX(sureBtn.frame), sureBtn.frame.origin.y, imageView.frame.size.width * 0.5, Adapter(40));
        [lookBtn addTarget:self action:@selector(lookClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view2 addSubview:lookBtn];
        
        UILabel *countLabel = [Tools labelWith:[NSString stringWithFormat:ModuleZW(@"您当前脉搏%ld次/分  收缩压%ldmmHg  舒张压 %ldmmhg"),(long)pulseCount,(long)highCount,(long)lowCount] frame:CGRectMake(0, Adapter(50), imageView.width, Adapter(60)) textSize:14 textColor:[Tools colorWithHexString:@"#e79947"] lines:0 aligment:NSTextAlignmentCenter];
        
        UILabel *label0 = [[UILabel alloc] init];
        label0.text = ModuleZW(@"血压、脉搏正常范围参考值：");
        label0.numberOfLines = 2;
        label0.textAlignment = NSTextAlignmentCenter;
        label0.font = [UIFont systemFontOfSize:13];
        label0.frame = CGRectMake(Adapter(20), Adapter(110), imageView.bounds.size.width-Adapter(40), Adapter(25));
        [imageView addSubview:label0];
        CGRect textRect1 = [label0.text  boundingRectWithSize:CGSizeMake(imageView.bounds.size.width-Adapter(40), MAXFLOAT)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}
                                                      context:nil];
        label0.height = textRect1.size.height;
        imageView.height = Adapter(180) + label0.height ;
        sureBtn.top = imageView.bottom;
        lookBtn.top = sureBtn.top;
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.text = ModuleZW(@"脉搏：60－100次/分");
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:12];
        label1.frame = CGRectMake(Adapter(20), CGRectGetMaxY(label0.frame), imageView.bounds.size.width-Adapter(40), Adapter(16));
        [imageView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = ModuleZW(@"90 < 高压 / 收缩压（mmHg）< 140");
        label2.textAlignment = NSTextAlignmentCenter;
        label2.font = [UIFont systemFontOfSize:12];
        label2.frame = CGRectMake(Adapter(20), CGRectGetMaxY(label1.frame), imageView.bounds.size.width-Adapter(40), Adapter(16));
        [imageView addSubview:label2];
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.text = ModuleZW(@"60 < 低压 / 舒张压（mmHg）< 90");
        label3.textAlignment = NSTextAlignmentCenter;
        label3.font = [UIFont systemFontOfSize:12];
        label3.frame = CGRectMake(Adapter(20), CGRectGetMaxY(label2.frame), imageView.bounds.size.width-Adapter(40), Adapter(16));
        [imageView addSubview:label3];
        
        [imageView addSubview:countLabel];
        [view2 addSubview:imageView];
        [self.view addSubview:view];
        [self.view addSubview:view2];


        
    }else{
        [self showAlertWarmMessage:ModuleZW(@"提交数据失败")];
    }
    
    
    //[self customeView];
}




//点击确定
-(void)confirmBtnClick2:(UIButton *)button{
    UIView *v1 = [self.view viewWithTag:331];
    UIView *v2 = [self.view viewWithTag:332];
    [v1 removeFromSuperview];
    [v2 removeFromSuperview];
}

//查看档案
- (void)lookClickBtn:(UIButton *)btn{
    NSString *subId = [NSString stringWithFormat:@"%@", [MemberUserShance shareOnce].idNum];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *controller = app.window.rootViewController;
    UITabBarController  *rvc = (UITabBarController  *)controller;
    [rvc setSelectedIndex:1];
    [UserShareOnce shareOnce].wherePop = ModuleZW(@"血压");
    [UserShareOnce shareOnce].bloodMemberID = [NSString stringWithFormat:@"%@",subId];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
