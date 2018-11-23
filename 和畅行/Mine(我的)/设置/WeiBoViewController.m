//
//  WeiBoViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/13.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "WeiBoViewController.h"
#import "LBReadingTimeScrollPanel.h"
#import "Global.h"

@interface WeiBoViewController ()<UITextViewDelegate>
@property (strong, nonatomic) LBReadingTimeScrollPanel *scrollPanel;

@end

@implementation WeiBoViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc{
    
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"官方微博";
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"#f2f1ef"];
    
    LBReadingTimeScrollPanel *scrollPanel1 = [[LBReadingTimeScrollPanel alloc] initWithFrame:CGRectZero];
    self.scrollPanel=scrollPanel1;
   
    
    UITextView* weiboTV=[[UITextView alloc] init];
    weiboTV.frame=CGRectMake(15, kNavBarHeight+5, ScreenWidth-30, ScreenHeight-310);
    weiboTV.text=weiboSpace;
    weiboTV.enableReadingTime = YES;
    weiboTV.userInteractionEnabled=YES;
    weiboTV.scrollEnabled=NO;
    weiboTV.multipleTouchEnabled=YES;
    weiboTV.delegate=self.scrollPanel;
    weiboTV.canCancelContentTouches=YES;
    weiboTV.bounces=YES;
    weiboTV.bouncesZoom=YES;
    weiboTV.delaysContentTouches=YES;
    weiboTV.showsHorizontalScrollIndicator=YES;
    weiboTV.showsVerticalScrollIndicator=YES;
    weiboTV.keyboardType=UIKeyboardTypeDefault;
    [weiboTV setEditable:NO];
    weiboTV.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:24];
    weiboTV.opaque=YES;
    weiboTV.clipsToBounds=YES;
    weiboTV.clearsContextBeforeDrawing=YES;
    weiboTV.font=[UIFont systemFontOfSize:16];
    weiboTV.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    weiboTV.backgroundColor=[UIColor clearColor];
    [self.view addSubview:weiboTV];
    
    
    
//    UIImageView* bj_2_1viewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, weiboTV.frame.origin.y+weiboTV.frame.size.height+10, ScreenWidth, 1)];
//    bj_2_1viewImgview.alpha=1.0f;
//    bj_2_1viewImgview.backgroundColor=[UtilityFunc colorWithHexString:@"#d8d8d8"];
//    [self.view addSubview:bj_2_1viewImgview];
    
    
    UIButton *weiboButton=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *weiboImg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"newguanzhu" ofType:@"png"]];
    [weiboButton setImage:weiboImg forState:UIControlStateNormal];
    
    weiboButton.frame=CGRectMake((ScreenWidth-weiboImg.size.width/2)/2,weiboTV.bottom+20, weiboImg.size.width/2,weiboImg.size.height/2);
    [weiboButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [weiboButton setTitleShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f] forState:UIControlStateNormal];
    weiboButton.titleLabel.shadowOffset=CGSizeMake(0.0f, -1.0f);
    [weiboButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    [weiboButton addTarget:self action:@selector(weiboButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weiboButton];
}

-(void)weiboButton
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://e.weibo.com/yanhuanghealth?ref=http%3A%2F%2Fs.weibo.com%2Fweibo%2F%2525E7%252582%25258E%2525E9%2525BB%252584%2525E5%252581%2525A5%2525E5%2525BA%2525B7%2525E7%2525A7%252591%2525E6%25258A%252580%26Refer%3DSTopic_box"]];
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
