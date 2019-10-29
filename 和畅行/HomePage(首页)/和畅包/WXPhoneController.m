//
//  WXPhoneController.m
//  和畅行
//
//  Created by 出神入化 on 2019/5/7.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "WXPhoneController.h"

@interface WXPhoneController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField  *userNameBox;
@property (nonatomic,strong)UITextField  *passWordBox;
@property (nonatomic,strong)UIButton *loginBtn;
@property (nonatomic,assign)int pageNo;
@property (nonatomic,strong)NSTimer* timer;
@property (nonatomic,strong)MBProgressHUD *progress;
@end

@implementation WXPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = ModuleZW(@"关联手机号");
    //布局微信登录绑定手机号页面
    [self layoutWXPhoneView];
    
}

-(void) layoutWXPhoneView {
    UITextField  *userNameBox=[[UITextField alloc] init];
    userNameBox.frame=CGRectMake(40, ScreenHeight/2 - 100 , ScreenWidth - 130 ,30 );
    userNameBox.borderStyle=UITextBorderStyleNone;
    userNameBox.returnKeyType=UIReturnKeyNext;
    userNameBox.keyboardType=UIKeyboardTypeNumberPad;
    userNameBox.clearButtonMode=UITextFieldViewModeWhileEditing;
    userNameBox.delegate=self;
    userNameBox.font=[UIFont systemFontOfSize:15.0];
    userNameBox.placeholder=ModuleZW(@"  请输入手机号");
    [self.view addSubview:userNameBox];
    _userNameBox = userNameBox;
    
    UILabel *addNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(userNameBox.width, 0, 50, 30)];
    addNumberLabel.text = @"+86";
    addNumberLabel.textColor = RGB_TextMidLightGray;
    [userNameBox addSubview:addNumberLabel];
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(40, userNameBox.bottom+2, ScreenWidth-40*2, 1)];
    imageV2.backgroundColor = UIColorFromHex(0X1E82D2);
    [self.view addSubview:imageV2];
    
    UITextField  * passWordBox=[[UITextField alloc]init];
    passWordBox.frame=CGRectMake(40, imageV2.bottom+10, ScreenWidth - 200 ,userNameBox.height );
    passWordBox.clearButtonMode=UITextFieldViewModeWhileEditing;
    passWordBox.delegate = self;
    passWordBox.font=[UIFont systemFontOfSize:15.0];
    passWordBox.placeholder=ModuleZW(@"  请输入验证码");
    passWordBox.keyboardType = UIKeyboardTypeNumberPad;
    passWordBox.returnKeyType=UIReturnKeyDone;
    [self.view addSubview:passWordBox];
    _passWordBox = passWordBox;
    
    
    UIImageView *imageV3 = [[UIImageView alloc] initWithFrame:CGRectMake(40, passWordBox.bottom+2, imageV2.width, 1)];
    imageV3.backgroundColor = UIColorFromHex(0X1E82D2);
    [self.view addSubview:imageV3];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(imageV3.right-130, passWordBox.top, 130, passWordBox.height);
    rightBtn.tag = 2018;
    [rightBtn setTitle:ModuleZW(@"获取验证码") forState:UIControlStateNormal];
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [rightBtn setTitleColor:[UIColor colorWithRed:69/255.0 green:139/255.0 blue:208/255.0 alpha:1.0] forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(40, passWordBox.bottom + 60, imageV3.width, 44);
    loginBtn.layer.cornerRadius = 22.0;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.backgroundColor = UIColorFromHex(0x1e82d2);
    [loginBtn setTitle:ModuleZW(@"确定") forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [loginBtn setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(suerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    
    RAC(loginBtn, enabled) = [RACSignal combineLatest:@[userNameBox.rac_textSignal, passWordBox.rac_textSignal] reduce:^id _Nullable(NSString * username, NSString * password){
        if(username.length> 0 && password.length  > 0) {
            loginBtn.backgroundColor = UIColorFromHex(0x1e82d2);
            loginBtn.enabled = YES;
        }else{
            loginBtn.backgroundColor = RGB(195, 195, 195);
            loginBtn.enabled = NO;
        }
        return @(username.length && password.length);
    }];
    
}

# pragma mark - 获取验证码
-(void)rightBtnAction
{
    if (_userNameBox.text.length==0) {
        [self showAlertWarmMessage:ModuleZW(@"请输入要绑定的手机号")];
        return;
    }
    if (_userNameBox.text.length!=11) {
        [self showAlertWarmMessage:ModuleZW(@"请输入正确的手机号")];
        return;
    }
    NSString *aUrl = @"weiq/sms/getsmsCode.jhtml";
    /**
     *  MD5加密后的字符串
     */
 
    [self showHUD];
    NSString *iPoneNumber = [NSString stringWithFormat:@"%@ky3h.com",_userNameBox.text];
    NSString *iPoneNumberMD5 = [GlobalCommon md5:iPoneNumber].uppercaseString;
    NSDictionary *dic = @{@"phone":_userNameBox.text,@"token":iPoneNumberMD5};
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:dic successBlock:^(id response) {

        [self hiddenHUD];
        NSLog(@"%@",response);
        id status=[response objectForKey:@"status"];
        if (status!=nil)   {
            if ([status intValue]==100) {
                
                self->_pageNo = 60;
                self->_timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                             target:self
                                                           selector:@selector(getResults)
                                                           userInfo:nil
                                                            repeats:YES];
            }else{

                NSString *str = [response objectForKey:@"message"];
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


-(void)showHUD{
    self.progress = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress.label.text = ModuleZW(@"请稍后");
    [self.view addSubview:self.progress];
    [self.progress showAnimated:YES];
}
-(void)hiddenHUD{
    [self.progress removeFromSuperview];
}
-(void)getResults
{
    UIButton *YZMbtn = (UIButton *)[self.view viewWithTag:2018];
    
    if (_pageNo==0)
    {
        [_timer invalidate];
        _pageNo=60;
        YZMbtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [YZMbtn setTitle:ModuleZW(@"获取验证码") forState:UIControlStateNormal];
        return;
    }
    YZMbtn.titleLabel.font=[UIFont systemFontOfSize:14];
    //[YZMbtn setTitle:[NSString stringWithFormat:@"%i秒内重新发送",pageNo--] forState:UIControlStateNormal];
    [YZMbtn setTitle:[NSString stringWithFormat:@"%is%@",_pageNo--,ModuleZW(@"后重新发送")] forState:UIControlStateNormal];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_userNameBox resignFirstResponder];
    [_passWordBox resignFirstResponder];
}
-(void)suerAction{
    
    if (_userNameBox.text.length==0) {
        [self showAlertWarmMessage:ModuleZW(@"请输入要绑定的手机号")];
        return;
    }
    if (_userNameBox.text.length!=11) {
        [self showAlertWarmMessage:ModuleZW(@"请输入正确的手机号")];
        return;
    }
    if(_passWordBox.text.length == 0 || _passWordBox.text.length != 4){
        [self showAlertWarmMessage:ModuleZW(@"请输入4位验证码")];
        return;
    }
    NSString *aUrl = @"/weiq/setUserInfo.jhtml";
    NSDictionary *dic = @{@"unionid":[UserShareOnce shareOnce].username,
                          @"phone":_userNameBox.text,
                          @"vftcode":_passWordBox.text
                          };
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:dic successBlock:^(id response) {
        
        [self hiddenHUD];
        id status=[response objectForKey:@"status"];
        if (status!=nil)   {
            if ([status intValue]==100) {
                [UserShareOnce shareOnce].username = self->_userNameBox.text;
                UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"绑定成功") preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *sureAction= [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                [alerVC addAction:sureAction];
                [self presentViewController:alerVC animated:YES completion:nil];
            }else{
                NSString *str = [response objectForKey:@"data"];
                [weakSelf showAlertWarmMessage:str];
                
            }
        }
        else
        {
            [weakSelf showAlertWarmMessage:ModuleZW(@"绑定失败，请重试")];
            
            return;
            
        }
    } failureBlock:^(NSError *error) {
        [GlobalCommon hideMBHudTitleWithView:weakSelf.view];
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
    
}


- (void)goBack:(UIButton *)btn
{
    if (self.pushType == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];

    }
}
@end
