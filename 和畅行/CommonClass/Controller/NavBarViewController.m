//
//  NavBarViewController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/11.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "NavBarViewController.h"
#import "MessageViewController.h"
#import "UIButton+WebCache.h"
#import "PersonalInformationViewController.h"
#import "UIButton+ExpandScope.h"

#define kLOGIN_CHECK @"/login/logincheck.jhtml"

@interface NavBarViewController ()
@property (nonatomic,strong) MBProgressHUD *hud;
@end

@implementation NavBarViewController

@synthesize topView,preBtn,rightBtn,leftBtn;




- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
    
}


-(void)setupNav
{
    //self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:243/255.0 blue:246/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = UIColorFromHex(0X4FAEFE);
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavBarHeight)];
    topView.backgroundColor = RGB_AppWhite;
    topView.tag = 101;
    [self.view addSubview:topView];
    
    // 设置导航默认标题的颜色及字体大小
    self.navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-Adapter(240))/2.0, Adapter(2)+kStatusBarHeight, Adapter(240), 40)];
    self.navTitleLabel.font = [UIFont systemFontOfSize:18];
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.textColor = [UIColor blackColor];
    [topView addSubview:self.navTitleLabel];
    
    
    preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    preBtn.frame = CGRectMake(15, kStatusBarHeight+2, 80, 40);
    [preBtn setImage:[UIImage imageNamed:@"黑色返回"] forState:UIControlStateNormal];
//    [preBtn setTitle:ModuleZW(@"返回") forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    preBtn.adjustsImageWhenHighlighted = NO;
    //[preBtn sizeToFit];
    preBtn.titleEdgeInsets = UIEdgeInsetsMake(1, -5, 0, 0);
    preBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    preBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    //[preBtn setHitTestEdgeInsets:UIEdgeInsetsMake(50, 50, 50, 50)];
    [preBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:preBtn];
    preBtn.hidden = YES;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(ScreenWidth-37-14, 2+kStatusBarHeight, 37, 40);
    [rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.hidden = YES;
    [topView addSubview:rightBtn];
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(15, 2+kStatusBarHeight+2.5, 32, 32);
    UIImage *personImg = [UIImage imageNamed:@"1我的_03"];
    
    if([GlobalCommon stringEqualNull:[UserShareOnce shareOnce].memberImage]){
       //[leftBtn setImage:personImg forState:UIControlStateNormal];
        [leftBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1我的_03"]];
    }else{
        [leftBtn sd_setImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] forState:UIControlStateNormal placeholderImage:personImg];
        //[leftBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] forState:UIControlStateNormal placeholderImage:personImg];
    }
    leftBtn.clipsToBounds = YES;
    //家庭成员
//    leftBtn.userInteractionEnabled = NO;
    leftBtn.layer.cornerRadius = leftBtn.frame.size.width/2;
    [leftBtn addTarget:self action:@selector(userBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([GlobalCommon stringEqualNull:[UserShareOnce shareOnce].memberImage]){
        [leftBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1我的_03"]];
        //[leftBtn setImage:[UIImage imageNamed:@"1我的_03"] forState:UIControlStateNormal];
    }else{
        [leftBtn sd_setImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"1我的_03"]];
    }
}

- (void)messageBtnAction:(UIButton *)btn
{
//    __weak typeof(self) weakSelf = self;
//    //先判断用户登录是否有效
//    [[NetworkManager sharedNetworkManager] requestWithType:2 urlString:kLOGIN_CHECK parameters:nil successBlock:^(id response) {
//        if([[response objectForKey:@"status"] integerValue] == 100){
//            if([[response objectForKey:@"data"] boolValue] == YES){
//
//            }else{
//                [weakSelf showAlertWarmMessage:@"未登录或者登录超时，请重新登录!"];
//            }
//        }
//    } failureBlock:^(NSError *error) {
//
//    }];
    
    MessageViewController *vc = [[MessageViewController alloc] init];
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (void)userBtnAction:(UIButton *)btn
{
    PersonalInformationViewController *personVC = [[PersonalInformationViewController alloc]init];
    [self presentViewController:personVC animated:YES completion:nil];
}

- (void)showAlertViewController:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:alertAct1];
    [alertVC addAction:alertAct12];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (void)showAlertWarmMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:UIAlertActionStyleCancel handler:NULL];
    [alertVC addAction:alertAct1];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

-(void)showHudWithString:(NSString *)string {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)endHud {
    [self.hud hideAnimated:YES];
}


- (void)goBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //self.navigationController.navigationBar.translucent = NO;
}



-(void)insertSublayerWithImageView:(UIView *)imageV with:(UIView *)view
{
    CALayer *subLayer=[CALayer layer];
    CGRect fixframe = imageV.frame;
    subLayer.frame= fixframe;
    subLayer.cornerRadius=8;
    subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
    
    subLayer.masksToBounds=NO;
    subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
    subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
    subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
    subLayer.shadowRadius = 4;//阴影半径，默认3
    [view.layer insertSublayer:subLayer below:imageV.layer];
    
    
}
-(void)addEnPopButton{
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - kTabBarHeight - 11, ScreenWidth, 1)];
    lineView.backgroundColor = RGB_TextGray;
    [self.view addSubview:lineView];
    
    UIButton *popBT = [UIButton buttonWithType:(UIButtonTypeCustom)];
    popBT.frame = CGRectMake(20, ScreenHeight - kTabBarHeight, ScreenWidth - 40, 30);
    [popBT setTitleColor:RGB(122, 124, 166) forState:(UIControlStateNormal)];
    [popBT setTitle:@"Already have an account?" forState:(UIControlStateNormal)];
    [popBT.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [[popBT rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [self.view addSubview:popBT];
    self.popBT = popBT;
    
}




@end
