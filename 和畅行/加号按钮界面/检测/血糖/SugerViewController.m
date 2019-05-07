//
//  SugerViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/9/23.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "SugerViewController.h"
#import "LJRuler.h"
#import "LoginViewController.h"
#import "AdvisoryTableViewCell.h"
#import "JSONKit.h"
#import "BloodSugerModel.h"
#import "SubMemberView.h"
#import "NSObject+SBJson.h"
#import "SugerStandardController.h"

#define NUMBERS @"0123456789.n"
#define kCELLHEIGHT 20.0f
#define kNomal @"您的血糖正常，控制得不错，建议您继续保持当下的健康生活方式，并定期监测血糖。"
#define kEmptyHigh @"您空腹血糖偏高，为%.2fmmol/L，建议您在医生指导下对血糖进行定期监测、科学控制。"
#define kEmptyLow @"您空腹血糖偏低，为%.2fmmol/L，建议您适量进食予以缓解，并在医生指导下对血糖进行定期监测，及时纠正。"
#define kFullHigh @"您餐后2小时血糖偏高，为%.2fmmol/L，建议您在医生指导下对血糖进行定期监测、科学控制。"

@interface SugerViewController ()<UITextFieldDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,LJRulerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    MBProgressHUD *_progress;
    NSString *_result;
    //提示信息

    NSInteger _totalCount;//测量的总次数
    NSInteger _nomalCount;//正常的次数
    NSInteger _unNomalCount;//异常的次数
    NSInteger _emptyCount;//空腹测量次数
    NSInteger _fullCount;//餐后测量次数
}

@property (nonatomic,copy)  NSString *dateString;
@property (nonatomic,copy)  NSString *timeString;
@property (nonatomic,copy)  NSString *sugarString;
@property (nonatomic,strong) UILabel *dataLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *sugarLabel;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UILabel *datatypeLabel;
@property (nonatomic,strong)NSArray *dataArray;
@property (nonatomic,copy)  NSString *type;
@property (nonatomic,copy)  NSString *typeStr;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong)  LJRuler *ruler;
@property (nonatomic,assign)float sugerValue;

@end

@implementation SugerViewController

-(void)dealloc{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = ModuleZW(@"血糖录入");
    _type = @"empty";
    [self initWithController];
    
     _dataArray = @[ModuleZW(@"凌晨"),ModuleZW(@"早餐前"),ModuleZW(@"早餐后"),ModuleZW(@"午餐前"),ModuleZW(@"午餐后"),ModuleZW(@"晚餐前"),ModuleZW(@"晚餐后"),ModuleZW(@"睡前")];
  
}

-(void)backClick:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark ------ 弹出视图
-(void)bounceView{
    
    //弹出视图
    self.dataArr = [[NSMutableArray alloc]init];
    self.headArray = [[NSMutableArray alloc]init];
    _personView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _personView.backgroundColor = [UIColor blackColor];
    _personView.alpha = 0.3;
    [self.view addSubview:_personView];
    _showView = [[UIView alloc]initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 60, self.view.frame.size.height - 190)];
    _showView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    
    _showView.hidden = YES;
    _personView.hidden = YES;
    
    //_showView添加点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [_personView addGestureRecognizer:tap];
    
    
    
}
-(void)tapScreen:(UITapGestureRecognizer *)tap{
    [_showView setHidden:YES];
    [_personView setHidden:YES];
}
#pragma mark ------ 初始化界面
-(void)initWithController{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd"];
    [dateFormatter1 setDateFormat:@"HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSString *dateString1 = [dateFormatter1 stringFromDate:currentDate];
    NSString *typeStr = ModuleZW(@"午餐前");
    self.dateString = dateString;
    self.timeString = dateString1;
    NSArray *buttonTitleArray = @[ ModuleZW(@"  日期"),ModuleZW(@"  测量时间"),ModuleZW(@"  时间段")];
    NSArray *titleArray = @[dateString,dateString1,typeStr];
    
    for (int i = 0; i < 2; i++) {
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10+kNavBarHeight, ScreenWidth - 20, 150)];
        backImageView.backgroundColor = [UIColor whiteColor];
        backImageView.userInteractionEnabled = YES;
        backImageView.layer.cornerRadius = 10;
        backImageView.layer.masksToBounds = YES;
        if (i == 0){
            for (int j  = 0; j < 3; j++) {
                UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
                button.frame = CGRectMake(0, 0 +backImageView.height*j/3 , backImageView.width, backImageView.height/3 );
                [button setTitle:buttonTitleArray[j] forState:(UIControlStateNormal)];
                [button setImage:[UIImage imageNamed:@"1我的_09"] forState:(UIControlStateNormal)];
                [button setTitleColor:RGB_TextGray forState:(UIControlStateNormal)];
                [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -button.currentImage.size.width,0,0)];
                [button.titleLabel setFrame:CGRectMake(20, 0, button.width - 20, button.height)];
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, backImageView.width - 40 , 0, -backImageView.width + 40)];
                [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    if(j == 0){
                        [self  layoutDataViewWithType:1];
                    }else  if(j ==1){
                        [self  layoutDataViewWithType:2];
                    }else{
                        [self  layoutDataViewWithType:3];
                    }
                }];
                [backImageView addSubview:button];
                
                UILabel *dataLable = [[UILabel alloc]initWithFrame:CGRectMake(backImageView.width - 200, 0, 150, backImageView.height/3)];
                dataLable.font = [UIFont systemFontOfSize:16];
                dataLable.textAlignment = NSTextAlignmentRight;
                dataLable.text = titleArray[j];
                [button addSubview:dataLable];
                if(j == 0){
                    self.dataLabel = dataLable;
                }else if(j == 1){
                    self.timeLabel = dataLable;
                }else{
                    self.typeLabel = dataLable;
                }
                if(j < 2){
                    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, backImageView.height*(j+1)/3 - 0.25, backImageView.width, 0.5)];
                    lineView.backgroundColor = UIColorFromHex(0XD6D6D6);
                    [backImageView addSubview:lineView];
                }
                
            }
          
        }else{
            
                backImageView.top = kNavBarHeight + 180 ;
                backImageView.height = 150;
//
                UILabel *bloodLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 300, 30)];
                bloodLabel.text = ModuleZW(@"血糖");
                bloodLabel.font = [UIFont systemFontOfSize:16];
                bloodLabel.textColor = RGB_TextGray;
                [backImageView addSubview:bloodLabel];
            
            UILabel *rightlabel =  [[UILabel alloc]initWithFrame:CGRectMake(0,bloodLabel.bottom + 10 , backImageView.width, 30)];
            rightlabel.text = @"3mmol/L";
            rightlabel.textAlignment = NSTextAlignmentCenter;
            rightlabel.font  =  [UIFont systemFontOfSize:19];
            [backImageView addSubview:rightlabel];
            self.sugarLabel = rightlabel;
            
            LJRuler *ruler = [[LJRuler alloc] initWithFrame:CGRectMake(40, rightlabel.bottom + 10 , backImageView.width - 80, 34)];
            ruler.rulerColor = [UIColor whiteColor];
            ruler.delegate = self;
            ruler.scaleCount = 330;
            ruler.mixscaleCount = 10;
            ruler.scaleAverage = 0.1;
            self.ruler = ruler;
            [backImageView addSubview:ruler];
            }
        
        [self insertSublayerWithImageView:backImageView with:self.view];
        [self.view addSubview:backImageView];
        
    }


    UIButton *suerButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    suerButton.frame = CGRectMake(ScreenWidth/2 - 45, 350 +kNavBarHeight, 90, 30);
    [suerButton setTitle:ModuleZW(@"确定") forState:(UIControlStateNormal)];
    [suerButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [suerButton setBackgroundColor:RGB_ButtonBlue];
    suerButton.layer.cornerRadius = 15;
    suerButton.layer.masksToBounds = YES;
    [suerButton addTarget:self action:@selector(commitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:suerButton];
 
    
    //使用规范
//    UIButton *useNorm = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-30,commitButton.bottom+30, 60, 25) target:self sel:@selector(useNormClick:) tag:102 image:ModuleZW(@"使用规范") title:nil];
//    [self.view addSubview:useNorm];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.ruler.currentValue = 2;
    self.sugerValue = 3.0;
    self.sugarLabel.text = @"3.0mmol/L";
}
- (void)ruler:(LJRuler *)ruler didScroll:(LJRulerScrollView *)scrollView {
    
    if(scrollView.currentValue +ruler.mixscaleCount/10 >scrollView.scaleCount/10){
        self.sugarLabel.text = [NSString stringWithFormat:@"%ldmmol/L",scrollView.scaleCount/10];
        self.sugerValue = 33.0;
    } else{
        self.sugarLabel.text = [NSString stringWithFormat:@"%.1fmmol/L",scrollView.currentValue+scrollView.mixscaleCount/10];
        self.sugerValue = scrollView.currentValue+scrollView.mixscaleCount/10;
    }
    
}



#pragma mark ------ 提交数据
-(void)commitClick:(UIButton *)button{
    NSString *idNumStr = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
    BOOL isAbnormity = NO;
    
    NSString *typeStr = NSString.new;
    if([self.typeLabel.text isEqualToString:ModuleZW(@"凌晨")]){
        typeStr = @"beforeDawn";
        _type = @"empty";
    }else   if([self.typeLabel.text isEqualToString:ModuleZW(@"早餐前")]){
        typeStr = @"beforeBreakfast";
         _type = @"empty";
    }else   if([self.typeLabel.text isEqualToString:ModuleZW(@"早餐后")]){
        typeStr = @"afterBreakfast";
        _type = @"full";
        
    }else   if([self.typeLabel.text isEqualToString:ModuleZW(@"午餐前")]){
        typeStr = @"beforeLunch";
         _type = @"empty";
    }else   if([self.typeLabel.text isEqualToString:ModuleZW(@"午餐后")]){
        typeStr = @"afterLunch";
         _type = @"full";
    }else   if([self.typeLabel.text isEqualToString:ModuleZW(@"晚餐前")]){
        typeStr = @" beforeDinner";
         _type = @"empty";
    }else   if([self.typeLabel.text isEqualToString:ModuleZW(@"晚餐后")]){
        typeStr = @"afterDinner";
         _type = @"full";
    }else   if([self.typeLabel.text isEqualToString:ModuleZW(@"睡前")]){
        typeStr = @"beforeSleep";
         _type = @"empty";
    }
    
    NSString *str = [NSString stringWithFormat:@"%@ %@",_dataLabel.text,_timeLabel.text];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSDate *tempDate = [dateFormatter dateFromString:str];
    long  timeSp = (long)[tempDate timeIntervalSince1970];
    if ([_type isEqualToString:@"empty"]) {
        //空腹
        if (self.sugerValue <3.9) {
            self->_result = [[NSString alloc] initWithFormat:ModuleZW(kEmptyLow),self.sugerValue];
            isAbnormity = YES;
        }else if (self.sugerValue <=6.1){
            self->_result = [[NSString alloc] initWithFormat:ModuleZW(kNomal)];
            isAbnormity = NO;
        }else{
            self->_result = [[NSString alloc] initWithFormat:ModuleZW(kEmptyHigh),self.sugerValue];
            isAbnormity = YES;
        }
    }else{
        //餐后
        if (self.sugerValue <=7.8) {
            self->_result = [[NSString alloc] initWithFormat:ModuleZW(kNomal)];
            isAbnormity = NO;
        }else{
            self->_result = [[NSString alloc] initWithFormat:ModuleZW(kFullHigh),self.sugerValue];
            isAbnormity = YES;
        }

    }
    
    [self showPreogressView];
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/uploadData.jhtml",URL_PRE] ;
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [request addPostValue:idNumStr forKey:@"memberChildId"];
    [request addPostValue:@(60) forKey:@"datatype"];
    [request addPostValue:@(self.sugerValue) forKey:@"levels"];
    [request addPostValue:typeStr forKey:@"type"];
//    [request addPostValue:_type forKey:@"type"];
    [request addPostValue:@(isAbnormity) forKey:@"isAbnormity"];
    [request addPostValue:@(timeSp) forKey:@"createDate"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestError:)];
    [request setDidFinishSelector:@selector(requestCompleted:)];
    [request startAsynchronous];
}



-(NSString *)timeStringFrom:(double )time{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time/1000.0f];
    return  [dateFormatter stringFromDate:timeDate];
}

-(void)hudWasHidden{
    [_progress removeFromSuperview];
    
    _progress = nil;
}
-(void)requestCompleted:(ASIHTTPRequest *)request{
    
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    [self hidePreogressView];
    //NSDictionary *dataDic = dic[@"data"];
    NSNumber *state = dic[@"status"];
    if (state.integerValue == 100) {
        NSLog(@"数据提交成功");
        //请求数据,得到空腹、餐前的数据
        [self getData];
        
    }else{
        [self showAlertWarmMessage:ModuleZW(@"提交数据失败")];
       
    }
    
}

-(void)requestError:(ASIHTTPRequest *)request{
    //[self hudWasHidden];
    [self hidePreogressView];
    [self showAlertWarmMessage:ModuleZW(@"提交数据失败")];
    
}
#pragma MARK ---------  获取当天体检血糖的数据
-(void)getData{
    
    NSString *aUrlle= [NSString stringWithFormat:@"%@/subject_report /findDate.jhtml?mcId=%@",URL_PRE,[MemberUserShance shareOnce].idNum];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(getDataError:)];
    [request setDidFinishSelector:@selector(getDataFinish:)];
    [request startAsynchronous];
}

-(void)getDataFinish:(ASIHTTPRequest *)request{
    [self hidePreogressView];
    NSString *jsonString = [request responseString];
    NSDictionary *dic = [jsonString JSONValue];
    if ([dic[@"status"] integerValue] == 100) {
        NSLog(@"请求成功");

        //数据清零
        _totalCount = 0;
        _emptyCount = 0;
        _fullCount = 0;
        _nomalCount = 0;
        _unNomalCount = 0;
        NSDictionary *data = dic[@"data"];
        NSLog(@"%@",data);
        NSArray *emptyArr = data[@"type=empty"];
        for (NSDictionary *emptyDic in emptyArr) {
            BloodSugerModel *model = [[BloodSugerModel alloc] init];
            model = [BloodSugerModel mj_objectWithKeyValues:emptyDic];
            
            
            _totalCount++;
            _emptyCount++;
            if ([emptyDic[@"isAbnormity"] integerValue] == 1) {
                _unNomalCount++;
            }else{
                _nomalCount++;
            }
        }
        NSArray *fullArr = data[@"type=full"];
        for (NSDictionary *fullDic in fullArr) {
            _totalCount++;
            _fullCount++;
            BloodSugerModel *model = [[BloodSugerModel alloc] init];
            model = [BloodSugerModel mj_objectWithKeyValues:fullDic];
            
            if ([fullDic[@"isAbnormity"] integerValue] == 1) {
                _unNomalCount++;
            }else{
                _nomalCount++;
            }
        }
        //弹出提示信息
        [self showHintInfo];
    }else{
        MBProgressHUD *mbHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        mbHud.removeFromSuperViewOnHide = YES;
        mbHud.mode = MBProgressHUDModeText;
        mbHud.label.text = @"获取血糖数据失败";
        mbHud.minSize = CGSizeMake(132.f, 108.f);
        [mbHud hideAnimated:YES afterDelay:2];
    }
}
#pragma mark -------- 展示提示信息
-(void)showHintInfo{
    //弹出视图，展现结果

    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    view.tag = 331;
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    UIView *view2 = [[UIView alloc] initWithFrame:self.view.frame];
    view2.tag = 332;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 303*1.1, 195*1.1)];
    imageView.center = self.view.center;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"bounceView"];

//    UIButton *confirmBtn = [Tools creatButtonWithFrame:CGRectMake(imageView.left, imageView.bottom, imageView.width, 40*1.1) target:self sel:@selector(confirmBtnClick2:) tag:21 image:ModuleZW(@"sureButton") title:nil];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setBackgroundImage:[UIImage imageNamed:@"sure"] forState:UIControlStateNormal];
    [sureBtn setTitle: ModuleZW(@"返回检测") forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sureBtn.frame = CGRectMake(20, kScreenSize.height/2+90, imageView.frame.size.width * 0.5, 40);
    [sureBtn addTarget:self action:@selector(confirmBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:sureBtn];
    
    UIButton *lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookBtn setBackgroundImage:[UIImage imageNamed:@"look"] forState:UIControlStateNormal];
    [lookBtn setTitle:ModuleZW(@"查看档案") forState:UIControlStateNormal];
    lookBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    lookBtn.frame = CGRectMake(CGRectGetMaxX(sureBtn.frame), sureBtn.frame.origin.y, imageView.frame.size.width * 0.5, 40);
    [lookBtn addTarget:self action:@selector(lookClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:lookBtn];

    UILabel *countLabel = [Tools labelWith:[NSString stringWithFormat:ModuleZW(@"您今天测量血糖%ld次，正常%ld次，异常%ld次\n您当前检测%@血糖值为%.1fmmol/L"),(long)_totalCount,(long)_nomalCount,(long)_unNomalCount,self.typeLabel.text,self.sugerValue] frame:CGRectMake(0, 80, imageView.bounds.size.width, 20) textSize:12 textColor:[Tools colorWithHexString:@"#e79947"] lines:0 aligment:NSTextAlignmentCenter];
    [imageView addSubview:countLabel];
    CGRect textRect1 = [countLabel.text  boundingRectWithSize:CGSizeMake(imageView.bounds.size.width-40, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                  context:nil];
    countLabel.height = textRect1.size.height;
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, countLabel.bottom + 10, imageView.bounds.size.width-40, 60)];
    
    hintLabel.numberOfLines = 0;
    hintLabel.font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:_result];
    NSRange range;
    if ([_result isEqualToString:kNomal]) {
        range = NSMakeRange(4, 2);
    }else if ([_result isEqualToString:[NSString stringWithFormat:kFullHigh,self.sugerValue]]){
        range = NSMakeRange(8, 2);
    }else{
        range = NSMakeRange(5, 2);
    }

//    [hintString addAttribute:NSForegroundColorAttributeName value:[Tools colorWithHexString:@"f60a0c"] range:range];
    hintLabel.attributedText = hintString;
    [imageView addSubview:hintLabel];
    //创建两个tableView
    
    [view2 addSubview:imageView];
    [self.view addSubview:view];
    [self.view addSubview:view2];
    [view2 addSubview:sureBtn];
    [view2 addSubview:lookBtn];
    
}

-(void)getDataError:(ASIHTTPRequest *)request{
    [self hidePreogressView];
    [self showAlertWarmMessage:ModuleZW(@"获取血糖数据失败")];
}

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
    [UserShareOnce shareOnce].wherePop = ModuleZW(@"血糖");
    [UserShareOnce shareOnce].bloodMemberID = [NSString stringWithFormat:@"%@",subId];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark --------  创建提示信息的两个tableView


-(void)useNormClick:(UIButton *) button{
    NSLog(@"点击使用规范");
    SugerStandardController *vc = [[SugerStandardController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)layoutDataViewWithType: (int) typeInt{
    
    if(!_backView){
        UIView *backView  = [[UIView alloc]initWithFrame:self.view.bounds];
        backView.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self.view addSubview:backView];
        _backView = backView;
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(10, ScreenHeight - 290, ScreenWidth - 20, 280)];
        bottomView.backgroundColor = [UIColor whiteColor];
        bottomView.layer.cornerRadius = 15;
        [backView addSubview:bottomView];
        self.bottomView = bottomView;
        
        UILabel *dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 100, 30)];
        dataLabel.textColor = RGB_TextGray;
        dataLabel.font = [UIFont systemFontOfSize:14];
        [bottomView addSubview:dataLabel];
        _datatypeLabel = dataLabel;
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(bottomView.width/2 - 0.25,bottomView.height - 36, 0.5, 32)];
        lineView.backgroundColor = RGB(230, 230, 230);
        [bottomView addSubview:lineView];
        
        
     
        
        if(typeInt == 1){
            dataLabel.text = ModuleZW(@"日期");
            self.datePicker.datePickerMode =  UIDatePickerModeDate;
            self.datePicker.tag = 111;

        }else if(typeInt == 2){
            dataLabel.text = ModuleZW(@"测量时间");
            self.datePicker.datePickerMode =  UIDatePickerModeTime;
            self.datePicker.tag = 112;

        }else{
            dataLabel.text = ModuleZW(@"时间段");
            self.pickerView.showsSelectionIndicator = YES;

        }
        
        
        NSArray *buttonTitleArray = @[ModuleZW(@"取消"),ModuleZW(@"确定")];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(40 + (bottomView.width/2-40)*i  , bottomView.height - 40, (bottomView.width - 80)/2, 40);
            [button setTitle:buttonTitleArray[i] forState:(UIControlStateNormal)];
            [button setTitleColor:UIColorFromHex(0Xffa200) forState:(UIControlStateNormal)];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                if(i == 1){
                    if([self.datatypeLabel.text isEqualToString: ModuleZW(@"日期")]){
                        self.dataLabel.text = self.dateString;
                    }else if([self.datatypeLabel.text isEqualToString: ModuleZW(@"测量时间")]){
                        self.timeLabel.text = self.timeString;
                    }else{
                          self.typeLabel.text = self.typeStr;
                    }
                }
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
            self.datePicker.hidden = NO;
            self.pickerView.hidden = YES;
        }else if(typeInt == 2){
            _datatypeLabel.text = ModuleZW(@"测量时间");
            self.datePicker.datePickerMode =  UIDatePickerModeTime;
            self.datePicker.tag = 112;
            self.datePicker.hidden = NO;
            self.pickerView.hidden = YES;
        }else{
            _datatypeLabel.text = ModuleZW(@"时间段");
            self.datePicker.hidden = YES;
            self.pickerView.hidden = NO;
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

-(UIDatePicker *)datePicker{
    if(!_datePicker){
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.frame = CGRectMake(30, 40, _bottomView.width - 80, 200);
        self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        [self.datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        [self.datePicker setMaximumDate:[NSDate date]];
        [_bottomView addSubview:self.datePicker];
    }
    return _datePicker;
}

-(UIPickerView *)pickerView{
    if(!_pickerView){
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.frame = CGRectMake(30, 40, _bottomView.width - 80, 200);
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [self.pickerView selectRow:3 inComponent:0 animated:NO];
        [_bottomView  addSubview:self.pickerView];
    }
    return _pickerView;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)componen {
    return  _dataArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _dataArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component
{
    self.typeStr = _dataArray[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}


@end
