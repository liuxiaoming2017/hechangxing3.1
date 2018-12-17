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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
