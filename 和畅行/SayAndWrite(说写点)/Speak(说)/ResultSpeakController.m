//
//  ResultSpeakController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/23.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ResultSpeakController.h"

@interface ResultSpeakController ()<UIGestureRecognizerDelegate>

@end

@implementation ResultSpeakController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = self.titleStr;
    [self customeViewWithStr:self.urlStr];
    
    if([self.titleStr isEqualToString:@"季度报告详情"]){
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    //
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    return YES;
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
        if([UserShareOnce shareOnce].languageType){
            [urlRequest setValue:[UserShareOnce shareOnce].languageType forHTTPHeaderField:@"language"];
        }
        [webView loadRequest:urlRequest];
        
    }
    
    NSLog(@"str*****:%@",strRequest);
    //decisionHandler(WKNavigationActionPolicyAllow);
}



@end
