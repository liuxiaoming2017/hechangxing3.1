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
#import "SBJson.h"
#import "WXApi.h"
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogManager.h>
#import "payRequsestHandler.h"
#import "HeChangPackgeController.h"
#import "EnRegistrController.h"
#define margin 40
#define leftOrigin 40


@interface LoginViewController ()
@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UILabel *addNumberLabel;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic,assign)BOOL isChoose;
@property (nonatomic,strong)UIButton *loginBtn;
@property (nonatomic,strong)UIButton *ageButton;
@property (nonatomic,strong)UIButton *leftButton;
@property (nonatomic,strong)UIButton *registeredBT;
@property (nonatomic,strong)UISegmentedControl *segment;
@property (nonatomic,strong)UIScrollView *backScrollView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //titleLabel.text = @"登录";
    navView.bottom = YES;
    self.isChoose = YES;
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
    UIScrollView *backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:backScrollView];
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenWidth-Adapter(110))/2.0, kNavBarHeight+Adapter(30), Adapter(110), Adapter(77))];
    imageV.image = [UIImage imageNamed:ModuleZW(@"和畅logo")];
    [backScrollView addSubview:imageV];
    NSArray *titleArray = @[ModuleZW(@"短信登录"),ModuleZW(@"密码登录")];
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:titleArray];
    segment.frame = CGRectMake(Adapter(40), imageV.bottom + Adapter(40), ScreenWidth - Adapter(80), Adapter(30));
    segment.tintColor = [UIColor clearColor];
    NSDictionary* selectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:24*[UserShareOnce shareOnce].fontSize],NSForegroundColorAttributeName: RGB_ButtonBlue };
    [segment setTitleTextAttributes:selectedTextAttributes forState:UIControlStateSelected];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:24*[UserShareOnce shareOnce].fontSize],NSForegroundColorAttributeName: RGB_ButtonBlue };
    [segment setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
    segment.selectedSegmentIndex = 0;
    [segment addTarget:self action:@selector(selected:) forControlEvents:UIControlEventValueChanged];
    [backScrollView addSubview:segment];
    self.segment = segment;
    if([UserShareOnce shareOnce].languageType){
        segment.top = imageV.bottom - 0;
    }
  
    
    
    UIView *blueView  = [[UIView alloc]initWithFrame:CGRectMake(Adapter(40), segment.bottom + Adapter(5), ScreenWidth/2 - Adapter(40), Adapter(1.5))];
    blueView.backgroundColor = RGB_ButtonBlue;
    [backScrollView addSubview:blueView];
    self.blueView = blueView;
    
 
    
    userNameBox=[[UITextField alloc] init];
    userNameBox.frame=CGRectMake(segment.left, segment.bottom+Adapter(40), ScreenWidth - Adapter(140) ,Adapter(30) );
    userNameBox.borderStyle=UITextBorderStyleNone;
    userNameBox.returnKeyType=UIReturnKeyNext;
    userNameBox.keyboardType=UIKeyboardTypeNumberPad;
    userNameBox.clearButtonMode=UITextFieldViewModeWhileEditing;
    userNameBox.delegate=self;
    userNameBox.font=[UIFont systemFontOfSize:15.0];
    userNameBox.placeholder=ModuleZW(@"  请输入手机号");
    [backScrollView addSubview:userNameBox];
    
    UILabel *addNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(userNameBox.width, 0, Adapter(50), Adapter(30))];
    addNumberLabel.text = @"+86";
    addNumberLabel.textColor = RGB_TextMidLightGray;
    [userNameBox addSubview:addNumberLabel];
    self.addNumberLabel = addNumberLabel;
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(segment.left, userNameBox.bottom+Adapter(2), ScreenWidth-segment.left*2, Adapter(1))];
    imageV2.backgroundColor = UIColorFromHex(0X1E82D2);
    [backScrollView addSubview:imageV2];
    
    passWordBox=[[UITextField alloc]init];
    passWordBox.frame=CGRectMake(segment.left, imageV2.bottom+Adapter(10), Adapter(160) ,userNameBox.height );
    passWordBox.clearButtonMode=UITextFieldViewModeWhileEditing;
    passWordBox.delegate = self;
    passWordBox.font=[UIFont systemFontOfSize:15.0];
    passWordBox.placeholder=ModuleZW(@"  请输入验证码");
    passWordBox.keyboardType = UIKeyboardTypeNumberPad;
    passWordBox.returnKeyType=UIReturnKeyDone;
    [backScrollView addSubview:passWordBox];
    
    NSArray *buttonTitleArray = @[ModuleZW(@"我已阅读并同意"),ModuleZW(@"《炎黄用户协议》")];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [button setTitle:buttonTitleArray[i] forState:(UIControlStateNormal)];
        [button addTarget:self action:@selector(agreeDeal:) forControlEvents:(UIControlEventTouchUpInside)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [button setFrame:CGRectMake(segment.left + 105*i, passWordBox.bottom + Adapter(20), Adapter(110), Adapter(20))];
        [button setTag:1000 + i];
        [backScrollView addSubview:button];
        [button  sizeToFit];
        if(i == 0 ) {
            [button setTitleColor:RGB_TextMidLightGray forState:(UIControlStateNormal)];
            [button setImage:[[UIImage imageNamed:@"协议选中"] transformWidth:Adapter(15) height:Adapter(15)] forState:(UIControlStateNormal)];
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, Adapter(-5), 0, 0)];
            button.width = button.width + Adapter(15);
            _leftButton = button;
        }else{
            [button setTitleColor:RGB_ButtonBlue forState:(UIControlStateNormal)];
            button.left = _leftButton.right;
        }
    }
    
    UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(segment.left, passWordBox.bottom+Adapter(2), imageV2.width, Adapter(1))];
    imageV3.backgroundColor = UIColorFromHex(0X1E82D2);
    [backScrollView addSubview:imageV3];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(imageV3.right-Adapter(140), passWordBox.top, Adapter(140), passWordBox.height);
    rightBtn.tag = 2018;
    [rightBtn setTitle:ModuleZW(@"获取验证码") forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [rightBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:139/255.0 blue:208/255.0 alpha:1.0] forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:rightBtn];
    
//    userNameBox.width = rightBtn.left-userNameBox.left;
//    passWordBox.width = userNameBox.width;
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(segment.left, passWordBox.bottom + Adapter(60), imageV3.width, Adapter(44));
   
    loginBtn.backgroundColor = UIColorFromHex(0x1e82d2);
    [loginBtn setTitle:ModuleZW(@"登录") forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [loginBtn setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    

    
    RAC(loginBtn, enabled) = [RACSignal combineLatest:@[userNameBox.rac_textSignal, passWordBox.rac_textSignal] reduce:^id _Nullable(NSString * username, NSString * password){
        if(username.length> 0 && password.length  > 0) {
            loginBtn.backgroundColor = UIColorFromHex(0x1e82d2);
        }else{
            loginBtn.backgroundColor = RGB(195, 195, 195);
        }
        return @(username.length && password.length);
    }];
    
    UILabel *promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, loginBtn.bottom , ScreenWidth, Adapter(40))];
    promptLabel.text = ModuleZW(@"无需注册，可直接登录");
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textColor = RGB_TextLightGray;
    [backScrollView addSubview:promptLabel];
    self.promptLabel = promptLabel;
    
    if([UserShareOnce shareOnce].languageType){
        segment.hidden = YES;
        self.blueView.hidden = YES;
        segment.selectedSegmentIndex = 1;
        [self selected:segment];
        self.promptLabel.hidden = YES;
        
        loginBtn.height = Adapter(35);
        UIButton *registeredBT = [UIButton buttonWithType:UIButtonTypeCustom];
        registeredBT.frame = CGRectMake(segment.left, passWordBox.bottom + Adapter(110), imageV3.width, Adapter(35));
        registeredBT.layer.cornerRadius = registeredBT.height/2;
        registeredBT.layer.masksToBounds = YES;
        registeredBT.backgroundColor = RGB(232, 241, 255);
        [registeredBT setTitle:@"Create New Account" forState:UIControlStateNormal];
        registeredBT.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [registeredBT setTitleColor:RGB_ButtonBlue forState:UIControlStateNormal];
        [[registeredBT rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            EnRegistrController *enVC = [[EnRegistrController alloc]init];
            [self.navigationController pushViewController:enVC animated:YES];
        }];
//        [registeredBT addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
        [backScrollView addSubview:registeredBT];
        self.registeredBT = registeredBT;
        self.ageButton.hidden = YES;
        userNameBox.left = Adapter(40);
        passWordBox.left = Adapter(40);
    }else{
        segment.hidden = NO;
        self.blueView.hidden = NO;
        
        
    }
    
    loginBtn.layer.cornerRadius = loginBtn.height/2;
    loginBtn.layer.masksToBounds = YES;
    
    UILabel *otherLoginLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-Adapter(120))/2.0, promptLabel.bottom+Adapter(30), Adapter(120), Adapter(30))];
    otherLoginLabel.font = [UIFont systemFontOfSize:14];
    otherLoginLabel.textAlignment = NSTextAlignmentCenter;
    otherLoginLabel.textColor = UIColorFromHex(0xcecece);
    otherLoginLabel.text = ModuleZW(@"其他登录方式");
    [backScrollView addSubview:otherLoginLabel];
    
    UIImageView *imageV4 = [[UIImageView alloc] initWithFrame:CGRectMake(otherLoginLabel.left-Adapter(100), otherLoginLabel.top+otherLoginLabel.height/2.0, Adapter(100), 1)];
    imageV4.backgroundColor = UIColorFromHex(0xb8b8b8);
    [backScrollView addSubview:imageV4];
    
    UIImageView *imageV5 = [[UIImageView alloc] initWithFrame:CGRectMake(otherLoginLabel.right, imageV4.top, imageV4.width, Adapter(1))];
    imageV5.backgroundColor = UIColorFromHex(0xb8b8b8);
    [backScrollView addSubview:imageV5];
    
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.frame = CGRectMake((ScreenWidth-Adapter(40))/2.0, otherLoginLabel.bottom+Adapter(20), Adapter(40), Adapter(40));
    [weixinBtn setBackgroundImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
    [weixinBtn addTarget:self action:@selector(weixinBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backScrollView addSubview:weixinBtn];
    
    
    if (![WXApi isWXAppInstalled]) {

        otherLoginLabel.hidden = YES;
        imageV5.hidden = YES;
        imageV4.hidden = YES;
        weixinBtn.hidden = YES;
        if([UserShareOnce shareOnce].languageType){
            self.registeredBT.top = ScreenHeight - kTabBarHeight - Adapter(20);
            otherLoginLabel.top = self.registeredBT.top - Adapter(40);
            imageV5.top = otherLoginLabel.top + Adapter(15);
            imageV4.top = otherLoginLabel.top + Adapter(15);
            otherLoginLabel.hidden = NO;
            imageV5.hidden = NO;
            imageV4.hidden = NO;
        }
    }
    
    backScrollView.contentSize = CGSizeMake(ScreenWidth, otherLoginLabel.bottom+Adapter(80));
    
    //从本地查找用户
    NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
    NSString* strcheck=[dicTmp objectForKey:@"ischeck"];
    if ([strcheck isEqualToString:@"1"])
    {
        isCheck=YES;
        userNameBox.text=[GlobalCommon AESDecodeWithString:[dicTmp objectForKey:@"USERNAME"]];
        passWordBox.text=[GlobalCommon AESDecodeWithString:[dicTmp objectForKey:@"PASSWORDAES"]];
        if(userNameBox.text.length>0&&passWordBox.text.length>0)
        {
            _loginBtn.backgroundColor = UIColorFromHex(0x1e82d2);
            _loginBtn.enabled = YES;
        }
        self.segment.selectedSegmentIndex = 1;
        [self selected:self.segment];
    }
    else
    {
        isCheck=YES;
    }
}

# pragma mark - 切换登录方式
-(void)selected:(id)sender{
    UISegmentedControl* control = (UISegmentedControl*)sender;
      UIButton *btn = (UIButton *)[self.view viewWithTag:2018];
    switch (control.selectedSegmentIndex) {
        case 0:{
            [UIView animateWithDuration:0.4 animations:^{
                self.blueView.left = Adapter(40);
            }];
            self.addNumberLabel.hidden = NO;
            userNameBox.placeholder = ModuleZW(@"  请输入手机号");
            passWordBox.placeholder = ModuleZW(@"  请输入验证码");
            userNameBox.left = Adapter(40);
            passWordBox.left = Adapter(40);
            passWordBox.width = Adapter(160);
            passWordBox.secureTextEntry=NO;
            passWordBox.keyboardType = UIKeyboardTypeNumberPad;
            [btn setTitle:ModuleZW(@"获取验证码") forState:UIControlStateNormal];
            [btn setTitleColor:RGB_ButtonBlue forState:(UIControlStateNormal)];
            self.promptLabel.hidden  = NO;
            if(self.ageButton){
                self.ageButton.hidden = YES;
            }
          
        }
            break;
        case 1: {
            [UIView animateWithDuration:0.4 animations:^{
                self.blueView.left = ScreenWidth/2;
            }];
            self.addNumberLabel.hidden = YES;
            userNameBox.placeholder = ModuleZW(@"  请输入和畅账户");
            passWordBox.placeholder = ModuleZW(@"  请输入密码");
            userNameBox.left = Adapter(60);
            passWordBox.left = Adapter(60);
            passWordBox.width = Adapter(140);
            passWordBox.secureTextEntry=YES;
            passWordBox.keyboardType = UIKeyboardTypeDefault;
            if(!self.ageButton){
                self.ageButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
                self.ageButton.frame = CGRectMake(Adapter(-25),passWordBox.height/2 -Adapter(10), Adapter(20), Adapter(20));
                [self.ageButton setImage:[UIImage imageNamed:@"眼睛闭icon"] forState:(UIControlStateNormal)];
                [[self.ageButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    x.selected  = !x.selected;
                    if(x.selected) {
                        [x setImage:[UIImage imageNamed:@"眼睛睁icon"] forState:(UIControlStateNormal)];
                        self->passWordBox.secureTextEntry = NO;
                    }else {
                        [x setImage:[UIImage imageNamed:@"眼睛闭icon"] forState:(UIControlStateNormal)];
                        self->passWordBox.secureTextEntry = YES;
                    }
                }];
                [passWordBox addSubview: self.ageButton];
            }else{
                self.ageButton.hidden = NO;
            }
          
            [btn setTitle:ModuleZW(@"忘记密码") forState:UIControlStateNormal];
            [btn setTitleColor:RGB_TextDarkGray forState:(UIControlStateNormal)];
            self.promptLabel.hidden  = YES;
            if(timer){
                [timer invalidate];
                pageNo = 0;
            }
            break;
        }
    }
}


-(void)agreeDeal:(UIButton *)button {
    if(button.tag == 1000) {
        button.selected = !button.selected;
        self.isChoose = !button.selected;
        if (button.selected) {
            [button setImage:[[UIImage imageNamed:@"协议未选中"] transformWidth:Adapter(15) height:Adapter(15)] forState:(UIControlStateNormal)];
        }else{
            [button setImage:[[UIImage imageNamed:@"协议选中"] transformWidth:Adapter(15) height:Adapter(15)] forState:(UIControlStateNormal)];
        }
    }else {
        HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
        vc.noWebviewBack = YES;
        vc.progressType = progress2;
        vc.titleStr =ModuleZW(@"用户协议");
        if([UserShareOnce shareOnce].languageType){
            vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201903/61/1.html",URL_PRE];
        }else{
            vc.urlStr = [NSString stringWithFormat:@"%@upload/article/content/201602/61/1.html",URL_PRE];
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)rightBtnAction:(UIButton *)button
{
    if([button.titleLabel.text isEqualToString:ModuleZW(@"获取验证码")]){
        [self userYZMButton];
    }else if ([button.titleLabel.text isEqualToString:ModuleZW(@"忘记密码")]){
        [self FoggetActive:nil];
    }
}



# pragma mark - 微信登录
- (void)weixinBtnAction
{
    
    if (![WXApi isWXAppInstalled]) {
        [self showAlertWarmMessage:ModuleZW(@"未安装相关软件")];
        return;
    }
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:APP_ID appSecret:APP_SECRET redirectURL:nil];
    NSLog(@"haha:%@,%@",APP_ID,APP_SECRET);
    [self loginByWeiXin];
    
}
#pragma   mark ----  微信登录
- (void)loginByWeiXin
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        NSLog(@"hahah");
        if (error) {
            
            [self showAlertWarmMessage:ModuleZW(@"抱歉登录失败，请重试")];
            
            NSLog(@"%@",error);
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            NSString *str = [NSString string];
            if ([resp.gender isEqualToString:@"m"]) {
                str = @"1";
            }else if([resp.gender isEqualToString:@"w"]) {
                str = @"2";
            }else {
                str = @"";
            }
            resp.name = [self removeEmoji:resp.name];
            NSDictionary *weiXDic = @{@"unionid":resp.uid,
                                                   @"screen_name":resp.name,
                                                   @"gender":str,
                                                   @"profile_image_url":resp.iconurl};
            
            [self userLoginWithWeiXParams:weiXDic withCheck:2];
            
           
        }
    }];
}
- (NSString*)removeEmoji:(NSString *)username {
    
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *temp = nil;
    
    for(int i = 0; i < [username length]; i++)
    {
        temp = [username substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:temp]) {
            NSLog(@"%@", temp);
            NSLog(@"This character is OK");
        } else {
            NSRange range = NSMakeRange(i, 1);
            username = [username stringByReplacingCharactersInRange:range withString:@" "];
        }
    }
    
    NSString *withoutEmojiUsername = [username stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return withoutEmojiUsername;
}

# pragma mark - 获取验证码
-(void)userYZMButton
{
    if (userNameBox.text.length==0) {
                [self showAlertWarmMessage:ModuleZW(@"登录手机号不能为空")];
        return;
    }
    if (userNameBox.text.length!=11||![userNameBox.text  hasPrefix:@"1"]) {
        [self showAlertWarmMessage:ModuleZW(@"您输入的手机号格式错误")];
        return ;
    }
    
    if(![self deptNumInputShouldNumber:userNameBox.text] ){
        [self showAlertWarmMessage:ModuleZW(@"您输入的手机号格式错误")];
        return ;
    }
    
    
    NSString *aUrl = @"weiq/sms/getsmsCode.jhtml";
    /**
     *  MD5加密后的字符串
     */
    [GlobalCommon showMBHudTitleWithView:self.view];
    NSString *iPoneNumber = [NSString stringWithFormat:@"%@ky3h.com",userNameBox.text];
    NSString *iPoneNumberMD5 = [GlobalCommon md5:iPoneNumber].uppercaseString;
    NSDictionary *dic = @{@"phone":userNameBox.text,@"token":iPoneNumberMD5};
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:dic successBlock:^(id response) {
        [GlobalCommon hideMBHudTitleWithView:weakSelf.view];
        NSLog(@"%@",response);
        id status=[response objectForKey:@"status"];
        if (status!=nil)
        {
            if ([status intValue]==100) {
                self->pageNo = 60;
                self->timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                       target:self
                                                     selector:@selector(getResults)
                                                     userInfo:nil
                                                      repeats:YES];
            }else{
                
                NSString *str = [dic objectForKey:@"message"];
                [weakSelf showAlertWarmMessage:str];
                
            }
        }
        else
        {
            [weakSelf showAlertWarmMessage:ModuleZW(@"短信验证码发送失败，请重试")];
            
            return;
            
        }
    } failureBlock:^(NSError *error) {
        [GlobalCommon hideMBHudTitleWithView:weakSelf.view];
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
    

    
}

-(void)getResults
{
    UIButton *YZMbtn = (UIButton *)[self.view viewWithTag:2018];
    
    if (pageNo==0)
    {
        [timer invalidate];
        pageNo=60;
        YZMbtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [YZMbtn setTitle:ModuleZW(@"获取验证码") forState:UIControlStateNormal];
        return;
    }
    YZMbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    //[YZMbtn setTitle:[NSString stringWithFormat:@"%i秒内重新发送",pageNo--] forState:UIControlStateNormal];
    [YZMbtn setTitle:[NSString stringWithFormat:@"%is%@",pageNo--,ModuleZW(@"后重新发送")] forState:UIControlStateNormal];
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
    UIButton *button = (UIButton *)[self.view viewWithTag:2019];
    
    //userNameBox.placeholder = ModuleZW(@"  请输入手机号");
    if([userNameBox.text isEqualToString:@"13665541112"]&&[passWordBox.text isEqualToString:@"123456"]){
        [self userNameLoginAction];
        return;
    }
    
    //短信验证码登录
    NSLog(@"%@",userNameBox.placeholder );
    if([userNameBox.placeholder isEqualToString:ModuleZW(@"  请输入手机号")]){
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
    if (userNameBox.text.length!=11||![userNameBox.text  hasPrefix:@"1"]) {
        [self showAlertWarmMessage:ModuleZW(@"您输入的手机号格式错误")];
        return;
    }
    if(![self deptNumInputShouldNumber:userNameBox.text] ){
        [self showAlertWarmMessage:ModuleZW(@"您输入的手机号格式错误")];
        return ;
        
    }
  
    if (self.isChoose == NO){
        [self showAlertWarmMessage:ModuleZW(@"请阅读并同意《炎黄用户协议》")];
        return;
    }
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [paramDic setObject:userNameBox.text forKey:@"phone"];
    [paramDic setObject:passWordBox.text forKey:@"code"];
    
    [self userLoginWithWeiXParams:paramDic withCheck:3];
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
    
    if(![UserShareOnce shareOnce].languageType){
        
        if (userNameBox.text.length!=11||![userNameBox.text  hasPrefix:@"1"]) {
            [self showAlertWarmMessage:ModuleZW(@"您输入的手机号格式错误")];
            return ;
        }
        
        if(![self deptNumInputShouldNumber:userNameBox.text] ){
            [self showAlertWarmMessage:ModuleZW(@"您输入的手机号格式错误")];
            return ;
        }
    }
       
    if (self.isChoose == NO){
        [self showAlertWarmMessage:ModuleZW(@"请阅读并同意《炎黄用户协议》")];
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
        [weakSelf showAlertWarmMessage:requestErrorMessage];
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
    
//    if([UserShareOnce shareOnce].languageType){
        FindPassWordController *findVc = [[FindPassWordController alloc] init];
        [self.navigationController pushViewController:findVc animated:YES];
//    }else{
//        self.segment.selectedSegmentIndex = 0;
//        [self selected:self.segment];
//    }
  
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [userNameBox resignFirstResponder];
    [passWordBox resignFirstResponder];
}

- (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}

-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}

@end
