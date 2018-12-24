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
#define kLOGIN_CHECK @"/login/logincheck.jhtml"

@interface NavBarViewController ()

@end

@implementation NavBarViewController

@synthesize topView,preBtn,rightBtn,leftBtn;

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadImageSuccess) name:@"uploadImageSuccess" object:nil];
}

-(void)setupNav
{
    //self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:243/255.0 blue:246/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = UIColorFromHex(0X4FAEFE);
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kNavBarHeight)];
    topView.tag = 101;
    [self.view addSubview:topView];
    
    // 设置导航默认标题的颜色及字体大小
    self.navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth-200)/2.0, 2+kStatusBarHeight, 200, 40)];
    self.navTitleLabel.font = [UIFont systemFontOfSize:18];
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    //self.navTitleLabel.textColor = UIColorFromHex(0x000000);
    self.navTitleLabel.textColor = [UIColor whiteColor];
    //self.navTitleLabel.text = @"和畅服务";
    [topView addSubview:self.navTitleLabel];;
    
    
    preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    preBtn.frame = CGRectMake(15, kStatusBarHeight+2, 80, 40);
    [preBtn setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    [preBtn setTitle:@"返回" forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    preBtn.adjustsImageWhenHighlighted = NO;
    //[preBtn sizeToFit];
    preBtn.titleEdgeInsets = UIEdgeInsetsMake(1, -5, 0, 0);
    preBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    preBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [preBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:preBtn];
    preBtn.hidden = YES;
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(ScreenWidth-37-14, 2+kStatusBarHeight, 37, 40);
    [rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(messageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(15, 2+kStatusBarHeight+2.5, 32, 32);
    UIImage *personImg = [UIImage imageNamed:@"1我的_03"];
    
    if([[UserShareOnce shareOnce].memberImage isKindOfClass:[NSNull class]]){
       [leftBtn setImage:personImg forState:UIControlStateNormal];
    }else{
        [leftBtn sd_setImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] forState:UIControlStateNormal placeholderImage:personImg];
        //[leftBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[UserShareOnce shareOnce].memberImage] forState:UIControlStateNormal placeholderImage:personImg];
    }
    leftBtn.clipsToBounds = YES;
    leftBtn.layer.cornerRadius = leftBtn.frame.size.width/2;
    [leftBtn addTarget:self action:@selector(userBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([[UserShareOnce shareOnce].memberImage isKindOfClass:[NSNull class]]){
        [leftBtn setImage:[UIImage imageNamed:@"1我的_03"] forState:UIControlStateNormal];
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
    SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
    [subMember receiveSubIdWith:^(NSString *subId) {
        NSLog(@"%@",subId);
        if ([subId isEqualToString:@"user is out of date"]) {
            //登录超时
            
        }else{
            //得到子账户的id
            NSLog(@"选中的子账户id为：%@",subId);
        }
        [subMember hideHintView];
    }];
}

- (void)showAlertViewController:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:alertAct1];
    [alertVC addAction:alertAct12];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (void)showAlertWarmMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
    [alertVC addAction:alertAct1];
    [self presentViewController:alertVC animated:YES completion:NULL];
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
