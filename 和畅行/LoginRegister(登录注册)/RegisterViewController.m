//
//  RegisterViewController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/4.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegistrationNoteController.h"
#import "IXAttributeTapLabel.h"
#import <SafariServices/SafariServices.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

#define margin 40

@interface RegisterViewController ()<SFSafariViewControllerDelegate>

@end

@implementation RegisterViewController
@synthesize pregistrationTF;
@synthesize pRegist_Sec_TF;
@synthesize pSecTF;
@synthesize pSureTF;
@synthesize pYzmTF;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    navView.backgroundColor = UIColorFromHex(0x009ef3);
    titleLabel.text = @"注册";
    [self addBackBtn];
    
   // [self addTitleWith:@"注册"];
    
    
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
    
    registrationTF.delegate=self;
    registrationTF.placeholder=@"请输入您的手机号";
    registrationTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    registrationTF.returnKeyType=UIReturnKeyNext;
    self.pregistrationTF=registrationTF;
    [self.view addSubview:self.pregistrationTF];
   
    
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
    Regist_Sec_TF.secureTextEntry=YES;
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
    Regist_Sec_TF.placeholder=@"请输入您的密码";
    self.pRegist_Sec_TF=Regist_Sec_TF;
    [self.view addSubview:Regist_Sec_TF];
   
    
    
    UITextField* sureSecTF=[[ UITextField alloc] init];
    sureSecTF.frame=CGRectMake(leftX, Regist_Sec_TF.frame.origin.y+Regist_Sec_TF.frame.size.height+8, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    sureSecTF.borderStyle=UITextBorderStyleNone;
    sureSecTF.secureTextEntry=YES;
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
    
    sureSecTF.returnKeyType=UIReturnKeyNext;
    sureSecTF.placeholder=@"请确认您的密码";
    self.pSureTF=sureSecTF;
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
    YZMTF.delegate = self;
    YZMTF.placeholder=@"请输入手机验证码";
    YZMTF.returnKeyType=UIReturnKeyDone;
    self.pYzmTF=YZMTF;
    [self.view addSubview:YZMTF];
    
    
    //
    UIImage* ObtainYzm_img=[UIImage imageNamed:@"Regist_YZM"];
    UIButton *YZMButton=[UIButton buttonWithType:UIButtonTypeCustom];
    YZMButton.frame=CGRectMake(YZMTF.frame.origin.x+YZMTF.frame.size.width+23.5,  sureSecTF.frame.origin.y+sureSecTF.frame.size.height+8, ObtainYzm_img.size.width/2,ObtainYzm_img.size.height/2);
    // [YZMButton setImage:ObtainYzm_img forState:UIControlStateNormal];
    [YZMButton setBackgroundImage:ObtainYzm_img forState:UIControlStateNormal];
    [YZMButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [YZMButton addTarget:self action:@selector(userYZMButton) forControlEvents:UIControlEventTouchUpInside];
    [YZMButton setTitleColor:[UIColor colorWithRed:112.0f/255.0f green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    YZMButton.titleLabel.font=[UIFont systemFontOfSize:13];
    YZMbtn=YZMButton;
    [self.view addSubview:YZMbtn];
    
    
    
    
    UIImage* tongyiImg=[UIImage imageNamed:@"checkboxyes.png"];
    UIButton* istongyi=[UIButton buttonWithType:UIButtonTypeCustom];
    [istongyi setImage:tongyiImg forState:UIControlStateNormal];
    [istongyi addTarget:self action:@selector(userisagreenButton:) forControlEvents:UIControlEventTouchUpInside];
    istongyi.frame=CGRectMake(leftX, YZMButton.frame.origin.y+YZMButton.frame.size.height+19, tongyiImg.size.width/2, tongyiImg.size.height/2);
    
    [self.view addSubview:istongyi];
    
    
    NSString    * str =  @"我已阅读并同意\"服务条款\"和\"隐私政策\"";
    
    IXAttributeTapLabel * label = [[IXAttributeTapLabel alloc] initWithFrame:CGRectMake(istongyi.frame.origin.x+istongyi.frame.size.width+11, YZMButton.frame.origin.y+YZMButton.frame.size.height+18, 260, 21)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    //文本点击回调
    __strong typeof(self) weakSelf = self;
    label.tapBlock = ^(NSString *string) {
        if([string isEqualToString:@"\"服务条款\""]){
            [weakSelf isagreenButton];
        }else{
            [weakSelf safariControllerAction];
        }
    };
    
    //设置需要点击的字符串，并配置此字符串的样式及位置
    IXAttributeModel    * model = [IXAttributeModel new];
    model.range = [str rangeOfString:@"\"服务条款\""];
    model.string = @"\"服务条款\"";
    //model.alertImg = [UIImage imageNamed:@"alert"];
    if (@available(iOS 10.0, *)) {
        model.attributeDic = @{NSForegroundColorAttributeName : [UIColor colorWithDisplayP3Red:80/255.0 green:158/255.0 blue:247/255.0 alpha:1.0]};
    } else {
        model.attributeDic = @{NSForegroundColorAttributeName : [UIColor colorWithRed:80/255.0 green:158/255.0 blue:247/255.0 alpha:1.0]};
        // Fallback on earlier versions
    }
    
    IXAttributeModel    * model1 = [IXAttributeModel new];
    model1.range = [str rangeOfString:@"\"隐私政策\""];
    model1.string = @"\"隐私政策\"";
    if (@available(iOS 10.0, *)) {
        model1.attributeDic = @{NSForegroundColorAttributeName : [UIColor colorWithDisplayP3Red:80/255.0 green:158/255.0 blue:247/255.0 alpha:1.0]};
    } else {
        model.attributeDic = @{NSForegroundColorAttributeName : [UIColor colorWithRed:80/255.0 green:158/255.0 blue:247/255.0 alpha:1.0]};
        // Fallback on earlier versions
    }
    
    //label内容赋值
    [label setText:str attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}
    tapStringArray:@[model,model1]];
    
    [self.view addSubview:label];
    
//    UIButton* agreenxieyi=[UIButton buttonWithType:UIButtonTypeCustom];
//    agreenxieyi.frame=CGRectMake(istongyi.frame.origin.x+istongyi.frame.size.width+11, YZMButton.frame.origin.y+YZMButton.frame.size.height+18, 200, 21);
//    [agreenxieyi setTitleColor:[UtilityFunc colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
//    [agreenxieyi addTarget:self action:@selector(isagreenButton) forControlEvents:UIControlEventTouchUpInside];
//    [agreenxieyi setTitle:@"我已阅读并同意和畅依....条款" forState:UIControlStateNormal];
//    agreenxieyi.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
//    agreenxieyi.titleLabel.font=[UIFont systemFontOfSize:13];
//    [self.view addSubview:agreenxieyi];
    
    UIButton *RegistrationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *ReplacementImg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Regist_btn" ofType:@"png"]];
    [RegistrationButton setImage:ReplacementImg forState:UIControlStateNormal];
    
    RegistrationButton.frame=CGRectMake((ScreenWidth-ReplacementImg.size.width/2)/2,istongyi.frame.origin.y+istongyi.frame.size.height+19, ReplacementImg.size.width/2,ReplacementImg.size.height/2);
    [RegistrationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [RegistrationButton setTitleShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f] forState:UIControlStateNormal];
    RegistrationButton.titleLabel.shadowOffset=CGSizeMake(0.0f, -1.0f);
    [RegistrationButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [RegistrationButton addTarget:self action:@selector(userRegistrationButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:RegistrationButton];
    
    pageNo=300;
    STtimeer=60;
    isagreen=YES;
    ptCenter= self.view.center;
   
}

- (void)safariControllerAction
{
    
    SFSafariViewController *sfVC = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://eky3h.com/hcx-policy.html"]];
    sfVC.delegate = self;
    [self.navigationController presentViewController:sfVC animated:YES completion:nil];
}

# pragma mark - 方框按钮
-(void)userisagreenButton:(id)sender
{
    UIButton* btn=(UIButton *)sender;
    if (isagreen==YES) {
        isagreen=NO;
        [btn setImage:[UIImage imageNamed:@"checkboxno.png"] forState:UIControlStateNormal];
    }
    else
    {
        isagreen=YES;
        [btn setImage:[UIImage imageNamed:@"checkboxyes.png"] forState:UIControlStateNormal];
    }
}

# pragma mark - 阅读条款
- (void)isagreenButton
{
    RegistrationNoteController *vc = [[RegistrationNoteController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark - 获取验证码
-(void)userYZMButton
{
    if (self.pregistrationTF.text.length==0) {
        
        [self showAlertWarmMessage:@"登录手机号不能为空"];
        return;
    }
 
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/register/captcha.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    /**
     *  MD5加密后的字符串
     */
    NSString *iPoneNumber = [NSString stringWithFormat:@"%@",self.pregistrationTF.text];
    NSString *iPoneNumberMD5 = [GlobalCommon md5:iPoneNumber];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setPostValue:self.pregistrationTF.text forKey:@"username"];
    [request setPostValue:iPoneNumberMD5 forKey:@"UserPhoneKey"];
    
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestYZMError:)];
    [request setDidFinishSelector:@selector(requestYZMCompleted:)];
    [request startAsynchronous];
    
    /*
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:self.pregistrationTF.text forKey:@"username"];
    [paramDic setObject:md5str forKey:@"UserPhoneKey"];

    __weak typeof(self) weakSelf = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:paramDic successBlock:^(id response) {
        id status=[response objectForKey:@"status"];
        if (status!=nil)
        {
            if ([status intValue]==100) {
                
                //[self.pYzmTF setText:[NSString stringWithString:[dic objectForKey:@"data"]]];
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

-(void)getResults
{
    if (pageNo==0)
    {
        [timer invalidate];
        pageNo=300;
        YZMbtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [YZMbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    YZMbtn.titleLabel.font=[UIFont systemFontOfSize:7];
    [YZMbtn setTitle:[NSString stringWithFormat:@"请在%i秒内输入验证码",pageNo--] forState:UIControlStateNormal];
}

- (void)requestYZMError:(ASIHTTPRequest *)request
{
    [self showAlertWarmMessage:@"短信验证码发送失败，请重试"];
    return;
}
- (void)requestYZMCompleted:(ASIHTTPRequest *)request
{
    
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    if (status!=nil)
    {
        if ([status intValue]==100) {
            
            YZMcode= [NSString stringWithString:[dic objectForKey:@"data"]];//;
            timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(getResults)
                                                 userInfo:nil
                                                  repeats:YES];
        }
        else{
            
            NSString *str = [dic objectForKey:@"data"];
            [self showAlertWarmMessage:str];
            
        }
    }
    else
    {
        [self showAlertWarmMessage:@"短信验证码发送失败，请重试"];
        
        return;
        
    }
}


-(void)userRegistrationButton
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSString* widthheight=[NSString stringWithFormat:@"%d*%d",(int)width,(int)height ];
    NSString* devicesname = @"";
    
    
    if (self.pregistrationTF.text.length==0) {
        
        [self showAlertWarmMessage:@"登录手机号不能为空"];
        return;
    }
    if (self.pregistrationTF.text.length<11) {
        
        [self showAlertWarmMessage:@"手机号格式错误，请正确输入您的手机号码"];
        return;
    }
    if (self.pRegist_Sec_TF.text.length==0) {
        
        [self showAlertWarmMessage:@"密码设置不能为空"];
        return;
    }
    if (self.pRegist_Sec_TF.text.length<6||self.pSecTF.text.length>20) {
        
        [self showAlertWarmMessage:@"请输入6-20位字符，可使用字母，数字或字符组合!"];
        return;
    }
    if (self.pSureTF.text.length==0) {
        [self showAlertWarmMessage:@"密码确认不能为空"];
        return;
    }
    if (self.pSureTF.text.length<6||self.pSureTF.text.length>20) {
        
        [self showAlertWarmMessage:@"请输入6-20位字符，可使用字母，数字或字符组合！"];
        return;
    }
    if (![self.pRegist_Sec_TF.text isEqualToString:self.pSureTF.text]) {
        [self showAlertWarmMessage:@"两次输入的密码不一致"];
        return;
    }
    if (self.pYzmTF.text.length==0) {
        [self showAlertWarmMessage:@"请获取注册码"];
        return;
    }
    else
    {
        
    }
    
    if (!isagreen) {
        [self showAlertWarmMessage:@"请阅读条款... ..."];
        return;
    }
    
  
    NSString *aUrl = @"register/commit.jhtml";
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:@"beta1.4" forKey:@"softver"];
    [paramDic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osver"];
    [paramDic setObject:widthheight forKey:@"resolution"];
    [paramDic setObject:self.pRegist_Sec_TF.text forKey:@"password"];
    [paramDic setObject:self.pSureTF.text forKey:@"password2"];
    [paramDic setObject:devicesname forKey:@"brand"];
    [paramDic setObject:self.pYzmTF.text forKey:@"code"];
    [paramDic setObject:@"" forKey:@"devmodel"];
    [paramDic setObject:self.pregistrationTF.text forKey:@"username"];
    
    __weak typeof(self) weakSelf = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:paramDic successBlock:^(id response) {
        id status=[response objectForKey:@"status"];
        if(status!=nil){
            if([status intValue] == 100){
                [weakSelf userLogin];
            }else{
                [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
            }
        }
    } failureBlock:^(NSError *error) {
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
}

- (void)userLogin
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSString* widthheight=[NSString stringWithFormat:@"%d*%d",(int)width,(int)height ];
    
    NSString* devicesname=@"iPhone 7";
    
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:@"beta1.4" forKey:@"softver"];
    [paramDic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osver"];
    [paramDic setObject:widthheight forKey:@"resolution"];
    [paramDic setObject:self.pRegist_Sec_TF.text forKey:@"password"];
    [paramDic setObject:devicesname forKey:@"brand"];
    [paramDic setObject:timeSp forKey:@"time"];
    [paramDic setObject:@"" forKey:@"devmodel"];
    [paramDic setObject:self.pregistrationTF.text forKey:@"username"];
    
//    [self userLoginWithParams:paramDic withisCheck:YES];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.pYzmTF)
    {
        [self performSelector:@selector(resizeViewForInput:) withObject:textField];
    }
}
-(void)resizeViewForInput:(id)sender
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.center = CGPointMake(ptCenter.x, ptCenter.y-50);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==self.pregistrationTF)
    {
        [self.pRegist_Sec_TF becomeFirstResponder];
    }
    if (textField==self.pRegist_Sec_TF) {
        [self.pSureTF becomeFirstResponder];
    }
    if (textField == self.pSureTF) {
        [self.pYzmTF becomeFirstResponder];
    }
    if (textField==self.pYzmTF) {
        [textField resignFirstResponder];
        [self restoreView];
    }
    
    return YES;
}

-(void)restoreView
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    self.view.center = CGPointMake(ptCenter.x, ptCenter.y);
    [UIView commitAnimations];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
