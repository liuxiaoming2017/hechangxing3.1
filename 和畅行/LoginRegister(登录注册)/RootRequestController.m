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
        NSString *usernameStr = [GlobalCommon AESDecodeWithString:[dicTmp objectForKey:@"USERNAME"]];
        NSString *passwordStr = [GlobalCommon AESDecodeWithString:[dicTmp objectForKey:@"PASSWORDAES"]];
        if([usernameStr isEqualToString:@""] || usernameStr == nil || usernameStr.length == 0 ){
            usernameStr = [dicTmp objectForKey:@"USERNAME"];
            passwordStr = [dicTmp objectForKey:@"PASSWORDAES"];
        }
        [dic setObject:usernameStr forKey:@"username"];
        [dic setObject:passwordStr forKey:@"password"];
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
        NSString *unionidStr = [GlobalCommon AESDecodeWithString:[dicTmp valueForKey:@"UNIONID"]];
        if([unionidStr isEqualToString:@""] || unionidStr == nil || unionidStr.length == 0 ){
            unionidStr = [dicTmp valueForKey:@"UNIONID"];
        }
        [dic setObject:unionidStr forKey:@"unionid"];
        [dic setObject:[dicTmp valueForKey:@"SCREENNAME"] forKey:@"screen_name"];
        [dic setObject:[dicTmp valueForKey:@"GENDER"] forKey:@"gender"];
        [dic setObject:[dicTmp valueForKey:@"PROFILEIMAGEURL"] forKey:@"profile_image_url"];
        // __block typeof(self) blockSelf = self;
        [self userLoginWithWeiXParams:dic withCheck:2];
        
    }else if ([strcheck isEqualToString:@"3"]){
        NSString *PhoneStr = [GlobalCommon AESDecodeWithString:[dicTmp valueForKey:@"PhoneShortMessage"]];
        if([PhoneStr isEqualToString:@""] || PhoneStr == nil || PhoneStr.length == 0 ){
            PhoneStr = [dicTmp valueForKey:@"PhoneShortMessage"];
        }
        [self userLoginWithShortMessage:PhoneStr];
    }else if ([strcheck isEqualToString:@"4"]){
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:[dicTmp valueForKey:@"user_id"] forKey:@"user_id"];
        
         [dic setObject:[dicTmp valueForKey:@"nikename"] forKey:@"nikename"];
         
         [dic setObject:[dicTmp valueForKey:@"sex"] forKey:@"sex"];
         [dic setObject:[dicTmp valueForKey:@"photourl"] forKey:@"photourl"];
         [dic setObject:[dicTmp valueForKey:@"id_token"] forKey:@"id_token"];
         [dic setObject:[dicTmp valueForKey:@"email"] forKey:@"email"];
        [self userLoginWithWeiXParams:dic withCheck:4];
    }
    else{
        [appDelegate() returnMainPage];
    }
    
}


- (void)showAlertWarmMessage:(NSString *)message
{

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
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
