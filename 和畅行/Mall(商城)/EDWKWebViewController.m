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

static inline WKUserScript * WKCookieUserScript(NSString *cookieString) {
    if (!cookieString.length) {
        return nil;
    }
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieString
                                                        injectionTime:WKUserScriptInjectionTimeAtDocumentStart
                                                     forMainFrameOnly:NO];
    return cookieScript;
}

typedef void(^EDLoadRequestAction)(void);

@interface EDWKWebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, copy) NSString *rootUrl;
@property (nonatomic, strong) WKWebView *webview;
@property (nonatomic, strong) WKWebView *cookieWebview;
@property (nonatomic, copy) EDLoadRequestAction loadAction;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@end

@implementation EDWKWebViewController

+ (WKProcessPool *)sharedProcessPool
{
    static WKProcessPool *processPool;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        processPool = [WKProcessPool new];
    });
    return processPool;
}

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
    
    [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    if(self.isCollect){
        self.preBtn.hidden = NO;
        self.leftBtn.hidden = YES;
        self.navTitleLabel.text = self.titleStr;
    }else{
        self.preBtn.hidden = YES;
        self.leftBtn.hidden = NO;
        self.navTitleLabel.text = ModuleZW(@"和畅商城");
    }
    
    
    [self.view addSubview:self.webview];
    [self.webview addSubview:self.indicatorView];
    [self startToLoadRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSize:) name:@"CHANGESIZE" object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.leftBtn.hidden = YES;
}

- (void)startToLoadRequest {
    [self.indicatorView startAnimating];
    NSString *urlStr = [NSString string];
    if([self.rootUrl hasSuffix:@"html"]){
        urlStr= [self.rootUrl stringByAppendingString:[NSString stringWithFormat:@"?fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
    }else{
        urlStr= [self.rootUrl stringByAppendingString:[NSString stringWithFormat:@"&fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    __weak typeof(self) weakSelf = self;
    self.loadAction = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.webview loadRequest:[NSURLRequest requestWithURL:url]];
    };
    [self syncCookieForURL:url loadAction:self.loadAction];
}

- (void)syncCookieForURL:(NSURL *)url loadAction:(EDLoadRequestAction)loadAction {
    [[EDWebviewCookieManager sharedCookieManager] shouldLoadRequestURL:url scriptCallback:^(NSString *cookieScript) {
        if (cookieScript.length) {
            [self.cookieWebview.configuration.userContentController removeAllUserScripts];
            [self.cookieWebview.configuration.userContentController addUserScript:WKCookieUserScript(cookieScript)];
            NSString *baseWebUrl = [NSString stringWithFormat:@"%@://%@", url.scheme,url.host];
            //如果需要加载cookie，则需要再cookie webview加载结束后再加载url，也就是在webView:(WKWebView *)webView didFinishNavigation方法中开始加载url
            [self.cookieWebview loadHTMLString:@"" baseURL:[NSURL URLWithString:baseWebUrl]];
        } else {
            //如果没有cookie需要加载，则直接加载url
            if (loadAction) {
                loadAction();
            }
        }
    }];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.indicatorView stopAnimating];

    if (webView == self.cookieWebview) {
        //cookieWebview加载成功后开始加载真正的url
        if (self.loadAction) {
            self.loadAction();
        }
        return;
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.indicatorView stopAnimating];
    
}


#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    
    NSLog(@"#############%@",[navigationAction.request allHTTPHeaderFields]);
    
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
            [webView goBack];
            [self.navigationController pushViewController:payVC animated:YES];
           
        }
        else{
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    NSLog(@"str*****:%@",strRequest);
}

#pragma mark - getter
- (WKWebView *)webview {
    if (!_webview) {
        WKUserContentController *userContentController = WKUserContentController.new;
        WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
        webViewConfig.userContentController = userContentController;
        //processPool需要和_cookieWebview的公用一个才能共享_cookieWebview的cookie
        webViewConfig.processPool = [EDWKWebViewController sharedProcessPool];
        
        _webview = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webViewConfig];
        if(self.isCollect){
            _webview.frame = CGRectMake(0, self.topView.bottom, Screen_Width, Screen_Height-self.topView.bottom);
        }else{
            _webview.frame = CGRectMake(0, self.topView.bottom, Screen_Width, Screen_Height-self.topView.bottom-kTabBarHeight);
        }
        _webview.UIDelegate = self;
        _webview.navigationDelegate = self;
    }
    return _webview;
}

- (WKWebView *)cookieWebview {
    if (!_cookieWebview) {
        WKUserContentController *userContentController = WKUserContentController.new;
        WKWebViewConfiguration* webViewConfig = WKWebViewConfiguration.new;
        webViewConfig.userContentController = userContentController;
        webViewConfig.processPool = [EDWKWebViewController sharedProcessPool];
        
        if(self.isCollect){
            _cookieWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, Screen_Width, Screen_Height-self.topView.bottom) configuration:webViewConfig];
        }else{
            _cookieWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, Screen_Width, Screen_Height-self.topView.bottom-kTabBarHeight) configuration:webViewConfig];
        }
        
        _cookieWebview.UIDelegate = self;
        _cookieWebview.navigationDelegate = self;
    }
    return _cookieWebview;
}


- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 200);
    }
    return _indicatorView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//改变字体大小
-(void)changeSize:(NSNotification *)notifi {
    [self startToLoadRequest];
}


@end
