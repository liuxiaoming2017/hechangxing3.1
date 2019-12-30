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
    
    self.navTitleLabel.text = ModuleZW(@"一助");
    
    UIImageView *contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, kNavBarHeight + 20, ScreenWidth - 20, (ScreenWidth - 20)*1.233)];
    contentImageView.userInteractionEnabled = YES;
    contentImageView.image = [UIImage imageNamed: ModuleZW(@"hcy_helpcontent") ];
    [self.view addSubview:contentImageView];
    
    
    UILabel *titleLabel = [Tools creatLabelWithFrame:CGRectMake(0, contentImageView.height - Adapter(85), contentImageView.width, Adapter(20)) text:ModuleZW(@"咨询预约敬请致电") textSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentImageView addSubview:titleLabel];
    
    UIButton *phoneButton = [Tools creatButtonWithFrame:CGRectMake(0, titleLabel.bottom -Adapter(15) , contentImageView.width, Adapter(60)) target:self sel:@selector(callPhoneAction) tag:100 image:nil title:@"400 6776 668"];
    [phoneButton.titleLabel setFont:[UIFont systemFontOfSize:26]];
    [phoneButton setTitleColor:RGB(243, 222, 99) forState:(UIControlStateNormal)];
    [contentImageView addSubview:phoneButton];

}

-(void)callPhoneAction {
    
    if ([UserShareOnce shareOnce].languageType) {
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"温馨提示") message:ModuleZW(@"请在法定工作日AM9:00-PM17:00拨打") preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cabcekAction  = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:(UIAlertActionStyleCancel) handler:nil];
        UIAlertAction *sureAction  = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006776668"]];
        }];
        [alerVC addAction:cabcekAction];
        [alerVC addAction:sureAction];
        [self presentViewController:alerVC animated:YES completion:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006776668"]];
    }
}

@end
