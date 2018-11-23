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


#define yueleyi [NSString stringWithFormat:@"%@hcy/member/action/erxue",URL_PRE]

#define yundong [NSString stringWithFormat:@"%@hcy/member/action/yundong",URL_PRE]

#define yinyue [NSString stringWithFormat:@"%@hcy/member/action/yinyue",URL_PRE]

@interface HeChangPackgeController ()
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation HeChangPackgeController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = self.titleStr;
    [self customeViewWithStr:self.urlStr];
    
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    NSString *ganyuStr = [NSString stringWithFormat:@"%@hcy/member/action/ganyufangan",URL_PRE];
    if([strRequest isEqualToString:ganyuStr]){
        decisionHandler(WKNavigationActionPolicyCancel);
        GanYuSchemeController *vc = [[GanYuSchemeController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([strRequest isEqualToString:yueleyi]){ //悦乐仪
        decisionHandler(WKNavigationActionPolicyCancel);
        YueYaoController *vc = [[YueYaoController alloc] initWithType:YES];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([strRequest isEqualToString:yundong]){ //进入运动
        decisionHandler(WKNavigationActionPolicyCancel);
        MySportController *vc = [[MySportController alloc] initWithAllSport];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if ([strRequest isEqualToString:yinyue]){ //进入音乐
        decisionHandler(WKNavigationActionPolicyCancel);
        YueYaoController *vc = [[YueYaoController alloc] initWithType:NO];
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
            NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:navigationAction.request.URL];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UserShareOnce shareOnce].token,@"token",[UserShareOnce shareOnce].JSESSIONID,@"JSESSIONID", nil];
            [request addValue:[self readCurrentCookieWith:dic] forHTTPHeaderField:@"Cookie"];
            [webView loadRequest:request];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        
    }
    NSLog(@"str:%@",strRequest);
    
}

- (void)goBack:(UIButton *)btn
{
    if(self.noWebviewBack){
         [self.navigationController popViewControllerAnimated:YES];
    }else{
        if([self.wkwebview canGoBack]){
            [self.wkwebview goBack];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
