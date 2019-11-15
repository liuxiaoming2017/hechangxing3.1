//
//  LectureDetailViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/10/26.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "LectureDetailViewController.h"
#import "PaymentInfoViewController.h"
#import "LoginViewController.h"
#import "PayDoneViewController.h"
#import "MyView.h"

@interface LectureDetailViewController ()<UIWebViewDelegate,MBProgressHUDDelegate>
{
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_buyCountLabel;
    UILabel *_orderMoneyLabel;
    NSInteger _buyCount;
    float _totalMoney;
    MBProgressHUD *_progress;
}
@end

@implementation LectureDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = ModuleZW(@"健康讲座");
    [self initWithcontroller];
}
#pragma mark ------ 初始化界面
-(void)initWithcontroller{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 5, kScreenSize.width, kScreenSize.height-kNavBarHeight  - 5- kTabBarHeight)];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:request];
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    //webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:webView];
    
    //为webView添加加载动画
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height)];
    [view setTag:103];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.3];
    [self.view addSubview:view];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicator setCenter:view.center];
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:_activityIndicator];
    
    _buyCount = 1;
    _totalMoney+=self.price;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-kTabBarHeight, kScreenSize.width-70, 44)];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = RGB_TextOrange;
    [self.view addSubview:imageView];
    UILabel *countLabel = [Tools labelWith:@"购买数量" frame:CGRectMake(20, 10, 50, 10) textSize:12 textColor:[UIColor whiteColor] lines:1 aligment:NSTextAlignmentLeft];
    countLabel.font = [UIFont boldSystemFontOfSize:12];
    UILabel *moneyLabel = [Tools labelWith:@"预约金额:" frame:CGRectMake(20, 25, 55, 10) textSize:12 textColor:[UIColor whiteColor] lines:1 aligment:NSTextAlignmentLeft];
    moneyLabel.font = [UIFont boldSystemFontOfSize:12];
    UIButton *reduceBtn = [Tools creatButtonWithFrame:CGRectMake(80, 7, 15, 15) target:self sel:@selector(reduceButtonClick:) tag:11 image:@"资讯图片01" title:nil];
    [imageView addSubview:reduceBtn];
    UIImageView *countImageView = [Tools creatImageViewWithFrame:CGRectMake(95, 7, 25, 15) imageName:@"资讯图片02"];
    [imageView addSubview:countImageView];
    _buyCountLabel = [Tools labelWith:[NSString stringWithFormat:@"%ld",(long)_buyCount] frame:CGRectMake(0, 0, 25, 15) textSize:12 textColor:[UIColor whiteColor] lines:1 aligment:NSTextAlignmentCenter];
    [countImageView addSubview:_buyCountLabel];
    UIButton *addBtn = [Tools creatButtonWithFrame:CGRectMake(120, 7, 15, 15) target:self sel:@selector(addButtonClick:) tag:12 image:@"资讯图片03" title:nil];
    [imageView addSubview:addBtn];
    _orderMoneyLabel = [Tools labelWith:[NSString stringWithFormat:@"￥%.2f",_totalMoney] frame:CGRectMake(80, 25, 80, 12) textSize:14 textColor:[UIColor whiteColor] lines:1 aligment:NSTextAlignmentLeft];
    _orderMoneyLabel.font = [UIFont boldSystemFontOfSize:13];
    [imageView addSubview:_orderMoneyLabel];
    UILabel *leftCountLabel = [Tools labelWith:[NSString stringWithFormat:@"剩余:%ld位",(long)self.leftPassengers] frame:CGRectMake(_orderMoneyLabel.right, 25, 60, 10) textSize:12 textColor:[UIColor whiteColor] lines:1 aligment:NSTextAlignmentLeft];
    leftCountLabel.font = [UIFont boldSystemFontOfSize:12];
    [imageView addSubview:leftCountLabel];
    [imageView addSubview:countLabel];
    [imageView addSubview:moneyLabel];
    
    
//
    MyView *order = [[MyView alloc] initWithFrame:CGRectMake(kScreenSize.width-70, kScreenSize.height-kTabBarHeight, 70, 44)];
    order.image = [UIImage imageNamed:@"立即预约"];
    [order addTarget:self action:@selector(orderClick:)];
    [self.view addSubview:order];
    
}
#pragma mark ----- 增加、减少、预约按钮
-(void)reduceButtonClick:(UIButton *)button{
    NSLog(@"点击减少按钮");
    if (_buyCount >0) {
        _buyCount--;
        _totalMoney = self.price*_buyCount;
        _buyCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_buyCount];
        _orderMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_totalMoney];
    }
}
-(void)addButtonClick:(UIButton *)button{
    NSLog(@"点击增加按钮");
    _buyCount++;
    _totalMoney = self.price*_buyCount;
    _buyCountLabel.text = [NSString stringWithFormat:@"%ld",(long)_buyCount];
    _orderMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",_totalMoney];
}

-(void)orderClick:(MyView *)imageView{
    NSLog(@"点击立即预约");
    //调用预约接口
//    NSString *str = [[NSString alloc] initWithFormat:@"%@/member/lecture/reserve.jhtml",URL_PRE];
//    NSString *parameter = [[NSString alloc] initWithFormat:@"?lectureId=%@&memberId=%@&reserveNums=%ld&totalFee=%f",self.model.id,[UserShareOnce shareOnce].uid,(long)_buyCount,_totalMoney];
//    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",str,parameter];
//    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    [_request addRequestHeader:@"version" value:@"ios_hcy-yh-1.0"];
//    _request.timeOutSeconds = 20;
//    _request.requestMethod = @"GET";
//    _request.delegate = self;
//    [_request startAsynchronous];

    
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    [self.view bringSubviewToFront:_progress];
    _progress.delegate = self;
    _progress.labelText = @"加载中...";
    [_progress show:YES];
    
    NSString *parameter = [[NSString alloc] initWithFormat:@"?lectureId=%@&memberId=%@&reserveNums=%ld&totalFee=%f",self.model.id,[UserShareOnce shareOnce].uid,(long)_buyCount,_totalMoney];
    NSString *urlStr = [[NSString alloc] initWithFormat:@"member/lecture/reserve.jhtml%@",parameter];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:2 urlString:urlStr parameters:nil successBlock:^(id response) {
        [weakSelf requestComfinish:response];
    } failureBlock:^(NSError *error) {
        [weakSelf requestFail];
    }];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [_progress removeFromSuperview];
    _progress = nil;
}

-(void)requestComfinish:(NSDictionary *)dic{
    [self hudWasHidden:nil];
//    NSString *requestStr = [request responseString];
//    NSDictionary *dic = [requestStr JSONValue];
    NSDictionary *dataDic = dic[@"data"];
    
    if ([dic[@"status"] integerValue]==43) {
        //预约数超过系统限制
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"预约数超过系统限制";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:2];
    }else if ([dic[@"status"] integerValue]==44){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"未登录或者登录超时，请重新登录";
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hide:YES afterDelay:2];
        
        LoginViewController *login = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:login animated:YES];
    }else if ([dic[@"status"] integerValue]==100){
       NSDictionary *orderDic = dataDic[@"order"];
//        分两种：一种是免费讲座，直接返回预约成功后的信息
        if (self.price == 0) {
            PayDoneViewController *pay = [[PayDoneViewController alloc] init];
            pay.result = @"success";
            [self.navigationController pushViewController:pay animated:YES];
        }else{
            //另一种是收费讲座，跳入支付界面
            PaymentInfoViewController *payment = [[PaymentInfoViewController alloc] init];
            payment.model = self.model;
            payment.count = _buyCount;
            payment.price = _totalMoney;
            payment.orderId = [orderDic[@"id"] integerValue];
            payment.sn = orderDic[@"sn"];
            [self.navigationController pushViewController:payment animated:YES];
        }
    }
    
}
-(void)requestFail{
    [self hudWasHidden:nil];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide =YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"数据请求失败";
    hud.minSize = CGSizeMake(132.f, 108.0f);
    [hud hide:YES afterDelay:2];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_activityIndicator startAnimating];
}
//数据加载完
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityIndicator stopAnimating];
    UIView *view = (UIView *)[self.view viewWithTag:103];
    [view removeFromSuperview];
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
