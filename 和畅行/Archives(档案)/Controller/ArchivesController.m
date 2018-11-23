//
//  ArchivesController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ArchivesController.h"
#import "ColumnBar.h"
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

@interface ArchivesController ()<ColumnBarDelegate,
ColumnBarDataSource,UITableViewDelegate,UITableViewDataSource,WKUIDelegate,WKNavigationDelegate,SidebarViewDelegate>

{
    ColumnBar *_columnBar;
    UIView *tipsView;
}

@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *archiveArr;


@property (nonatomic,strong) WKWebView *wkwebview;
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) NSMutableArray *healthTipsData;

@property (nonatomic, retain) SidebarViewController* sidebarVC;

@end

@implementation ArchivesController
@synthesize currentIndex,memberId;

- (void)dealloc
{
    self.titleArr = nil;
    self.archiveArr = nil;
    self.tableView = nil;
    self.progressView = nil;
    self.wkwebview = nil;
    self.healthTipsData = nil;
    
    [_wkwebview removeObserver:self forKeyPath:@"estimatedProgress"];
    
}

- (void)userBtnAction:(UIButton *)btn
{
   
        SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [subMember receiveSubIdWith:^(NSString *subId) {
            self->memberId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
            [weakSelf requestNetworkWithIndex:self->currentIndex];
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
    
    self.topView.backgroundColor = UIColorFromHex(0x1e82d2);
    self.navTitleLabel.text = @"健康档案";
    self.navTitleLabel.textColor = [UIColor whiteColor];
    //[self.leftBtn setImage:[UIImage imageNamed:@"user_01"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    
    TimeLineView *timeLinvView = [[TimeLineView alloc] initWithFrame:CGRectMake(0, self.topView.bottom+5, ScreenWidth, ScreenHeight-self.topView.bottom) withData:self.archiveArr];
    [self.view addSubview:timeLinvView];
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.frame = CGRectMake(ScreenWidth-37-14, ScreenHeight-120, 36, 36);
    [filterBtn setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
    [filterBtn addTarget:self action:@selector(filterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:filterBtn];
    
    self.sidebarVC = [[SidebarViewController alloc] init];
    [self.sidebarVC setBgRGB:0x000000];
    self.sidebarVC.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.sidebarVC.view];
    //    [self.view addSubview:self.sidebarVC.view];
    self.sidebarVC.view.frame  = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    
    
    /*
    self.titleArr = [NSArray arrayWithObjects:@"最新",@"经络",@"体质",@"脏腑",@"心率",@"血压",@"血氧",@"血糖",@"体温",@"呼吸", nil];
    _columnBar = [[ColumnBar alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, 40) withIsFirstNewsVC:YES];
    _columnBar.columnName = [self.titleArr objectAtIndex:currentIndex];
    _columnBar.selectedIndex = (int)currentIndex;
    _columnBar.dataSource = self;
    _columnBar.delegate = self;
    [_columnBar reloadData:[self.titleArr objectAtIndex:0]];
    [self.view addSubview:_columnBar];
    
    self.healthTipsData = [NSMutableArray arrayWithCapacity:0];
    tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, _columnBar.bottom, ScreenWidth, 140)];
    tipsView.backgroundColor = [Tools colorWithHexString:@"#f0f0f0"];
    [self.view addSubview:tipsView];
    UILabel *tipTitleLbel = [Tools labelWith:@"最新提示" frame:CGRectMake(20, 15, 140, 10) textSize:14 textColor:[Tools colorWithHexString:@"#747474"] lines:1 aligment:NSTextAlignmentLeft];
    [tipsView addSubview:tipTitleLbel];
    
    //添加tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tipsView.bottom, ScreenWidth, ScreenHeight-tipsView.bottom) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundView=nil;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
    
    self.archiveArr = [NSMutableArray arrayWithCapacity:0];
    
    
    [self requestHealthHintData];
    
    if(!memberId){
        memberId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
    }
    
    [self requestNetworkWithIndex:currentIndex];
    */
    if(!memberId){
        memberId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
    }
    
   // [self requestNetworkWithIndex:0];
}

- (void)filterBtnAction:(UIButton *)button
{
    [self.sidebarVC showHideSidebar];
}

- (void)selectIndexWithString:(NSString *)str
{
    NSLog(@"hhhh:%@",str);
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
        
        self.wkwebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, _columnBar.bottom+10, ScreenWidth, ScreenHeight-_columnBar.bottom-10)
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
    self.tableView.hidden = YES;
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.wkwebview loadRequest:request];
    
}

# pragma mark - 健康提示数据
- (void)requestHealthHintData
{
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:@"member/healthAdvisor/healthTipList.jhtml" parameters:nil successBlock:^(id response) {
        if ([response[@"status"] integerValue] == 100){
            NSDictionary *dataDic = response[@"data"];
            NSArray *contentArr = dataDic[@"content"];
            if (contentArr.count) {
                for (NSDictionary *dic in contentArr) {
                    HealthTipsModel *tipModel = [[HealthTipsModel alloc] init];
                    tipModel.totalPages = dataDic[@"totalPages"];
                    tipModel.tipId = dic[@"id"];
                    tipModel.createDate = dic[@"createDate"];
                    tipModel.modifyDate = dic[@"modifyDate"];
                    tipModel.title = dic[@"title"];
                    tipModel.content = dic[@"content"];
                    [weakSelf.healthTipsData addObject:tipModel];
                    
                }
            }
            [weakSelf setHealthTips];
        }
    } failureBlock:^(NSError *error) {
        [weakSelf showAlertWarmMessage:@"请求失败,网络错误!"];
    }];
}

#pragma mark - 设置提示消息
-(void)setHealthTips{
    if (self.healthTipsData.count) {
        //设置消息.......
        HealthTipsModel *tipModel = self.healthTipsData[0];
        UILabel *tip = [Tools labelWith:tipModel.content frame:CGRectMake(40, 45, ScreenWidth-40-20, 10) textSize:12 textColor:[Tools colorWithHexString:@"#747474"] lines:0 aligment:NSTextAlignmentLeft];
        //动态计算label的高度
        CGRect tmpRect = [tip.text boundingRectWithSize:CGSizeMake(ScreenWidth-60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:tip.font,NSFontAttributeName, nil] context:nil];
        CGFloat labelH = tmpRect.size.height;
        [tip setFrame:CGRectMake(40, 45, ScreenWidth-60,labelH)];
        [tipsView addSubview:tip];
        NSString *time1 = [Tools timeYMDStringFrom:tipModel.modifyDate.doubleValue];
        NSString *time2 = [Tools timeHMStringFrom:tipModel.modifyDate.doubleValue];
        UILabel *timeLabel = [Tools labelWith:[NSString stringWithFormat:@"%@  %@",time1,time2] frame:CGRectMake(ScreenWidth-120, tipsView.frame.size.height-20, 110, 10) textSize:12 textColor:[Tools colorWithHexString:@"#747474"] lines:1 aligment:NSTextAlignmentLeft];
        [tipsView addSubview:timeLabel];
    }else{
        UILabel *tip = [Tools labelWith:@"暂时没有健康提示" frame:CGRectMake(40, 45, ScreenWidth-40-20, 10) textSize:12 textColor:[Tools colorWithHexString:@"#747474"] lines:1 aligment:NSTextAlignmentLeft];
        [tipsView addSubview:tip];
    }
}

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
    
    switch (index) {
        case 0:
            
            urlStr = [NSString stringWithFormat:@"/member/myreport/view/%@.jhtml",memberId];
            break;
         case 1:
            urlStr = [NSString stringWithFormat:@"/member/myreport/list/JLBS/%@.jhtml",memberId];
            break;
        case 2:
            urlStr = [NSString stringWithFormat:@"/member/myreport/list/TZBS/%@.jhtml",memberId];
            break;
        case 3:
            urlStr = [NSString stringWithFormat:@"result/IdentificationList.jhtml?cust_id=%@",memberId];
            break;
        case 4:
            urlStr = [NSString stringWithFormat:@"member/myreport/getEcgList/%@.jhtml",memberId];
            break;
        default:
            break;
    }
    __weak typeof(self) weakSelf = self;
    [self.archiveArr removeAllObjects];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"加载中...";
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
        [hud hideAnimated:YES];
        NSLog(@"response:%@",response);
        if([[response objectForKey:@"status"] integerValue] == 100){
            
            weakSelf.tableView.frame = CGRectMake(0, self->_columnBar.bottom+10, ScreenWidth, ScreenHeight-self->_columnBar.bottom-10);
            weakSelf.tableView.hidden = NO;
            self->tipsView.hidden = YES;
            
            if(index == 0){
                weakSelf.tableView.frame = CGRectMake(0, self->tipsView.bottom, ScreenWidth, ScreenHeight-self->tipsView.bottom);
                self->tipsView.hidden = NO;
                [weakSelf handleReportDataWith:[response objectForKey:@"data"]];
            }else if (index == 1){
                [weakSelf handleJingLuoDataWith:[response objectForKey:@"data"]];
            }else if (index == 2){
                [weakSelf handleTiZhiDataWith:[response objectForKey:@"data"]];
            }else if (index == 3){
                [weakSelf handleZangFuDataWith:[response objectForKey:@"data"]];
            }else if (index == 4){
                [weakSelf handleXinLvDataWith:[response objectForKey:@"data"]];
            }
            
        }else{
            [weakSelf.tableView reloadData];
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
        
    } failureBlock:^(NSError *error) {
        [hud hideAnimated:YES];
        [weakSelf.tableView reloadData];
        [weakSelf showAlertWarmMessage:@"请求失败,网络错误!"];
    }];
}

#pragma mark - 处理报告数据
-(void)handleReportDataWith:(NSDictionary *)dic
{
    
    NSDictionary *XLBS = dic[@"XLBS"];
//    if (![XLBS isKindOfClass:[NSNull class]]) {
//        NSDictionary *subjectDic = XLBS[@"subject"];
//
//    }
    
    //oxygen
    NSDictionary *oxygen = dic[@"oxygen"];
    if (![oxygen isKindOfClass:[NSNull class]]) {
        ArchiveModel *model = [[ArchiveModel alloc] init];
        model.iconImage = @"知己档案_血氧";
        model.result = @"血氧";
        model.symptom = [oxygen objectForKey:@"density"];
        model.time = [oxygen objectForKey:@"createDate"];
        model.cellType = 0;
        [self.archiveArr addObject:model];
    }
    
    //bloodPressure
    NSDictionary *bloodPressure = dic[@"bloodPressure"];
    if (![bloodPressure isKindOfClass:[NSNull class]]) {
        ArchiveModel *model = [[ArchiveModel alloc] init];
        model.iconImage = @"知己档案_血压";
        model.result = @"血压";
        model.symptom = [NSString stringWithFormat:@"%@-%@",bloodPressure[@"lowPressure"],bloodPressure[@"highPressure"]];
        model.time = [bloodPressure objectForKey:@"createDate"] ;
        model.cellType = 0;
        [self.archiveArr addObject:model];
    }
    
    //TZBS
    NSDictionary *TZBS = dic[@"TZBS"];
    if (![TZBS isKindOfClass:[NSNull class]]) {
        NSDictionary *subject = TZBS[@"subject"];
        ArchiveModel *model = [[ArchiveModel alloc] init];
        model.iconImage = @"知己档案_体质";
        model.result = @"体质";
        model.symptom = [subject objectForKey:@"name"];
        model.time = [TZBS objectForKey:@"createDate"] ;
        model.cellType = 0;
        [self.archiveArr addObject:model];
    }
    
    //bodyTemperature
    NSDictionary *bodyTemperature = dic[@"bodyTemperature"];
    if (![bodyTemperature isKindOfClass:[NSNull class]]) {
        ArchiveModel *model = [[ArchiveModel alloc] init];
        model.iconImage = @"知己档案_体温";
        model.result = @"体温";
        model.symptom = [bodyTemperature objectForKey:@"temperature"];
        model.time = [bodyTemperature objectForKey:@"createDate"];
        model.cellType = 0;
        [self.archiveArr addObject:model];
    }
    
    //ecg
    NSDictionary *ecg = dic[@"ecg"];
    if(![ecg isKindOfClass:[NSNull class]]){
        ArchiveModel *model = [[ArchiveModel alloc] init];
        model.iconImage = @"知己档案_心电";
        model.result = @"心电";
        model.symptom = [ecg objectForKey:@"heartRate"];
        model.time = [ecg objectForKey:@"createDate"];
        model.cellType = 0;
        [self.archiveArr addObject:model];
    }
    
    //JLBS
    NSDictionary *JLBS = dic[@"JLBS"];
    if(![JLBS isKindOfClass:[NSNull class]]){
        NSDictionary *subjectDic = JLBS[@"subject"];
        ArchiveModel *model = [[ArchiveModel alloc] init];
        model.iconImage = @"知己档案_经络";
        model.result = @"经络";
        model.symptom = [subjectDic objectForKey:@"name"];
        model.time = [JLBS objectForKey:@"createDate"];
        model.cellType = 0;
        [self.archiveArr addObject:model];
    }
    
    //ZFBS
    NSDictionary *ZFBS = dic[@"ZFBS"];
    if(![ZFBS isKindOfClass:[NSNull class]]){
        ArchiveModel *model = [[ArchiveModel alloc] init];
        model.iconImage = @"知己档案_脏腑";
        model.result = @"脏腑";
        model.symptom = [ZFBS objectForKey:@"zz_name_str"];
        model.time = [ZFBS objectForKey:@"createDate"];
        model.cellType = 0;
        [self.archiveArr addObject:model];
    }
    
    [self.tableView reloadData];
    
    if ([XLBS isKindOfClass:[NSNull class]] && [oxygen isKindOfClass:[NSNull class]]&& [bloodPressure isKindOfClass:[NSNull class]]&& [TZBS isKindOfClass:[NSNull class]]&& [bodyTemperature isKindOfClass:[NSNull class]]&& [ecg isKindOfClass:[NSNull class]]&& [JLBS isKindOfClass:[NSNull class]]&& [ZFBS isKindOfClass:[NSNull class]]) {
        
    }
}

- (void)handleJingLuoDataWith:(NSArray *)arr
{
    for(NSDictionary *dic in arr){
        ArchiveModel *model = [[ArchiveModel alloc] init];
        model.iconImage = [dic objectForKey:@"picture"];
        model.symptom = [[dic objectForKey:@"subject"] objectForKey:@"name"];
        model.time = [dic objectForKey:@"createDate"];
        model.subject_sn = [[dic objectForKey:@"subject"] objectForKey:@"subject_sn"];
        model.cellType = 1;
        [self.archiveArr addObject:model];
    }
    [self.tableView reloadData];
}

- (void)handleTiZhiDataWith:(NSArray *)arr
{
    for(NSDictionary *dic in arr){
        ArchiveModel *model = [[ArchiveModel alloc] init];
        model.iconImage = [dic objectForKey:@"picture"];
        model.symptom = [[dic objectForKey:@"subject"] objectForKey:@"name"];
        model.time = [dic objectForKey:@"createDate"];
        model.subject_sn = [[dic objectForKey:@"subject"] objectForKey:@"subject_sn"];
        model.cellType = 2;
        [self.archiveArr addObject:model];
    }
    [self.tableView reloadData];
}

- (void)handleZangFuDataWith:(NSArray *)arr
{
    for(NSDictionary *dic in arr){
        ArchiveModel *model = [[ArchiveModel alloc] init];
        model.result = [dic objectForKey:@"zz_name_str"];
        model.symptom = [dic objectForKey:@"icd_name_str"];
        model.time = [dic objectForKey:@"createDate"];
        model.subject_sn = [dic objectForKey:@"physique_id"];
        model.cellType = 3;
        [self.archiveArr addObject:model];
    }
    [self.tableView reloadData];
}


- (void)handleXinLvDataWith:(NSDictionary *)dic
{
    NSArray *contentArr = [dic objectForKey:@"content"];
    if(contentArr.count>0){
        for(NSDictionary *contentDic in contentArr){
            NSDictionary *subjectDic = [contentDic objectForKey:@"subject"];
            ArchiveModel *model = [[ArchiveModel alloc] init];
            model.result = [subjectDic objectForKey:@"introduction"];
            model.symptom = [[contentDic objectForKey:@"content"] isKindOfClass:[NSNull class]] ? @"暂无心电图医生提示" : [contentDic objectForKey:@"content"];
            model.time = [subjectDic objectForKey:@"createDate"];
            model.subject_sn = [contentDic objectForKey:@"path"];
            model.cellType = 4;
            [self.archiveArr addObject:model];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(currentIndex==0||currentIndex==1||currentIndex==2){
        return 50;
    }else if (currentIndex == 3){
        return 80;
    }else if (currentIndex == 4){
        return 100;
    }else{
        return 0;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.archiveArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArchivesCell *cell = nil;
    ArchiveModel *archive = [self.archiveArr objectAtIndex:indexPath.row];
    cell = [CellUtil getArchiveCell:archive in:tableView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArchiveModel *model = [self.archiveArr objectAtIndex:indexPath.row];
    if(currentIndex == 1){
        NSString *aUrlle= [NSString stringWithFormat:@"%@member/service/reshow.jhtml?sn=%@&device=1",URL_PRE,model.subject_sn];
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = aUrlle;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(currentIndex == 2){
        ResultController *resultVC = [[ResultController alloc] init];
        resultVC.TZBSstr = model.subject_sn;
        [self.navigationController pushViewController:resultVC animated:YES];
    }else if (currentIndex == 3){
        NSString *url = [[NSString alloc] initWithFormat:@"%@esult/reportHtml.jhtml?cust_id=%@&physique_id=%@",URL_PRE,memberId,model.subject_sn];
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = url;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (currentIndex == 4){
//        ElecDetailViewController *detail = [[ElecDetailViewController alloc] init];
//        detail.dataPath = model.subject_sn;
        EEGDetailController *detail = [[EEGDetailController alloc] init];
        detail.dataPath = model.subject_sn;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detail];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

# pragma mark - columnBar代理
- (void)columnBar:(ColumnBar *)sender didSelectedTabAtIndex:(int)index
{
    NSLog(@"index:%d",index);
    currentIndex = index;
    [self requestNetworkWithIndex:index];
}

#pragma mark - column bar data source

- (NSString *)columnBar:(ColumnBar *)columnBar titleForTabAtIndex:(int)index
{
    NSString *titleStr = [self.titleArr objectAtIndex:index];
    return titleStr;
}

- (int)numberOfTabsInColumnBar:(ColumnBar *)columnBar
{
    return 10;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
