//
//  ResultSpeakController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/23.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ResultSpeakController.h"

@interface ResultSpeakController ()

@end

@implementation ResultSpeakController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = self.titleStr;
    [self customeViewWithStr:self.urlStr];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
