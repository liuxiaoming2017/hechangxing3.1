//
//  ScanSuccessJumpVC.m
//  SGQRCodeExample
//
//  Created by Sorgle on 16/8/29.
//  Copyright © 2016年 Sorgle. All rights reserved.
//
//  - - - - - - - - - - - - - - 交流QQ：1357127436 - - - - - - - - - - - - - - - //
//
//  - - 如在使用中, 遇到什么问题或者有更好建议者, 请于 kingsic@126.com 邮箱联系 - - - - //
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
//  - - GitHub下载地址 https://github.com/kingsic/SGQRCode.git - - - - - - - - - //
//
//  - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

#import "ScanSuccessJumpVC.h"

@interface ScanSuccessJumpVC ()

@property (nonatomic)BOOL isNetValid;
//未选中的imageView
@property (nonatomic,strong)UIImageView    *sanxuanzhongImageView;

//选中的imageView
@property (nonatomic,strong)UIImageView    *sixuanzhongImageView;
//是否是星标亲友
@property (nonatomic,copy)NSString *sanChange;


@property (nonatomic,copy) NSString *userStr;


@end

@implementation ScanSuccessJumpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _sanChange = @"0";
    [self setupNavigationItem];
    
   

}


- (void)setupNavigationItem {
    UIButton *left_Button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [left_Button setTitle:ModuleZW(@"返回") forState:UIControlStateNormal];
    [left_Button addTarget:self action:@selector(left_BarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left_BarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_Button];
    self.navigationItem.leftBarButtonItem = left_BarButtonItem;
}
- (void)left_BarButtonItemAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}




// 添加Label，加载扫描过来的内容
- (void)setupLabel {
    // 提示文字
    UILabel *prompt_message = [[UILabel alloc] init];
    prompt_message.frame = CGRectMake(0, 200, self.view.frame.size.width, 30);
    prompt_message.text = @"您扫描的条形码结果如下： ";
    prompt_message.textColor = [UIColor redColor];
    prompt_message.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:prompt_message];
    
    // 扫描结果
    CGFloat label_Y = CGRectGetMaxY(prompt_message.frame);
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, label_Y, self.view.frame.size.width, 30);
    label.text = self.jump_bar_code;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}




@end

