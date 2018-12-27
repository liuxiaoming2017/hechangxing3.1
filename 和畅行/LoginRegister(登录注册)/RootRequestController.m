//
//  RootRequestController.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/14.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "RootRequestController.h"
#import "AppDelegate.h"
#import "HomePageController.h"
#import "CustomNavigationController.h"

@interface RootRequestController ()

@end

@implementation RootRequestController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString*viewOrientation =@"Portrait";//横屏请设置成 @"Landscape"
    NSString*launchImage =nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for(NSDictionary* dict in imagesDict) {
        CGSize imageSize =CGSizeFromString(dict[@"UILaunchImageSize"]);
        if(CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    UIImageView*launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    launchView.frame=[UIScreen mainScreen].bounds;
    launchView.contentMode=UIViewContentModeScaleAspectFill;
    [self.view addSubview:launchView];
    
    [self loginRequest];
    
}


- (void)loginRequest
{
    
    NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
    NSString *strcheck=[dicTmp objectForKey:@"ischeck"];
    if([strcheck isEqualToString:@"1"]){
        
        
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        CGFloat width = size.width;
        CGFloat height = size.height;
        NSString* widthheight=[NSString stringWithFormat:@"%d*%d",(int)width,(int)height ];
        NSDate *datenow = [NSDate date];
        NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:@"beta1.4" forKey:@"softver"];
        [dic setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osver"];
        [dic setObject:widthheight forKey:@"resolution"];
        [dic setObject:timeSp forKey:@"time"];
        [dic setObject:[dicTmp objectForKey:@"USERNAME"] forKey:@"username"];
        [dic setObject:[dicTmp objectForKey:@"PASSWORDAES"] forKey:@"password"];
        [dic setObject:@"" forKey:@"brand"];
        [dic setObject:@"" forKey:@"devmodel"];
       // __block typeof(self) blockSelf = self;
        [self userLoginWithParams:dic withisCheck:YES];
//        [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:aUrl parameters:dic successBlock:^(id response) {
//
//        } failureBlock:^(NSError *error) {
//
//        }];
    }else if ([strcheck isEqualToString:@"2"]){
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:[dicTmp valueForKey:@"UNIONID"] forKey:@"unionid"];
        [dic setObject:[dicTmp valueForKey:@"SCREENNAME"] forKey:@"screen_name"];
        [dic setObject:[dicTmp valueForKey:@"GENDER"] forKey:@"gender"];
        [dic setObject:[dicTmp valueForKey:@"PROFILEIMAGEURL"] forKey:@"profile_image_url"];
        // __block typeof(self) blockSelf = self;
        [self userLoginWithWeiXParams:dic withCheck:2];
        
    }else if ([strcheck isEqualToString:@"3"]){
        [self userLoginWithShortMessage:[dicTmp valueForKey:@"PhoneShortMessage"]];
    }
    else{
        [appDelegate() returnMainPage];
    }
    
}

/*
- (void)GetMemberChild
{
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/memberModifi/selectMemberChild.jhtml?mobile=%@",UrlPre,g_userInfo.UserName];
    NSMutableDictionary *headDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [headDic setObject:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID] forKey:@"Cookie"];
    __block typeof(self) blockSelf = self;
    [[NetWorkSharedInstance sharedInstance] networkWithRequestUrlStr:aUrl RequestMethod:@"GET" PostDictionay:nil headDictionay:headDic Success:^(id result, int flag) {
        id status=[result objectForKey:@"status"];
        if ([status intValue]==100)
        {
            id data=[result objectForKey:@"data"];
            g_userInfo.mengberchildId=[data objectForKey:@"id"];
            NSString *greetStr = [NSString stringWithFormat:@"登录成功,欢迎%@",g_userInfo.UserName];
            HomeViewController *mainview = [[HomeViewController alloc] init];
            CustomNavigationController *nav=[[CustomNavigationController alloc]initWithRootViewController:mainview];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
            
            
            [GlobalCommon showMessage:greetStr duration:2.0];
            
        }else{
//            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[result objectForKey:@"data"] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [appDelegate() returnMainPage];
//            }];
//            [alertVC addAction:alertAct1];
//            [self presentViewController:alertVC animated:YES completion:NULL];
            [blockSelf showAlertWarmMessage:[result objectForKey:@"data"]];
        }
    } Fail:^(id error, int flag) {
        [blockSelf showAlertWarmMessage:@"抱歉登录失败，请重试"];
    }];
}
*/

- (void)showAlertWarmMessage:(NSString *)message
{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [appDelegate() returnMainPage];
    }];
    
    [alertVC addAction:alertAct1];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

AppDelegate *appDelegate()
{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
