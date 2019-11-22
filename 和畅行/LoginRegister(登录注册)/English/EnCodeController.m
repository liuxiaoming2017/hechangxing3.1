//
//  EnCodeController.m
//  和畅行
//
//  Created by Wei Zhao on 2019/7/16.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "EnCodeController.h"
#import "HWTFCursorView.h"
@interface EnCodeController ()
@property (nonatomic,strong) HWTFCursorView *code4View;

@end

@implementation EnCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutSendCodeView];

}
-(void)layoutSendCodeView{
    
    UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(20), kNavBarHeight , ScreenWidth - Adapter(40), Adapter(40))];
    topLabel.text = @"What's the code ?";
    topLabel.textColor = RGB_ButtonBlue;
    topLabel.font = [UIFont systemFontOfSize:26];
    [self.view addSubview:topLabel];
    
    UILabel *modLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(20), topLabel.bottom + Adapter(10) , ScreenWidth - Adapter(40), Adapter(45))];
    modLabel.numberOfLines = 0;
    if([self.numberStr containsString:@"@"]){
        modLabel.text =  [NSString stringWithFormat:@"Enter the code sent to  %@",self.numberStr] ;
    }else{
        modLabel.text =  [NSString stringWithFormat:@"Enter the code sent to +1 %@",self.numberStr] ;
    }
    modLabel.textColor = RGB_ButtonBlue;
    modLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:modLabel];

    
    
    HWTFCursorView *code4View = [[HWTFCursorView alloc] initWithCount:4 margin:20];
    code4View.frame = CGRectMake(Adapter(20), modLabel.bottom + Adapter(30) , ScreenWidth - Adapter(40), Adapter(50));
    [self.view addSubview:code4View];
    self.code4View = code4View;
    __weak typeof(self) weakself = self;
    self.code4View.codeBlock = ^{
        [weakself submit];
    };
    
    UIButton *codeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    codeButton.frame = CGRectMake(Adapter(20), code4View.bottom + Adapter(20), ScreenWidth - Adapter(40), Adapter(30));
    [codeButton setTitle:@"Problems receiving the code?" forState:(UIControlStateNormal)];
    [codeButton setTitleColor:RGB_ButtonBlue forState:(UIControlStateNormal)];
    [codeButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    codeButton.hidden = YES;
    codeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [[codeButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self resendCode];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        codeButton.hidden = NO;
    });
    [self.view addSubview:codeButton];
    
    [self addEnPopButton];
    
    
    
}

-(void)submit{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = ModuleZW(@"加载中...");
//    NSString *iPoneNumber = [NSString stringWithFormat:@"%@ky3h.com",self.numberStr];
//    NSString *tokenStr = [GlobalCommon md5:iPoneNumber].uppercaseString;
    NSString *codeStr = [NSString stringWithFormat:@"%@",self.code4View.code];
    NSString *typeStr = [NSString string];
    NSString *urlStr  = [NSString string];
    NSDictionary *dic = [NSDictionary dictionary];
    if([self.numberStr containsString:@"@"]){
        typeStr = @"email";
        urlStr  = @"/login/register/email.jhtml";

        dic = @{@"email":self.numberStr,
                @"password":self.passWordStr,
                @"code":codeStr };
    }else{
        typeStr = @"phone";
         urlStr  = @"/login/register/phone.jhtml";
        dic = @{@"phone":self.numberStr,
                @"password":self.passWordStr,
                @"code":codeStr };

    }

    [[NetworkManager sharedNetworkManager] requestWithType:BAHttpRequestTypePost urlString:urlStr parameters:dic successBlock:^(id response) {
        
        [hud hideAnimated:YES];
        if ([response[@"status"] integerValue] == 100){
            CGRect rect = [[UIScreen mainScreen] bounds];
            CGSize size = rect.size;
            CGFloat width = size.width;
            CGFloat height = size.height;
            NSString* widthheight=[NSString stringWithFormat:@"%d*%d",(int)width,(int)height ];
            
            NSString* devicesname=@"iPhone 7";
            
            NSDate *datenow = [NSDate date];
            NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
            
            NSDictionary *paramDic = @{@"softver":@"beta1.4",
                                              @"osver":[[UIDevice currentDevice] systemVersion],
                                              @"resolution":widthheight,
                                              @"password":self.passWordStr,
                                              @"brand":devicesname,
                                              @"time":timeSp,
                                              @"devmodel":@"",
                                              @"username":self.numberStr };
        
            [self userLoginWithParams:paramDic withisCheck:YES];
        }else{
        [self showAlertWarmMessage:response[@"message"]];
        }
        
    } failureBlock:^(NSError *error) {
        [hud hideAnimated:YES];
        [self showAlertWarmMessage:requestErrorMessage];
    }];
    
}

# pragma mark - 账号密码登录

- (void)userLoginWithParams:(NSDictionary *)paramDic withisCheck:(BOOL)isCheck
{
    // NSString *aUrl = @"weiq/sms/login.jhtml";
    NSString *aUrl = @"login/commit.jhtml";
    __weak typeof(self) weakself = self;
    [GlobalCommon showMBHudTitleWithView:self.view];
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:paramDic successBlock:^(id response) {
        
        
        //NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:nil];
        if([[response objectForKey:@"status"] intValue] == 100){
            [UserShareOnce shareOnce].loginType = @"SMS";
            
            //判断是不是第一次登录
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLongined"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLongined"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLogin"];
            }
            else{
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLogin"];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[paramDic objectForKey:@"username"] forKey:@"loginPhone"];
            [[NSUserDefaults standardUserDefaults] setObject:[paramDic objectForKey:@"password"] forKey:@"loginPassword"];
            //将登录成功的标志保存到本地
            [[NSUserDefaults standardUserDefaults] setObject:@"isLogin" forKey:@"longinStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //发送登录成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCompleted" object:self userInfo:nil];
            if (isCheck)
            {
                NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
                if (dicTmp) {
                    [dicTmp setObject:[paramDic objectForKey:@"username"] forKey:@"USERNAME"];
                    [dicTmp setObject:[paramDic objectForKey:@"password"] forKey:@"PASSWORDAES"];
                    [dicTmp setValue:@"1" forKey:@"ischeck"];
                }
                [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
            }
            
            
            UserShareOnce *userShare = [UserShareOnce shareOnce];
            NSDictionary *dic = [[(NSDictionary *)response objectForKey:@"data"] objectForKey:@"member"];
            
            NSLog(@"%@",response);
            userShare = [UserShareOnce mj_objectWithKeyValues:dic];
            userShare.JSESSIONID = [[(NSDictionary *)response objectForKey:@"data"] objectForKey:@"JSESSIONID"];
            userShare.token = [[(NSDictionary *)response objectForKey:@"data"] objectForKey:@"token"];
            userShare.isRefresh = NO;
            userShare.passWord = self.passWordStr;
            if([GlobalCommon stringEqualNull:[dic objectForKey:@"uuid"]] ){
                userShare.uuid = nil;
            }
            NSArray *arrMem = [[[response objectForKey:@"data"] objectForKey:@"member"] objectForKey:@"mengberchild"];
            
            NSMutableArray *memberArr = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary *dic in  arrMem) {
                ChildMemberModel *model = [ChildMemberModel mj_objectWithKeyValues:dic];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                [memberArr addObject:data];
                if([model.mobile isEqualToString:[paramDic objectForKey:@"username"]]) {
                    MemberUserShance *memberShance = [MemberUserShance shareOnce];
                    memberShance = [MemberUserShance mj_objectWithKeyValues:dic];
                    if(memberArr.count>1){
                        [memberArr exchangeObjectAtIndex:0 withObjectAtIndex:[memberArr count] - 1];
                    }
                }
                
                
            }
            
            
            if (![[dic objectForKey:@"isMarried"] isKindOfClass:[NSNull class]]) {
                if ([[dic objectForKey:@"isMarried"] boolValue] == YES) {
                    userShare.marryState = ModuleZW(@"未婚");
                }else if ([[dic objectForKey:@"isMarried"] boolValue] == NO){
                    userShare.marryState = ModuleZW(@"未婚");
                }
            }
            
            [weakself saveLocalWithArr:memberArr];
            [weakself GetMemberChild];
        }else{
            [GlobalCommon hideMBHudTitleWithView:weakself.view];
            [weakself showAlertWarmMessage:[response objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        [GlobalCommon hideMBHudTitleWithView:weakself.view];
        [weakself showAlertWarmMessage:requestErrorMessage];
    }];
    
}

- (void)GetMemberChild
{
    
    NSString *aUrl = [NSString stringWithFormat:@"member/memberModifi/selectMemberChild.jhtml?mobile=%@",[UserShareOnce shareOnce].username];
    NSLog(@"name:%@,token:%@",[UserShareOnce shareOnce].username,[UserShareOnce shareOnce].token);
    __weak typeof(self) weakself = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:aUrl parameters:nil successBlock:^(id response) {
        if([[response objectForKey:@"status"] intValue] == 100){
            [GlobalCommon hideMBHudTitleWithView:weakself.view];
            //id data = [response objectForKey:@"data"];
            // if (data && data != [NSNull null]) {
            [UIApplication sharedApplication].keyWindow.rootViewController = [(AppDelegate*)[UIApplication sharedApplication].delegate tabBar];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            
            // }
        }else{
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [(AppDelegate*)[UIApplication sharedApplication].delegate tabBar];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            [weakself showAlertWarmMessage:[response objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        [GlobalCommon hideMBHudTitleWithView:weakself.view];
        [weakself showAlertWarmMessage:requestErrorMessage];
    }];
}

- (void)saveLocalWithArr:(NSArray *)memberArr
{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberChirldArr"];
    if (arr.count) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"memberChirldArr"];
    }
    NSArray *modelArr = [[NSArray alloc] initWithArray:memberArr];
    
    [[NSUserDefaults standardUserDefaults] setObject:modelArr forKey:@"memberChirldArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.code4View endEditing:YES];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.code4View.textField becomeFirstResponder];
    [self.code4View cursor];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.code4View endEditing:YES];
}
//重新发送验证码
-(void)resendCode {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = ModuleZW(@"加载中...");
    NSString *iPoneNumber = [NSString stringWithFormat:@"%@ky3h.com",self.numberStr];
    NSString *tokenStr = [GlobalCommon md5:iPoneNumber].uppercaseString;
    NSString *urlStr = [NSString string];
    NSDictionary *dic = [NSDictionary dictionary];
    if([self.numberStr containsString:@"@"]){
        urlStr  = @"/login/send/email.jhtml";
        dic = @{@"email":self.numberStr,
                @"token":tokenStr};
    }else{
        urlStr  = @"/login/send/phone.jhtml";
        dic = @{@"phone":self.numberStr,
                @"token":tokenStr};
    }
    
    [[NetworkManager sharedNetworkManager] requestWithType:BAHttpRequestTypePost urlString:urlStr parameters:dic successBlock:^(id response) {
        NSLog(@"%@",response);
        [hud hideAnimated:YES];
        if ([response[@"status"] integerValue] == 100){
            [GlobalCommon  showMessage2:ModuleZW(@"发送成功") duration2:2.0];
         
        }else{
            [self showAlertWarmMessage:response[@"message"]];
        }
        [hud hideAnimated:YES];
    } failureBlock:^(NSError *error) {
        [hud hideAnimated:YES];
        [self showAlertWarmMessage:requestErrorMessage];
    }];
}

@end
