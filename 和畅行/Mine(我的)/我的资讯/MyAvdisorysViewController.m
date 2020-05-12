//
//  MyAvdisorysViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/12.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "MyAvdisorysViewController.h"

#import "NSObject+SBJson.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "MyAdvisoryTableViewCell.h"
#import "MyAdvisoryDetailsViewController.h"
#import "LoginViewController.h"
#import "NoMessageView.h"

@interface MyAvdisorysViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD* progress_;
    UIView       *noView;
}
@property (nonatomic ,retain) UITableView *tableView;
@property (nonatomic ,retain) NSMutableArray *dataArray;
@end

@implementation MyAvdisorysViewController
- (void)dealloc{
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.endTimeStr = [GlobalCommon getCurrentTimes];
    [GlobalCommon pageDurationWithpageId:@"43" withstartTime:self.startTimeStr withendTime:self.endTimeStr];
}



- (void)goBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = ModuleZW(@"咨询记录");
    self.view.backgroundColor = [UIColor whiteColor];
    self.startTimeStr = [GlobalCommon getCurrentTimes];
    self.dataArray = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, self.view.frame.size.width, self.view.frame.size.height - kNavBarHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = ScreenWidth*0.4;
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[MyAdvisoryTableViewCell class] forCellReuseIdentifier:@"CELL"];
    [self GetResourcess];
}


-(void)GetResourcess
{
    [self showHUD];
    
//    NSString *UrlPre=URL_PRE;
//    NSString *aUrlle= [NSString stringWithFormat:@"%@member/user_consultation/list.jhtml?memberChildId=%@",UrlPre,[MemberUserShance shareOnce].idNum];
//    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:aUrlle];
//
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//   // [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
//    NSString *nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString *headStr = [NSString stringWithFormat:@"ios_hcy-oem-%@",nowVersion];
//    [request addRequestHeader:@"version" value:headStr];
//
//    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//    [request setRequestMethod:@"GET"];
//    [request setTimeOutSeconds:20];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requestResourceslistErrorr:)];
//    [request setDidFinishSelector:@selector(requestResourceslistCompleteds:)];
//    [request startAsynchronous];
    
    NSString *aUrlle= [NSString stringWithFormat:@"member/user_consultation/list.jhtml?memberChildId=%@",[MemberUserShance shareOnce].idNum];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:2 urlString:aUrlle parameters:nil successBlock:^(id response) {
        [weakSelf requestResourceslistCompleteds:response];
    } failureBlock:^(NSError *error) {
        [weakSelf requestResourceslistErrorr];
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

- (void)requestResourceslistErrorr
{
    [self hudWasHidden];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    [self showAlertWarmMessage:ModuleZW(@"抱歉，请检查您的网络是否畅通")];
   
}
- (void)requestResourceslistCompleteds:(NSDictionary *)dic
{
    [self hudWasHidden];
//    NSString* reqstr=[request responseString];
//    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",dic);
    if ([status intValue]==100)
    {
        NSLog(@"1111--1-1-1-1--11-1--%@",dic);
        self.dataArray = [dic objectForKey:@"data"];
        if (self.dataArray.count == 0) {
            noView = [NoMessageView createImageWith:100.0f];
            [self.view addSubview:noView];
            return ;
        }
        if (noView) {
            [noView removeFromSuperview];
        }
        [self.tableView reloadData];
    }
    else if ([status intValue]==44)
    {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"登录超时，请重新登录") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        av.tag = 100008;
        [av show];
        
    }else{
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:str];
     
        
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==100008)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ? self.dataArray.count: 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAdvisoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataArray.count) {
        NSDictionary *memberDic = self.dataArray[indexPath.row];
        
        if ([[self.dataArray[indexPath.row] objectForKey:@"replyUserConsultations"] isEqual:[NSNull null]]) {
            cell.answerLabel.text = ModuleZW(@"未回复");
            cell.answerLabel.textColor = [UtilityFunc colorWithHexString:@"#fe6f5f"];
        }else{
            cell.answerLabel.text = ModuleZW(@"已回复");
            cell.answerLabel.textColor = [UtilityFunc colorWithHexString:@"#5bb3fa"];
        }
        cell.contentlabel.text = [self.dataArray[indexPath.row]objectForKey:@"content"];
        NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:[[self.dataArray[indexPath.row]objectForKey:@"modifyDate"] doubleValue]/1000.00];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        NSString *confromTimespStr = [formatter stringFromDate:data];
        cell.timeLabel.text = confromTimespStr;
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAdvisoryDetailsViewController *myDetailsVC = [[MyAdvisoryDetailsViewController alloc]init];
    //myDetailsVC.dataDic = [[NSMutableDictionary alloc]init];
    myDetailsVC.dataDic = self.dataArray[indexPath.row];
   
    [self.navigationController pushViewController:myDetailsVC animated:YES];
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
