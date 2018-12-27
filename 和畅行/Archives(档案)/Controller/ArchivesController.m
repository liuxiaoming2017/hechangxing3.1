//
//  ArchivesController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ArchivesController.h"
#import "ArchivesCell.h"
#import "ArchiveModel.h"
#import "CellUtil.h"
#import "HealthTipsModel.h"
#import <WebKit/WebKit.h>
#import "ResultSpeakController.h"
#import "ResultController.h"
#import "ElecDetailViewController.h"
#import "EEGDetailController.h"
#import "SidebarViewController.h"
#import "TimeLineView.h"
#import "SBJson.h"


@interface ArchivesController ()<WKUIDelegate,WKNavigationDelegate,SidebarViewDelegate>

{
    UIView *tipsView;
}

@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSMutableArray *archiveArr;
@property (nonatomic,strong) NSMutableArray *dataListArray;
@property (nonatomic,strong) WKWebView *wkwebview;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) NSMutableArray *healthTipsData;
@property (nonatomic,strong) TimeLineView *timeLinvView;
@property (nonatomic, retain) SidebarViewController* sidebarVC;
//刷选button
@property (nonatomic,strong) UIButton *filterBtn;
//请求接口分类
@property (nonatomic,assign) NSInteger typeUrlInteger;
//请求页数
@property (nonatomic,assign) NSInteger pageInteger;

@property (nonatomic,strong)UIView *noView;

@end

@implementation ArchivesController
@synthesize currentIndex,memberId;



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.filterBtn.hidden = NO;
}



- (void)dealloc
{
    self.titleArr = nil;
    self.archiveArr = nil;
    self.progressView = nil;
    self.wkwebview = nil;
    self.healthTipsData = nil;
    
    [_wkwebview removeObserver:self forKeyPath:@"estimatedProgress"];
    
}


//获取其他成员
- (void)userBtnAction:(UIButton *)btn
{
    SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [subMember receiveSubIdWith:^(NSString *subId) {
        self->memberId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
        weakSelf.pageInteger = 1;
        [weakSelf requestHealthHintDataWithTipyInteger:self->currentIndex withPageInteger:weakSelf.pageInteger];
        [subMember hideHintView];
    }];
    
}


- (void)setCurrentIndex:(NSInteger)currentInde
{
    currentIndex = currentInde;
}

- (id)initWithIndex:(NSInteger )index
{
    self = [super init];
    if(self){
        currentIndex = index;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.healthTipsData = [NSMutableArray array];
    self.dataListArray  = [NSMutableArray array];
    self.typeUrlInteger = 0;
    self.pageInteger    = 1;
    
    self.topView.backgroundColor = UIColorFromHex(0x1e82d2);
    self.navTitleLabel.text = @"健康档案";
    self.navTitleLabel.textColor = [UIColor whiteColor];
    [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    
    self.timeLinvView = [[TimeLineView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, ScreenWidth, ScreenHeight-self.topView.bottom-kTabBarHeight) withData:self.dataListArray];
    [self.view addSubview:self.timeLinvView];
    
    self.noView = [NoMessageView createImageWith:100.0f];
    [self.view addSubview:self.noView ];
    
 
//下拉刷新
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"松开即可刷新..." forState:MJRefreshStatePulling];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = RGB_TextAppBlue;
    header.lastUpdatedTimeLabel.textColor = RGB_TextAppBlue;
    self.timeLinvView.tableView.mj_header = header;
    
//上拉加载
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataOther)];
    
    [footer setTitle:@"上拉加载"   forState:MJRefreshStateIdle];
    [footer setTitle:@"加载中..."  forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了"  forState:MJRefreshStateNoMoreData];
    [footer setTitle:@"松开即可加载..."  forState:MJRefreshStatePulling];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.stateLabel.textColor = RGB_TextAppBlue;
    self.timeLinvView.tableView.mj_footer = footer;
    
    self.filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filterBtn.frame = CGRectMake(ScreenWidth-37-14, ScreenHeight-120, 36, 36);
    [self.filterBtn setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
    [self.filterBtn addTarget:self action:@selector(filterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.filterBtn];
    
    self.sidebarVC = [[SidebarViewController alloc] init];
    [self.sidebarVC setBgRGB:0x000000];
    self.sidebarVC.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.sidebarVC.view];
    //    [self.view addSubview:self.sidebarVC.view];
    self.sidebarVC.view.frame  = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    if(!memberId){
        memberId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
    }
    
    [self selectIndexWithString:@"最新"];
    
}

//下拉加载
-(void)loadNewData {
    
    self.pageInteger = 1;
   [self requestHealthHintDataWithTipyInteger:self.typeUrlInteger withPageInteger:self.pageInteger];
}

//上拉刷新
-(void)loadMoreDataOther {
    
    if (_typeUrlInteger == 10||_typeUrlInteger == 0){
        [self.timeLinvView.tableView.mj_footer endRefreshing];
        return;
    };
    self.pageInteger ++;
    [self requestHealthHintDataWithTipyInteger:self.typeUrlInteger withPageInteger:self.pageInteger];
    
}

- (void)filterBtnAction:(UIButton *)button
{
    [self.sidebarVC showHideSidebar];
}


//点击筛选确定走的方法
- (void)selectIndexWithString:(NSString *)str
{
    if ([str isEqualToString:@"最新"])        self.typeUrlInteger = 0;
    else if([str isEqualToString:@"经络"])    self.typeUrlInteger = 1;
    else if([str isEqualToString:@"体质"])    self.typeUrlInteger = 2;
    else if([str isEqualToString:@"脏腑"])    self.typeUrlInteger = 3;
    else if([str isEqualToString:@"心率"])    self.typeUrlInteger = 4;
    else if([str isEqualToString:@"血压"])    self.typeUrlInteger = 5;
    else if([str isEqualToString:@"血氧"])    self.typeUrlInteger = 6;
    else if([str isEqualToString:@"血糖"])    self.typeUrlInteger = 7;
    else if([str isEqualToString:@"体温"])    self.typeUrlInteger = 8;
    else if([str isEqualToString:@"呼吸"])    self.typeUrlInteger = 9;
    else if([str isEqualToString:@"季度报告"]) self.typeUrlInteger = 10;
    else if([str isEqualToString:@"病历"])    self.typeUrlInteger = 11;
    
    self.pageInteger = 1;
    
    
    [_dataListArray removeAllObjects];
    [self.timeLinvView.tableView reloadData];
    
    if(self.typeUrlInteger < 5 || self.typeUrlInteger > 9) {
        if (self.wkwebview) {
            self.wkwebview.hidden = YES;
        }
        self.timeLinvView.hidden = NO;
        [self requestHealthHintDataWithTipyInteger:self.typeUrlInteger withPageInteger:self.pageInteger];
    }else {
        if (self.wkwebview) {
            self.wkwebview.hidden = NO;
        }
        self.timeLinvView.hidden = YES;
        [self requestNetworkWithIndex:self.typeUrlInteger];
        
    }
}

# pragma mark - wkwebview的设置
- (void)createWKWebviewWithUrlStr:(NSString *)urlStr
{
    
    if(!self.wkwebview){
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        config.preferences.minimumFontSize = 10;
        // 默认认为YES
        config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // 通过JS与webview内容交互
        config.userContentController = [[WKUserContentController alloc] init];
        
        self.wkwebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 10, ScreenWidth, ScreenHeight- kNavHeight + 54)
                                            configuration:config];
        // 导航代理
        self.wkwebview.navigationDelegate = self;
        // 与webview UI交互代理
        self.wkwebview.UIDelegate = self;
        [self.view addSubview:self.wkwebview];
        // 添加KVO监听
        [self.wkwebview addObserver:self
                         forKeyPath:@"estimatedProgress"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.frame = CGRectMake(0, 0, self.wkwebview.frame.size.width, 2);
        self.progressView.trackTintColor = [UIColor clearColor]; // 设置进度条的色彩
        self.progressView.progressTintColor = UIColorFromHex(0x1e82d2);
        // 设置初始的进度
        [self.progressView setProgress:0.05 animated:YES];
        [self.wkwebview addSubview:self.progressView];
    }else{
        self.wkwebview.hidden = NO;
    }
//    self.tableView.hidden = YES;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.wkwebview loadRequest:request];
    
}

# pragma mark - 健康提示数据
- (void)requestHealthHintDataWithTipyInteger:(NSInteger )tipyInteger withPageInteger:(NSInteger )pageInteger
{
    __weak typeof(self) weakSelf = self;
    ///member/service/zf_report.jhtml?cust_id=32&physique_id=181224175130815054&device=1
    NSString *str = [NSString new];
    NSString *pageIntegerstr = [NSString stringWithFormat:@"%ld",(long)pageInteger];
    self.currentIndex = tipyInteger;
    switch (tipyInteger) {
        case 0:   str = [NSString stringWithFormat:
                         @"/member/myreport/view/%@.jhtml?",memberId];
            break;
        case 1:   str = [NSString stringWithFormat:
                         @"/member/myreport/list/JLBS/%@.jhtml?pageNumber=%@",memberId,pageIntegerstr];
            break;
            
        case 2:   str = [NSString stringWithFormat:
                         @"/member/myreport/list/TZBS/%@.jhtml?pageNumber=%@",memberId,pageIntegerstr];
            break;
            
        case 3:   str = [NSString stringWithFormat:
                         @"/result/IdentificationList.jhtml?cust_id=%@&pageNumber=%@",memberId,pageIntegerstr];
            break;
            
        case 4:   str = [NSString stringWithFormat:
                         @"/member/myreport/getEcgList/%@.jhtml?pageNumber=%@",memberId,pageIntegerstr];
            break;
            
        case 10:   str = [NSString stringWithFormat:
                          @"/member/service/reportslist.jhtml?memberChildId=%@",@"24"];
            break;
            
        case 11:   [self getCasesList];
            
            return;
            break;
            
        default:
            break;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中...";
    
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:str parameters:nil successBlock:^(id response) {
        
        [hud hideAnimated:YES];
        if ([response[@"status"] integerValue] == 100){
            
            if (self.pageInteger == 1) {
                [weakSelf.dataListArray removeAllObjects];
            }
            

            if (tipyInteger == 0) {
                
                NSArray *array = @[@"report",@"JLBS",@"TZBS",@"ZFBS",@"ecg",@"bloodPressure",@"oxygen",@"bodyTemperature"];
                
                for (int i = 0 ; i<array.count; i++) {
                     NSDictionary *dic  = [[response valueForKey:@"data"] valueForKey:array[i]];
                    HealthTipsModel *tipModel = [[HealthTipsModel alloc] init];
                    
                    if (dic != nil && ![dic isKindOfClass:[NSNull class]]) {
                        [tipModel yy_modelSetWithJSON:dic];
                        tipModel.typeStr = array[i];
                        [weakSelf.dataListArray addObject:tipModel];
                    }
                }
         
                
            }else if (tipyInteger == 4) {
                for (NSDictionary *dic in [[response valueForKey:@"data"] valueForKey:@"content"]) {
                    HealthTipsModel *tipModel = [[HealthTipsModel alloc] init];
                    [tipModel yy_modelSetWithJSON:dic];
                    [weakSelf.dataListArray addObject:tipModel];
                }
            }else {
                for (NSDictionary *dic in [response valueForKey:@"data"]) {
                    HealthTipsModel *tipModel = [[HealthTipsModel alloc] init];
                    [tipModel yy_modelSetWithJSON:dic];
                    [weakSelf.dataListArray addObject:tipModel];
                }
            }
            
            
            if (weakSelf.dataListArray.count < 1) {
                weakSelf.noView.hidden = NO;
                weakSelf.timeLinvView.tableView.hidden = YES;
            }else{
                weakSelf.noView.hidden = YES;
                weakSelf.timeLinvView.tableView.hidden = NO;
            }
            [self.timeLinvView relodTableViewWitDataArray:weakSelf.dataListArray withType:self.typeUrlInteger];
            
        }
    } failureBlock:^(NSError *error) {
        
        [hud hideAnimated:YES];
        NSLog(@"%@",error);
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
    
    if (self.pageInteger == 1) {
        [self.timeLinvView.tableView.mj_header endRefreshing];
    }else {
        [self.timeLinvView.tableView.mj_footer endRefreshing];
    }
}

#pragma mark - 设置提示消息
//-(void)setHealthTips{
//    if (self.healthTipsData.count) {
//        //设置消息.......
//        HealthTipsModel *tipModel = self.healthTipsData[0];
//        UILabel *tip = [Tools labelWith:tipModel.content frame:CGRectMake(40, 45, ScreenWidth-40-20, 10) textSize:12 textColor:[Tools colorWithHexString:@"#747474"] lines:0 aligment:NSTextAlignmentLeft];
//        //动态计算label的高度
//        CGRect tmpRect = [tip.text boundingRectWithSize:CGSizeMake(ScreenWidth-60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:tip.font,NSFontAttributeName, nil] context:nil];
//        CGFloat labelH = tmpRect.size.height;
//        [tip setFrame:CGRectMake(40, 45, ScreenWidth-60,labelH)];
//        [tipsView addSubview:tip];
//        NSString *time1 = [Tools timeYMDStringFrom:tipModel.modifyDate.doubleValue];
//        NSString *time2 = [Tools timeHMStringFrom:tipModel.modifyDate.doubleValue];
//        UILabel *timeLabel = [Tools labelWith:[NSString stringWithFormat:@"%@  %@",time1,time2] frame:CGRectMake(ScreenWidth-120, tipsView.frame.size.height-20, 110, 10) textSize:12 textColor:[Tools colorWithHexString:@"#747474"] lines:1 aligment:NSTextAlignmentLeft];
//        [tipsView addSubview:timeLabel];
//    }else{
//        UILabel *tip = [Tools labelWith:@"暂时没有健康提示" frame:CGRectMake(40, 45, ScreenWidth-40-20, 10) textSize:12 textColor:[Tools colorWithHexString:@"#747474"] lines:1 aligment:NSTextAlignmentLeft];
//        [tipsView addSubview:tip];
//    }
//}

# pragma mark - 网络请求
- (void)requestNetworkWithIndex:(NSInteger)index
{
    
    NSString *urlStr = @"";
    
    if(index > 4){
        
        switch (index) {
            case 5:
                urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,memberId,@(30)];
                break;
            case 6:
                
                urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,memberId,@(20)];
                break;
            case 7:
                urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,memberId,@(40)];
                break;
            case 8:
                urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,memberId,@(20)];
                break;
            case 9:
                urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,memberId,@(50)];
                break;
            default:
                break;
        }
        [self createWKWebviewWithUrlStr:urlStr];
        return;
    }
    
    if(self.wkwebview){
        self.wkwebview.hidden = YES;
    }
}


# pragma mark - 病例的请求

-(void)getCasesList {
    
     [self.timeLinvView.tableView.mj_footer endRefreshing];
    [self.timeLinvView.tableView.mj_header endRefreshing];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@md/diseaList.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    
    [request setPostValue:[MemberUserShance shareOnce].idNum forKey:@"memberId"];
    
    
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requesstuserinfoError:)];
    [request setDidFinishSelector:@selector(requesstuserinfoCompleted11:)];
    [request startAsynchronous];
    
    
}


- (void)requesstuserinfoError:(ASIHTTPRequest *)request
{
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
}
- (void)requesstuserinfoCompleted11:(ASIHTTPRequest *)request
{
    NSString* reqstr=[request responseString];
    //NSLog(@"dic==%@",reqstr);
    NSDictionary * dica=[reqstr JSONValue];
    NSLog(@"dic==%@",reqstr);
    id status=[dica objectForKey:@"status"];
    //NSLog(@"234214324%@",status);
    if ([status intValue]== 100) {
        
        [self.dataListArray removeAllObjects];
        for (NSDictionary *dic in [dica valueForKey:@"data"]) {
            HealthTipsModel *tipModel = [[HealthTipsModel alloc] init];
            [tipModel yy_modelSetWithJSON:dic];
            [self.dataListArray addObject:tipModel];
        }
        
        if(self.dataListArray.count==0){
            self.noView.hidden = NO;
            self.timeLinvView.tableView.hidden = YES;
            return;
        }else{
            self.noView.hidden = YES;
            self.timeLinvView.tableView.hidden = NO;
        }
        
        [self.timeLinvView relodTableViewWitDataArray:self.dataListArray withType:self.typeUrlInteger];

    }
    else if ([status intValue]== 44)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        av.tag  = 100008;
        [av show];
    }
    else  {
        NSString *str = [dica objectForKey:@"data"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        [av show];
    }
}

#pragma mark - tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(currentIndex==0||currentIndex==1||currentIndex==2){
        return 500;
    }else if (currentIndex == 3){
        return 80;
    }else if (currentIndex == 4){
        return 100;
    }else{
        return 0;
    }
    return 0;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([object isEqual:self.wkwebview] && [keyPath isEqualToString:@"estimatedProgress"]) { // 进度条
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        //NSLog(@"打印测试进度值：%f", newprogress);
        if (newprogress == 1) { // 加载完成
            // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES];
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            });
            
        } else { // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}


# pragma mark - wkwebview delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"加载成功");
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [GlobalCommon showMessage:@"请求失败!" duration:2];
    //[self addFailView];
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.filterBtn.hidden = YES;
    
    if (self.timeLinvView.hud){
        [self.timeLinvView.hud hideAnimated:YES];
    }
}



@end
