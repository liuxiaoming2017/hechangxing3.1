//
//  EDWKWebViewController.m
//  CookieStorageDemo
//
//  Created by Ella on 2018/5/21.
//  Copyright © 2018年 com.dove. All rights reserved.
//

#import "EDWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "EDWebviewCookieManager.h"
#import <WebKit/WKWebsiteDataStore.h>
#import <WebKit/WKWebsiteDataRecord.h>
#import "EDMacros.h"

#import "PayViewController.h"


@interface EDWKWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, copy) NSString *rootUrl;
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@end

@implementation EDWKWebViewController



- (instancetype)initWithUrlString:(NSString *)url {
    if (self = [super init]) {
        _rootUrl = url;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.rightBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    if(self.isCollect){
        self.preBtn.hidden = NO;
        self.leftBtn.hidden = YES;
        self.navTitleLabel.text = self.titleStr;
    }else{
        self.preBtn.hidden = YES;
        self.leftBtn.hidden = NO;
        self.navTitleLabel.text = ModuleZW(@"和畅商城");
    }
    
    
    [self customeViewWithStr:self.rootUrl];
    if(self.isCollect){
        self.wkwebview.frame = CGRectMake(0, self.topView.bottom, Screen_Width, Screen_Height-self.topView.bottom);
    }else{
        self.wkwebview.frame = CGRectMake(0, self.topView.bottom, Screen_Width, Screen_Height-self.topView.bottom-kTabBarHeight);
    }
   
    self.rightBtn.hidden = NO;
    [self.rightBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSize:) name:@"CHANGESIZE" object:nil];
    
}

- (void)messageBtnAction:(UIButton *)btn
{
//    NSString *cookieStr = [NSString stringWithFormat:@"document.cookie = '%@=%@';document.cookie = '%@=%@';",@"token",[UserShareOnce shareOnce].token,@"JSESSIONID",[UserShareOnce shareOnce].JSESSIONID];
//    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//
//    [self.wkwebview.configuration.userContentController addUserScript:cookieScript];
    
    [self testCookie];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.leftBtn.hidden = YES;
}


-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"22222");
    
}


- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
{
     NSLog(@"11111");
    
    decisionHandler(WKNavigationResponsePolicyAllow);
   
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];

    //NSLog(@"#############%@",[navigationAction.request allHTTPHeaderFields]);
    
    if(self.isCollect){
        if([strRequest isEqualToString:[NSString stringWithFormat:@"%@mobileIndex.html",URL_PRE]]){
            decisionHandler(WKNavigationActionPolicyAllow);
            //修改位置
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIViewController *controller = app.window.rootViewController;
            UITabBarController  *rvc = (UITabBarController  *)controller;
            [rvc setSelectedIndex:2];
            [self.navigationController popToRootViewControllerAnimated:YES];
            return;
        }
    }
    
        NSArray *array = [strRequest componentsSeparatedByString:@"="];
        if ([array[0] isEqualToString:[NSString stringWithFormat:@"%@%@",URL_PRE,@"member/mobile/order/payment.jhtml?sn"]]) {
            decisionHandler(WKNavigationActionPolicyCancel);
            
            PayViewController *payVC = [[PayViewController alloc]init];
            payVC.dingdanStr = array[1];
            payVC.hidesBottomBarWhenPushed = YES;
           // [webView goBack];
            [self.navigationController pushViewController:payVC animated:YES];
           
        }
        else{
            
            //[self clearCookieFromWKWebview];
            
//            [self.wkwebview.configuration.userContentController removeAllUserScripts];
//            NSString *cookieStr = [NSString stringWithFormat:@"document.cookie = '%@=%@';document.cookie = '%@=%@';",@"token",[UserShareOnce shareOnce].token,@"JSESSIONID",[UserShareOnce shareOnce].JSESSIONID];
//            WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
//
//            [self.wkwebview.configuration.userContentController addUserScript:cookieScript];
//
            
            
            NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            NSArray *_tmpArray = [NSArray arrayWithArray:[cookieStorage cookies]];
           // NSLog(@"&&&&&:%@",_tmpArray);


             NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UserShareOnce shareOnce].token,@"token",[UserShareOnce shareOnce].JSESSIONID,@"JSESSIONID", nil];
            NSLog(@"dic!!!!:%@",dic);
            
           // [self testCookie];
            
//            WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:@"alert(document.cookie);" injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
//            [self.wkwebview.configuration.userContentController addUserScript:cookieScript];
            
//            NSString *cookieStr = [NSString stringWithFormat:@"document.cookie = '%@=%@';document.cookie = '%@=%@';",@"token",[UserShareOnce shareOnce].token,@"JSESSIONID",[UserShareOnce shareOnce].JSESSIONID];
//            [self.wkwebview evaluateJavaScript:cookieStr completionHandler:^(id _Nullable success, NSError * _Nullable error) {
//                if(error){
//                    NSLog(@"error");
//                }else{
//                    NSLog(@"success");
//                }
//
//            }];
            
            decisionHandler(WKNavigationActionPolicyAllow);

            
            
            
//            if([navigationAction.request allHTTPHeaderFields][@"Cookie"]){
//                NSLog(@"cookie:%@",[navigationAction.request allHTTPHeaderFields]);
//                decisionHandler(WKNavigationActionPolicyAllow);
//            }else{
//                if([strRequest hasPrefix:@"tel"]){
//
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strRequest]];
//
//                    decisionHandler(WKNavigationActionPolicyCancel);
//
//                }else{
//
//                    NSString *urlStr =   [NSString stringWithFormat:@"%@",navigationAction.request.URL];
//                    if([urlStr hasSuffix:@"html"]){
//                        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"?fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
//                    }else{
//                        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
//                    }
//                    NSLog(@"===========%@",urlStr);
//
//                    NSURL *url = [NSURL URLWithString:urlStr];
//                    NSMutableURLRequest *request= [NSMutableURLRequest requestWithURL:url];
//                    //NSURLRequest *request = [navigationAction.request];
//                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UserShareOnce shareOnce].token,@"token",[UserShareOnce shareOnce].JSESSIONID,@"JSESSIONID", nil];
//                    [request addValue:[self readCurrentCookieWith:dic] forHTTPHeaderField:@"Cookie"];
//                    if([UserShareOnce shareOnce].languageType){
//                        [request addValue:[UserShareOnce shareOnce].languageType forHTTPHeaderField:@"language"];
//                    }
//                    [webView loadRequest:request];
//                    decisionHandler(WKNavigationActionPolicyCancel);
//                }
//            }

        }
    NSLog(@"str*****:%@",strRequest);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clearCookieFromWKWebview
{
    
    
    NSArray *types = @[WKWebsiteDataTypeCookies,WKWebsiteDataTypeSessionStorage];
    
    NSSet *websitDataTypes = [NSSet setWithArray:types];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websitDataTypes modifiedSince:date completionHandler:^{
    }];
}

- (void)testCookie
{
    if (@available(iOS 11.0, *)) {
        
        WKHTTPCookieStore *cookieStroe = self.wkwebview.configuration.websiteDataStore.httpCookieStore;

        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *tmpArray = [NSArray arrayWithArray:[cookieStorage cookies]];

        NSHTTPCookie *cookieToken = nil;
         NSHTTPCookie *cookieJSESSIONID = nil;

        for(NSHTTPCookie *cookie in tmpArray){
            if([cookie.name isEqualToString:@"token"]){
                cookieToken = cookie;
            }
            if([cookie.name isEqualToString:@"JSESSIONID"]){
                cookieJSESSIONID = cookie;
            }
        }
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        dic[NSHTTPCookieName] = @"liuxiaoming";
        dic[NSHTTPCookieValue] = @"aini";
        
        NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:[dic copy]];
        
        NSLog(@"cokie1:%@",cookie1);
        
        [cookieStroe setCookie:cookie1 completionHandler:^{
            
        }];
        
        //get cookies
        [cookieStroe getAllCookies:^(NSArray<NSHTTPCookie *> * _Nonnull cookies) {
            NSLog(@"count:%ld",cookies.count);
            for(NSHTTPCookie *cookie in cookies){
                if([cookie.name isEqualToString:@"token"]){
                    [cookieStroe deleteCookie:cookie completionHandler:^{
                        [cookieStroe setCookie:cookieToken completionHandler:^{
                            NSLog(@"success1");
                        }];
                    }];
                    
                }
                if([cookie.name isEqualToString:@"JSESSIONID"]){
                    [cookieStroe deleteCookie:cookie completionHandler:^{
                        [cookieStroe setCookie:cookieJSESSIONID completionHandler:^{
                            NSLog(@"success1");
                        }];
                    }];
                NSLog(@"原来的Name:%@,value:%@",cookie.name,cookie.value);
                }
                
            }
        }];
        
        
        
        
        
//        NSArray *arr = @[@{@"token":[UserShareOnce shareOnce].token},@{@"JSESSIONID":[UserShareOnce shareOnce].JSESSIONID}];
//
//        for(NSInteger i=0;i<2;i++){
//            NSDictionary *dic1 = [arr objectAtIndex:i];
//            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
//            [dic setObject:[[dic1 allValues] objectAtIndex:0] forKey:NSHTTPCookieValue];
//            [dic setObject:[[dic1 allKeys] objectAtIndex:0] forKey:NSHTTPCookieName];
//             NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:dic];
//            [cookieStroe setCookie:cookie completionHandler:^{
//                NSLog(@"set cookie");
//            }];
//        }
        
        
//        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        NSArray *tmpArray = [NSArray arrayWithArray:[cookieStorage cookies]];
//
//        for(NSHTTPCookie *cookie in tmpArray){
//            [cookieStroe setCookie:cookie completionHandler:^{
//               // NSLog(@"***Name:%@,value:%@",cookie.name,cookie.value);
//            }];
//        }
        
       
        
    }
}

- (void)cookiesDidChangeInCookieStore:(WKHTTPCookieStore *)cookieStore
{
    NSLog(@"哈哈哈哈");
}

// 显示两个按钮，通过completionHandler回调判断用户点击的确定还是取消按钮
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

// 显示一个带有输入框和一个确定按钮的，通过completionHandler回调用户输入的内容
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields.lastObject.text);
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 显示一个按钮。点击后调用completionHandler回调
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
