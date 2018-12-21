//
//  ResultController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ResultController.h"
#import <WebKit/WebKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "JSONKit.h"

@interface ResultController ()<WKUIDelegate,WKNavigationDelegate>

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"健康档案";
    NSString *str = [NSString stringWithFormat:@"member/service/reshow.jhtml?sn=%@&device=1",self.TZBSstr];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,str];
    
    
    [self customeViewWithStr:urlStr];
}


- (void)goBack:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tabBarController.tabBar.hidden = YES;
    });
}
- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
