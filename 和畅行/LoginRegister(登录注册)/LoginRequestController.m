//
//  LoginRequestController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "LoginRequestController.h"
#import "RegisterViewController.h"
#import "CustomNavigationController.h"
#import "ChildMemberModel.h"
#import "HomePageController.h"
#import "AppDelegate.h"

@interface LoginRequestController ()

@end

@implementation LoginRequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavBarHeight)] ;
    navView.backgroundColor = UIColorFromHex(0x009ef3);
    [self.view addSubview:navView];
    [self.view sendSubviewToBack:navView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-120)/2.0, kStatusBarHeight+2, 120, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor =[UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font=[UIFont systemFontOfSize:18];
    [navView addSubview:titleLabel];
}

- (void)addBackBtn
{
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    preBtn.frame = CGRectMake(10, kStatusBarHeight+2, 60, 40);
    [preBtn setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    [preBtn setTitle:@"返回" forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [preBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    //[preBtn sizeToFit];
    preBtn.titleEdgeInsets = UIEdgeInsetsMake(1, -5, 0, 0);
    preBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [navView addSubview:preBtn];
}

- (void)addRightBtn
{
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    preBtn.frame = CGRectMake(ScreenWidth-60-20, kStatusBarHeight+2, 60, 40);
    [preBtn setTitle:@"注册" forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [preBtn addTarget:self action:@selector(registAction) forControlEvents:UIControlEventTouchUpInside];
    //[preBtn sizeToFit];
    preBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [navView addSubview:preBtn];
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)registAction
{
    
}

- (void)userLoginWithParams:(NSDictionary *)paramDic withisCheck:(BOOL)isCheck
{
   // NSString *aUrl = @"weiq/sms/login.jhtml";
    NSString *aUrl = @"login/commit.jhtml";
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
            userShare.passWord = self->passWordBox.text;
            NSArray *arrMem = [[[response objectForKey:@"data"] objectForKey:@"member"] objectForKey:@"mengberchild"];
            
            NSMutableArray *memberArr = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary *dic in  arrMem) {
                ChildMemberModel *model = [ChildMemberModel mj_objectWithKeyValues:dic];
                if([model.mobile isEqualToString:[paramDic objectForKey:@"username"]]) {
                    MemberUserShance *memberShance = [MemberUserShance shareOnce];
                    memberShance = [MemberUserShance mj_objectWithKeyValues:dic];
                    
                }
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                [memberArr addObject:data];
            }
            
            
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
            NSArray *modelArr = [[NSArray alloc] initWithArray:memberArr];
            
            [[NSUserDefaults standardUserDefaults] setObject:modelArr forKey:@"memberChirldArr"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakself GetMemberChild];
        }else{
            [weakself showAlertWarmMessage:[response objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        
        [weakself showAlertWarmMessage:requestErrorMessage];
    }];
    
}


- (void)userLoginWithSMSParams:(NSDictionary *)paramDic {
      NSString *aUrl = @"weiq/sms/login.jhtml";
    
    
}

- (void)GetMemberChild
{
   
    NSString *aUrl = [NSString stringWithFormat:@"member/memberModifi/selectMemberChild.jhtml?mobile=%@",[UserShareOnce shareOnce].username];
    NSLog(@"name:%@,token:%@",[UserShareOnce shareOnce].username,[UserShareOnce shareOnce].token);
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:aUrl parameters:nil successBlock:^(id response) {
        if([[response objectForKey:@"status"] intValue] == 100){
            id data = [response objectForKey:@"data"];
            if (data && data != [NSNull null]) {
//                [UserShareOnce shareOnce].mengberchild = [data objectForKey:@"id"];
                [UIApplication sharedApplication].keyWindow.rootViewController = [(AppDelegate*)[UIApplication sharedApplication].delegate tabBar];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
                
            }
        }else{
            
            [UIApplication sharedApplication].keyWindow.rootViewController = [(AppDelegate*)[UIApplication sharedApplication].delegate tabBar];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
}

- (void)showAlertViewController:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:alertAct1];
    [alertVC addAction:alertAct12];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (void)showAlertWarmMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
    [alertVC addAction:alertAct1];
    [self presentViewController:alertVC animated:YES completion:NULL];
}


//微信登录 check == 2 or 短息登录 check == 3
- (void)userLoginWithWeiXParams:(NSDictionary *)paramDic withCheck:(NSInteger)check{
    NSString *aUrl = [NSString string];

    if (check == 2) {
        aUrl = @"/weiq/weiq/weix/authlogin.jhtml";
    }else if (check == 3) {
        aUrl = @"/weiq/sms/login.jhtml";
    }
    
    __weak typeof(self) weakself = self;
    
    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:paramDic successBlock:^(id response) {
        NSLog(@"%@",response);

        if([[response objectForKey:@"status"] intValue] == 100){
            
            //判断是不是第一次登录
            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLongined"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLongined"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLogin"];
            }
            else{
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLogin"];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[paramDic objectForKey:@"username"] forKey:@"loginPhone"];
            //将登录成功的标志保存到本地
            [[NSUserDefaults standardUserDefaults] setObject:@"isLogin" forKey:@"longinStatus"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //发送登录成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginCompleted" object:self userInfo:nil];
            
            
            UserShareOnce *userShare = [UserShareOnce shareOnce];
            NSDictionary *dic = [[(NSDictionary *)response objectForKey:@"data"] objectForKey:@"member"];
            
            NSLog(@"%@",dic);
            userShare = [UserShareOnce mj_objectWithKeyValues:dic];
            userShare.JSESSIONID = [[(NSDictionary *)response objectForKey:@"data"] objectForKey:@"JSESSIONID"];
            userShare.token = [[(NSDictionary *)response objectForKey:@"data"] objectForKey:@"token"];
            userShare.isRefresh = NO;
            NSArray *arrMem = [[[response objectForKey:@"data"] objectForKey:@"member"] objectForKey:@"mengberchild"];
            
            NSMutableArray *memberArr = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary *dic in  arrMem) {
                ChildMemberModel *model = [ChildMemberModel mj_objectWithKeyValues:dic];
                if([model.name isEqualToString:[[[response objectForKey:@"data"] objectForKey:@"member"] objectForKey:@"username"]]) {
                    MemberUserShance *memberShance = [MemberUserShance shareOnce];
                    memberShance = [MemberUserShance mj_objectWithKeyValues:dic];
                    
                }
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                [memberArr addObject:data];
            }
            
            
            if (check == 2)
            {
                NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
                if (dicTmp) {
                    [dicTmp setObject:[paramDic valueForKey:@"unionid"] forKey:@"UNIONID"];
                    if ([paramDic valueForKey:@"screen_name"] != nil) {
                        [dicTmp setObject:[paramDic valueForKey:@"screen_name"] forKey:@"SCREENNAME"];
                    }
                    [dicTmp setObject:[paramDic valueForKey:@"gender"] forKey:@"GENDER"];
                    [dicTmp setObject:[paramDic valueForKey:@"profile_image_url"] forKey:@"PROFILEIMAGEURL"];
                    [dicTmp setValue:@"2" forKey:@"ischeck"];

                }
                [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
            }
            
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
            NSArray *modelArr = [[NSArray alloc] initWithArray:memberArr];
            
            [[NSUserDefaults standardUserDefaults] setObject:modelArr forKey:@"memberChirldArr"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakself GetMemberChild];
        }else{
            [weakself showAlertWarmMessage:[response objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
        
        [weakself showAlertWarmMessage:requestErrorMessage];
    }];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
