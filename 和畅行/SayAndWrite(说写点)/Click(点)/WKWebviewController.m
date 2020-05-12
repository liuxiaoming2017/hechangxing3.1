//
//  WKWebviewController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/20.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "WKWebviewController.h"
#import "ShareProcessPoll.h"
#import <WebKit/WebKit.h>
#if FIRST_FLAG
#import "ArmchairHomeVC.h"
#else
#import "OGA730BHomeVC.h"
#endif

@interface WKWebviewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation WKWebviewController

- (void)dealloc
{
    if(self.progressType == progress2)
    {
        [self.wkwebview removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    self.wkwebview = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preBtn.hidden = NO;
    //[self.leftBtn setImage:[UIImage imageNamed:@"user_01"] forState:UIControlStateNormal];
    self.leftBtn.hidden = YES;
    [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    
}

- (void)customeViewWithStr:(NSString *)urlStr
{
    
    if([urlStr hasSuffix:@"html"]){
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"?fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
    }else{
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
    }
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    //config.processPool = [[WKProcessPool alloc] init];
    
    WKUserContentController *userContentController = WKUserContentController.new;
    NSString *cookieStr = [NSString stringWithFormat:@"document.cookie = '%@=%@';document.cookie = '%@=%@';",@"token",[UserShareOnce shareOnce].token,@"JSESSIONID",[UserShareOnce shareOnce].JSESSIONID];
    
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieStr injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    
    
    [userContentController addUserScript:cookieScript];
    
    config.userContentController = userContentController;
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    //config.userContentController = userContentController;
    
    self.wkwebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight)
                                              configuration:config];
    // 导航代理
    self.wkwebview.navigationDelegate = self;
    // 与webview UI交互代理
    self.wkwebview.UIDelegate = self;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:[self getCookieValue] forHTTPHeaderField:@"Cookie"];
    
    if([UserShareOnce shareOnce].languageType){
        [request addValue:[UserShareOnce shareOnce].languageType forHTTPHeaderField:@"language"];
    }
    request.timeoutInterval = 20;
    [self.wkwebview loadRequest:request];
    [self.view addSubview:self.wkwebview];
    
    if(self.progressType == progress2){
        // 添加KVO监听
        [self.wkwebview addObserver:self
                         forKeyPath:@"estimatedProgress"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.frame = CGRectMake(0, 0, self.wkwebview.frame.size.width, 2);
        self.progressView.trackTintColor = [UIColor clearColor]; // 设置进度条的色彩
        self.progressView.progressTintColor = UIColorFromHex(0x1e82d2);
        // 设置初始的进度
        [self.progressView setProgress:0.05 animated:YES];
        [self.wkwebview addSubview:self.progressView];
       
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    // [GlobalCommon showMBHudWithView:self.view];
}



- (NSString*)readCurrentCookieWith:(NSDictionary*)dic{
    if (dic == nil) {
        return nil;
    }else{
        NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSMutableString *cookieString = [[NSMutableString alloc] init];
        for (NSHTTPCookie*cookie in [cookieJar cookies]) {
            [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
        }
        //删除最后一个“；”
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
        return cookieString;
        
    }
}

- (NSMutableString*)getCookieValue{
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    return cookieValue;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if(self.progressType == progress2){
        
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    NSLog(@"加载成功");
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    if(self.progressType == progress2){
        
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    [GlobalCommon showMessage:requestErrorMessage duration:2];
    //[self addFailView];
}

- (void)goBack:(UIButton *)btn
{
    
    
#if FIRST_FLAG
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ArmchairHomeVC class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
#else
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[OGA730BHomeVC class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
#endif
    
    if (self.popInt == 111 || [self.titleStr isEqualToString:ModuleZW(@"和畅包")]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    
    NSString *pageIDStr = @"";
    
    
    if ([self.navTitleLabel.text isEqualToString:ModuleZW(@"经络辨识")]) {
        pageIDStr = @"6";
    }
    if (![pageIDStr isEqualToString:@""]) {
        self.endTimeStr = [GlobalCommon getCurrentTimes];
        [GlobalCommon pageDurationWithpageId:pageIDStr withstartTime:self.startTimeStr withendTime:self.endTimeStr];
    }
    
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([object isEqual:self.wkwebview] && [keyPath isEqualToString:@"estimatedProgress"]) { // 进度条
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        //NSLog(@"打印测试进度值：%f", newprogress);
        if (newprogress == 1) { // 加载完成
            // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES];
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            });
            
        } else { // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{

    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    //NSURL *url = navigationAction.request.URL;
    if (policy == WKNavigationActionPolicyAllow) {
        NSDictionary *dic = navigationAction.request.allHTTPHeaderFields;
        NSString *cookie = [dic objectForKey:@"Cookie"];
        if (cookie == nil) {
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:navigationAction.request.URL];
            request.allHTTPHeaderFields = dic;
            [request setValue:@"替换custom cookie" forHTTPHeaderField:@"Cookie"];
            [webView loadRequest:request];
            policy = WKNavigationActionPolicyCancel;
        }
    }
    if (decisionHandler) {
        decisionHandler(policy);
    }
}

// 此方法是收到响应开始加载后才会调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    // 获取cookie
    if (@available(iOS 12.0, *)) {//iOS11也有这种获取方式，但是我使用的时候iOS11系统可以在response里面直接获取到，只有iOS12获取不到
        WKHTTPCookieStore *cookieStore = webView.configuration.websiteDataStore.httpCookieStore;
        [cookieStore getAllCookies:^(NSArray* cookies) {
            [self setCookie:cookies];
        }];
    }else {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)navigationResponse.response;
        NSArray *cookies =[NSHTTPCookie cookiesWithResponseHeaderFields:[response allHeaderFields] forURL:response.URL];
        [self setCookie:cookies];
    }

    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 保存cookie到NSHTTPCookieStorage
-(void)setCookie:(NSArray *)cookies {
    if (cookies.count > 0) {
        for (NSHTTPCookie *cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
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
