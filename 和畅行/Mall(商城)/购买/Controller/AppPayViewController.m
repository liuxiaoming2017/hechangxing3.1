//
//  AppPayViewController.m
//  Voicediagno
//
//  Created by 李传铎 on 15/10/27.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "AppPayViewController.h"
#import "AlipayHeader.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "WXApiObject.h"
#import "payRequsestHandler.h"
#import "WXApi.h"
//服务端签名只需要用到下面一个头文件
#import "ApiXml.h"
#import <QuartzCore/QuartzCore.h>

@interface AppPayViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD* _progress;
}
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *tabArray;
@property (nonatomic ,strong) UILabel *jinerLabel;
@property (nonatomic ,strong) NSMutableArray *zhifufangshiArray;
@property (nonatomic ,copy) NSString *paymentPluginId;
@property (nonatomic ,copy) NSString *voucher;
@property (nonatomic ,copy) NSString *namePay;
@property (nonatomic ,strong) NSMutableDictionary *shoukuandanDic;
@end

@implementation AppPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _shoukuandanDic = [[NSMutableDictionary alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height -130) style:UITableViewStylePlain];
    _tableView.rowHeight = 60;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CELL"];
//    _tabArray = [[NSMutableArray alloc]initWithObjects:@"zhifubao.png",@"weixin.png", nil];
//    _zhifufangshiArray = [[NSMutableArray alloc]initWithObjects:@"支付宝支付",@"微信支付", nil];
    _tabArray = [[NSMutableArray alloc]initWithObjects:@"weixin.png", nil];
    _zhifufangshiArray = [[NSMutableArray alloc]initWithObjects:@"微信支付", nil];
    self.view.backgroundColor = [UIColor whiteColor];
   
    
    UIImageView *xiaofeijinerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width - 105, 44)];
    xiaofeijinerImage.image = [UIImage imageNamed:@"leyaoxiaofeijiner.png"];
    [self.view addSubview:xiaofeijinerImage];
    UIImageView *jiesuanImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width -  105, self.view.frame.size.height - 44, 105, 44)];
    jiesuanImage.image = [UIImage imageNamed:@"leyaojiesuan.png"];
    [self.view addSubview:jiesuanImage];
    UIImageView *gouwucheImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height - 32, 20, 20)];
    gouwucheImage.image = [UIImage imageNamed:@"leyaogouwuche.png"];
    [self.view addSubview:gouwucheImage];
    UILabel *zongjinerLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height - 76, 90, 20)];
    zongjinerLabel.text = @"消费总金额：";
    zongjinerLabel.textColor = [UIColor whiteColor];
    zongjinerLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:zongjinerLabel];
    _jinerLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, self.view.frame.size.height - 32, 60, 20)];
    
    
    _jinerLabel.textColor = [UIColor whiteColor];
    _jinerLabel.text = [NSString stringWithFormat:@"%.1f",[_priceAPPStr floatValue]];
    _jinerLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.view addSubview:_jinerLabel];
    UILabel *qujiesuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 105, self.view.frame.size.height - 32, 105, 20)];
    qujiesuanLabel.textColor = [UIColor whiteColor];
    qujiesuanLabel.text = @"去结算";
    qujiesuanLabel.font = [UIFont systemFontOfSize:13];
    qujiesuanLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:qujiesuanLabel];
    
    UIButton *jiesuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jiesuanButton.frame = CGRectMake(self.view.frame.size.width - 105, self.view.frame.size.height - 44, 105, 44);
    [jiesuanButton addTarget:self action:@selector(zhifujiesuanButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:jiesuanButton];
}
- (void)zhifujiesuanButton{
    int dianCount = 0;//点击状态的个数
    NSInteger tagCount = 0;//点击状态的tag值
    for (int i = 0; i <2; i ++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:(3000+i)];
        if (button.selected ) {
            dianCount++;
            tagCount = button.tag;
        }
    }
    if (dianCount == 0 ) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择支付方式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        [av show];
        
        return;
        
    }else{
        if (tagCount == 3000) {
           // [self buttonWithPay];
        [self dingdanhaozhifu:@"alipayNativeAppPlugin"];
        }else if(tagCount == 3001){
           // [self WXPayButton];
        [self dingdanhaozhifu:@"weixinPayHcyPhonePlugin"];
        }
    }
}
- (void)dingdanhaozhifu:(NSString *)zhifufangshi{
    [self showHUD];
    self.paymentPluginId = zhifufangshi;
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/order/create_pay.jhtml",UrlPre];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setRequestMethod:@"POST"];
    //[request setPostValue:idStr forKey:@"id"];
    //[request setPostValue:isreader forKey:@"isRead"];
    [request setPostValue:@"50" forKey:@"reserveType"];
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [request setPostValue:self.idStr forKey:@"orderId"];
    [request setPostValue:@"payment" forKey:@"type"];
    [request setPostValue:zhifufangshi forKey:@"paymentPluginId"];
    if ([_priceStr isEqualToString:@"0"]) {
        
    }else{
    [request setPostValue:_priceStr forKey:@"cardFees"];
    }
    [request setPostValue:_priceAPPStr forKey:@"balance"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestIsAPPpayReaderError:)];
    
    [request setDidFinishSelector:@selector(requestIsAPPpayReaderCompleted:)];
    [request startAsynchronous];
}
-(void) showHUD
{
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    [self.view bringSubviewToFront:_progress];
    _progress.delegate = self;
    _progress.label.text = @"加载中...";
    [_progress showAnimated:YES];
}

- (void)hudWasHidden
{
    
    // Remove HUD from screen when the HUD was hidded
    [_progress removeFromSuperview];
    
    _progress = nil;
    
}
-(void)requestIsAPPpayReaderError:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    
}
-(void)requestIsAPPpayReaderCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
//        self.voucher = [[[dic objectForKey:@"data"]objectForKey:@"payment"]objectForKey:@"sn"];
        self.shoukuandanDic = [[dic objectForKey:@"data"]objectForKey:@"payment"];
        self.namePay = [[dic objectForKey:@"data"]objectForKey:@"name"];
        if ([self.paymentPluginId isEqualToString:@"alipayNativeAppPlugin"]) {
            
              [AlipayRequestConfig alipayWithPartner:kPartnerID seller:kSellerAccount tradeNO:[AlipayToolKit genTradeNoWithTime] productName:self.namePay   productDescription:self.namePay amount:[self.shoukuandanDic objectForKey:@"amount"] notifyURL:[NSString stringWithFormat:@"%@payment/notify/async/%@.jhtml",URL_PRE,[_shoukuandanDic objectForKey:@"sn"]] itBPay:@"30m"];
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
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
       
    }
}
- (void)sendPay_demoName:(NSString *)name Dictionary:(NSMutableDictionary *)dictionary
{
    
    //{{{
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc] ;
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
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:debug delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        
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




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    UIImageView *zhifufangshiImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
    zhifufangshiImage.image = [UIImage imageNamed:self.tabArray[indexPath.row]];
    [cell addSubview:zhifufangshiImage];
    UILabel *zhifufangshiLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, 100, 20)];
    zhifufangshiLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
    zhifufangshiLabel.font = [UIFont systemFontOfSize:15];
    zhifufangshiLabel.text = _zhifufangshiArray[indexPath.row];
    [cell addSubview:zhifufangshiLabel];
    UIButton *zhifuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zhifuButton.frame = CGRectMake(self.view.frame.size.width- 40, 30, 20, 20);
    zhifuButton.tag = 3000 +indexPath.row;
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
        if (sender.tag == 3000) {
            UIButton *button = (UIButton *)[self.view viewWithTag:3001];
            if (button.selected) {
                button.selected = NO;
            }
        }
        if (sender.tag == 3001) {
            UIButton *button = (UIButton *)[self.view viewWithTag:3000];
            if (button.selected) {
                button.selected = NO;
            }
        }
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
