//
//  ResultSpeakController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/23.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ResultSpeakController.h"
#import "MeridianIdentifierViewController.h"
#import "TipSpeakController.h"
#import "ArmchairHomeVC.h"

#define anmoyi [NSString stringWithFormat:@"%@hcy/member/action/yinyue",URL_PRE]

@interface ResultSpeakController ()<UIGestureRecognizerDelegate>

@end

@implementation ResultSpeakController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = self.titleStr;
    [self customeViewWithStr:self.urlStr];
    
    if([self.titleStr isEqualToString:ModuleZW(@"季度报告详情")]){
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    //
}

# pragma mark - 解决侧滑返回指定控制器
- (void)didMoveToParentViewController:(UIViewController*)parent
{
    
    NSMutableArray *tempArr = self.navigationController.viewControllers.mutableCopy;
    for(UIViewController *vc in self.navigationController.viewControllers){
        if([vc isKindOfClass:[MeridianIdentifierViewController class]]||[vc isKindOfClass:[TipSpeakController class]]){
            [tempArr removeObject:vc];
        }
    }
    self.navigationController.viewControllers = tempArr;
    
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    return YES;
}



#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    if ([strRequest isEqualToString:anmoyi]){
        decisionHandler(WKNavigationActionPolicyCancel);
        
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:[ArmchairHomeVC class]]){
                [self.navigationController popToViewController:vc animated:YES];
                return;
            }
        }
        
        ArmchairHomeVC *vc = [[ArmchairHomeVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
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
        if([UserShareOnce shareOnce].languageType){
            [urlRequest setValue:[UserShareOnce shareOnce].languageType forHTTPHeaderField:@"language"];
        }
        [webView loadRequest:urlRequest];
        
    }
    
    NSLog(@"str*****:%@",strRequest);
    //decisionHandler(WKNavigationActionPolicyAllow);
}



@end
