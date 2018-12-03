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

#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>

#import "ZYGASINetworking.h"

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
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        NSLog(@"hahah");
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.gender);
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
        }
    }];
}

# pragma mark - 获取验证码
-(void)userYZMButton
{
    if (userNameBox.text.length==0) {
        
        [self showAlertWarmMessage:@"登录手机号不能为空"];
        return;
    }
    
    NSString *aUrl = @"weiq/sms/getsmsCode.jhtml";
    /**
     *  MD5加密后的字符串
     */
    NSString *iPoneNumber = [NSString stringWithFormat:@"%@ky3h.com",userNameBox.text];
    NSString *iPoneNumberMD5 = [GlobalCommon md5:iPoneNumber].uppercaseString;
    NSDictionary *dic = @{@"phone":userNameBox.text,@"token":iPoneNumberMD5};
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:dic successBlock:^(id response) {
        
        NSLog(@"%@",response);
        id status=[response objectForKey:@"status"];
        if (status!=nil)
        {
            if ([status intValue]==100) {
                
                self->timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(getResults)
                                                     userInfo:nil
                                                      repeats:YES];
            }else{
                
                NSString *str = [dic objectForKey:@"data"];
                [weakSelf showAlertWarmMessage:str];
                
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

# pragma mark - 登录按钮
- (void)userLogin
{
    UIButton *button = (UIButton *)[self.view viewWithTag:2018];
    //短信验证码登录
    if([button.titleLabel.text isEqualToString:@"获取验证码"]){
        [self smsCodeLoginAction];
    }
    //用户名密码登录
    else{
        [self userNameLoginAction];
    }
}

# pragma mark - 短信验证码登录
- (void)smsCodeLoginAction
{
    if (userNameBox.text.length!=11) {
        
        [self showAlertWarmMessage:@"请输入正确的手机号"];
        
        return;
    }
    if (passWordBox.text.length==0) {
        
        [self showAlertWarmMessage:@"请输入短信验证码"];
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [paramDic setObject:userNameBox.text forKey:@"phone"];
    [paramDic setObject:passWordBox.text forKey:@"code"];
    
    [self userLoginWithParams:paramDic withisCheck:isCheck];
}

# pragma mark - 用户名密码登录
- (void)userNameLoginAction
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
