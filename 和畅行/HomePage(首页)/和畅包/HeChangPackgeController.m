//
//  HeChangPackgeController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/1.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HeChangPackgeController.h"
#import "GanYuSchemeController.h"
#import "MySportController.h"
#import "YueYaoController.h"
#import "i9_MoxaMainViewController.h"


#define yueleyi [NSString stringWithFormat:@"%@hcy/member/action/erxue",URL_PRE]

#define yundong [NSString stringWithFormat:@"%@hcy/member/action/yundong",URL_PRE]

#define yinyue [NSString stringWithFormat:@"%@hcy/member/action/yinyue",URL_PRE]

#define aijiu [NSString stringWithFormat:@"%@hcy/member/action/aijiu",URL_PRE]

@interface HeChangPackgeController ()
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,assign) BOOL isForeground; //是否是从后台返回到前台
@end

@implementation HeChangPackgeController
@synthesize isForeground;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = self.titleStr;
    [self customeViewWithStr:self.urlStr];
    isForeground = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appHasGoneForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];

    //NSString *ganyuStr = [NSString stringWithFormat:@"%@hcy/member/action/ganyufangan",URL_PRE];
    NSString *ganyuStr = [NSString stringWithFormat:@"%@member/action/ganyufangan",URL_PRE];
    NSLog(@"%@",strRequest);
    
    if ([strRequest containsString:@"/member/service/view/tiyan/JLBS"]){
        self.navTitleLabel.text = ModuleZW(@"经络体检报告");
    }else if ([strRequest containsString:@"member/service/zf_report.jhtml"]){
        self.navTitleLabel.text = ModuleZW(@"脏腑体检报告");
    }else if ([strRequest containsString:@"member/service/view/tiyan/TZBS"]){
        self.navTitleLabel.text = ModuleZW(@"体质体检报告");
    }else if ([strRequest containsString:@"/member/service/home"]){
        self.navTitleLabel.text = ModuleZW(@"和畅包");
    }else if ([strRequest containsString:@"member/service/index/yibao/TZBS/"]){
        self.navTitleLabel.text = ModuleZW(@"健康保险");
    }
    ///member/service/view/fang/JLBS
    
    if([strRequest isEqualToString:ganyuStr]){
        decisionHandler(WKNavigationActionPolicyCancel);
        GanYuSchemeController *vc = [[GanYuSchemeController alloc] init];
        vc.notYiChi = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([strRequest isEqualToString:yueleyi]){ //悦乐仪
        decisionHandler(WKNavigationActionPolicyCancel);
        YueYaoController *vc = [[YueYaoController alloc] initWithType:YES];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([strRequest isEqualToString:yundong]){ //进入运动
        
        if(![UserShareOnce shareOnce].languageType&&![[UserShareOnce shareOnce].bindCard isEqualToString:@"1"]){
            [self showAlertWarmMessage:@"您还不是会员"];
            return;
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        NSString *physicalStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"Physical"];
        NSString *yueyaoIndex = [GlobalCommon getSportTypeFrom:physicalStr];
        if(yueyaoIndex == nil){
            MySportController *vc = [[MySportController alloc] initWithAllSport];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            MySportController *vc = [[MySportController alloc] initWithSportType:[yueyaoIndex integerValue]];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        return;
    }else if ([strRequest isEqualToString:yinyue]){ //进入音乐
        decisionHandler(WKNavigationActionPolicyCancel);
        YueYaoController *vc = [[YueYaoController alloc] initWithType:NO];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([strRequest isEqualToString:aijiu]){ //进入艾灸
        decisionHandler(WKNavigationActionPolicyCancel);
        i9_MoxaMainViewController *vc = [[i9_MoxaMainViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if([navigationAction.request allHTTPHeaderFields][@"Cookie"]){
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        if([strRequest hasPrefix:@"tel"]){

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strRequest]];
            
            decisionHandler(WKNavigationActionPolicyCancel);

        }else{
            
            if([strRequest hasSuffix:@"html"]){
                strRequest = [strRequest stringByAppendingString:[NSString stringWithFormat:@"?fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
            }else{
                strRequest = [strRequest stringByAppendingString:[NSString stringWithFormat:@"&fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
            }
            
            NSURL *url = [NSURL URLWithString:strRequest];
            NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UserShareOnce shareOnce].token,@"token",[UserShareOnce shareOnce].JSESSIONID,@"JSESSIONID", nil];
            [request addValue:[self readCurrentCookieWith:dic] forHTTPHeaderField:@"Cookie"];
            if([UserShareOnce shareOnce].languageType){
                [request addValue:[UserShareOnce shareOnce].languageType forHTTPHeaderField:@"language"];
            }
            [webView loadRequest:request];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        
    }
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    
}

- (void)goBack:(UIButton *)btn
{
    if(self.noWebviewBack){
         [self.navigationController popViewControllerAnimated:YES];
    }else{
//        NSLog(@"list:%ld",self.wkwebview.backForwardList.backList.count);
//        NSLog(@"haha*****:%@",[self syncExecScript]);
        //解决应用进入后台后,canGoBack 判断问题
        if(isForeground){
            NSString *urlStr = [NSString stringWithFormat:@"%@member/service/home/1/%@.jhtml?isnew=1",URL_PRE,[MemberUserShance shareOnce].idNum];
            if([urlStr isEqualToString:[self syncExecScript]]){
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
        if([self.wkwebview canGoBack]){
            
            [self.wkwebview goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

//同步获取当前html界面的地址
- (NSString *)syncExecScript
{
    __block BOOL finished = NO;
    __block NSString *content = nil;
    NSString *script = @"window.location.href";
    [self.wkwebview evaluateJavaScript:script completionHandler:^(id _Nullable result, NSError * _Nullable error) {
     content = result;
     finished = YES;
    }];
    while (!finished)
        {
           [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    return content;
}

- (void)appHasGoneForeground
{
    isForeground = YES;
    //NSLog(@"回到前台");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
