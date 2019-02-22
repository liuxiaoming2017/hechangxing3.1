//
//  FindPassWordController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "FindPassWordController.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface FindPassWordController ()

@end

@implementation FindPassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    navView.backgroundColor = UIColorFromHex(0x009ef3);
    titleLabel.text = ModuleZW(@"忘记密码1");
    [self addBackBtn];
    
    UIImage *registrationImageTextField = [UIImage imageNamed:@"RegistTF_bg.png"];
    CGFloat leftX = (ScreenWidth-registrationImageTextField.size.width/2)/2.0;
    
    //设置手机号框
    UITextField* registrationTF=[[ UITextField alloc] init];
    registrationTF.frame=CGRectMake(leftX, kNavBarHeight+27, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    registrationTF.borderStyle=UITextBorderStyleNone;
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    imageLayer.contents = (id) registrationImageTextField.CGImage;
    [registrationTF.layer addSublayer:imageLayer];
    registrationTF.font=[UIFont systemFontOfSize:14];
    UIImage* Regist_Tele=[UIImage imageNamed:@"Regist_Tele.png"];
    CGRect frame = [registrationTF frame];  //为你定义的UITextField
    frame.size.width = Regist_Tele.size.width/2+16.5+11.5;
    UIImageView* RegistImgView=[[UIImageView alloc] init];
    RegistImgView.frame=CGRectMake(16.5, 12.5, Regist_Tele.size.width/2, Regist_Tele.size.height/2);
    RegistImgView.image=Regist_Tele;
    UIView *leftview1 = [[UIView alloc] initWithFrame:frame];
    [leftview1 addSubview:RegistImgView];
    
    registrationTF.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    registrationTF.leftView = leftview1;
    registrationTF.tag = 111;
    registrationTF.delegate=self;
    registrationTF.placeholder=ModuleZW(@"请输入您的手机号");
    registrationTF.returnKeyType=UIReturnKeyNext;
    registrationTF.keyboardType=UIKeyboardTypeNumberPad;
    self.RepInputphoneTF=registrationTF;
    [self.view addSubview:self.RepInputphoneTF];
    
    
    
    //设置密码框
    UITextField* Regist_Sec_TF=[[ UITextField alloc] init];
    Regist_Sec_TF.frame=CGRectMake(leftX, registrationTF.frame.origin.y+registrationTF.frame.size.height+8, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    Regist_Sec_TF.borderStyle=UITextBorderStyleNone;
    CALayer *SecimageLayer = [CALayer layer];
    SecimageLayer.frame = CGRectMake(0, 0, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    SecimageLayer.contents = (id) registrationImageTextField.CGImage;
    [Regist_Sec_TF.layer addSublayer:SecimageLayer];
    Regist_Sec_TF.font=[UIFont systemFontOfSize:14];
    Regist_Sec_TF.returnKeyType=UIReturnKeyNext;
    UIImage* Regist_Sec=[UIImage imageNamed:@"Regist_passwork.png"];
    CGRect frame_sec = [Regist_Sec_TF frame];  //为你定义的UITextField
    frame_sec.size.width = Regist_Sec.size.width/2+16.5+11.5;
    UIImageView* Regist_sec_ImgView=[[UIImageView alloc] init];
    Regist_sec_ImgView.frame=CGRectMake(16.5, 12.5, Regist_Sec.size.width/2, Regist_Sec.size.height/2);
    Regist_sec_ImgView.image=Regist_Sec;
    UIView *left_secview = [[UIView alloc] initWithFrame:frame_sec];
    [left_secview addSubview:Regist_sec_ImgView];
    
    Regist_Sec_TF.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    Regist_Sec_TF.leftView = left_secview;
    
    Regist_Sec_TF.delegate=self;
    Regist_Sec_TF.secureTextEntry=YES;
    Regist_Sec_TF.tag = 112;
    Regist_Sec_TF.placeholder=ModuleZW(@"请输入您的新密码");
    self.TtempInputsecTF=Regist_Sec_TF;
    [self.view addSubview:Regist_Sec_TF];
    
    
    
    
    
    UITextField* sureSecTF=[[ UITextField alloc] init];
    sureSecTF.frame=CGRectMake(leftX, Regist_Sec_TF.frame.origin.y+Regist_Sec_TF.frame.size.height+8, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    sureSecTF.borderStyle=UITextBorderStyleNone;
    
    CALayer *Sure_SecimageLayer = [CALayer layer];
    Sure_SecimageLayer.frame = CGRectMake(0, 0, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    Sure_SecimageLayer.contents = (id) registrationImageTextField.CGImage;
    [sureSecTF.layer addSublayer:Sure_SecimageLayer];
    
    sureSecTF.font=[UIFont systemFontOfSize:14];
    sureSecTF.delegate=self;
    
    UIImage* Regist_Sure_Sec=[UIImage imageNamed:@"Regist_surepass.png"];
    CGRect frame__Sure_sec = [sureSecTF frame];  //为你定义的UITextField
    frame__Sure_sec.size.width = Regist_Sure_Sec.size.width/2+16.5+11.5;
    UIImageView* Regist_Sure_sec_ImgView=[[UIImageView alloc] init];
    Regist_Sure_sec_ImgView.frame=CGRectMake(16.5, 12.5, Regist_Sure_Sec.size.width/2, Regist_Sure_Sec.size.height/2);
    Regist_Sure_sec_ImgView.image=Regist_Sure_Sec;
    UIView *left_Sure_secview = [[UIView alloc] initWithFrame:frame__Sure_sec];
    [left_Sure_secview addSubview:Regist_Sure_sec_ImgView];
    
    sureSecTF.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    sureSecTF.leftView = left_Sure_secview;
    
    sureSecTF.secureTextEntry=YES;
    sureSecTF.returnKeyType=UIReturnKeyNext;
    sureSecTF.tag = 113;
    sureSecTF.placeholder=ModuleZW(@"请确认您的新密码");
    self.NewInputSecTF=sureSecTF;
    [self.view addSubview:sureSecTF];
    
    
    
    UIImage* YzmImg=[UIImage imageNamed:@"Regist_yzm_bg.png"];
    
    UITextField* YZMTF=[[ UITextField alloc] init];
    YZMTF.frame=CGRectMake(leftX, sureSecTF.frame.origin.y+sureSecTF.frame.size.height+8, YzmImg.size.width/2, YzmImg.size.height/2);
    YZMTF.borderStyle=UITextBorderStyleNone;
    
    CALayer *YzmimageLayer = [CALayer layer];
    YzmimageLayer.frame = CGRectMake(0, 0, YzmImg.size.width/2, YzmImg.size.height/2);
    YzmimageLayer.contents = (id) YzmImg.CGImage;
    [YZMTF.layer addSublayer:YzmimageLayer];
    
    UIImage* Regist_Yzm=[UIImage imageNamed:@"Regist_SMS.png"];
    CGRect frame_Yzm = [YZMTF frame];  //为你定义的UITextField
    frame_Yzm.size.width = Regist_Yzm.size.width/2+16.5+11.5;
    UIImageView* Regist_Yzm_ImgView=[[UIImageView alloc] init];
    Regist_Yzm_ImgView.frame=CGRectMake(16.5, 12.5, Regist_Yzm.size.width/2, Regist_Yzm.size.height/2);
    Regist_Yzm_ImgView.image=Regist_Yzm;
    UIView *left_Yzm_view = [[UIView alloc] initWithFrame:frame_Yzm];
    [left_Yzm_view addSubview:Regist_Yzm_ImgView];
    
    YZMTF.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    YZMTF.leftView = left_Yzm_view;
   
    
    YZMTF.font=[UIFont systemFontOfSize:14];
    YZMTF.delegate=self;
    YZMTF.placeholder=ModuleZW(@"请输入验证码");
    YZMTF.tag = 114;
    YZMTF.returnKeyType=UIReturnKeyDone;
    YZMTF.keyboardType=UIKeyboardTypeNumberPad;
    self.pYzmTF=YZMTF;
    [self.view addSubview:YZMTF];
    
    //
    UIImage* ObtainYzm_img=[UIImage imageNamed:@"Regist_YZM"];
    UIButton *YZMButton=[UIButton buttonWithType:UIButtonTypeCustom];
    YZMButton.frame=CGRectMake(YZMTF.frame.origin.x+YZMTF.frame.size.width+10.5,  sureSecTF.frame.origin.y+sureSecTF.frame.size.height+8, ObtainYzm_img.size.width/2 + 13,ObtainYzm_img.size.height/2);
    [YZMButton setBackgroundImage:ObtainYzm_img forState:UIControlStateNormal];
    [YZMButton setTitle:ModuleZW(@"获取验证码") forState:UIControlStateNormal];
    [YZMButton addTarget:self action:@selector(userYZMButton) forControlEvents:UIControlEventTouchUpInside];
    [YZMButton setTitleColor:[UIColor colorWithRed:112.0f/255.0f green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    YZMButton.titleLabel.font=[UIFont systemFontOfSize:12];
    YZMbtn=YZMButton;
    [self.view addSubview:YZMbtn];
    
    UIButton *findpsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *findImg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Find_Btn" ofType:@"png"]];
    [findpsButton setImage:findImg forState:UIControlStateNormal];
    findpsButton.frame=CGRectMake((ScreenWidth-findImg.size.width/2)/2,YZMButton.frame.origin.y+YZMButton.frame.size.height+19, findImg.size.width/2,findImg.size.height/2);
    [findpsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [findpsButton setTitleShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f] forState:UIControlStateNormal];
    findpsButton.titleLabel.shadowOffset=CGSizeMake(0.0f, -1.0f);
    [findpsButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [findpsButton addTarget:self action:@selector(userfindpasswordButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findpsButton];
    ptCenter= self.view.center;
    pageNo=60;
    STtimeer=60;
}

# pragma mark - 获取验证码
-(void)userYZMButton
{
    if (self.RepInputphoneTF.text.length==0) {
        
        [self showAlertWarmMessage:ModuleZW(@"登录手机号不能为空")];
        return;
    }
    
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/password/captchaPassword.jhtml",UrlPre];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    /**
     *  MD5加密后的字符串
     */
    NSString *iPoneNumber = [NSString stringWithFormat:@"%@",self.RepInputphoneTF.text];
    NSString *iPoneNumberMds = [GlobalCommon md5:iPoneNumber];
    
    [GlobalCommon showMBHudTitleWithView:self.view];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request setPostValue:self.RepInputphoneTF.text forKey:@"username"];
    [request setPostValue:timeSp forKey:@"time"];
    [request setPostValue:iPoneNumberMds forKey:@"UserPhoneKey"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    
    [request setDidFailSelector:@selector(requestYZMError:)];
    [request setDidFinishSelector:@selector(requestYZMCompleted:)];
    [request startAsynchronous];
    
    /*
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:self.RepInputphoneTF.text forKey:@"username"];
    [paramDic setObject:timeSp forKey:@"time"];
    [paramDic setObject:iPoneNumberMds forKey:@"UserPhoneKey"];
    
    __weak typeof(self) weakSelf = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:paramDic successBlock:^(id response) {
        id status=[response objectForKey:@"status"];
        if (status!=nil)
        {
            if ([status intValue]==100) {
                
                LPPopup *popup = [LPPopup popupWithText:@"请在300秒内输入验证码"];
                CGPoint point=self.view.center;
                point.y=point.y+130;
                [popup showInView:self.view
                    centerAtPoint:point
                         duration:5.0f
                       completion:nil];
                
                self->YZMcode= [NSString stringWithString:[response objectForKey:@"data"]];//;
                self->timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(getResults)
                                                     userInfo:nil
                                                      repeats:YES];
            }
            
            else
            {
                [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
                return;
                
            }
        }
        else
        {
            [weakSelf showAlertWarmMessage:@"短信验证码发送失败，请重试"];
            return;
            
        }
    } failureBlock:^(NSError *error) {
        [weakSelf showAlertWarmMessage:@"短信验证码发送失败，请重试"];
    }];
    */
}


- (void)requestYZMError:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudTitleWithView:self.view];
   [self showAlertWarmMessage:ModuleZW(@"短信验证码发送失败，请重试")];
    return;
}
- (void)requestYZMCompleted:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudTitleWithView:self.view];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    if (status!=nil)
    {
        if ([status intValue]==100) {
            
            LPPopup *popup = [LPPopup popupWithText:ModuleZW(@"请在60秒内输入验证码")];
            CGPoint point=self.view.center;
            point.y=point.y+130;
            [popup showInView:self.view
                centerAtPoint:point
                     duration:5.0f
                   completion:nil];
            
            YZMcode= [NSString stringWithString:[dic objectForKey:@"data"]];//;
            timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(getResults)
                                                 userInfo:nil
                                                  repeats:YES];
        }
        
        else if ([status intValue]==44)
        {
            [self showAlertWarmMessage:ModuleZW(@"登录超时，请重新登录")];
            return;
        }else{
            
            NSString *str = [dic objectForKey:@"data"];
            [self showAlertWarmMessage:str];
            
        }
    }
    else
    {
        [self showAlertWarmMessage:ModuleZW(@"短信验证码发送失败，请重试")];
        
        return;
        
    }
}

-(void)getResults
{
    if (pageNo==0)
    {
        [timer invalidate];
        pageNo=60;
        YZMbtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [YZMbtn setTitle:ModuleZW(@"获取验证码") forState:UIControlStateNormal];
        return;
    }
    YZMbtn.titleLabel.font=[UIFont systemFontOfSize:10];
    [YZMbtn setTitle:[NSString stringWithFormat:@"%is%@",pageNo--,ModuleZW(@"后重新发送")] forState:UIControlStateNormal];
}

# pragma mark - 提交按钮
-(void)userfindpasswordButton
{
    if (self.TtempInputsecTF.text.length==0) {
        [self showAlertWarmMessage:ModuleZW(@"临时密码不能为空")];
        return;
    }
    if (self.TtempInputsecTF.text.length<6||self.TtempInputsecTF.text.length>20)
    {
        [self showAlertWarmMessage:ModuleZW(@"请输入6-20位字符，可使用字母，数字或字符组合！")];
        return;
    }
    
    
    if (self.NewInputSecTF.text.length==0) {
        [self showAlertWarmMessage:ModuleZW(@"新密码不能为空")];
        return;
    }
    if (self.NewInputSecTF.text.length<6||self.NewInputSecTF.text.length>20) {
        [self showAlertWarmMessage:ModuleZW(@"请输入6-20位字符，可使用字母，数字或字符组合！")];
        return;
    }
    
    
    if (![self.NewInputSecTF.text isEqualToString:self.TtempInputsecTF.text]) {
        [self showAlertWarmMessage:ModuleZW(@"两次输入的密码不一致")];
        return;
    }
    // NSString* md5str=[UtilityFunc md5:self.AgainInputSecTF.text];
    
  
    NSString *aUrl = @"password/resetPassword.jhtml";
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:self.RepInputphoneTF.text forKey:@"username"];
    [paramDic setObject:self.pYzmTF.text forKey:@"code"];
    [paramDic setObject:self.TtempInputsecTF.text forKey:@"newPassword"];
    [paramDic setObject:timeSp forKey:@"time"];
    
    __weak typeof(self) weakSelf = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:paramDic successBlock:^(id response) {
        id status=[response objectForKey:@"status"];
        if (status!=nil)
        {
            if ([status intValue]==100) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [GlobalCommon showMessage:ModuleZW(@"密码修改成功") duration:2.0];
            }
            else
            {
                [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
                return;
            }
        }
    } failureBlock:^(NSError *error) {
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for(NSInteger i=111;i<115;i++){
        UITextField *field = (UITextField *)[self.view viewWithTag:i];
        [field resignFirstResponder];
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
