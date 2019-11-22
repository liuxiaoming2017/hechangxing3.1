//
//  PayViewController.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/23.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "PayViewController.h"
#import "AlipayHeader.h"
#import "MBProgressHUD.h"

#import "SBJson.h"
#import "LoginViewController.h"

#import "EDWKWebViewController.h"

#import "WXApiObject.h"
#import "PayAbnormalViewController.h"
#import "PaySuccessViewController.h"

//APP端签名相关头文件

#import "payRequsestHandler.h"

//服务端签名只需要用到下面一个头文件
#import "ApiXml.h"
#import <QuartzCore/QuartzCore.h>
//////////////////

@interface PayViewController ()<MBProgressHUDDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD* progress_;
}
@property (nonatomic ,strong) NSMutableDictionary *dataDic;
@property (nonatomic ,strong) NSMutableDictionary *dingdanDic;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *tabArray;
@property (nonatomic ,strong) UILabel *jinerLabel;
@property (nonatomic ,strong) NSMutableArray *zhifufangshiArray;
@property (nonatomic ,copy) NSString *paymentPluginId;
@property (nonatomic ,copy) NSString *voucher;
@property (nonatomic ,copy) NSString *namePay;
@property (nonatomic ,strong) NSMutableDictionary *shoukuandanDic;
@end

@implementation PayViewController
- (void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navTitleLabel.text = ModuleZW(@"第三方支付");
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    
    self.shoukuandanDic = [[NSMutableDictionary alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(20, 10, 44, 44);
//    [leftButton setBackgroundImage:[UIImage imageNamed:@"backImg.png"] forState:UIControlStateNormal];
//    //leftButton.backgroundColor = [UIColor redColor];
//    [leftButton addTarget:self action:@selector(leftButton) forControlEvents:UIControlEventTouchUpInside];
   
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, self.view.frame.size.width, self.view.frame.size.height -kNavBarHeight + 44 - Adapter(44)) style:UITableViewStylePlain];
    _tableView.rowHeight = Adapter(60);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets =NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
    
    _tabArray = [[NSMutableArray alloc]initWithObjects:@"zhifubao.png",@"weixin.png", nil];
    _zhifufangshiArray = [[NSMutableArray alloc]initWithObjects:ModuleZW(@"支付宝支付"),ModuleZW(@"微信支付"), nil];
    
//    _tabArray = [[NSMutableArray alloc]initWithObjects:@"weixin.png", nil];
//    _zhifufangshiArray = [[NSMutableArray alloc]initWithObjects:@"微信支付", nil];

    self.dataDic = [[NSMutableDictionary alloc]init];
    self.dingdanDic = [[NSMutableDictionary alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];

    [self generatePayOrders];
    UIImageView *xiaofeijinerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - kTabBarHeight + 44 - Adapter(44), self.view.frame.size.width - Adapter(105), Adapter(44))];
    xiaofeijinerImage.image = [UIImage imageNamed:@"leyaoxiaofeijiner.png"];
    [self.view addSubview:xiaofeijinerImage];
    
    UIButton *jiesuanButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    jiesuanButton.frame = CGRectMake(self.view.frame.size.width -  Adapter(105), xiaofeijinerImage.top, Adapter(105), Adapter(44));
    [jiesuanButton addTarget:self action:@selector(zhifujiesuanButton) forControlEvents:(UIControlEventTouchUpInside)];
    [jiesuanButton setTitle:ModuleZW(@"去结算") forState:(UIControlStateNormal)];
    [jiesuanButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    jiesuanButton.backgroundColor = RGB(68, 204, 82);
    [self.view addSubview:jiesuanButton];
    
    
    UILabel *zongjinerLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(50), Adapter(12), Adapter(50), Adapter(20))];
    zongjinerLabel.text = ModuleZW(@"总计: ");
    zongjinerLabel.textColor = [UIColor whiteColor];
    zongjinerLabel.font = [UIFont systemFontOfSize:13];
    [xiaofeijinerImage addSubview:zongjinerLabel];
    
    
    _jinerLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(100), Adapter(12), Adapter(60), Adapter(20))];
    _jinerLabel.textColor = [UIColor whiteColor];
    _jinerLabel.font = [UIFont systemFontOfSize:13];
    if (self.dingdanStr.length == 0) {
        _jinerLabel.text  = [NSString stringWithFormat:@"¥%.2f",[_priceAPPStr floatValue]];
    }
    [xiaofeijinerImage addSubview:_jinerLabel];

  
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zhifujieguo:) name:@"count" object:nil];
     

    
}


- (void)zhifujieguo:(NSNotification *)notification
{
    
    NSString *strCount = [notification.userInfo objectForKey:@"count"];
    if ([strCount isEqualToString:@"1"]) {
        PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc]init];
        [self.navigationController pushViewController:paySuccessVC animated:YES];
    }else if ([strCount isEqualToString:@"0"]){
        PayAbnormalViewController *payAbnormalVC = [[PayAbnormalViewController alloc]init];
        [self.navigationController pushViewController:payAbnormalVC animated:YES];
    }
    
   
}
- (void)zhifujiesuanButton{
    int dianCount = 0;//点击状态的个数
    NSInteger tagCount = 0;//点击状态的tag值
    for (int i = 0; i <2; i ++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:(6000+i)];
        if (button.selected ) {
            dianCount++;
            tagCount = button.tag;
        }
    }
    if (dianCount == 0 ) {
        [self showAlertWarmMessage:@"请选择支付方式"];
        
        return;
        
    }else{
       
        //[self WXPayButton];
        
        if (self.dingdanStr.length == 0) {
            if (tagCount == 6000) {
                // [self buttonWithPay];
                [self dingdanhaozhifu:@"alipayNativeAppPlugin"];
            }else if(tagCount == 6001){
                // [self WXPayButton];
                [self dingdanhaozhifu:@"weixinPayHcyPhonePlugin"];
            }
        }else{
        if (tagCount == 6000) {
            [self buttonWithPay];
        }else if(tagCount == 6001){
            [self WXPayButton];
            }
        }
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIButton *button = (UIButton *)[self.view viewWithTag:6000+indexPath.row];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:6001+indexPath.row];
    UIButton *button3 = (UIButton *)[self.view viewWithTag:5999+indexPath.row];
    if (button.selected) {
        button.selected = NO;
    }else{
        button.selected = YES;
        if (button2.selected ) {
            button2.selected = NO;
        }
        if (button3.selected) {
            button3.selected = NO;
        }
    }
}
- (void)dingdanhaozhifu:(NSString *)zhifufangshi{
    [self showHUD];
    self.paymentPluginId = zhifufangshi;
    
//    NSString *UrlPre=URL_PRE;
//    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/order/create_pay.jhtml",UrlPre];
//    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:aUrlle];
//
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    //ios_hcy-yh-1.0//andriod_phone_hcy-yh-33
//    [request addRequestHeader:@"version" value:@"ios_hcy-yh-1.0"];
//    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
//    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//    [request setRequestMethod:@"POST"];
//    //[request setPostValue:idStr forKey:@"id"];
//    //[request setPostValue:isreader forKey:@"isRead"];
//    [request setPostValue:@"50" forKey:@"reserveType"];
//    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
//    [request setPostValue:self.idStr forKey:@"orderId"];
//    [request setPostValue:@"payment" forKey:@"type"];
//    [request setPostValue:zhifufangshi forKey:@"paymentPluginId"];
//    if ([_priceStr isEqualToString:@"0"]) {
//
//    }else{
//        [request setPostValue:_priceStr forKey:@"cardFees"];
//    }
//    [request addPostValue:_priceAPPStr forKey:@"balance"];
//   // [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
//    [request setTimeOutSeconds:20];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requestIsAPPpayReaderError:)];
//
//    [request setDidFinishSelector:@selector(requestIsAPPpayReaderCompleted:)];
//    [request startAsynchronous];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [dic setObject:@"50" forKey:@"reserveType"];
    [dic setObject:self.idStr forKey:@"orderId"];
    [dic setObject:@"payment" forKey:@"type"];
    if ([_priceStr isEqualToString:@"0"]) {
        
    }else{
       [dic setObject:_priceStr forKey:@"cardFees"];
    }
    [dic setObject:zhifufangshi forKey:@"paymentPluginId"];
    [dic setObject:@"0" forKey:@"balance"];
    
    
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithCookieType:1 urlString:@"member/order/create_pay.jhtml" headParameters:@{@"version":@"ios_hcy-yh-1.0"} parameters:dic successBlock:^(id response) {
        [weakSelf requestIsAPPpayReaderCompleted:response];
    } failureBlock:^(NSError *error) {
        [weakSelf requestIsAPPpayReaderError];
    }];
}

-(void)requestIsAPPpayReaderError
{
    [self hudWasHidden];
    
    [self showAlertWarmMessage:requestErrorMessage];
    
}
-(void)requestIsAPPpayReaderCompleted:(NSDictionary *)dic
{
    [self hudWasHidden];
    NSLog(@"%@",dic);
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        //        self.voucher = [[[dic objectForKey:@"data"]objectForKey:@"payment"]objectForKey:@"sn"];
        self.shoukuandanDic = [[dic objectForKey:@"data"]objectForKey:@"payment"];
        
       self.namePay = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"data"]objectForKey:@"name"]];
        
        NSString *nameStr = nil ;
        
        
        for (NSString *str in self.nameArr) {
            nameStr = str;
        }
    //if ([self.namePay isKindOfClass:[NSNull class]]) {
            self.namePay = nameStr;
      // }
        if ([self.paymentPluginId isEqualToString:@"alipayNativeAppPlugin"]) {
            
            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:[_shoukuandanDic objectForKey:@"sn"] productName:self.namePay   productDescription:self.namePay amount:[self.shoukuandanDic objectForKey:@"amount"] notifyURL:[NSString stringWithFormat:@"%@payment/notify/async/%@.jhtml",URL_PRE,[_shoukuandanDic objectForKey:@"sn"]] itBPay:@"30m"];
        }else if([self.paymentPluginId isEqualToString:@"weixinPayHcyPhonePlugin"]){
            
            
            [self sendPay_demoName:self.namePay Dictionary:self.shoukuandanDic];
        }
    }
    else if([status intValue]== 44)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        av.tag = 100008;
        [av show];
       
    }else{
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:str];
       
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    UIImageView *zhifufangshiImage = [[UIImageView alloc]initWithFrame:CGRectMake(Adapter(20), Adapter(10), Adapter(40), Adapter(40))];
    zhifufangshiImage.image = [UIImage imageNamed:self.tabArray[indexPath.row]];
    [cell addSubview:zhifufangshiImage];
    UILabel *zhifufangshiLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(110), Adapter(20), Adapter(180), Adapter(20))];
    zhifufangshiLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
    zhifufangshiLabel.font = [UIFont systemFontOfSize:15];
    zhifufangshiLabel.text = _zhifufangshiArray[indexPath.row];
    [cell addSubview:zhifufangshiLabel];
    UIButton *zhifuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zhifuButton.frame = CGRectMake(self.view.frame.size.width- Adapter(60), Adapter(20), Adapter(20), Adapter(20));
    zhifuButton.tag = 6000 +indexPath.row;
    [zhifuButton setBackgroundImage:[UIImage imageNamed:@"zhifuweishiyong.png"] forState:UIControlStateNormal];
    [zhifuButton setBackgroundImage:[UIImage imageNamed:@"leyaozhifuxianjinka.png"] forState:UIControlStateSelected];
    [zhifuButton addTarget:self action:@selector(zhifufangshideButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:zhifuButton];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)zhifufangshideButton:(UIButton *)sender{
    if (sender.selected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
        if (sender.tag == 6000) {
            UIButton *button = (UIButton *)[self.view viewWithTag:6001];
            if (button.selected) {
                button.selected = NO;
            }
        }
        if (sender.tag == 6001) {
            UIButton *button = (UIButton *)[self.view viewWithTag:6000];
            if (button.selected) {
                button.selected = NO;
            }
        }
    }
}

# pragma mark - 微信支付
- (void)WXPayButton{
    [self showHUD];
    
//    NSString *UrlPre=URL_PRE;
//    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/mobile/order/payment/submit.jhtml?sn=%@&paymentPluginId=%@&token=%@&JESSONID=%@",UrlPre,_dingdanStr,@"weixinPayHcyPhonePlugin",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID];
//    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:aUrlle];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//    [request setRequestMethod:@"GET"];
//    [request setTimeOutSeconds:20];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requestWXPayOverError:)];
//    [request setDidFinishSelector:@selector(requestWXPayOverCompleted:)];
//    [request startAsynchronous];
    
     NSString *urlStr= [NSString stringWithFormat:@"member/mobile/order/payment/submit.jhtml?sn=%@&paymentPluginId=%@&token=%@&JESSONID=%@",_dingdanStr,@"weixinPayHcyPhonePlugin",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
        [weakSelf requestWXPayOverCompleted:response];
    } failureBlock:^(NSError *error) {
        [weakSelf requestWXPayOverError];
    }];
    
}
-(void)requestWXPayOverError
{
    [self hudWasHidden];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
   
    [self showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
   
    
}
-(void)requestWXPayOverCompleted:(NSDictionary *)dic
{
    [self hudWasHidden];
    
    
    id status=[dic objectForKey:@"status"];
    if (status!=nil)
    {
        if ([status intValue]==100)
        {
            [self.dingdanDic removeAllObjects];
            self.dingdanDic = [dic objectForKey:@"data"];
            _jinerLabel.text = [NSString stringWithFormat:@"¥%@",[self.dingdanDic  objectForKey:@"amount"]];
            [self sendPay_demoName:[self.dataDic objectForKey:@"name"] Dictionary:self.dingdanDic];

        }
        else if ([status intValue]==44) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            av.tag = 100008;
            [av show];
           
        } else
        {
            NSString *str = [dic objectForKey:@"data"];
            [self showAlertWarmMessage:str];
           
        }
    }
    
    
}
- (void)sendPay_demoName:(NSString *)name Dictionary:(NSMutableDictionary *)dictionary
{
    
    
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    //}}}
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demoName:name dictionary:dictionary];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        [self showAlertWarmMessage:debug];
       
       // [self alert:@"提示信息" msg:debug];
        
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        
        [WXApi sendReq:req];
    }
}


- (void)goBack:(UIButton *)btn{
    
    if (_dingdanStr.length > 0) {
        for (UIViewController *vcHome in self.navigationController.viewControllers) {
            if ([vcHome isKindOfClass:[EDWKWebViewController class]]) {
                [self.navigationController popToViewController:vcHome animated:YES];
            }
        }
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}



- (void)generatePayOrders{
    [self showHUD];
    
//    NSString *UrlPre=URL_PRE;
//    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/mobile/order/getOrderInfo.jhtml?sn=%@&token=%@&JESSONID=%@",UrlPre,_dingdanStr,[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID];
//    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:aUrlle];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//    [request setRequestMethod:@"GET"];
//    [request setTimeOutSeconds:20];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requestMayError:)];
//    [request setDidFinishSelector:@selector(requestMayCompleted:)];
//    [request startAsynchronous];
    
    NSString *urlStr= [NSString stringWithFormat:@"member/mobile/order/getOrderInfo.jhtml?sn=%@&token=%@&JESSONID=%@",_dingdanStr,[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
        [weakSelf requestMayCompleted:response];
    } failureBlock:^(NSError *error) {
        [weakSelf requestMayError];
    }];
}
-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.label.text = ModuleZW(@"加载中...");
    [progress_ showAnimated:YES];
    
}

- (void)hudWasHidden
{
    
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
   
    progress_ = nil;
    
}

-(void)requestMayError
{
    [self hudWasHidden];
//    [self showAlertWarmMessage:ModuleZW(@"抱歉，请检查您的网络是否畅通")];
    
    
}
-(void)requestMayCompleted:(NSDictionary *)dic
{
    [self hudWasHidden];
   
    id status=[dic objectForKey:@"status"];
    if (status!=nil)
    {
        if ([status intValue]==100)
        {
            [self.dataDic removeAllObjects];
            self.dataDic = [dic objectForKey:@"data"];
            _jinerLabel.text = [NSString stringWithFormat:@"¥%@",[self.dataDic objectForKey:@"amount"]];
            NSLog(@"%@",dic);NSLog(@"%@",[self.dataDic objectForKey:@"name"]);
        }
        else if ([status intValue]==44) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            av.tag = 100008;
            [av show];
           
        } else
        {
            NSString *str = [dic objectForKey:@"data"];
            [self showAlertWarmMessage:str];
           
        }
           }
    
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    //    if (alertView.tag==10007)
    //    {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }else
    if (alertView.tag==100008)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

# pragma mark - 支付宝支付
- (void)buttonWithPay{
    [self showHUD];
    
//    NSString *UrlPre=URL_PRE;
//    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/mobile/order/payment/submit.jhtml?sn=%@&paymentPluginId=%@&token=%@&JESSONID=%@",UrlPre,_dingdanStr,@"alipayNativeAppPlugin",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID];
//    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:aUrlle];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//    [request setRequestMethod:@"GET"];
//    [request setTimeOutSeconds:20];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requestMayOverError:)];
//    [request setDidFinishSelector:@selector(requestMayOverCompleted:)];
//    [request startAsynchronous];
    
    NSString *urlStr= [NSString stringWithFormat:@"member/mobile/order/payment/submit.jhtml?sn=%@&paymentPluginId=%@&token=%@&JESSONID=%@",_dingdanStr,@"alipayNativeAppPlugin",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
        [weakSelf requestMayOverCompleted:response];
    } failureBlock:^(NSError *error) {
        [weakSelf requestMayOverError];
    }];
    
}
-(void)requestMayOverError
{
    [self hudWasHidden];
    
    [self showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
    
    
}
-(void)requestMayOverCompleted:(NSDictionary *)dic
{
    [self hudWasHidden];
    
    id status=[dic objectForKey:@"status"];
    if (status!=nil)
    {
        if ([status intValue]==100)
        {
            [self.dingdanDic removeAllObjects];
            self.dingdanDic = [dic objectForKey:@"data"];
            NSLog(@"dic*******%@",dic);
            _jinerLabel.text = [NSString stringWithFormat:@"¥%@",[self.dingdanDic  objectForKey:@"amount"]];
            [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:[self.dataDic objectForKey:@"sn"] productName:[self.dataDic objectForKey:@"name"]   productDescription:[self.dataDic objectForKey:@"name"] amount:[self.dingdanDic objectForKey:@"amount"] notifyURL:[NSString stringWithFormat:@"%@payment/notify/async/%@.jhtml",URL_PRE,[_dingdanDic objectForKey:@"sn"]] itBPay:@"30m"];
        }
        else if ([status intValue]==44) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            av.tag = 100008;
            [av show];
           
        } else{
            NSString *str = [dic objectForKey:@"data"];
            [self showAlertWarmMessage:str];
        }
    }
    
    
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK if ([url.host isEqualToString:@"safepay"]) {
//    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//        NSLog(@"result = %@",resultDic);
//    }];
//    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
//        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//    }
//    return YES;
//}
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
