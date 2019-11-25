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
#import "UpdateReportViewController.h"
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
    self.startTimeStr = [GlobalCommon getCurrentTimes];
    self.navTitleLabel.text = ModuleZW(@"健康档案");
//    [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    
    self.timeLinvView = [[TimeLineView alloc] initWithFrame:CGRectMake(0, self.topView.bottom, ScreenWidth, ScreenHeight-self.topView.bottom-kTabBarHeight) withData:self.dataListArray];
    [self.view addSubview:self.timeLinvView];
    
    self.noView = [NoMessageView createImageWith:100.0f];
    [self.view addSubview:self.noView ];
    
    UIButton *ploadRreportBT = [UIButton buttonWithType:UIButtonTypeCustom];
    ploadRreportBT.frame = CGRectMake(ScreenWidth-Adapter(104), 2+kStatusBarHeight, Adapter(100), 40);
    [ploadRreportBT setTitle:ModuleZW(@"上传报告") forState:(UIControlStateNormal)];
    if (ISPaid) {
        [ploadRreportBT.titleLabel setFont:[UIFont systemFontOfSize:15/[UserShareOnce shareOnce].multipleFontSize]];
    }else{
        [ploadRreportBT.titleLabel setFont:[UIFont systemFontOfSize:15/[UserShareOnce shareOnce].fontSize]];
    }
    
    [ploadRreportBT setTitleColor:RGB_ButtonBlue forState:(UIControlStateNormal)];
    [[ploadRreportBT rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        UpdateReportViewController *updateVC = [[UpdateReportViewController alloc]init];
        updateVC.hidesBottomBarWhenPushed = YES;
        updateVC.returnTextBlock = ^{
            self.pageInteger = 1;
            [self requestHealthHintDataWithTipyInteger:self.typeUrlInteger withPageInteger:self.pageInteger];
        };
        [self.navigationController pushViewController:updateVC animated:YES];
        
    }];
    [self.topView addSubview:ploadRreportBT];
    
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
    self.filterBtn.frame = CGRectMake(ScreenWidth-Adapter(51), ScreenHeight-Adapter(120), Adapter(36), Adapter(36));
    [self.filterBtn setBackgroundImage:[UIImage imageNamed:@"筛选"] forState:UIControlStateNormal];
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
//    else if([str isEqualToString:ModuleZW(@"上传报告")])    self.typeUrlInteger = 13;
    else if([str isEqualToString:ModuleZW(@"体检报告")])    self.typeUrlInteger = 14;
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
//        [self layoutUploadReport];
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
    
    [request addValue:[self getCookieValue] forHTTPHeaderField:@"Cookie"];
    
    [self.wkwebview loadRequest:request];
    
}

-(NSString*)readCurrentCookieWith:(NSDictionary*)dic{
    if (dic == nil) {
        return nil;
    }else{
        NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSMutableString *cookieString = [[NSMutableString alloc] init];
        for (NSHTTPCookie*cookie in [cookieJar cookies]) {
            [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
        }
        //删除最后一个“；”
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
        return cookieString;
        
    }
}

- (NSMutableString*)getCookieValue{
    // 在此处获取返回的cookie
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@""];
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    // cookie重复，先放到字典进行去重，再进行拼接
    for (NSString *key in cookieDic) {
        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
        [cookieValue appendString:appendString];
    }
    return cookieValue;
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
   
//    NSString *UrlPre=URL_PRE;
//    NSString *aUrl = [NSString stringWithFormat:@"%@md/diseaList.jhtml",UrlPre];
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
//    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
//    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
//
//
//    [request setTimeOutSeconds:20];
//    [request setRequestMethod:@"POST"];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requesstuserinfoError:)];
//    [request setDidFinishSelector:@selector(requesstuserinfoCompleted11:)];
//    [request startAsynchronous];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [dic setObject:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithCookieType:1 urlString:@"md/diseaList.jhtml" headParameters:nil parameters:dic successBlock:^(id dica) {
        id status=[dica objectForKey:@"status"];
        if ([status intValue]== 100) {
            
            [self.dataListArray removeAllObjects];
            for (NSDictionary *dic in [dica valueForKey:@"data"]) {
                HealthTipsModel *tipModel = [[HealthTipsModel alloc] init];
                [tipModel yy_modelSetWithJSON:dic];
                [weakSelf.dataListArray addObject:tipModel];
            }
            
            if(weakSelf.dataListArray.count==0){
                weakSelf.noView.hidden = NO;
                weakSelf.timeLinvView.tableView.hidden = YES;
                return;
            }else{
                weakSelf.noView.hidden = YES;
                weakSelf.timeLinvView.tableView.hidden = NO;
            }
            
            [weakSelf.timeLinvView relodTableViewWitDataArray:weakSelf.dataListArray withType:weakSelf.typeUrlInteger withMemberID:self->memberId];
            
        }
        else if ([status intValue]== 44)
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"登录超时，请重新登录") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
            av.tag  = 100008;
            [av show];
        }
        else  {
            NSString *str = [dica objectForKey:@"data"];
            [weakSelf showAlertWarmMessage:str];
        }
    } failureBlock:^(NSError *error) {
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
    
}



- (void)requesstuserinfoCompleted11:(NSDictionary *)dica
{
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
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.endTimeStr = [GlobalCommon getCurrentTimes];
    [GlobalCommon pageDurationWithpageId:@"2" withstartTime:self.startTimeStr withendTime:self.endTimeStr];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if (self.timeLinvView.hud){
        [self.timeLinvView.hud hideAnimated:YES];
    }
}



@end
