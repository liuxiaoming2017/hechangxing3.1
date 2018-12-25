//
//  HCY_ActivationController.m
//  和畅行
//
//  Created by Wei Zhao on 2018/12/7.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_ActivationController.h"
#import "SBJson.h"


@interface HCY_ActivationController ()

@property (nonatomic,strong) UIView *blackView;

@end

@implementation HCY_ActivationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self requestMemberInfo];
    /// 布局激活卡页面
    [self layoutAcitivaTionView];
    
}

-(void)layoutAcitivaTionView{
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10,kNavBarHeight + 20 ,ScreenWidth - 20, ScreenHeight -  kNavBarHeight - 200)];
    imageV.userInteractionEnabled = YES;
    //添加渐变色
    [imageV.layer addSublayer:[UIColor setGradualChangingColor:imageV fromColor:@"4294E1" toColor:@"D1BDFF"]];
    imageV.layer.cornerRadius = 10;
    imageV.layer.masksToBounds = YES;
    [self.view addSubview:imageV];
    
    UILabel *carTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 10, imageV.width, 45)];
    carTitleLabel.text = _model.service_name;
    carTitleLabel.backgroundColor = [UIColor clearColor];
    carTitleLabel.textColor = [UIColor whiteColor];
    carTitleLabel.textAlignment = NSTextAlignmentCenter;
    carTitleLabel.font = [UIFont systemFontOfSize:22];
    [imageV addSubview:carTitleLabel];
    
    
    UITextView *contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, carTitleLabel.bottom ,imageV.width - 20, imageV.height - 65)];
    
    if (self.model.cardDescription==nil || [self.model.cardDescription isKindOfClass:[NSNull class]]||self.model.cardDescription.length == 0) {
        contentTextView.text = @"暂无";
    }else{
        contentTextView.text = self.model.cardDescription;
    }
    contentTextView.font = [UIFont systemFontOfSize:15];
    [contentTextView setEditable:NO];

    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.textColor = RGB(240, 240, 240);
    [imageV addSubview:contentTextView];
    
    UIButton *activationBT = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2 - 75, imageV.bottom + 30, 150, 50) target:self sel:@selector(activationAction) tag:11111 image:nil title:@"激活"];
    [activationBT setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [activationBT setBackgroundColor:RGB_ButtonBlue];
    activationBT.layer.cornerRadius = 25;
    activationBT.layer.masksToBounds = YES;
    
    [self.view addSubview:activationBT];
    
    
    
}


-(void)activationAction {
    
    self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
   self.blackView.backgroundColor = [UIColor colorWithRed:180/255 green:180/255 blue:180/255 alpha:0.5];
    [self.view addSubview:self.blackView];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(40, ScreenHeight/2 -(ScreenWidth - 80)*4/10 - 30 , ScreenWidth - 80, (ScreenWidth - 80)*4/5)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = 10;
    whiteView.layer.masksToBounds = YES;
    [self.blackView addSubview:whiteView];
    
    UILabel *txtLabel = [[UILabel alloc]initWithFrame:CGRectMake( 50, 0, whiteView.width - 100, whiteView.height - 62)];
    txtLabel.text =  [NSString stringWithFormat:@"您将激活%@,是否继续?",_model.card_name] ;
    txtLabel.textColor = RGB_TextLightGray;
    txtLabel.font = [UIFont systemFontOfSize:17];
    txtLabel.numberOfLines = 2;
    txtLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:txtLabel];
    
   
    NSArray *titleArray = @[@"否",@"是"];
    
    
    for (int i = 0 ; i < 2; i++) {
        UIButton *button = [Tools creatButtonWithFrame:CGRectMake( whiteView.width/8 + (whiteView.width/2)*i, txtLabel.bottom + (whiteView.height - txtLabel.height - 40)/2 - 20, whiteView.width/4, 40) target:self sel:@selector(chooseAction:) tag:1000+i image:nil title:titleArray[i]];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button setBackgroundColor:RGB_ButtonBlue];
        button.layer.cornerRadius = 20;
        button.layer.masksToBounds = YES;
        [whiteView addSubview:button];
    }
    
}

-(void)chooseAction:(UIButton *)button {
    
    if (button.tag == 1001) {
        
        NSString *memberId = [NSString stringWithFormat:@"%@",[UserShareOnce shareOnce].uid];
//        NSString *urlStr   = @"weiq/service_card/active.jhtml";
//        NSDictionary *dic = @{@"memberId":memberId,
//                              @"card_no":self.model.card_no,
//                              @"token":[UserShareOnce shareOnce].token
//                              };

        NSString *UrlPre=URL_PRE;
        NSString *aUrl = [NSString stringWithFormat:@"%@/weiq/service_card/active.jhtml",UrlPre];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
        [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
        [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
        
        [request setPostValue:memberId forKey:@"memberId"];
        [request setPostValue:self.model.card_no forKey:@"card_no"];
        [request setPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
        [request setTimeOutSeconds:20];
        [request setRequestMethod:@"POST"];
        [request setDelegate:self];
        [request setDidFailSelector:@selector(requesstuserinfoError:)];
        [request setDidFinishSelector:@selector(requesstuserinfoCompleted:)];
        [request startAsynchronous];
        
//        [ZYGASINetworking POST_Path:urlStr params:dic completed:^(id JSON, NSString *stringData) {
//            if([[JSON objectForKey:@"code"] integerValue] == 100){
//                [weakSelf requestMemberInfo];
//            }else{
//                [weakSelf showAlertWarmMessage:[JSON objectForKey:@"message"]];
//            }
//        } failed:^(NSError *error) {
//            [weakSelf showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
//        }];
    }
    
    
    [self.blackView removeFromSuperview];
    
}

# pragma mark - 激活成功后 查询用户信息
- (void)requestMemberInfo
{
//    NSString *urlStr   = @"weiq/getMemberInfo.jhtml";
//    NSDictionary *dic = @{@"memberId":[UserShareOnce shareOnce].uid};    
    
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/weiq/getMemberInfo.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
     
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requesstuserinfoError:)];
    [request setDidFinishSelector:@selector(requesstuserinfoCompleted:)];
    [request startAsynchronous];
    
//    __weak typeof(self) weakSelf = self;
//    [ZYGASINetworking POST_Path:urlStr params:dic completed:^(id JSON, NSString *stringData) {
//        if([[JSON objectForKey:@"code"] integerValue] == 100){
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }else{
//            [weakSelf showAlertWarmMessage:[JSON objectForKey:@"message"]];
//        }
//    } failed:^(NSError *error) {
//        [weakSelf showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
//    }];
}

- (void)requesstuserinfoError:(ASIHTTPRequest *)request
{
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
}
- (void)requesstuserinfoCompleted:(ASIHTTPRequest *)request
{
    NSString* reqstr=[request responseString];
    //NSLog(@"dic==%@",reqstr);
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    //NSLog(@"234214324%@",status);
    if ([status intValue]== 100) {
         [self showAlertWarmMessage:[dic objectForKey:@"message"]];
        
    }
    
}


@end
