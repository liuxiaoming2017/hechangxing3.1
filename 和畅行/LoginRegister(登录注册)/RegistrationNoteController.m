//
//  RegistrationNoteController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "RegistrationNoteController.h"
#import "LBReadingTimeScrollPanel.h"


@interface RegistrationNoteController ()
@property (strong, nonatomic) LBReadingTimeScrollPanel *scrollPanel;
@end

@implementation RegistrationNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = @"注册说明";
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    
    LBReadingTimeScrollPanel *scrollPanel1 = [[LBReadingTimeScrollPanel alloc] initWithFrame:CGRectZero];
    self.scrollPanel=scrollPanel1;
    
    UITextView* DisclaimerTV=[[UITextView alloc] init];
    DisclaimerTV.frame=CGRectMake(15, kNavBarHeight, ScreenWidth-30, ScreenHeight-kNavBarHeight);
    DisclaimerTV.text=RegistText;
    DisclaimerTV.enableReadingTime = YES;
    DisclaimerTV.userInteractionEnabled=YES;
    DisclaimerTV.scrollEnabled=YES;
    DisclaimerTV.multipleTouchEnabled=YES;
    DisclaimerTV.delegate=self.scrollPanel;
    DisclaimerTV.canCancelContentTouches=YES;
    DisclaimerTV.bounces=YES;
    DisclaimerTV.bouncesZoom=YES;
    DisclaimerTV.delaysContentTouches=YES;
    DisclaimerTV.showsHorizontalScrollIndicator=YES;
    DisclaimerTV.showsVerticalScrollIndicator=YES;
    DisclaimerTV.keyboardType=UIKeyboardTypeDefault;
    [DisclaimerTV setEditable:NO];
    DisclaimerTV.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:26];
    DisclaimerTV.opaque=YES;
    DisclaimerTV.clipsToBounds=YES;
    DisclaimerTV.clearsContextBeforeDrawing=YES;
    DisclaimerTV.font=[UIFont systemFontOfSize:13];
    DisclaimerTV.backgroundColor=[UIColor clearColor];
    DisclaimerTV.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    [self.view addSubview:DisclaimerTV];
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
