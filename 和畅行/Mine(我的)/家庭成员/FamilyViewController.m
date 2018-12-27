//
//  FamilyViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/11.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "FamilyViewController.h"
#import "FamilyTableViewCell.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSObject+SBJson.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "AlterViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "ArchivesController.h"
//#import "MainViewController.h"

//SSUserInfo* [UserShareOnce shareOnce];
NSString *sex;
NSString *isYiBao;
@interface FamilyViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
{
    MBProgressHUD* progress_;
    
    
}
@property (nonatomic ,retain) UITableView *memberTable;
@property (nonatomic ,retain) NSMutableArray *dataArray;//数据源数组
@property (nonatomic ,assign) int tag;
@end

@implementation FamilyViewController

- (void)dealloc
{
    self.dataArray = nil;
    self.memberTable = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"家庭成员";
    [self createView];
    
}



-(void)createView{
    UIImageView *addFamilyView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+5, kScreenSize.width, 50)];
    [self.view addSubview:addFamilyView];
    UIImageView *personImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 14.25, 61 / 2, 43 / 2)];
    personImage.image = [UIImage imageNamed:@"221323_03.png"];
    [addFamilyView addSubview:personImage];
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 17.5, 100, 15)];
    addLabel.text = @"添加家庭成员";
    addLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    addLabel.font = [UIFont systemFontOfSize:14];
    [addFamilyView addSubview:addLabel];
    UIImageView *xiaImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30, 17.5, 19 /2, 15)];
    xiaImage.image = [UIImage imageNamed:@"21221_12206.png"];
    [addFamilyView addSubview:xiaImage];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 41, kScreenSize.width, 9)];
    lineView.image = [UIImage imageNamed:@"healthLec"];
    [addFamilyView addSubview:lineView];
    UIButton *addBtn = [[UIButton alloc] initWithFrame:addFamilyView.frame];
    addBtn.backgroundColor = [UIColor clearColor];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    
    
    self.dataArray = [[NSMutableArray alloc]init];
    _memberTable = [[UITableView alloc]initWithFrame:CGRectMake(0, addFamilyView.bottom, self.view.frame.size.width, self.view.frame.size.height - addFamilyView.bottom) style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //_tabelView.tableHeaderView = headView;
    _memberTable.userInteractionEnabled = YES;
    _memberTable.delegate = self;
    _memberTable.dataSource = self;
    _memberTable.rowHeight = 55;
    _memberTable.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_memberTable];
    [_memberTable registerClass:[FamilyTableViewCell class] forCellReuseIdentifier:@"CELL"];
}

-(void)addBtnClick:(UIButton *)button{
    
    NSLog(@"点击添加按钮");
    AlterViewController *alter = [[AlterViewController alloc] init];
    alter.category = @"addMember";
    [self.navigationController pushViewController:alter animated:YES];
    
}

-(void)GetResource
{
    
    [self showHUD];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:@"/member/memberModifi/list.jhtml" parameters:@{@"memberId":[UserShareOnce shareOnce].uid} successBlock:^(id response) {
        [weakSelf hudWasHidden];
        [weakSelf requestResourceslistCompletedWith:response];
    } failureBlock:^(NSError *error) {
        [weakSelf hudWasHidden];

        [weakSelf showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
    }];
    
//    [ZYGASINetworking GET_Path:@"/member/memberModifi/list.jhtml" params:@{@"memberId":[UserShareOnce shareOnce].uid} completed:^(id JSON, NSString *stringData) {
//        [self hudWasHidden];
//        [self requestResourceslistCompletedWith:JSON];
//    } failed:^(NSError *error) {
//        [self hudWasHidden];
//
//        [self showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
//
//    }];
}
-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.label.text = @"加载中...";
    [progress_ showAnimated:YES];
}

- (void)hudWasHidden
{
    
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    
    progress_ = nil;
    
}

- (void)requestResourceslistCompletedWith:(NSDictionary *)dic
{
    [self hudWasHidden];
    id status=[dic objectForKey:@"status"];
    NSLog(@"11111111%@",dic);
    if ([status intValue]==100)
    {
//        [self.dataArray removeAllObjects];
        self.dataArray=[dic objectForKey:@"data"];
        [self.memberTable reloadData];
    }
    else if ([status intValue]==44)
    {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录超时，请重新登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *vc = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alertVC addAction:alertAct1];
        [self presentViewController:alertVC animated:YES completion:NULL];
        
        
    }else{
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:str];
       
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  _dataArray.count? _dataArray.count: 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FamilyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([[self.dataArray[indexPath.row] objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
        cell.nameLabel.text = @"未知";
    }else{
        if ([[self.dataArray[indexPath.row] objectForKey:@"name"]isEqualToString:[UserShareOnce shareOnce].username]) {
            cell.nameLabel.text = [[UserShareOnce shareOnce].name isKindOfClass:[NSNull class]]? [UserShareOnce shareOnce].username:[UserShareOnce shareOnce].name;
        }else{
            cell.nameLabel.text = [self.dataArray[indexPath.row] objectForKey:@"name"];
        }
        
        if( [[self.dataArray[indexPath.row] objectForKey:@"name"] length] > 26) {
            cell.nameLabel.text = [UserShareOnce shareOnce].wxName;
        }
    }
    
    int sesss = 0;
    int age  = 0;
    
    if ( [[self.dataArray[indexPath.row]objectForKey:@"birthday"] isEqual:[NSNull null]]) {
        if ([[UserShareOnce shareOnce].birthday isEqual:[NSNull null]]) {
            age = 0;
        }else{
            NSString *str = [[UserShareOnce shareOnce].birthday substringToIndex:4];
            sesss = [str intValue];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDate *now;
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
            NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            now=[NSDate date];
            comps = [calendar components:unitFlags fromDate:now];
            age = (int)[comps year] - sesss;
        }
        NSString *sex = @"";
        if ([[UserShareOnce shareOnce].gender isEqual:[NSNull null]]) {
            sex = @"未知";
        }else if ([[UserShareOnce shareOnce].gender isEqualToString:@"male"]) {
            sex =@"男" ;
        }else if([[UserShareOnce shareOnce].gender isEqualToString:@"femal"]){
            sex = @"女";
        }
        
        NSString *sexStr = [NSString stringWithFormat:@"(%@%d岁)",sex,age];
        
        cell.sexLabel.text = sexStr;
        
    }else{
        NSString *sex = @"";
        if ([[self.dataArray[indexPath.row] objectForKey:@"gender"] isEqual:[NSNull null]]) {
            sex =@"未知" ;
        }else if([[self.dataArray[indexPath.row] objectForKey:@"gender"] isEqualToString:@"male"]){
            sex = @"男";
        }else{
            sex = @"女";
        }
        
        NSString *str = [[self.dataArray[indexPath.row] objectForKey:@"birthday"] substringToIndex:4];
        sesss = [str intValue];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *now;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
        NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        now=[NSDate date];
        comps = [calendar components:unitFlags fromDate:now];
        age = (int)[comps year] - sesss;
        NSString *sexStr = [NSString stringWithFormat:@"(%@%d岁)",sex,age];
        cell.sexLabel.text = sexStr;
        
    }
    
    if ([[self.dataArray[indexPath.row] objectForKey:@"mobile"]isEqual:[NSNull null]]) {
        cell.phoneLabel.text = @"无";
    }else{
        cell.phoneLabel.text = [self.dataArray[indexPath.row] objectForKey:@"mobile"];
    }
    UIImage* CellDeleImg=[UIImage imageNamed:@"2_1wq5.png"];
    UIButton* CellDeleImgView=[UIButton buttonWithType:UIButtonTypeCustom];
    CellDeleImgView.tag=indexPath.row+10000;
    [CellDeleImgView addTarget:self action:@selector(DeleActive:) forControlEvents:UIControlEventTouchUpInside];
    CellDeleImgView.frame=CGRectMake(self.view.frame.size.width - 30, (55 - 17.5) / 2, 18, 18);
    [CellDeleImgView setImage:CellDeleImg forState:UIControlStateNormal];
    UIButton *deleBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenSize.width-40, (55 - 17.5) / 2-10, 38, 38)];
    deleBtn.tag = indexPath.row+10000;
    [deleBtn addTarget:self action:@selector(DeleActive:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == 0) {
        
    }else{
        [cell addSubview:CellDeleImgView];
        [cell addSubview:deleBtn];
       
    }
    
    UIButton *checkBtn = [Tools buttonWithFrame:CGRectMake(kScreenSize.width-40-60-10, 16, 60, 23) title:nil nomalImage:@"查看报告" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:500+indexPath.row target:self sel:@selector(checkBtnClick:)];
    [cell addSubview:checkBtn];
    return cell;
}
#pragma mark - 点击查看报告按钮
-(void)checkBtnClick:(UIButton *) button{
    //NSLog(@"点击了第%ld个查看报告",button.tag - 500);
    //NSLog(@"%@",_dataArray);
    NSDictionary *dic = _dataArray[button.tag - 500];
    UITabBarController *main = [(AppDelegate*)[UIApplication sharedApplication].delegate tabBar];
    main.selectedIndex = 1;
    UINavigationController *nav = main.selectedViewController;
    ArchivesController *vc = (ArchivesController *)nav.topViewController;
    vc.memberId = [NSString stringWithFormat:@"%@",dic[@"id"]];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = main;
}
#pragma mark - 点击删除按钮
-(void)DeleActive:(UIButton *)sender
{
    _tag = (float)sender.tag - 10000 ;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteAction];
    }];
    [alertVC addAction:alertAct1];
    [alertVC addAction:alertAct12];
    [self presentViewController:alertVC animated:YES completion:NULL];
   
}

- (void)deleteAction
{
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/memberModifi/delete.jhtml?memberId=%@&id=%@",UrlPre,[UserShareOnce shareOnce].uid,[self.dataArray[_tag]objectForKey:@"id"]];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceslistssError:)];
    [request setDidFinishSelector:@selector(requestResourceslistssCompleted:)];
    [request startAsynchronous];
}


- (void)requestResourceslistssError:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    [self showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self GetResource];

}
- (void)requestResourceslistssCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    
    id status=[dic objectForKey:@"status"];
    if ([status intValue] == 100)
    {
        [self GetResource];
//        NSLog(@"%@",[dic objectForKey:@"data"]);
//        [self.memberTable reloadData];
    }
    else
    {
        //        UIAlertView *avv = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"data"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        //        [avv show];
        //        [avv release];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AlterViewController *alterVC = [[AlterViewController alloc]init];
    alterVC.dataDictionary = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:alterVC animated:YES];
}

@end
