//
//  ArmchairAcheTestVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/17.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairAcheTestVC.h"
#import "ArmchairTestResultVC.h"

@interface ArmchairAcheTestVC ()

@end

@implementation ArmchairAcheTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"酸疼检测";
    
    [self initUI];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-116)/2.0, kNavBarHeight+35, 116, 35)];
    remindLabel.font = [UIFont fontWithName:@"PingFang SC" size:17];
    remindLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
    remindLabel.text = @"体型检测中…";
    remindLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remindLabel];
    
    CGFloat height = 251/677.0*(ScreenWidth-40);
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(20, remindLabel.bottom+55, ScreenWidth-40, height)];
    imageV.image = [UIImage imageNamed:@"体测图"];
    [self.view addSubview:imageV];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(imageV.left,imageV.bottom+55,124.5,22.5);
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"手心握住电极片"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentLeft;
   
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.frame = CGRectMake(imageV.left,label.bottom+15,245,120);
    label2.numberOfLines = 0;
    [self.view addSubview:label2];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"①静坐并备考在按摩椅上 \n②上肢自然放于两侧，掌心向下 \n③左手握住金属电极 \n④保持安静"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    label2.attributedText = string2;
    label2.textAlignment = NSTextAlignmentLeft;
}

- (void)messageBtnAction:(UIButton *)btn
{
    ArmchairTestResultVC *vc = [[ArmchairTestResultVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
