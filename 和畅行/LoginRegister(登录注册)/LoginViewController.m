//
//  LoginViewController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/4.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "CustomNavigationController.h"
#import "ChildMemberModel.h"
#import "HomePageController.h"
#import "FindPassWordController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

#define margin 40
#define leftOrigin 40

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //titleLabel.text = @"登录";
    navView.bottom = YES;
    [self addRightBtn];
    
    [self initWithUI];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initWithUI
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-110)/2.0, kNavBarHeight+30, 110, 77)];
    imageV.image = [UIImage imageNamed:@"和畅logo"];
    [self.view addSubview:imageV];
    
    UILabel *welcomLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftOrigin, ScreenHeight/3.0, 200, 40)];
    welcomLabel.font = [UIFont systemFontOfSize:22];
    welcomLabel.textAlignment = NSTextAlignmentLeft;
    welcomLabel.textColor = UIColorFromHex(0X0e0e0e);
    welcomLabel.text = @"欢迎登录";
    [self.view addSubview:welcomLabel];
    
    userNameBox=[[UITextField alloc] init];
    userNameBox.frame=CGRectMake(welcomLabel.left, welcomLabel.bottom+10, 200 ,30 );
    userNameBox.borderStyle=UITextBorderStyleNone;
    userNameBox.returnKeyType=UIReturnKeyNext;
    userNameBox.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    userNameBox.clearButtonMode=UITextFieldViewModeWhileEditing;
    userNameBox.delegate=self;
    userNameBox.font=[UIFont systemFontOfSize:13.0];
    userNameBox.placeholder=@"  请输入手机号";
    [self.view addSubview:userNameBox];
    
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(welcomLabel.left, userNameBox.bottom+2, ScreenWidth-welcomLabel.left*2, 1)];
    imageV2.backgroundColor = UIColorFromHex(0X1E82D2);
    [self.view addSubview:imageV2];
    
    passWordBox=[[UITextField alloc]init];
    passWordBox.frame=CGRectMake(welcomLabel.left, imageV2.bottom+10, 200 ,userNameBox.height );
    passWordBox.secureTextEntry=YES;
    passWordBox.clearButtonMode=UITextFieldViewModeWhileEditing;
    passWordBox.delegate = self;
    passWordBox.font=[UIFont systemFontOfSize:13.0];
    passWordBox.placeholder=@"  请输入验证码";
    passWordBox.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:passWordBox];
    
    UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(welcomLabel.left, passWordBox.bottom+2, imageV2.width, 1)];
    imageV3.backgroundColor = UIColorFromHex(0X1E82D2);
    [self.view addSubview:imageV3];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(imageV3.right-80, passWordBox.top, 80, passWordBox.height);
    rightBtn.tag = 2018;
    [rightBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    userNameBox.width = rightBtn.left-userNameBox.left;
    passWordBox.width = userNameBox.width;
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(welcomLabel.left, imageV3.bottom+25, imageV3.width, 44);
    loginBtn.layer.cornerRadius = 22.0;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = UIColorFromHex(0x1e82d2);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [loginBtn setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    UIButton *switchLoginType = [UIButton buttonWithType:UIButtonTypeCustom];
    switchLoginType.frame = CGRectMake(welcomLabel.left, loginBtn.bottom+10, 140, 30);
    [switchLoginType addTarget:self action:@selector(switchLoginTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    switchLoginType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [switchLoginType setTitle:@"账户密码登录" forState:UIControlStateNormal];
    switchLoginType.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [switchLoginType setTitleColor:UIColorFromHex(0xb8b8b8) forState:UIControlStateNormal];
    [self.view addSubview:switchLoginType];
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(imageV3.right-80, switchLoginType.top, 80, 30);
    [registBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    registBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [registBtn setTitleColor:UIColorFromHex(0xb8b8b8) forState:UIControlStateNormal];
    [self.view addSubview:registBtn];
    
    
    
    
    UILabel *otherLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-100)/2.0, registBtn.bottom+30, 100, 30)];
    otherLoginLabel.font = [UIFont systemFontOfSize:14];
    otherLoginLabel.textAlignment = NSTextAlignmentCenter;
    otherLoginLabel.textColor = UIColorFromHex(0xcecece);
    otherLoginLabel.text = @"其他登录方式";
    [self.view addSubview:otherLoginLabel];
    
    UIImageView *imageV4 = [[UIImageView alloc] initWithFrame:CGRectMake(otherLoginLabel.left-80, otherLoginLabel.top+otherLoginLabel.height/2.0, 80, 1)];
    imageV4.backgroundColor = UIColorFromHex(0xb8b8b8);
    [self.view addSubview:imageV4];
    
    UIImageView *imageV5 = [[UIImageView alloc] initWithFrame:CGRectMake(otherLoginLabel.right, imageV4.top, imageV4.width, 1)];
    imageV5.backgroundColor = UIColorFromHex(0xb8b8b8);
    [self.view addSubview:imageV5];
    
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake((ScreenWidth-40)/2.0, otherLoginLabel.bottom+20, 40, 40);
    [weixinBtn setImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    
    //从本地查找用户
    NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
    NSString* strcheck=[dicTmp objectForKey:@"ischeck"];
    if ([strcheck isEqualToString:@"1"])
    {
        isCheck=YES;
        userNameBox.text=[dicTmp objectForKey:@"USERNAME"];
        passWordBox.text=[dicTmp objectForKey:@"PASSWORDAES"];
        if(userNameBox.text.length>0&&passWordBox.text.length>0)
        {
            // [self userLogin ];
        }
    }
    else
    {
        isCheck=YES;
    }
}

# pragma mark - 账户密码登录
- (void)switchLoginTypeAction:(UIButton *)button
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:2018];
    
    if([button.titleLabel.text isEqualToString:@"账户密码登录"]){
        [button setTitle:@"短信验证码登录" forState:UIControlStateNormal];
        userNameBox.placeholder = @"  请输入和畅账户";
        passWordBox.placeholder = @"  请输入密码";
        [btn setTitle:@"忘记密码" forState:UIControlStateNormal];
    }else if ([button.titleLabel.text isEqualToString:@"短信验证码登录"]){
         //button.titleLabel.text = @"账户密码登录";
        userNameBox.placeholder = @"  请输入手机号";
        passWordBox.placeholder = @"  请输入验证码";
        [button setTitle:@"账户密码登录" forState:UIControlStateNormal];
        [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)rightBtnAction:(UIButton *)button
{
    if([button.titleLabel.text isEqualToString:@"获取验证码"]){
        [self userYZMButton];
    }else if ([button.titleLabel.text isEqualToString:@"忘记密码"]){
        [self FoggetActive:nil];
    }
}

# pragma mark - 微信登录
- (void)weixinBtnAction
{
    
}

# pragma mark - 获取验证码
-(void)userYZMButton
{
    if (userNameBox.text.length==0) {
        
        [self showAlertWarmMessage:@"登录手机号不能为空"];
        return;
    }
    
    NSString *aUrl = [NSString stringWithFormat:@"%@/register/captcha.jhtml",URL_PRE];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    /**
     *  MD5加密后的字符串
     */
    NSString *iPoneNumber = [NSString stringWithFormat:@"%@xinxijishubu",userNameBox.text];
    NSString *iPoneNumberMD5 = [self md5:iPoneNumber];
    
    [request setPostValue:userNameBox.text forKey:@"username"];
    [request setPostValue:iPoneNumberMD5 forKey:@"UserPhoneKey"];
    
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestYZMError:)];
    [request setDidFinishSelector:@selector(requestYZMCompleted:)];
    [request startAsynchronous];
    
}

-(void)getResults
{
    UIButton *YZMbtn = (UIButton *)[self.view viewWithTag:2018];
    
    if (pageNo==0)
    {
        [timer invalidate];
        pageNo=300;
        YZMbtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [YZMbtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        return;
    }
    YZMbtn.titleLabel.font=[UIFont systemFontOfSize:7];
    [YZMbtn setTitle:[NSString stringWithFormat:@"%i秒内重新发送",pageNo--] forState:UIControlStateNormal];
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

- (void)initViewControl{
    
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    //[self setNaviBarTitle:@"登录"];
    
    UIButton* ReginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ReginBtn.frame=CGRectMake(0, 0, 60, 44);
    [ReginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [ReginBtn setTitle:@"注册" forState:UIControlStateNormal];
    ReginBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [ReginBtn addTarget:self action:@selector(userRegistrationButton) forControlEvents:UIControlEventTouchUpInside];
    ReginBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //[self setNaviBarRightBtn:ReginBtn];
    
    UIImage* LoginUserBg=[UIImage imageNamed:@"LoginUser_bg.png"];
    UIImageView *viewbg_ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,LoginUserBg.size.width/2,LoginUserBg.size.height/2)];
    [viewbg_ImgView setImage:LoginUserBg];
    
    UIView* userView=[[UIView alloc] init];
    userView.frame=CGRectMake(margin,kNavBarHeight+27,LoginUserBg.size.width/2,LoginUserBg.size.height/2);
    [userView addSubview:viewbg_ImgView];
    [self.view addSubview:userView];
   
    
    [userView addSubview:viewbg_ImgView];
    
    
    UIImage * Loginimage=[UIImage imageNamed:@"LoginUser.png"];
    UIImageView *viewbgImgView = [[UIImageView alloc] initWithFrame:CGRectMake((userView.frame.size.width-Loginimage.size.width/2)/2,(userView.frame.size.height-Loginimage.size.height/2)/2,Loginimage.size.width/2,Loginimage.size.height/2)];
    [viewbgImgView setImage:Loginimage];
    [userView addSubview:viewbgImgView];
    
    
    UIImage* UserBoxImg=[UIImage imageNamed:@"UserBoxImg.png"];
    userNameBox=[[UITextField alloc] init];
   userNameBox.frame=CGRectMake(userView.frame.origin.x+userView.frame.size.width, userView.frame.origin.y, ScreenWidth-margin-userView.right , UserBoxImg.size.height/2);
    userNameBox.borderStyle=UITextBorderStyleNone;
    CALayer *ImageUserNameLayer = [CALayer layer];
    ImageUserNameLayer.frame = CGRectMake(0, 0, userNameBox.width, UserBoxImg.size.height/2);
    ImageUserNameLayer.contents = (id) UserBoxImg.CGImage;
    [userNameBox.layer addSublayer:ImageUserNameLayer];
    userNameBox.returnKeyType=UIReturnKeyNext;
    userNameBox.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    userNameBox.clearButtonMode=UITextFieldViewModeWhileEditing;
    userNameBox.delegate=self;
    userNameBox.tag=20;
    userNameBox.placeholder=@"  请输入用户名";
    [self.view addSubview:userNameBox];
    
    UIImage* LoginPassWordBg=[UIImage imageNamed:@"LoginUser_bg.png"];
    UIImageView *Passviewbg_ImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,LoginPassWordBg.size.width/2,LoginPassWordBg.size.height/2)];
    [Passviewbg_ImgView setImage:LoginPassWordBg];
    
    UIView* PassWordView=[[UIView alloc] init];
 PassWordView.frame=CGRectMake(margin,userView.frame.origin.y+userView.frame.size.height+8,LoginPassWordBg.size.width/2,LoginPassWordBg.size.height/2);
    [PassWordView addSubview:Passviewbg_ImgView];
    [self.view addSubview:PassWordView];
    
    
    [PassWordView addSubview:Passviewbg_ImgView];
    
    UIImage * PassWordimage=[UIImage imageNamed:@"LoginPassWord.png"];
    UIImageView *PassWordImgView = [[UIImageView alloc] initWithFrame:CGRectMake((PassWordView.frame.size.width-PassWordimage.size.width/2)/2,(PassWordView.frame.size.height-PassWordimage.size.height/2)/2,PassWordimage.size.width/2,PassWordimage.size.height/2)];
    [PassWordImgView setImage:PassWordimage];
    [PassWordView addSubview:PassWordImgView];
    
    
    
    passWordBox=[[UITextField alloc]init];
    passWordBox.secureTextEntry=YES;
    passWordBox.clearButtonMode=UITextFieldViewModeWhileEditing;
 passWordBox.frame=CGRectMake(PassWordView.frame.origin.x+PassWordView.frame.size.width, userNameBox.frame.origin.y+userNameBox.frame.size.height+8, userNameBox.width, UserBoxImg.size.height/2);
    passWordBox.borderStyle=UITextBorderStyleNone;
    CALayer *ImagePassWordLayer = [CALayer layer];
    ImagePassWordLayer.frame = CGRectMake(0, 0, userNameBox.width, UserBoxImg.size.height/2);
    ImagePassWordLayer.contents = (id) UserBoxImg.CGImage;
    [passWordBox.layer addSublayer:ImagePassWordLayer];
    passWordBox.delegate = self;
    passWordBox.tag=21;
    passWordBox.placeholder=@"  请输入密码";
    passWordBox.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:passWordBox];
    
    
    UIImage* CheckBoxImg=[UIImage imageNamed:@"checkboxyes.png"];
    isPush = YES;
    UIButton* CheckBoxBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [CheckBoxBtn setFrame:CGRectMake(margin, passWordBox.frame.origin.y+passWordBox.frame.size.height+15.5, 20, 20)];
    
    [CheckBoxBtn setImage:CheckBoxImg forState:UIControlStateNormal];
    [CheckBoxBtn addTarget:self action:@selector(CheckActive:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:CheckBoxBtn];
    
    
    
    UILabel* checkLable=[[UILabel alloc] init];
    checkLable.frame=CGRectMake(CheckBoxBtn.frame.origin.x+CheckBoxBtn.frame.size.width+10, CheckBoxBtn.frame.origin.y, 60, 21);
    checkLable.text=@"记住我";
    checkLable.textColor=[UtilityFunc colorWithHexString:@"#9b9b9b"];
    checkLable.font=[UIFont systemFontOfSize:13];
    [self.view addSubview:checkLable];
    
    
    UIButton* ForgetBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    ForgetBtn.frame=CGRectMake(ScreenWidth-margin-120, CheckBoxBtn.frame.origin.y, 120, 21);
    [ForgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    ForgetBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    ForgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [ForgetBtn addTarget:self action:@selector(FoggetActive:) forControlEvents:UIControlEventTouchUpInside];
    
    [ForgetBtn setTitleColor:[UtilityFunc colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
    [self.view addSubview:ForgetBtn];
    
    UIImage* LoginBtnImg=[UIImage imageNamed:@"LoginBtn.png"];
    UIButton* LoginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    LoginBtn.frame=CGRectMake(margin, passWordBox.frame.origin.y+passWordBox.frame.size.height+46, ScreenWidth-margin*2, LoginBtnImg.size.height/2);
    [LoginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [LoginBtn setImage:LoginBtnImg forState:UIControlStateNormal];
    [self.view addSubview:LoginBtn];
    
    if (!self.isChangeUser) {
        //从本地查找用户
        NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
        NSString* strcheck=[dicTmp objectForKey:@"ischeck"];
        if ([strcheck isEqualToString:@"1"])
        {
            UIImage* CheckBoxImg=[UIImage imageNamed:@"checkboxyes.png"];
            [CheckBoxBtn setImage:CheckBoxImg forState:UIControlStateNormal];
            isCheck=YES;
            userNameBox.text=[dicTmp objectForKey:@"USERNAME"];
            passWordBox.text=[dicTmp objectForKey:@"PASSWORDAES"];
            if(userNameBox.text.length>0&&passWordBox.text.length>0)
            {
               // [self userLogin ];
            }
        }
        else
        {
            isCheck=YES;
        }
    }
    
}

-(void) CheckActive:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    
    if (!isPush) {
        UIImage* CheckBoxImg=[UIImage imageNamed:@"checkboxyes.png"];
        [btn setImage:CheckBoxImg forState:UIControlStateNormal];
        isPush=YES;
        NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
        if (dicTmp) {
            [dicTmp setValue:@"1" forKey:@"ischeck"];
        }
        [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
    }
    else
    {
        UIImage* CheckBoxImg=[UIImage imageNamed:@"checkboxno.png"];
        [btn setImage:CheckBoxImg forState:UIControlStateNormal];
        isPush=NO;
        NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
        if (dicTmp) {
            [dicTmp setValue:@"1" forKey:@"ischeck"];
        }
        [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
    }
    
}

- (void)userLogin
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSString* widthheight=[NSString stringWithFormat:@"%d*%d",(int)width,(int)height ];
    
    NSString* devicesname=@"iPhone 7";
    
    if (userNameBox.text.length==0) {
       
        [self showAlertWarmMessage:@"请输入用户名或密码"];
        
        return;
    }
    if (passWordBox.text.length==0) {

        [self showAlertWarmMessage:@"请输入用户名或密码"];
        return;
    }
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [paramDic setObject:@"beta1.4" forKey:@"softver"];
    [paramDic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osver"];
    [paramDic setObject:widthheight forKey:@"resolution"];
    [paramDic setObject:passWordBox.text forKey:@"password"];
    [paramDic setObject:devicesname forKey:@"brand"];
    [paramDic setObject:timeSp forKey:@"time"];
    [paramDic setObject:@"" forKey:@"devmodel"];
    [paramDic setObject:userNameBox.text forKey:@"username"];
    
    [self userLoginWithParams:paramDic withisCheck:isCheck];
    
    /*
    __weak typeof(self) weakself = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:paramDic successBlock:^(id response) {
        //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        if([[response objectForKey:@"status"] intValue] == 100){
            
            //判断是不是第一次登录
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLongined"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLongined"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLogin"];
            }
            else{
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLogin"];
            }
            [[NSUserDefaults standardUserDefaults] setObject:self->userNameBox.text forKey:@"loginPhone"];
            [[NSUserDefaults standardUserDefaults] setObject:self->passWordBox.text forKey:@"loginPassword"];
            //将登录成功的标志保存到本地
            [[NSUserDefaults standardUserDefaults] setObject:@"isLogin" forKey:@"longinStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //发送登录成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCompleted" object:self userInfo:nil];
            if (self->isCheck)
            {
                NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
                if (dicTmp) {
                    [dicTmp setObject:self->userNameBox.text forKey:@"USERNAME"];
                    [dicTmp setObject:self->passWordBox.text forKey:@"PASSWORDAES"];
                    [dicTmp setValue:@"1" forKey:@"ischeck"];
                }
                [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
            }
            
            
            UserShareOnce *userShare = [UserShareOnce shareOnce];
            NSDictionary *dic = [[(NSDictionary *)response objectForKey:@"data"] objectForKey:@"member"];
            userShare = [UserShareOnce mj_objectWithKeyValues:dic];
            userShare.JSESSIONID = [[(NSDictionary *)response objectForKey:@"data"] objectForKey:@"JSESSIONID"];
            userShare.token = [[(NSDictionary *)response objectForKey:@"data"] objectForKey:@"token"];
            
            if (![[dic objectForKey:@"isMarried"] isKindOfClass:[NSNull class]]) {
                if ([[dic objectForKey:@"isMarried"] boolValue] == YES) {
                    userShare.marryState = @"未婚";
                }else if ([[dic objectForKey:@"isMarried"] boolValue] == NO){
                    userShare.marryState = @"未婚";
                }
            }
            
            NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberChirldArr"];
            if (arr.count) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberChirldArr"];
            }
            NSArray *modelArr = [[NSArray alloc] initWithArray:userShare.mengberchild];
            
            [[NSUserDefaults standardUserDefaults] setObject:modelArr forKey:@"memberChirldArr"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakself GetMemberChild];
        }else{
            [weakself showAlertWarmMessage:[response objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        [weakself showAlertWarmMessage:@"抱歉登录失败，请重试"];
    }];
     */
}

- (void)GetMemberChild2
{
   
    NSString *aUrl = [NSString stringWithFormat:@"member/memberModifi/selectMemberChild.jhtml?mobile=%@",[UserShareOnce shareOnce].username];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:aUrl parameters:nil successBlock:^(id response) {
        if([[response objectForKey:@"statue"] intValue] == 100){
            id data = [response objectForKey:@"data"];
            if (data && data != [NSNull null]) {
                //[UserShareOnce shareOnce].mengberchild = [data objectForKey:@"id"];
                 HomePageController *main = [[HomePageController alloc]init];
                CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:main];
                [UIApplication sharedApplication].keyWindow.rootViewController = nav;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
               
            }
        }else{
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        [weakSelf showAlertWarmMessage:@"抱歉登录失败，请重试"];
    }];
}

# pragma mark - //注册功能
- (void)registAction
{
    RegisterViewController *Registview=[[RegisterViewController alloc]init];
    
    [self.navigationController pushViewController:Registview animated:YES];
    
}


# pragma mark - //忘记密码

-(void)FoggetActive:(id)sender
{
    FindPassWordController *findVc = [[FindPassWordController alloc] init];
    [self.navigationController pushViewController:findVc animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==userNameBox)
    {
        [passWordBox becomeFirstResponder];
    }
    if (textField==passWordBox) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
