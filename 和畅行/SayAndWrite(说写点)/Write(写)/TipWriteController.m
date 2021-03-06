//
//  TipWriteController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/12.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "TipWriteController.h"
#import "WriteListController.h"

@interface TipWriteController ()

@end

@implementation TipWriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = ModuleZW(@"脏腑状态评估");
    
    CGFloat hh = self.topView.bottom + 25;
    UIImageView *backImageV = [[UIImageView alloc] initWithFrame:CGRectMake(25, hh, ScreenWidth-50, ScreenHeight-hh-25)];
    NSLog(@"%f,%f,%@",ScreenWidth,ScreenHeight,NSStringFromCGRect(backImageV.frame));
    backImageV.image = [UIImage imageNamed:ModuleZW(@"writeTip")];
    backImageV.userInteractionEnabled = YES;
    [self.view addSubview:backImageV];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake((backImageV.width-120)/2.0, backImageV.height-70, 120, 40);
    [nextBtn setBackgroundColor:UIColorFromHex(0x1e82d2)];
    [nextBtn setTitle:ModuleZW(@"进入")  forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[nextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 5.0;
    nextBtn.clipsToBounds = YES;
    [backImageV addSubview:nextBtn];
    
}

- (void)nextBtnAction
{
    WriteListController *vc = [[WriteListController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
