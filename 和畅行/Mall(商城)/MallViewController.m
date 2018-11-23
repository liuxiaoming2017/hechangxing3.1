//
//  MallViewController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "MallViewController.h"

//@"member/mobile/order/payment.jhtml?sn"
//拦截支付
#define kPayUrl          @"member/mobile/order/payment.jhtml?sn"

@interface MallViewController ()

@end

@implementation MallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.backgroundColor = UIColorFromHex(0x1e82d2);
    self.navTitleLabel.text = @"和畅商城";
    self.preBtn.hidden = YES;
    NSString *urlStr = [NSString stringWithFormat:@"%@mobileIndex.html",URL_PRE];
    self.progressType = progress2;
    [self customeViewWithStr:urlStr];
    self.wkwebview.frame = CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight-49);
    
}

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
//{
//    //存储cookies
//    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
//        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
//        NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
//        NSLog(@"cook:%@",cookies);
//    });
//    decisionHandler(WKNavigationResponsePolicyAllow);
//}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    NSLog(@"#############%@",[navigationAction.request allHTTPHeaderFields]);
    
    
    NSArray *array = [strRequest componentsSeparatedByString:@"="];
    if ([array[0] isEqualToString:[NSString stringWithFormat:@"%@%@",URL_PRE,kPayUrl]]) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
                
    
    if([navigationAction.request allHTTPHeaderFields][@"Cookie"]){
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
        NSDictionary *headerFields = navigationAction.request.allHTTPHeaderFields;
       // NSString *cookie = headerFields[@"Cookie"];
     
            NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:navigationAction.request.URL];
            urlRequest.allHTTPHeaderFields = headerFields;
            [urlRequest setValue:[self getCookieValue] forHTTPHeaderField:@"Cookie"];
            [webView loadRequest:urlRequest];

    }
    
   
    NSLog(@"str*****:%@",strRequest);
    //decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if(self.progressType == progress2){
        
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
//     [webView evaluateJavaScript:@"document.location.href" completionHandler:^(id result, NSError * _Nullable error) {
//         NSLog(@"result:%@",result);
//     }];
    //NSLog(@"加载成功");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
