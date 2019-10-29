//
//  PayDoneViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/10/27.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "PayDoneViewController.h"

@interface PayDoneViewController ()

@end

@implementation PayDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = ModuleZW(@"支付信息");
    [self initWithController];
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
}

-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initWithController{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 69, kScreenSize.width, 300)];
    backImageView.image = [UIImage imageNamed:@"支付结果背景"];
    [self.view addSubview:backImageView];
    UIImageView *stateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenSize.width/2-100, 20, 200, 200)];
    stateImageView.image = [UIImage imageNamed:[self.result isEqualToString:@"success"]?@"支付成功图片":@"支付失败图片"];
    [backImageView addSubview:stateImageView];
    UILabel *stateLabel = [Tools labelWith:[self.result isEqualToString:@"success"]?@"支付成功":@"支付异常" frame:CGRectMake(kScreenSize.width/2-50, 240, 100, 15) textSize:22 textColor:[UIColor whiteColor] lines:1 aligment:NSTextAlignmentCenter];
    stateLabel.font = [UIFont boldSystemFontOfSize:22];
    [backImageView addSubview:stateLabel];
    UILabel *infoLabel = [Tools labelWith:[self.result isEqualToString:@"success"]?@"您已成功购买商品，请注意查收":@"当前支付异常，请重新支付" frame:CGRectMake(0, 260, kScreenSize.width, 10) textSize:16 textColor:[UIColor whiteColor] lines:1 aligment:NSTextAlignmentCenter];
    infoLabel.font = [UIFont boldSystemFontOfSize:16];
    [backImageView addSubview:infoLabel];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width/2-80, kScreenSize.height-140, 160, 30)];
    [button setImage:[UIImage imageNamed:[self.result isEqualToString:@"success"]?@"支付完成":@"重新支付图标"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)buttonClick:(UIButton *)button{
    if ([self.result isEqualToString:@"success"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        //重新支付
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
