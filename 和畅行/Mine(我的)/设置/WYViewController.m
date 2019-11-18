//
//  WYViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/13.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "WYViewController.h"
#import "Global.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import "LoginViewController.h"


@interface WYViewController ()<UITextFieldDelegate,MBProgressHUDDelegate>

@property (nonatomic ,retain) UIView *dishiView;

@end

@implementation WYViewController

- (void)dealloc{
    [super dealloc];
    
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}
-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.label.text = ModuleZW(@"加载中...");
    [progress_ showAnimated:YES];
}

- (void)hudWasHidden
{
    
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    progress_ = nil;
    
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rightBtn.hidden = YES;
    self.leftBtn.hidden = YES;
    
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    self.navTitleLabel.text = ModuleZW(@"修改密码");
    _dishiView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, kScreenSize.width, kScreenSize.height-kNavBarHeight)];
    self.view.backgroundColor = RGB_AppWhite;
    [self.view addSubview:_dishiView];
    UIImageView* userImgView=[[UIImageView alloc] initWithFrame:CGRectMake(Adapter(40), Adapter(25), Adapter(10), Adapter(10))];
    userImgView.image=[UIImage imageNamed:@"ReplaceSec_User.png"];;
    [_dishiView addSubview:userImgView];
    
    UILabel* userNameLb=[[UILabel alloc ] initWithFrame:CGRectMake(userImgView.right + Adapter(10), Adapter(15), Adapter(75), Adapter(30))];
    userNameLb.text=ModuleZW(@"用 户 名:");
    userNameLb.textColor=[UtilityFunc colorWithHexString:@"#9B9B9B"];
    userNameLb.font=[UIFont systemFontOfSize:12];
    [_dishiView addSubview:userNameLb];
    CGRect textRect = [userNameLb.text boundingRectWithSize:CGSizeMake(MAXFLOAT, Adapter(30))
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                    context:nil];
    userNameLb.width = textRect.size.width;
    UILabel* UserName_text_Lb=[[UILabel alloc ] init];
    UserName_text_Lb.frame=CGRectMake(userNameLb.right + Adapter(10), userNameLb.top, ScreenWidth - userNameLb.right - Adapter(50), Adapter(30));
    UserName_text_Lb.textAlignment=0;
    if ([[UserShareOnce shareOnce].name isEqual:[NSNull null]]) {
        
    }
    else
    {
        UserName_text_Lb.text=[NSString stringWithString:[UserShareOnce shareOnce].name];
    }
    UserName_text_Lb.textColor=[UtilityFunc colorWithHexString:@"#c4c4c4"];
    UserName_text_Lb.font=[UIFont systemFontOfSize:12];
    [_dishiView addSubview:UserName_text_Lb];
    
    
    UIImageView* TeleImgView=[[UIImageView alloc] initWithFrame:CGRectMake(Adapter(40), UserName_text_Lb.bottom + Adapter(15), Adapter(10), Adapter(10))];
    TeleImgView.image=[UIImage imageNamed:@"ReplaceSec_Tele.png"];;
    [_dishiView addSubview:TeleImgView];
    
    
    UILabel* TeleNameLb=[[UILabel alloc ] init];
    TeleNameLb.frame=CGRectMake(userNameLb.left,  UserName_text_Lb.bottom + Adapter(5), Adapter(78), Adapter(30));
    TeleNameLb.text=ModuleZW(@"手机号码:");
    TeleNameLb.textColor=[UtilityFunc colorWithHexString:@"#9B9B9B"];
    TeleNameLb.font=[UIFont systemFontOfSize:12];
    [_dishiView addSubview:TeleNameLb];
    CGRect textRect1 = [TeleNameLb.text boundingRectWithSize:CGSizeMake(MAXFLOAT, Adapter(30))
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                    context:nil];
    TeleNameLb.width = textRect1.size.width;
    
    UILabel* TeleName_text_Lb=[[UILabel alloc ] init];
    TeleName_text_Lb.frame=CGRectMake(TeleNameLb.right, TeleNameLb.top, ScreenWidth - TeleNameLb.right - Adapter(50), Adapter(30));
    TeleName_text_Lb.textAlignment=0;
    TeleName_text_Lb.text=[NSString stringWithString:[UserShareOnce shareOnce].username];;
    TeleName_text_Lb.textColor=[UtilityFunc colorWithHexString:@"#c4c4c4"];
    TeleName_text_Lb.font=[UIFont systemFontOfSize:12];
    [_dishiView addSubview:TeleName_text_Lb];
    
    
    
    UIImage *registrationImageTextField = [UIImage imageNamed:@"ReplaceSec_TF_bg.png"];
    //设置手机号框
    UITextField* registrationTF=[[ UITextField alloc] initWithFrame:CGRectMake(Adapter(30), TeleNameLb.bottom + Adapter(10), ScreenWidth - Adapter(60), Adapter(40))];
    registrationTF.borderStyle=UITextBorderStyleNone;
    registrationTF.secureTextEntry=YES;
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, registrationTF.width, registrationTF.height);
    imageLayer.contents = (id) registrationImageTextField.CGImage;
    [registrationTF.layer addSublayer:imageLayer];
    registrationTF.font=[UIFont systemFontOfSize:14];
    
    UIImage* Regist_Tele=[UIImage imageNamed:@"ReplaceSec_FSec.png"];
    CGRect frame = [registrationTF frame];  //为你定义的UITextField
    frame.size.width = Adapter(40);
    UIImageView* RegistImgView=[[UIImageView alloc] initWithFrame:CGRectMake(Adapter(15), Adapter(15), Adapter(10), Adapter(10))];
    RegistImgView.image=Regist_Tele;
    UIView *leftview1 = [[UIView alloc] initWithFrame:frame];
    [leftview1 addSubview:RegistImgView];
    registrationTF.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    registrationTF.leftView = leftview1;
    registrationTF.delegate=self;
    registrationTF.placeholder=ModuleZW(@"请输入原密码");
    registrationTF.returnKeyType=UIReturnKeyNext;
    self.OriginalSec_TF=registrationTF;
    [_dishiView addSubview:registrationTF];
    
    
    //设置密码框
    UITextField* Regist_Sec_TF=[[ UITextField alloc] init];
    Regist_Sec_TF.frame=CGRectMake(Adapter(30), registrationTF.bottom + Adapter(10), registrationTF.width, registrationTF.height);
    Regist_Sec_TF.borderStyle=UITextBorderStyleNone;
    CALayer *SecimageLayer = [CALayer layer];
    SecimageLayer.frame = CGRectMake(0, 0, registrationTF.width, registrationTF.height);
    SecimageLayer.contents = (id) registrationImageTextField.CGImage;
    [Regist_Sec_TF.layer addSublayer:SecimageLayer];
    Regist_Sec_TF.font=[UIFont systemFontOfSize:14];
    Regist_Sec_TF.returnKeyType=UIReturnKeyNext;
    UIImage* Regist_Sec=[UIImage imageNamed:@"ReplaceSec_NSec.png"];
    CGRect frame_sec = [Regist_Sec_TF frame];
    frame_sec.size.width = Adapter(40);
    UIImageView* Regist_sec_ImgView=[[UIImageView alloc] initWithFrame:CGRectMake(Adapter(15), Adapter(15), Adapter(10), Adapter(10))];
    Regist_sec_ImgView.image=Regist_Sec;
    UIView *left_secview = [[UIView alloc] initWithFrame:frame_sec];
    [left_secview addSubview:Regist_sec_ImgView];
    Regist_Sec_TF.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    Regist_Sec_TF.leftView = left_secview;
    Regist_Sec_TF.secureTextEntry=YES;
    Regist_Sec_TF.delegate=self;
    Regist_Sec_TF.placeholder=ModuleZW(@"请输入新密码");
    self.NewSec_TF=Regist_Sec_TF;
    [_dishiView addSubview:Regist_Sec_TF];
    
    
    UITextField* sureSecTF=[[ UITextField alloc] init];
    sureSecTF.frame=CGRectMake(Adapter(30), Regist_Sec_TF.bottom + Adapter(10),Regist_Sec_TF.width,Regist_Sec_TF.height);
    sureSecTF.borderStyle=UITextBorderStyleNone;
    
    CALayer *Sure_SecimageLayer = [CALayer layer];
    Sure_SecimageLayer.frame = CGRectMake(0, 0, registrationTF.width, registrationTF.height);
    Sure_SecimageLayer.contents = (id) registrationImageTextField.CGImage;
    [sureSecTF.layer addSublayer:Sure_SecimageLayer];
    
    sureSecTF.font=[UIFont systemFontOfSize:14];
    sureSecTF.delegate=self;
    
    UIImage* Regist_Sure_Sec=[UIImage imageNamed:@"ReplaceSec_NSecS.png"];
    CGRect frame__Sure_sec = [sureSecTF frame];
    frame__Sure_sec.size.width =Adapter(40);
    UIImageView* Regist_Sure_sec_ImgView=[[UIImageView alloc] initWithFrame:CGRectMake(Adapter(15), Adapter(15), Adapter(10), Adapter(10))];
    Regist_Sure_sec_ImgView.image=Regist_Sure_Sec;
    UIView *left_Sure_secview = [[UIView alloc] initWithFrame:frame__Sure_sec];
    [left_Sure_secview addSubview:Regist_Sure_sec_ImgView];
    sureSecTF.leftViewMode = UITextFieldViewModeAlways;
    sureSecTF.leftView = left_Sure_secview;
    sureSecTF.returnKeyType=UIReturnKeyDone;
    sureSecTF.secureTextEntry=YES;
    sureSecTF.placeholder=ModuleZW(@"请确认新密码");
    self.NewSure_TF=sureSecTF;
    [_dishiView addSubview:sureSecTF];
    
    UIButton *findpsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *findImg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"ReplaceSec_BTN" ofType:@"png"]];
    [findpsButton setTitle:ModuleZW(@"确认修改") forState:UIControlStateNormal];
    [findpsButton setBackgroundColor:UIColorFromHex(0x1e82d2)];
    findpsButton.layer.cornerRadius = 5.0;
    findpsButton.clipsToBounds = YES;
    //[findpsButton setImage:findImg forState:UIControlStateNormal];
    findpsButton.frame=CGRectMake(Adapter(30),sureSecTF.bottom + Adapter(20),sureSecTF.width,sureSecTF.height);
    [findpsButton addTarget:self action:@selector(userfindpasswordButton) forControlEvents:UIControlEventTouchUpInside];
    [_dishiView addSubview:findpsButton];
    ptCenter=self.view.center;
}

-(void)userfindpasswordButton
{
    
    
    if (self.OriginalSec_TF.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"原密码不能为空") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        [av show];
        return;
    }
    if (self.OriginalSec_TF.text.length<6||self.OriginalSec_TF.text.length>20)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"请输入6-20位字符，可使用字母，数字或字符组合!") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        [av show];
        return;
    }
    
    if (![self.OriginalSec_TF.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"loginPassword"]])
    {
        NSLog(@"%@",[UserShareOnce shareOnce].passWord);
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"输入原密码不正确") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        [av show];
        return;
    }
    
    if (self.NewSec_TF.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"确认密码不能为空") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        [av show];
        return;
    }
    if (self.NewSec_TF.text.length<6||self.NewSec_TF.text.length>20) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"请输入6-20位字符，可使用字母，数字或字符组合!") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        [av show];
        return;
    }
    
    
    if (![self.NewSec_TF.text isEqualToString:self.NewSure_TF.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"两次输入的密码不一致") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        [av show];
        return;
    }
    [ self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/memberModifi/reset.jhtml",UrlPre];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [request setPostValue:self.OriginalSec_TF.text forKey:@"password"];
    [request setPostValue:self.NewSec_TF.text forKey:@"newPassword1"];
    [request setPostValue:self.NewSure_TF.text forKey:@"newPassword2"];
    [request setPostValue:[UserShareOnce shareOnce].JSESSIONID forKey:@"JSESSIONID"];
    [request setPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setPostValue:timeSp forKey:@"time"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFindPassError:)];
    [request setDidFinishSelector:@selector(requestFindPassCompleted:)];
    [request startAsynchronous];
}


- (void)requestFindPassError:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"抱歉修改密码失败，请重试") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
    [av show];
    return;
}
- (void)requestFindPassCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    if (status!=nil)
    {
        if ([status intValue]==100) {
            id data=[dic objectForKey:@"data"];
            [[NSUserDefaults standardUserDefaults] setObject:self.NewSec_TF.text forKey:@"loginPassword"];
            NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
            if (dicTmp) {
                [dicTmp setObject:self.NewSec_TF.text forKey:@"PASSWORDAES"];
                [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
            }
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:data delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
            [av show];
            av.tag=10003;
            return;
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"登录超时，请重新登录") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
            av.tag = 100008;
            [av show];
        }
    }
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==100008)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    if (alertView.tag==10003)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)UserReplaceActive:(id)sender
{
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.NewSure_TF)
    {
       // [self performSelector:@selector(resizeViewForInput:) withObject:textField];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==self.OriginalSec_TF)
    {
        [self.NewSec_TF becomeFirstResponder];
    }
    if (textField==self.NewSec_TF) {
        [self.NewSure_TF becomeFirstResponder];
    }
    
    if (textField==self.NewSure_TF) {
        [textField resignFirstResponder];
        [self restoreView];
    }
    
    return YES;
}
-(void)resizeViewForInput:(id)sender
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-60,width,height);
    _dishiView.frame=rect;
    [UIView commitAnimations];
}
-(void)restoreView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    CGRect rect=CGRectMake(0.0f,0,width,height);
    _dishiView.frame=rect;
    //  NSLog(@"%f %f %f %f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
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
