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
//上传报告相关
#import "CPTextViewPlaceholder.h"
#import "PYPhotoBrowser.h"
#import "TZImagePickerController.h"

#import "AFHTTPSessionManager.h"
///弱引用/强引用
#define CCWeakSelf __weak typeof(self) weakSelf = self;
#define WIDTHS (self.view.frame.size.width -64)/4

@interface ArchivesController ()<WKUIDelegate,WKNavigationDelegate,SidebarViewDelegate,UIActionSheetDelegate,UIPickerViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate,UIScrollViewDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,PYPhotosViewDelegate>

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
@property (nonatomic,strong)UIButton *firstButton;

@property (nonatomic,copy)NSString *urlStr;
@property (nonatomic,strong)UIView *uploadReportView;

//上传报告相关
@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UITextView *textViews;
@property (nonatomic,strong)UIButton *finishButton;
@property (nonatomic,strong)UIButton *choseButton;
@property (nonatomic, weak) PYPhotosView *publishPhotosView;//属性 保存选择的图片
@property (nonatomic ,strong) UILabel *numberLabel;
@property (nonatomic,strong)UIButton *photoButton;
@property(nonatomic,assign)int repeatClickInt;
@property(nonatomic,strong)NSMutableArray * photos;//放图片的数组
@property(nonatomic,strong)UIImageView *backImageView;
@property(nonatomic,strong)UIView *backView;

@end

@implementation ArchivesController
@synthesize currentIndex,memberId;

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //血压
    if ([[UserShareOnce shareOnce].wherePop isEqualToString:ModuleZW(@"血压")]) {
        UIButton *btn = (UIButton *)[self.sidebarVC.contentView viewWithTag:107];
        self.memberId = [UserShareOnce shareOnce].bloodMemberID;
        [self selectIndexWithString:ModuleZW(@"血压") withButton:btn];
        [UserShareOnce shareOnce].wherePop = @"";
    }
   
    //血糖
    if ([[UserShareOnce shareOnce].wherePop isEqualToString:ModuleZW(@"血糖")]) {
        UIButton *btn = (UIButton *)[self.sidebarVC.contentView viewWithTag:109];
        self.memberId = [UserShareOnce shareOnce].bloodMemberID;
        [self selectIndexWithString:ModuleZW(@"血糖") withButton:btn];
        [UserShareOnce shareOnce].wherePop = @"";
    }
    self.leftBtn.hidden = YES;
    

}

-(void)changeSize:(NSNotification *)notifi {
    self.navTitleLabel.font = [UIFont systemFontOfSize:18];
    [self.timeLinvView.tableView reloadData];
    if(self.urlStr.length > 0 ){
        [self createWKWebviewWithUrlStr:self.urlStr];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.healthTipsData = [NSMutableArray array];
    self.dataListArray  = [NSMutableArray array];
    self.typeUrlInteger = 0;
    self.pageInteger    = 1;
    self.urlStr = @"";
    if(!memberId){
        memberId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
    }
    
    self.navTitleLabel.text = ModuleZW(@"健康档案");
    [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    
    self.timeLinvView = [[TimeLineView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, ScreenWidth, ScreenHeight-self.topView.bottom-kTabBarHeight) withData:self.dataListArray];
    [self.view addSubview:self.timeLinvView];
    
    self.noView = [NoMessageView createImageWith:100.0f];
    [self.view addSubview:self.noView ];
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:ModuleZW(@"下拉刷新") forState:MJRefreshStateIdle];
    [header setTitle:ModuleZW(@"努力加载中...") forState:MJRefreshStateRefreshing];
    [header setTitle:ModuleZW(@"松开即可刷新...") forState:MJRefreshStatePulling];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    header.stateLabel.textColor = RGB_TextAppBlue;
    header.lastUpdatedTimeLabel.textColor = RGB_TextAppBlue;
    self.timeLinvView.tableView.mj_header = header;
    
    //上拉加载
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataOther)];
    [footer setTitle:ModuleZW(@"上拉加载")   forState:MJRefreshStateIdle];
    [footer setTitle:ModuleZW(@"加载中...")  forState:MJRefreshStateRefreshing];
    [footer setTitle:ModuleZW(@"没有更多了")  forState:MJRefreshStateNoMoreData];
    [footer setTitle:ModuleZW(@"松开即可加载...")  forState:MJRefreshStatePulling];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    footer.stateLabel.textColor = RGB_TextAppBlue;
    self.timeLinvView.tableView.mj_footer = footer;
    
    self.sidebarVC = [[SidebarViewController alloc] init];
    [self.sidebarVC setBgRGB:0x000000];
    self.sidebarVC.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.sidebarVC.view];
    self.sidebarVC.view.frame  = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
   //档案筛选按钮
    self.filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.filterBtn.frame = CGRectMake(ScreenWidth-37-14, ScreenHeight-120, 36, 36);
    [self.filterBtn setImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
    [self.filterBtn addTarget:self action:@selector(filterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.filterBtn];
    //    [[UIApplication sharedApplication].keyWindow addSubview:self.filterBtn];
    
    //默认选择
    //血压
    if ([[UserShareOnce shareOnce].wherePop isEqualToString:ModuleZW(@"血压")]) {
        UIButton *btn = (UIButton *)[self.sidebarVC.contentView viewWithTag:107];
        self.memberId = [UserShareOnce shareOnce].bloodMemberID;
        [self selectIndexWithString:ModuleZW(@"血压") withButton:btn];
        [UserShareOnce shareOnce].wherePop = @"";
    }else if ([[UserShareOnce shareOnce].wherePop isEqualToString:ModuleZW(@"血糖")]) {
        UIButton *btn = (UIButton *)[self.sidebarVC.contentView viewWithTag:109];
        self.memberId = [UserShareOnce shareOnce].bloodMemberID;
        [self selectIndexWithString:ModuleZW(@"血糖") withButton:btn];
        [UserShareOnce shareOnce].wherePop = @"";
    }else{
        self.firstButton = (UIButton *)[self.sidebarVC.contentView viewWithTag:100];
        [self selectIndexWithString:@"全部" withButton:self.firstButton];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeMemberChild:) name:exchangeMemberChildNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSize:) name:@"CHANGESIZE" object:nil];
    
}

- (void)exchangeMemberChild:(NSNotification *)notify
{
    if([[notify object] isKindOfClass:[self class]]){
        return;
    }
    self->memberId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
    self.pageInteger = 1;
    [self requestHealthHintDataWithTipyInteger:self->currentIndex withPageInteger:self.pageInteger];
}

//获取其他成员
- (void)userBtnAction:(UIButton *)btn
{
//    SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
//    __weak typeof(self) weakSelf = self;
//    [subMember receiveSubIdWith:^(NSString *subId) {
//        self->memberId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
//        weakSelf.pageInteger = 1;
//        [[NSNotificationCenter defaultCenter] postNotificationName:exchangeMemberChildNotify object:self];
//        [weakSelf requestHealthHintDataWithTipyInteger:self->currentIndex withPageInteger:weakSelf.pageInteger];
//        [subMember hideHintView];
//    }];
    
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


# pragma mark ----- 下拉加载
-(void)loadNewData {
    
    self.pageInteger = 1;
   [self requestHealthHintDataWithTipyInteger:self.typeUrlInteger withPageInteger:self.pageInteger];
}

# pragma mark ----- 上拉刷新
-(void)loadMoreDataOther {
    //档案最新
    if (_typeUrlInteger == 2||_typeUrlInteger == 1||_typeUrlInteger == 14){
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


# pragma mark ----- 点击筛选走的方法
- (void)selectIndexWithString:(NSString *)str withButton:(UIButton *)button{
    
    button.selected = !button.selected;
    if(button.selected){
        [button.layer setBorderColor:[UIColor redColor].CGColor];
    }else{
        [button.layer setBorderColor:UIColorFromHex(0XEEEEEE).CGColor];
        self.typeUrlInteger = 0;
        self.firstButton.selected = YES;
        [self.firstButton.layer setBorderColor:[UIColor redColor].CGColor];
        self.wkwebview.hidden = YES;
        self.timeLinvView.hidden = NO;
        [self requestHealthHintDataWithTipyInteger:0  withPageInteger:1];
        return;
    }
    for(NSInteger i=0;i<15;i++){
        UIButton *btn = (UIButton *)[self.sidebarVC.contentView viewWithTag:100+i];
        if(button.tag != 100+i){
            [btn.layer setBorderColor:UIColorFromHex(0XEEEEEE).CGColor];
            [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            btn.selected = NO;
        }
    }
    
    if ([str isEqualToString:ModuleZW(@"全部")])  self.typeUrlInteger = 0;
    else if([str isEqualToString:ModuleZW(@"最新")])    self.typeUrlInteger = 1;
    else if([str isEqualToString:ModuleZW(@"阶段报告")])    self.typeUrlInteger = 2;
    else if([str isEqualToString:ModuleZW(@"病历")])    self.typeUrlInteger = 3;
    else if([str isEqualToString:ModuleZW(@"经络")])    self.typeUrlInteger = 4;
    else if([str isEqualToString:ModuleZW(@"脏腑")])    self.typeUrlInteger = 5;
    else if([str isEqualToString:ModuleZW(@"体质")])    self.typeUrlInteger = 6;
    else if([str isEqualToString:ModuleZW(@"血压")])    self.typeUrlInteger = 7;
    else if([str isEqualToString:ModuleZW(@"血氧")])    self.typeUrlInteger = 8;
    else if([str isEqualToString:ModuleZW(@"血糖")])    self.typeUrlInteger = 9;
    else if([str isEqualToString:ModuleZW(@"心率")])    self.typeUrlInteger = 10;
    else if([str isEqualToString:ModuleZW(@"呼吸")])    self.typeUrlInteger = 11;
    else if([str isEqualToString:ModuleZW(@"体温")])    self.typeUrlInteger = 12;
    else if([str isEqualToString:ModuleZW(@"上传报告")])    self.typeUrlInteger = 13;
    else if([str isEqualToString:ModuleZW(@"报告列表")])    self.typeUrlInteger = 14;
    NSLog(@"%@",str);
    self.pageInteger = 1;
   
    [_dataListArray removeAllObjects];
    [self.timeLinvView.tableView reloadData];
    
    
    if(self.typeUrlInteger < 7 || self.typeUrlInteger == 10||self.typeUrlInteger == 14) {
        if (self.wkwebview) {
            self.wkwebview.hidden = YES;
        }
        if (self.uploadReportView) {
            self.uploadReportView.hidden = YES;
        }
        self.timeLinvView.hidden = NO;
        self.urlStr = @"";
        [self requestHealthHintDataWithTipyInteger:self.typeUrlInteger withPageInteger:self.pageInteger];
    }else if (self.typeUrlInteger == 13){
        [self layoutUploadReport];
        if (self.wkwebview) {
            self.wkwebview.hidden = YES;
        }
        self.timeLinvView.hidden = YES;

    } else {
        if (self.wkwebview) {
            self.wkwebview.hidden = NO;
        }
        if (self.uploadReportView) {
            self.uploadReportView.hidden = YES;
        }
        self.timeLinvView.hidden = YES;
        [self requestNetworkWithIndex:self.typeUrlInteger];
        
    }
}
# pragma mark - wkwebview的设置
- (void)createWKWebviewWithUrlStr:(NSString *)urlStr {
    if([urlStr hasSuffix:@"html"]){
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"?fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
    }else{
        urlStr = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
    }
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
        
        self.wkwebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight + 10, ScreenWidth, ScreenHeight- kNavBarHeight - kTabBarHeight - 10)
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
    
    NSString *urlString = [NSString string];
    if([urlStr hasSuffix:@"html"]){
        urlString = [urlStr stringByAppendingString:[NSString stringWithFormat:@"?fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
    }else{
        urlString = [urlStr stringByAppendingString:[NSString stringWithFormat:@"&fontSize=%.1f",[UserShareOnce shareOnce].fontSize]];
    }
//    self.tableView.hidden = YES;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self.wkwebview loadRequest:request];
    
}

# pragma mark - 健康提示数据
- (void)requestHealthHintDataWithTipyInteger:(NSInteger )tipyInteger withPageInteger:(NSInteger )pageInteger
{
    __weak typeof(self) weakSelf = self;
    ///member/service/zf_report.jhtml?cust_id=32&physique_id=181224175130815054&device=1
    
    /*
     全部          0;
    最新           1;
    阶段报告    2;
    病历           3;
    经络           4;
    脏腑           5;
    体质           6;
    心率          10;
     报告列表          14;
     */
    NSString *str = [NSString new];
    NSString *pageIntegerstr = [NSString stringWithFormat:@"%ld",(long)pageInteger];
    self.currentIndex = tipyInteger;
    
    switch (tipyInteger) {
        case 0:
            str = [NSString stringWithFormat:
                   @"/member/new_ins/all.jhtml?memberChildId=%@&pageNumber=%@",memberId,pageIntegerstr];
            break;
        case 1:
            //最新
            str = [NSString stringWithFormat:
                   @"/member/myreport/view/%@.jhtml?",memberId];
            break;
            
        case 2:
            
            //阶段报告
            str = [NSString stringWithFormat:
                   @"/member/service/reportslist.jhtml?memberChildId=%@",memberId];
            break;
            
        case 3:
            //病历
            [self getCasesList];
            return;
            break;
            
        case 4:
            //经络
            str = [NSString stringWithFormat:
                   @"/member/myreport/list/JLBS/%@.jhtml?pageNumber=%@",memberId,pageIntegerstr];
         
            break;
            
        case 5:
            //脏腑
            str = [NSString stringWithFormat:
                   @"/result/IdentificationList.jhtml?cust_id=%@&pageNumber=%@",memberId,pageIntegerstr];
            break;
        case 6:
            //体质
            str = [NSString stringWithFormat:
                   @"/member/myreport/list/TZBS/%@.jhtml?pageNumber=%@",memberId,pageIntegerstr];
             break;
        case 10:
            //心率
            str = [NSString stringWithFormat:
                   @"/member/myreport/getEcgList/%@.jhtml?pageNumber=%@",memberId,pageIntegerstr];
            break;
        case 14:
            //心率
            str = [NSString stringWithFormat:
                   @"/login/healthr/list.jhtml?memberId=%@",[UserShareOnce shareOnce].uid];
            break;
            
        default:
            break;
    }
    
    //全部接口先从本地数据库找
//    if(tipyInteger == 0){
//        if (self.pageInteger == 1) {
//            [weakSelf.dataListArray removeAllObjects];
//        }
//        NSArray *arr = [[CacheManager sharedCacheManager] gethealthArchivesModelsWithIndex:pageInteger andRows:20];
//        if(arr.count==20){
//            [self.dataListArray addObjectsFromArray:arr];
//            weakSelf.noView.hidden = YES;
//            weakSelf.timeLinvView.tableView.hidden = NO;
//            [self.timeLinvView relodTableViewWitDataArray:weakSelf.dataListArray withType:self.typeUrlInteger withMemberID:self->memberId];
//            return;
//        }
//    }
    

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = ModuleZW(@"加载中...");
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:str parameters:nil successBlock:^(id response) {
        
        [hud hideAnimated:YES];
        if ([response[@"status"] integerValue] == 100){
            
            if (self.pageInteger == 1) {
                [weakSelf.dataListArray removeAllObjects];
            }
            
            ///最新
            if (tipyInteger == 1) {
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
            }else if (tipyInteger == 10) {
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
                //添加到本地数据库
//                if (tipyInteger == 0){
//                    [[CacheManager sharedCacheManager] insertArchiveModels:weakSelf.dataListArray];
//                }
            }
            
            if (weakSelf.dataListArray.count < 1) {
                weakSelf.noView.hidden = NO;
                weakSelf.timeLinvView.tableView.hidden = YES;
            }else{
                weakSelf.noView.hidden = YES;
                weakSelf.timeLinvView.tableView.hidden = NO;
            }
            [self.timeLinvView relodTableViewWitDataArray:weakSelf.dataListArray withType:self.typeUrlInteger withMemberID:self->memberId];
        }
    } failureBlock:^(NSError *error) {
        [hud hideAnimated:YES];
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
    
    /*
     血压          7;
     血氧           8;
     血糖           9;
     心率          10;
     呼吸          11;
     体温         12;
     */
    self.urlStr = @"";
    
    if(index > 4){
       
        switch (index) {
            case 7:
                //血压
                self.urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,memberId,@(30)];
                break;
            case 8:
                //血氧
                self.urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,memberId,@(20)];
                break;
            case 9:
                //血糖
                self.urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@&version=2",URL_PRE,memberId,@(60)];
                break;
            case 11:
                //体温
                self.urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,memberId,@(50)];
                break;
            case 12:
                //呼吸
                self.urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,memberId,@(40)];
                break;
            default:
                break;
        }
        [self createWKWebviewWithUrlStr:self.urlStr];
        [self.view addSubview:self.filterBtn];
        return;
    }
    
    if(self.wkwebview){
        self.wkwebview.hidden = YES;
    }
}


# pragma mark - 病历的请求

-(void)getCasesList {
    
     [self.timeLinvView.tableView.mj_footer endRefreshing];
    [self.timeLinvView.tableView.mj_header endRefreshing];
   
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@md/diseaList.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    
    
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
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"抱歉，请检查您的网络是否畅通") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
    [av show];
}
- (void)requesstuserinfoCompleted11:(ASIHTTPRequest *)request
{
    NSString* reqstr=[request responseString];
    NSDictionary * dica=[reqstr JSONValue];
    id status=[dica objectForKey:@"status"];
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
        
        [self.timeLinvView relodTableViewWitDataArray:self.dataListArray withType:self.typeUrlInteger withMemberID:memberId];

    }
    else if ([status intValue]== 44)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"登录超时，请重新登录") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        av.tag  = 100008;
        [av show];
    }
    else  {
        NSString *str = [dica objectForKey:@"data"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:str delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        
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
    [GlobalCommon showMessage:ModuleZW(@"请求失败!") duration:2];
    //[self addFailView];
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.timeLinvView.hud){
        [self.timeLinvView.hud hideAnimated:YES];
    }
}
//布局上传报告页面
-(void )layoutUploadReport{
    if (!_uploadReportView) {
        _uploadReportView = [[UIView alloc]initWithFrame: CGRectMake(0, self.topView.bottom, ScreenWidth, ScreenHeight-self.topView.bottom-kTabBarHeight)];
        _uploadReportView.backgroundColor = RGB_AppWhite;
        [self.view addSubview:_uploadReportView];
        
        UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,   10, ScreenWidth - 20, 300)];
        backImageView.backgroundColor = [UIColor whiteColor];
        backImageView.layer.cornerRadius = 10;
        backImageView.userInteractionEnabled = YES;
        backImageView.layer.shadowColor = RGB_TextGray.CGColor;
        backImageView.layer.shadowOffset = CGSizeMake(0,0);
        backImageView.layer.shadowOpacity = 0.5;
        backImageView.layer.shadowRadius = 5;
        
        [self.uploadReportView addSubview:backImageView];
        self.backImageView =  backImageView;
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, backImageView.width - 20, 210)];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderColor = RGB(221, 221, 221).CGColor;
        backView.layer.borderWidth =0.5;
        [backImageView addSubview:backView];
        self.backView = backView;
        
        _textView = [[CPTextViewPlaceholder alloc]initWithFrame:CGRectMake(5, 5, backView.width - 10, 190)];
        _textView.delegate = self;
        _textView.textContainerInset = UIEdgeInsetsMake(10, 0, 20, 10);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangess) name:UITextViewTextDidChangeNotification object:self.textView];
        
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = [UtilityFunc colorWithHexString:@"#666666"];
        
        _textViews = [[UITextView alloc]initWithFrame:CGRectMake(10,5, backView.width - 30, 100)];
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.returnKeyType = UIReturnKeyDone;
        _textViews.text = ModuleZW(@"请输入您想咨询的内容");
        _textViews.font = [UIFont systemFontOfSize:15];
        _textViews.textColor =RGB(162, 162, 162);
        [backView addSubview:_textViews];
        _textView.backgroundColor = [UIColor clearColor];
        [backView addSubview:_textView];
        
        UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(backView.width - 100, backView.height - 20, 90, 20)];
        numberLabel.text = @"0/200";
        numberLabel.textColor =RGB(162, 162, 162);
        numberLabel.textAlignment = NSTextAlignmentRight;
        [backView addSubview:numberLabel];
        _numberLabel = numberLabel;
        
        // 1. 常见一个发布图片时的photosView
        PYPhotosView *publishPhotosView = [PYPhotosView photosView];
        publishPhotosView.py_x = 15;
        publishPhotosView.py_y = backView.bottom + 10;
        publishPhotosView.photoWidth = (backImageView.width-50)/4 ;
        publishPhotosView.photoHeight = (backImageView.width-50)/4 ;
        // 2.1 设置本地图片
        publishPhotosView.images = nil;
        publishPhotosView.hideDeleteView = YES;
        // 3. 设置代理
        publishPhotosView.delegate = self;
        //publishPhotosView.backgroundColor = [UIColor blackColor];
        publishPhotosView.photosMaxCol = 4;//每行显示最大图片个数
        publishPhotosView.imagesMaxCountWhenWillCompose = 9;//最多选择图片的个数
        // 4. 添加photosView
        [backImageView addSubview:publishPhotosView];
        self.publishPhotosView = publishPhotosView;
        
        
        UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        photoButton.frame = CGRectMake(backImageView.width/8-20, backView.bottom + 20 , 40, 40) ;
        [photoButton setBackgroundImage:[UIImage imageNamed:@"专家咨询添加图片"] forState:UIControlStateNormal];
        [photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
        [backImageView addSubview:photoButton];
        self.photoButton = photoButton;
        
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        finishButton.frame = CGRectMake(self.view.frame.size.width / 2 - 45,backImageView.bottom + 40, 90, 26);
        [finishButton setBackgroundColor:RGB_ButtonBlue];
        [finishButton setTitle:ModuleZW(@"提交") forState:UIControlStateNormal];
        [finishButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        finishButton.layer.cornerRadius = 13;
        finishButton.clipsToBounds = YES;
        finishButton.alpha = 0.4;
        finishButton.userInteractionEnabled = NO;
        [finishButton addTarget:self action:@selector(finishButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.uploadReportView addSubview:finishButton];
        self.finishButton = finishButton;
       
        
        
    }else{
        _uploadReportView.hidden = NO;
    }
    [self.view addSubview:self.filterBtn];
    
}

- (void)textDidChangess{
    _textViews.hidden = [_textViews hasText];
    
    
    if (_textView.text.length > 200)
    {
        _textView.text = [_textView.text substringToIndex:200];
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)[_textView.text length], 200];
    
    if (_textView.text.length > 200)
    {
        NSRange rangeIndex = [_textView.text rangeOfComposedCharacterSequenceAtIndex:200];
        
        if (rangeIndex.length == 1)//字数超限
        {
            _textView.text = [_textView.text substringToIndex:200];
            //这里重新统计下字数，字数超限，我发现就不走textViewDidChange方法了，你若不统计字数，忽略这行
            self.numberLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)_textView.text.length, 200];
        }else{
            NSRange rangeRange = [_textView.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 200)];
            _textView.text = [_textView.text substringWithRange:rangeRange];
        }
    }
    
}

# pragma mark - 照片按钮事件
- (void)photoAction{
    
    UIAlertController *alectSheet = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:ModuleZW(@"拍照") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:ModuleZW(@"选取照片") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getPhotos];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:UIAlertActionStyleCancel handler:NULL];
    
    [alectSheet addAction:action1];
    [alectSheet addAction:action2];
    [alectSheet addAction:cancleAction];
    
    [self presentViewController:alectSheet animated:YES completion:NULL];
    
}

# pragma mark - 选取照片
- (void)selectImagePhotoLibrary
{
    if (self.repeatClickInt !=2) {
        self.repeatClickInt = 2;
        
    }
}

#pragma mark - PYPhotosViewDelegate
- (void)photosView:(PYPhotosView *)photosView didAddImageClickedWithImages:(NSMutableArray *)images{
    // 在这里做当点击添加图片按钮时，你想做的事。
    [self getPhotos];
}
// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr{
    NSLog(@"进入预览图片");
}

- (void)photosViewDeleteImageAction
{
    UIView *bottomView = [self.view viewWithTag:2018];
    bottomView.top = self.publishPhotosView.bottom+20;
    
    
    
}

# pragma mark - 选取本地图片
-(void)getPhotos{
    CCWeakSelf;
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9-weakSelf.photos.count delegate:weakSelf];
    imagePickerVc.maxImagesCount = 9 - self.photos.count;//最小照片必选张数,默认是0
    imagePickerVc.sortAscendingByModificationDate = NO;// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    // 你可以通过block或者代理，来得到用户选择的照片.
    UIView *bottomView = [self.view viewWithTag:2018];
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets,BOOL isSelectOriginalPhoto){
        NSLog(@"选中图片photos === %@",photos);
        
        [weakSelf.photos addObjectsFromArray:photos];
        [self.publishPhotosView reloadDataWithImages:self.photos];
        [self updateThePage];
    }];
    [weakSelf presentViewController:imagePickerVc animated:YES completion:nil];
}

-(void)photosView:(PYPhotosView *)photosView didDeleteImageIndex:(NSInteger)imageIndex{
    NSLog(@"%lu",(unsigned long)self.photos.count);
   [self updateThePage];
}

-(NSMutableArray *)photos{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc]init];
        
    }
    return _photos;
}

# pragma mark - 拍照
- (void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
    {
        NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
        NSString *str = [NSString stringWithFormat:ModuleZW(@"请在iPhone的\"设置->隐私->相机\"选项中，允许%@访问您的摄像头。"),appName];
        
        [self showAlertWarmMessage:str];
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.mediaTypes = [NSArray arrayWithObjects: @"public.image", nil];
    [self presentViewController:picker animated:YES completion:^{
    }];
}



- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    //[picker dismissModalViewControllerAnimated:YES comp];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIView *bottomView = [self.view viewWithTag:2018];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.photos addObject:image];
    [self.publishPhotosView reloadDataWithImages:self.photos];
    [self updateThePage];
    bottomView.top = self.publishPhotosView.bottom+20;
    
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabbar" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"6",@"index",nil]];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)finishButtonAction{
    
 
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = ModuleZW(@"加载中...");
    NSString *str = [NSString stringWithFormat:@"%@/login/healthr/upload.jhtml",URL_PRE];
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {

        for (int i = 0; i<self.photos.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(self.photos[i], 1);
            [formData appendPartWithFileData:imageData name:@"myfiles" fileName:@"headimage.jpg" mimeType:@"image/jpeg"];
        }
        NSData *memberIDData = [[UserShareOnce shareOnce].uid dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:memberIDData name:@"memberId"];
        NSData *contentData = [weakSelf.textView.text dataUsingEncoding:NSUTF8StringEncoding];
        [formData appendPartWithFormData:contentData name:@"content"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@",uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [hud hideAnimated:YES];
        NSDictionary*jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves  error:nil];
        if ([[jsonDic valueForKey:@"status"] intValue]== 100) {
            [weakSelf showAlertWarmMessage:ModuleZW(@"上传成功")];
            [weakSelf.photos removeAllObjects];
            [self updateThePage];
        } else  {
            NSString *str = [jsonDic objectForKey:@"message"];
            [self showAlertWarmMessage:str];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [hud hideAnimated:YES];
    }];
    
 
  
    
}

-(void)publishTheinFormationwithDic:(NSDictionary *)dic {
  
}


-(void)updateThePage{
    if (self.photos.count < 4 ) {
        self.photoButton.hidden = NO;
        self.photoButton.left = (ScreenWidth - 20)/8-20 + (((ScreenWidth - 20)-50)/4 + 10)*self.photos.count;
        self.photoButton.top = self->_backView.bottom +20;
        self.backImageView.height = 320;
    }else if (self.photos.count > 3&&self.photos.count < 8 ){
        self.photoButton.hidden = NO;
        self.photoButton.left = (ScreenWidth - 20)/8-20 + (((ScreenWidth - 20)-50)/4 + 10)*(self.photos.count%4);
        self.photoButton.top = self->_backView.bottom +20 +  (self->_backImageView.width-50)/4 +10;
        self.backImageView.height = 320 + (self->_backImageView.width-50)/4 + 10;
    } else if(self.photos.count == 8 ){
        self.photoButton.hidden = NO;
        self.backImageView.height = 320 + (self->_backImageView.width-50)/2 + 20;
        self.photoButton.top = self->_backView.bottom +30 +  (self->_backImageView.width-50)/2 +10;
    }else{
        self.photoButton.hidden = YES;
        self.backImageView.height = 320 + (self->_backImageView.width-50)/2 + 20;
        self.photoButton.top = self->_backView.bottom +20 +  (self->_backImageView.width-50)/2 +10;
        
    }
    if(self.photos.count>0){
        self.finishButton.alpha = 1;
        self.finishButton.userInteractionEnabled = YES;
    }else{
        self.textView.text = @"";
        _textViews.hidden = NO;
        self.finishButton.alpha = 0.4;
        self.finishButton.userInteractionEnabled = NO;
        self.numberLabel.text = [NSString stringWithFormat:@"%lu/%d", (unsigned long)[_textView.text length], 200];
        [self.publishPhotosView reloadDataWithImages:self.photos];
    }
    self.finishButton.top = self.backImageView.bottom+40;
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



@end
