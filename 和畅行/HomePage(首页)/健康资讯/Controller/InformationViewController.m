//
//  InformationViewController.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/22.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "InformationViewController.h"
#import "HYSegmentedControl.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSObject+SBJson.h"
#import "SBJson.h"
#import "MBProgressHUD.h"

#import "LoginViewController.h"
#import "UIImageView+WebCache.h"
#import "HeChangPackgeController.h"

@interface InformationViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate,MBProgressHUDDelegate,HYSegmentedControlDelegate>
{
    MBProgressHUD* progress_;
    
}
@property (nonatomic,strong)  HYSegmentedControl *BaoGaosegment;
@property (nonatomic ,strong) UITableView *hotTableView;
@property (nonatomic ,strong) UITableView *healthTableView;
@property (nonatomic,strong) UIScrollView* BaoGaoScroll;
@property (nonatomic,strong) UIView * BaoGaoview;
@property (nonatomic ,strong) NSMutableArray *hotArray;
@property (nonatomic ,strong) NSMutableArray *healthArray;
@property (nonatomic ,strong) NSMutableArray *idArray;
@property (nonatomic,strong)UIView *noView;
@property (nonatomic ,strong) UIView *healthView;

@end

@implementation InformationViewController
- (void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _idArray = [[NSMutableArray alloc]init];
    self.navTitleLabel.text = ModuleZW(@"健康资讯");
    self.hotArray = [[NSMutableArray alloc]init];
    self.healthArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.noView = [NoMessageView createImageWith:150.0f];
    [self.view addSubview:self.noView ];
    //10
//    NSArray *titleArr = @[@"最新资讯",@"健康讲座"];
//    _idArray = [NSMutableArray arrayWithObjects:@"hot",@"10", nil];
//    [self huoquwenzhang:titleArr];
    
    [self huoquwenzhangCanshu];

}

-(void)initWithController{
    if(!self.healthView){
        self.healthView = [[UIView alloc] initWithFrame:CGRectMake(0, _BaoGaosegment.bottom, ScreenWidth, ScreenHeight-_BaoGaosegment.bottom)];
        [self.view addSubview:self.healthView];
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 10)];
        lineView.image = [UIImage imageNamed:@"healthLec"];
        [self.healthView addSubview:lineView];
        
        
        UILabel *titleLabel = [Tools labelWith:ModuleZW(@"讲座说明：") frame:CGRectMake(5, lineView.bottom+10, 150, 10) textSize:11 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
        [self.healthView addSubview:titleLabel];
        
        UILabel *contentLabel = [Tools labelWith:ModuleZW(@"在线预约养生类、慢病类、职业防护类、两性保健类、亲子健康类等健康主题的讲座或沙龙服务。") frame:CGRectMake(15, titleLabel.bottom, kScreenSize.width-25, 30) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:0 aligment:NSTextAlignmentLeft];
        [self.healthView addSubview:contentLabel];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, contentLabel.bottom+20, kScreenSize.width, 30)];
        imageView.backgroundColor = [Tools colorWithHexString:@"#616161"];
        [self.healthView addSubview:imageView];
        
        NSArray *categoryLabel = @[ModuleZW(@"主讲人"),ModuleZW(@"讲座地址"),ModuleZW(@"讲座课题"),ModuleZW(@"开讲日期"),ModuleZW(@"时间"),ModuleZW(@"价格")];
        CGFloat width = kScreenSize.width/6.0f;
        for (int i=0; i<6; i++) {
            UILabel *label = [Tools labelWith:categoryLabel[i] frame:CGRectMake(width*i, 0, width, 30) textSize:11 textColor:[Tools colorWithHexString:@"#abafaf"] lines:2 aligment:NSTextAlignmentCenter];
            [imageView addSubview:label];
        }
        self.healthView.hidden = YES;
    }
    
    
}

- (void)huoquwenzhangCanshu{
    NSString *headYUrl = @"/article/healthCategoryList.jhtml";
    
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:BAHttpRequestTypeHeadGet urlString:headYUrl parameters:nil successBlock:^(id response) {
        [self hudWasHidden];
        id status=[response objectForKey:@"status"];
        if ([status intValue] == 100)
        {
            NSArray *array = [response objectForKey:@"data"];
            NSMutableArray *daArray = [[NSMutableArray alloc]init];
            [weakSelf.idArray addObject:@"hot"];
            [weakSelf.idArray addObject:@"10"];
            [daArray addObject:ModuleZW(@"最新资讯")];
            [daArray addObject:ModuleZW(@"健康讲座")];
            for (NSDictionary *Dic in array) {
                [daArray addObject:[NSString stringWithFormat:@"%@",[Dic objectForKey:@"name"]]];
                [weakSelf.idArray addObject:[NSString stringWithFormat:@"%@",[Dic objectForKey:@"id"]]];
            }
            
            [self huoquwenzhang:daArray];
        }
        else  {
            [self showAlertWarmMessage:requestErrorMessage];
        }
    
    } failureBlock:^(NSError *error) {
        [self hudWasHidden];
        [self showAlertWarmMessage:requestErrorMessage];
    }];

}


- (void)huoquwenzhang:(NSArray *)array{
    
    
    UILabel* lb=[[UILabel alloc] init];
    lb.frame=CGRectMake(0, kNavBarHeight, ScreenWidth, 1);
    [self.view addSubview:lb];
    
    _BaoGaosegment = [[HYSegmentedControl alloc] initWithOriginY:lb.frame.origin.y Titles:array delegate:self];
    [self.view addSubview:_BaoGaosegment];
    _BaoGaosegment.delegate = self;
    [_BaoGaosegment setBtnorline:array];
    
//    _BaoGaoScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _BaoGaosegment.bottom, self.view.frame.size.width, self.view.frame.size.height - _BaoGaosegment.bottom)];
//    _BaoGaoScroll.pagingEnabled = YES;
//    _BaoGaoScroll.delegate = self;
//
//    [self.view addSubview:_BaoGaoScroll];
//    self.automaticallyAdjustsScrollViewInsets = YES;
//    _BaoGaoScroll.contentSize = CGSizeMake(self.view.frame.size.width, 1);
   // _healthTableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.size.width*_BaoGaosegment.frame.origin.x/(self.view.frame.size.width/self.idArray.count), 0, self.view.frame.size.width, self.view.frame.size.height - _BaoGaosegment.bottom) style:UITableViewStylePlain];
    _healthTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _BaoGaosegment.bottom, ScreenWidth, ScreenHeight-_BaoGaosegment.bottom) style:UITableViewStylePlain];
    _healthTableView.tableFooterView = [[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _healthTableView.rowHeight = 84;
    _healthTableView.delegate = self;
    _healthTableView.dataSource = self;
    [self.view addSubview:_healthTableView];

    [self hySegmentedControlSelectAtIndex:0];
    
    [self initWithController];
}
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
   // _healthTableView.frame = CGRectMake(self.view.frame.size.width * index, 0, self.view.frame.size.width, self.view.frame.size.height - 98);
   // _BaoGaoScroll.contentOffset = CGPointMake(self.view.frame.size.width*index, 0);
    NSString *idStr = [self.idArray objectAtIndex:index];
    if (index == 0) {
        self.healthView.hidden = YES;
        self.healthTableView.hidden = NO;
        [self hotArrayWithView];
    }else if(index == 1){
        self.healthView.hidden = NO;
        self.healthTableView.hidden = YES;
        self.noView.hidden = YES;
    }else{
        self.healthView.hidden = YES;
        self.healthTableView.hidden = NO;
        [self healthArrayWithView:idStr];
    }

    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
//    [self.healthArray removeAllObjects];
//    [self.healthTableView reloadData];
//    //通过最终得到的偏移量offset值，来确定pageContntrol当前应该显示第几个圆点
//
//    NSInteger index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
//
//    [_BaoGaosegment changeSegmentedControlWithIndex:index];
    
}
# pragma mark - 最新资讯
- (void)hotArrayWithView{
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/article/healthArticleList.jhtml",UrlPre];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"version" value:@"ios_hcy-yh-1.0"];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }    //[request healthArticleList.jhtml:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    //[request setValue:@"50" forKey:@"count"];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceslisttssError:)];
    [request setDidFinishSelector:@selector(requestResourceslisttssCompleted:)];
    [request startAsynchronous];
}
- (void)requestResourceslisttssError:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    [self showAlertWarmMessage:ModuleZW(@"抱歉，请检查您的网络是否畅通")];
    
}

- (void)requestResourceslisttssCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",status);
    if ([status intValue] == 100)
    {
        [self.healthArray removeAllObjects];
        
        self.healthArray = [dic objectForKey:@"data"];
        NSLog(@"%@",[dic objectForKey:@"data"]);
        [self.healthTableView reloadData];
    }
    else
    {
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:str];
        
    }
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
# pragma mark - 养生之道
- (void)healthArrayWithView:(NSString*)string{
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    
    NSString *aUrlle= [NSString stringWithFormat:@"%@/article/healthListByCategory/%@.jhtml",UrlPre,string];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    //[request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    [request addRequestHeader:@"version" value:@"ios_hcy-yh-1.0"];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceslisttssErrorsss:)];
    [request setDidFinishSelector:@selector(requestResourceslisttssCompletedsss:)];
    [request startAsynchronous];
}
- (void)requestResourceslisttssErrorsss:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    [self showAlertWarmMessage:ModuleZW(@"抱歉，请检查您的网络是否畅通")];
    
}

- (void)requestResourceslisttssCompletedsss:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue] == 100)
    {
        [self.healthArray removeAllObjects];
        self.healthArray = [dic objectForKey:@"data"];
       // NSLog(@"%@",[dic objectForKey:@"data"]);
        CGSize size;
        size.width=self.healthTableView.frame.size.width;
        size.height=(self.idArray.count)*84;
        [self.healthTableView setContentSize:size];
        [self.healthTableView reloadData];
        
        if (self.healthArray.count < 1){
            self.noView.hidden = NO;
            self.healthTableView.hidden = YES;
        }else {
            self.noView.hidden = YES;
            self.healthTableView.hidden = NO;
        }
        
    }
    else if ([status intValue]==44)
    {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"登录超时,请重新登录") preferredStyle:UIAlertControllerStyleAlert];
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

    return self.healthArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"LeMedicineCell";
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        else
        {
            while ([cell.contentView.subviews lastObject] != nil)
            {
                
                [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
            }

    }
        UIImageView *hotImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 7, 80, 70)];

        [hotImage sd_setImageWithURL:[NSURL URLWithString:[self.healthArray[indexPath.row]objectForKey:@"picture"]]];
        [cell addSubview:hotImage];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(118, 15, self.view.frame.size.width - 135, 15)];
        titleLabel.textColor = [UtilityFunc colorWithHexString:@"#4b4a4a"];
        titleLabel.font = [UIFont systemFontOfSize:12];
        titleLabel.text = [self.healthArray[indexPath.row]objectForKey:@"title"];
        [cell addSubview:titleLabel];
        
        UILabel *hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(118, 42, self.view.frame.size.width - 135, 15)];
        hotLabel.font = [UIFont systemFontOfSize:11];
        hotLabel.textColor = [UtilityFunc colorWithHexString:@"#838383"];
        if ([[self.healthArray[indexPath.row]objectForKey:@"seoDescription"]isEqual:[NSNull null]]) {
            hotLabel.text = [self.healthArray[indexPath.row]objectForKey:@"title"];
        }else{
        hotLabel.text = [self.healthArray[indexPath.row]objectForKey:@"seoDescription"];
        }
        [cell addSubview:hotLabel];
        NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:[[self.healthArray[indexPath.row]objectForKey:@"createDate" ] doubleValue]/1000.00];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        
        NSString *confromTimespStr = [formatter stringFromDate:data];
        
        
        UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 117, 60, 100, 15)];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
        timeLabel.font = [UIFont systemFontOfSize:9];
        timeLabel.text = confromTimespStr;
        [cell addSubview:timeLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
    vc.titleStr = ModuleZW(@"健康文化");
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,[self.healthArray[indexPath.row] objectForKey:@"path"]];
    vc.urlStr = urlStr;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
