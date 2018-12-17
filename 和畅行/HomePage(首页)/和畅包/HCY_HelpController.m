//
//  HCY_HelpController.m
//  和畅行
//
//  Created by 出神入化 on 2018/12/12.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_HelpController.h"

@interface HCY_HelpController ()

@end

@implementation HCY_HelpController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //布局一助页面
    [self layoutHelpView];
}

-(void)layoutHelpView {
    
    self.navTitleLabel.text = @"一助";
    
    UIImageView *contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, kNavBarHeight + 20, ScreenWidth - 20, (ScreenWidth - 20)*1.233)];
    contentImageView.userInteractionEnabled = YES;
    contentImageView.image = [UIImage imageNamed:@"hcy_helpcontent"];
    [self.view addSubview:contentImageView];
    
    
    UILabel *titleLabel = [Tools creatLabelWithFrame:CGRectMake(0, contentImageView.height - 85, contentImageView.width, 20) text:@"咨询预约敬请致电" textSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentImageView addSubview:titleLabel];
    
    UIButton *phoneButton = [Tools creatButtonWithFrame:CGRectMake(0, titleLabel.bottom -15 , contentImageView.width, 60) target:self sel:@selector(callPhoneAction) tag:100 image:nil title:@"400 6776 668"];
    [phoneButton.titleLabel setFont:[UIFont systemFontOfSize:26]];
    [phoneButton setTitleColor:RGB(243, 222, 99) forState:(UIControlStateNormal)];
    [contentImageView addSubview:phoneButton];

}

-(void)callPhoneAction {
    
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"4006776668"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
    [self.view addSubview:callWebview];
   
    
  
    
}

@end
