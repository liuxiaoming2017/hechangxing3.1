//
//  BreathCheckViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/9/25.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "BreathCheckViewController.h"
//#import "BreathCheckGuideViewController.h"
#import "AdvisoryTableViewCell.h"
#import "LoginViewController.h"
#import "NSObject+SBJson.h"
#import "BreathStandardController.h"

#define NUMBERS @"0123456789.n"

@interface BreathCheckViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>
{
    UITextField *_breathCountTF;
    UILabel *_timeLabel;
    UILabel *_instanceTimeLabel;
    UILabel *_endLabel;
    UILabel *_unitLabel;
    NSTimer *_timer;
    NSInteger _leftTime;
    NSInteger _childAge;//记录选择子账户的年龄
    UIButton *_useNorm;
}
@end

@implementation BreathCheckViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.userInteractionEnabled = YES;
    
    self.navTitleLabel.text = ModuleZW(@"呼吸检测");
    [self initWithController];
    [self bounceView];
}

#pragma mark ------ 弹出视图
-(void)bounceView{
    //弹出视图
    self.dataArr = [[NSMutableArray alloc]init];
    self.headArray = [[NSMutableArray alloc]init];
    _memberChildId = [UserShareOnce shareOnce].mengberchildId;
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



-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ------- 界面
-(void)initWithController{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, kScreenSize.width, 180)];
    imageView.image = [UIImage imageNamed:@"呼吸01"];
    [self.view addSubview:imageView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2-100, 80, 100, 20)];
    _timeLabel.text = ModuleZW(@"倒计时");
    _timeLabel.textAlignment = NSTextAlignmentRight;
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont systemFontOfSize:15];
    [imageView addSubview:_timeLabel];
    
    _instanceTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2, 65, 50, 50)];
    _instanceTimeLabel.text = @"30";
    _instanceTimeLabel.textColor = [UIColor whiteColor];
    _instanceTimeLabel.font = [UIFont boldSystemFontOfSize:38];
    _instanceTimeLabel.textAlignment = NSTextAlignmentRight;
    [imageView addSubview:_instanceTimeLabel];
    
    _unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenSize.width/2+55, 90, 10, 15)];
    _unitLabel.textAlignment = NSTextAlignmentLeft;
    _unitLabel.text = @"S";
    _unitLabel.font = [UIFont boldSystemFontOfSize:16];
    _unitLabel.textColor = [UIColor whiteColor];
    [imageView addSubview:_unitLabel];
    
    
    
    
    //[self createLabelWith:CGRectMake(kScreenSize.width/2-70, imageView.bottom+36, 140, 20) text:@"请输入本次呼吸次数" fontSize:14 textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter tag:21 isBord:YES];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, imageView.bottom+36, ScreenWidth-20, 40)];
    label.text = ModuleZW(@"请输入本次呼吸次数");
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    //label.tag = tag;
    [self.view addSubview:label];
    
    UIImageView *breathCount = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width/2-50, label.bottom+20, 100, 40)];
    breathCount.image = [UIImage imageNamed:@"呼吸02"];
    [self.view addSubview:breathCount];
   
    
    _breathCountTF = [[UITextField alloc] initWithFrame:CGRectMake(kScreenSize.width/2-50, breathCount.top, 100, 40)];
    _breathCountTF.delegate = self;
    _breathCountTF.placeholder = @"- -";
    _breathCountTF.textAlignment = NSTextAlignmentCenter;
    _breathCountTF.keyboardType = UIKeyboardTypeNumberPad;
    _breathCountTF.textColor = [Tools colorWithHexString:@"#1ca5ed"];
    _breathCountTF.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_breathCountTF];
    
    
    //开始检测
    UIButton *startCheckButton = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-100, breathCount.bottom+30, 200, 40) target:self sel:@selector(startCheckClick:) tag:101 image:ModuleZW(@"血压03") title:nil];
    [self.view addSubview:startCheckButton];
    
    //使用规范
   UIButton *useNorm = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-30,startCheckButton.bottom+30, 60, 25) target:self sel:@selector(useNormClick:) tag:102 image:ModuleZW(@"使用规范") title:nil];
    [self.view addSubview:useNorm];
    _useNorm = useNorm;
}

-(void)createLabelWith:(CGRect)frame text:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment tag:(NSInteger)tag isBord:(BOOL)isBord{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.textAlignment = alignment;
    label.tag = tag;
    [self.view addSubview:label];
    if (isBord) {
        label.font = [UIFont boldSystemFontOfSize:size];
    }
    
}
#pragma mark ------ 开始输入时view上移，输入结束收键盘同时view下移
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        self.view.frame = CGRectMake(0, frame.origin.y-50, frame.size.width, frame.size.height);
    }];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        self.view.frame = CGRectMake(0, frame.origin.y+50, frame.size.width, frame.size.height);
    }];
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_breathCountTF resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }];
    
}
//只允许textField输入数字
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""]; //按cs分离出数组,数组按@""分离出字符串
    BOOL canChange = [string isEqualToString:filtered];
    return canChange;
}

#pragma mark ------ 开始检测
-(void)startCheckClick:(UIButton *)button{
    NSLog(@"点击开始检测按钮");
    [button setHidden:YES];
    
    UIButton *commitButton = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-100, kScreenSize.height == 480? 350: 400, 200, 40) target:self sel:@selector(commitBtnClick:) tag:11 image:ModuleZW(@"commit_green") title:nil];
    [self.view addSubview:commitButton];
    
    UIButton *reCheckButton = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-100, kScreenSize.height == 480? 400: 450, 200, 40) target:self sel:@selector(reCheckBtnClick:) tag:12 image:ModuleZW(@"recheck_blue") title:nil];
    [self.view addSubview:reCheckButton];
    
    _useNorm.top = reCheckButton.bottom + 20;
    
    //倒计时30s
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantPast]];
}

-(void)timerRun{
    //改变_timeLabel显示的字体，计时时间到显示计时结束
    _leftTime++;
    [_instanceTimeLabel setText:[NSString stringWithFormat:@"%ld",31-(long)_leftTime]];
    if (_leftTime == 31) {
        [_timeLabel setHidden:YES];
        [_instanceTimeLabel setHidden:YES];
        [_unitLabel setHidden:YES];
        _endLabel = [Tools labelWith:ModuleZW(@"计时结束") frame:CGRectMake(kScreenSize.width/2-60, 130, 120, 50) textSize:18 textColor:[UIColor whiteColor] lines:1 aligment:NSTextAlignmentCenter];
        [self.view addSubview:_endLabel];
        if (_timer) {
            [_timer invalidate];
        }
        _leftTime = 0;
    }
}

-(void)commitBtnClick:(UIButton *)button{
    //提交
    if (_leftTime) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = ModuleZW(@"正在计时中，请稍后...");
        hud.minSize = CGSizeMake(152.f, 120.0f);
        hud.label.numberOfLines = 0;
        [hud hideAnimated:YES afterDelay:2];
        
    }else{
        NSString *str = @"";
        if([GlobalCommon stringEqualNull:_breathCountTF.text]){
            str =ModuleZW(@"温度值不能为空");
        }else if([self->_breathCountTF.text integerValue] == 0){
            str = ModuleZW(@"您的输入有误,请重新输入");
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = str;
        hud.label.numberOfLines = 0;
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
        [self requestNetworkData:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];

//        if([GlobalCommon isManyMember]){
//            __weak typeof(self) weakSelf = self;
//            SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
//            [subMember receiveSubIdWith:^(NSString *subId) {
//                NSLog(@"%@",subId);
//                if ([subId isEqualToString:@"user is out of date"]) {
//                    //登录超时
//
//                }else{
//                    [weakSelf requestNetworkData:subId];
//                }
//                [subMember hideHintView];
//            }];
//        }else{
//             [self requestNetworkData:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];
//        }
        
        
    }
}

- (void)requestNetworkData:(NSString *)subId
{
//    [self showPreogressView];
//    NSInteger nums = [self->_breathCountTF.text integerValue];
//    //提交数据
//    NSString *aUrl = [NSString stringWithFormat:@"%@/member/uploadData.jhtml",URL_PRE];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
//    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
//    [request addPostValue:subId forKey:@"memberChildId"];
//    [request addPostValue:@(50) forKey:@"datatype"];
//    [request addPostValue:@(nums*2) forKey:@"nums"];
//    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
//    [request setTimeOutSeconds:20];
//    [request setRequestMethod:@"POST"];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requestError:)];
//    [request setDidFinishSelector:@selector(requestCompleted:)];
//    [request startAsynchronous];
    
    
    [self showPreogressView];
    NSInteger nums = [self->_breathCountTF.text integerValue];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [dic setObject:subId forKey:@"memberChildId"];
    [dic setObject:@(50) forKey:@"datatype"];
    [dic setObject:@(nums*2) forKey:@"nums"];
    [dic setObject:[UserShareOnce shareOnce].token forKey:@"token"];
    
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithCookieType:1 urlString:@"member/uploadData.jhtml" headParameters:nil parameters:dic successBlock:^(id dic) {
        
        [weakSelf requestCompleted:dic];
        
    } failureBlock:^(NSError *error) {
        [weakSelf hidePreogressView];
        [weakSelf showAlertWarmMessage:ModuleZW(@"提交数据失败")];
    }];
}

-(void)requestCompleted:(NSDictionary *)dic{
    [self hidePreogressView];

    NSNumber *state = dic[@"status"];
    if (state.integerValue == 100) {
        NSLog(@"数据提交成功");
        //弹出视图，展现结果
        NSInteger nums = [_breathCountTF.text integerValue];//呼吸次数
        NSString *resultStr = [[NSString alloc] init];
        if (_childAge>=18) {
            //成人，正常值16~20次/分
            if (nums>=32 && nums <=40) {
                resultStr = ModuleZW(@"正常");
            }else{
                resultStr = ModuleZW(@"不正常");
            }
        }else{
            //儿童，正常值30~40次/分
            if (nums>=60 && nums <=80) {
                resultStr = ModuleZW(@"正常");
            }else{
                resultStr = ModuleZW(@"不正常");
            }
        }
        UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
        view.tag = 31;
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.3;
        UIView *view2 = [[UIView alloc] initWithFrame:self.view.frame];
        view2.tag = 32;
        self.view.userInteractionEnabled = YES;
        view.userInteractionEnabled = YES;
        view2.userInteractionEnabled = YES;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width-40, 180)];
        imageView.center = self.view.center;
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:@"bounceView"];
        
        UIButton *confirmBtn = [Tools creatButtonWithFrame:CGRectMake(20, kScreenSize.height/2+90, kScreenSize.width-40, 40) target:self sel:@selector(confirmBtnClick2:) tag:21 image:ModuleZW(@"sureButton") title:nil];
                
        UILabel *countLabel = [Tools labelWith:[NSString stringWithFormat:ModuleZW(@"您当前呼吸节律%ld次/分"),(long)nums*2] frame:CGRectMake(0, 60, imageView.bounds.size.width, 20) textSize:14 textColor:[Tools colorWithHexString:@"#e79947"] lines:1 aligment:NSTextAlignmentCenter];
        UILabel *resultLabel1 = [Tools labelWith:ModuleZW(@"当前呼吸节律") frame:CGRectMake(imageView.bounds.size.width/2-90, 110, 110, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentRight];
        NSString *colorStr = [[NSString alloc] init];
        if ([resultStr isEqualToString:ModuleZW(@"正常")]) {
            colorStr = @"#68c900";
        }else{
            colorStr = @"#f60a0c";
        }
        UILabel *resultLabel2 = [Tools labelWith:resultStr frame:CGRectMake(resultLabel1.right, 110, 50, 20) textSize:12 textColor:[Tools colorWithHexString:colorStr] lines:1 aligment:NSTextAlignmentLeft];
        
        [imageView addSubview:countLabel];
        [imageView addSubview:resultLabel1];
        [imageView addSubview:resultLabel2];
        
        [view2 addSubview:imageView];
        [self.view addSubview:view];
        [self.view addSubview:view2];
        [view2 addSubview:confirmBtn];
        
        
        
    }else{
        [self showAlertWarmMessage:ModuleZW(@"提交数据失败")];
        
    }
    
  
    //[self customeView];
}

-(void)requestError{
    [self hidePreogressView];
    [self showAlertWarmMessage:ModuleZW(@"提交数据失败")];
}
//点击确定
-(void)confirmBtnClick2:(UIButton *)button{
    UIView *v1 = [self.view viewWithTag:31];
    UIView *v2 = [self.view viewWithTag:32];
    [v1 removeFromSuperview];
    [v2 removeFromSuperview];
}



-(void)reCheckBtnClick:(UIButton *)button{
    //重新检测
    _leftTime = 0;
    _breathCountTF.text = nil;
    [_endLabel setHidden:YES];
    [_timeLabel setHidden:NO];
    [_instanceTimeLabel setHidden:NO];
    [_unitLabel setHidden:NO];
    if (_timer) {
        [_timer invalidate];
    }
    //倒计时30s
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantPast]];
}

-(void)useNormClick:(UIButton *)button{
    NSLog(@"点击使用规范");
    BreathStandardController *vc = [[BreathStandardController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
