//
//  MySportController.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "MySportController.h"
#import "MySportCell.h"
#import "MenuTypeView.h"
#import "ZYAudioManager.h"
#import "SportDemonstratesViewController.h"
#import "YueYaoController.h"
@interface MySportController ()<UICollectionViewDataSource,UICollectionViewDelegate,MenuTypeDelegate,AVAudioPlayerDelegate>
{
    NSInteger _pageIndex;
    BOOL _isScrol;
    NSInteger _lastSelect;
    NSInteger yueyaoCount;
}

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *imageArr;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,assign) NSInteger titleIndex;

@property (nonatomic,strong) UIButton *voiceButton;
@property (nonatomic ,strong) UIButton *yueYaoButton; //乐药按钮
@property (nonatomic ,strong) UIButton *shifanyinButton; //示范音按钮

@property (nonatomic ,strong) AVAudioPlayer *audioPlay; //音频播放

@property (nonatomic ,strong) NSArray *yueYaoArray; //乐药数据

@property (nonatomic ,strong) NSArray *titleShiFanYinArr;

@property (nonatomic ,strong) NSMutableArray *shifanTitlesArray; //示范音数据

@property (nonatomic, strong) NSMutableArray *shifanyinPlayArr; //运动示范音地址

@property (nonatomic ,assign) NSInteger shifanyinCount;

@property (nonatomic, assign) BOOL isPlayYueYao; // 乐药播放

@property (nonatomic, assign) BOOL isPlayShiFanYin; //示范音播放

@property (nonatomic, assign) BOOL isHaveShiFan;

@property (nonatomic, copy) NSString *cureentPlayUrl;

@property (nonatomic, copy) NSString *yueYaoPlayUrl;

@property (nonatomic, assign) BOOL isNextVC;
@end

@implementation MySportController

@synthesize collectionV,voiceButton,yueYaoButton,shifanyinButton,timer,audioPlay,shifanyinCount;

- (id)initWithSportType:(NSInteger)index
{
    self = [super init];
    if(self){
        
       NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sportImageType" ofType:@"plist"];
        NSArray *fileArr = [NSArray arrayWithContentsOfFile:filePath];
        self.imageArr = [fileArr objectAtIndex:index];
        
        NSString *filePath2 = [[NSBundle mainBundle] pathForResource:ModuleZW(@"sportImageText") ofType:@"plist"];
        NSArray *fileArr2 = [NSArray arrayWithContentsOfFile:filePath2];
        self.titleArr = [fileArr2 objectAtIndex:index];
        //self.titleShiFanYinArr = self.titleArr;
        self.titleIndex = index;
    }
    return self;
}

- (id)initWithAllSport
{
    self = [super init];
    if(self){
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sportImageType" ofType:@"plist"];
        NSArray *fileArr = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i=0;i<fileArr.count;i++){
            NSArray *arr = [fileArr objectAtIndex:i];
            for(NSString *str in arr){
                [mutableArr addObject:str];
            }
        }
        self.imageArr = [mutableArr copy];
        
        NSString *filePath2 = [[NSBundle mainBundle] pathForResource:ModuleZW(@"sportImageText") ofType:@"plist"];
        NSArray *fileArr2 = [NSArray arrayWithContentsOfFile:filePath2];
        NSMutableArray *mutableArr2 = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i=0;i<fileArr2.count;i++){
            NSArray *arr2 = [fileArr2 objectAtIndex:i];
            for(NSString *str in arr2){
                [mutableArr2 addObject:str];
            }
        }
        self.titleArr = [mutableArr2 copy];
        self.titleIndex = -1;
       // self.imageArr =  [NSArray arrayWithObjects: @"gf_tp_yubeidongzuo_0",@"gf_tp_yubeidongzuo_1",@"gf_tp_qishi_0",@"gf_tp_qishi",@"gf_tp_1_0",@"gf_tp_1_1",@"gf_tp_1_2",@"gf_tp_1_3",@"gf_tp_1_4",@"gf_tp_2_0",@"gf_tp_2_1",@"gf_tp_2_2",@"gf_tp_2_3",@"gf_tp_2_4",@"gf_tp_3_0",@"gf_tp_3_1",@"gf_tp_3_2",@"gf_tp_3_3",@"gf_tp_3_4",@"gf_tp_4_0",@"gf_tp_4_1",@"gf_tp_4_2",@"gf_tp_4_3",@"gf_tp_4_4",@"gf_tp_5_0",@"gf_tp_5_1",@"gf_tp_5_2",@"gf_tp_5_3",@"gf_tp_5_4",@"gf_tp_6_0",@"gf_tp_6_1",@"gf_tp_6_2",@"gf_tp_6_3",@"gf_tp_shoushi_0",@"gf_tp_shoushi_1", nil];
    //self.imageArr = [NSArray arrayWithObjects:@[@"gf_tp_yubeidongzuo_0",@"gf_tp_yubeidongzuo_1"],@[@"gf_tp_qishi_0",@"gf_tp_qishi"],@[@"gf_tp_1_0",@"gf_tp_1_1",@"gf_tp_1_2",@"gf_tp_1_3",@"gf_tp_1_4"],@[@"gf_tp_2_0",@"gf_tp_2_1",@"gf_tp_2_2",@"gf_tp_2_3",@"gf_tp_2_4"],@[@"gf_tp_3_0",@"gf_tp_3_1",@"gf_tp_3_2",@"gf_tp_3_3",@"gf_tp_3_4"],@[@"gf_tp_4_0",@"gf_tp_4_1",@"gf_tp_4_2",@"gf_tp_4_3",@"gf_tp_4_4"],@[@"gf_tp_5_0",@"gf_tp_5_1",@"gf_tp_5_2",@"gf_tp_5_3",@"gf_tp_5_4"],@[@"gf_tp_6_0",@"gf_tp_6_1",@"gf_tp_6_2",@"gf_tp_6_3"],@[@"gf_tp_shoushi_0",@"gf_tp_shoushi_1"], nil];
    }
    return self;
}

- (void)dealloc
{
    [self stopTimer];
    [[ZYAudioManager defaultManager] stopMusic:self.cureentPlayUrl];
    [[ZYAudioManager defaultManager] stopMusic:self.yueYaoPlayUrl];
    audioPlay = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.isNextVC){
        [self dealWithShiFanYinYueYaoData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    shifanyinCount = 0;
    
    self.shifanyinPlayArr = [NSMutableArray arrayWithCapacity:0];
    [self dealWithShiFanYinYueYaoData];
}

- (void)createUI
{
    self.navTitleLabel.text = ModuleZW(@"和畅经络运动");
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight-kNavBarHeight-kTabBarHeight);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, layout.itemSize.height) collectionViewLayout:layout];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.backgroundColor = [UIColor clearColor];
    //collectionV.userInteractionEnabled = NO;
    collectionV.pagingEnabled = YES;
    
    [collectionV registerClass:[MySportCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self.view addSubview:collectionV];
    [collectionV reloadData];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, collectionV.bottom, ScreenWidth, kTabBarHeight)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceButton.frame = CGRectMake((ScreenWidth - 25 * 3) / 6, 2, 25, 25);
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"yundongtupian2.png"] forState:UIControlStateSelected];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"yundongtupian1.png"] forState:UIControlStateNormal];
    [voiceButton addTarget:self action:@selector(voiceAction:) forControlEvents:UIControlEventTouchUpInside];
    //voiceButton.selected = YES;
    [footView addSubview:voiceButton];
    
    UILabel *lunbotu = [[UILabel alloc]initWithFrame:CGRectMake(0, voiceButton.bottom, ScreenWidth/3,16)];
    lunbotu.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    lunbotu.text =ModuleZW(@"轮播暂停");
    lunbotu.textAlignment = NSTextAlignmentCenter;
    lunbotu.font = [UIFont systemFontOfSize:12];
    [footView addSubview:lunbotu];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    yueYaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    yueYaoButton.frame = CGRectMake((ScreenWidth - 25 * 3) / 2 + 25, 3, 25, 25);
    
    [yueYaoButton setBackgroundImage:[UIImage imageNamed:@"yudongbofang2.png"] forState:UIControlStateNormal];
    [yueYaoButton setBackgroundImage:[UIImage imageNamed:@"yundongbofang1.png"] forState:UIControlStateSelected];
    
    [yueYaoButton addTarget:self action:@selector(yueYaoAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:yueYaoButton];
    UILabel *bofangyueYao = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/3, voiceButton.bottom, ScreenWidth/3,16)];
    bofangyueYao.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    
    bofangyueYao.text = ModuleZW(@"播放乐药");
    bofangyueYao.textAlignment = NSTextAlignmentCenter;
    bofangyueYao.font = [UIFont systemFontOfSize:12];
    [footView addSubview:bofangyueYao];
    shifanyinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shifanyinButton.frame = CGRectMake((ScreenWidth - 25 * 3) * 5 / 6 + 50, 3, 25, 25);
    [shifanyinButton setBackgroundImage:[UIImage imageNamed:@"yundongyueyaoting.png"] forState:UIControlStateNormal];
    [shifanyinButton setBackgroundImage:[UIImage imageNamed:@"yundongyueyao.png"] forState:UIControlStateSelected];
    [shifanyinButton addTarget:self action:@selector(shifanyinAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:shifanyinButton];
    UILabel *shifanyin = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth*2/3, voiceButton.bottom, ScreenWidth/3,16)];
    shifanyin.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    shifanyin.text = ModuleZW(@"动作示范音");
    shifanyin.textAlignment = NSTextAlignmentCenter;
    shifanyin.font = [UIFont systemFontOfSize:12];
    [footView addSubview:shifanyin];
    
    /********************************************/
    
    UIImageView *countImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, collectionV.top+5, 50.4, 64.8)];
    countImageV.userInteractionEnabled = YES;
    countImageV.tag = 2001;
    countImageV.image = [UIImage imageNamed:@"YD_Type"];
    [self.view addSubview:countImageV];

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, countImageV.width, 15)];
    label1.text =ModuleZW([GlobalCommon getSportNameWithIndex:self.titleIndex+1]);
    label1.tag = 2002;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:15];
    label1.textColor = [UIColor whiteColor];
    [countImageV addSubview:label1];
    CGRect textRect = [label1.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                context:nil];
   label1.width = textRect.size.width;
    countImageV.width = textRect.size.width;

    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.bottom+6, countImageV.width, label1.height)];
    label2.text = [NSString stringWithFormat:@"1/%lu",(unsigned long)self.imageArr.count];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:16];
    label2.textColor = [UIColor whiteColor];
    label2.tag = 2003;
    [countImageV addSubview:label2];
    label2.width = textRect.size.width;

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((countImageV.width-8)/2, label2.bottom+6, 8, 5)];
    imgV.image = [UIImage imageNamed:@"DownImg"];
    imgV.tag = 2004;
    [countImageV addSubview:imgV];
    imgV.left = textRect.size.width/2 - 4;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [countImageV addGestureRecognizer:tap];
    
     [self startTimer];
    
//    self.titleShiFanYinArr = [NSArray arrayWithObjects:@"gf_tp_yubeidongzuo_0",@"gf_tp_yubeidongzuo_1",@"gf_tp_qishi_0",@"gf_tp_qishi_1",@"gf_tp_1_0",@"gf_tp_1_1",@"gf_tp_1_2",@"gf_tp_1_3",@"gf_tp_1_4",@"gf_tp_2_0",@"gf_tp_2_1",@"gf_tp_2_2",@"gf_tp_2_3",@"gf_tp_2_4",@"gf_tp_3_0",@"gf_tp_3_1",@"gf_tp_3_2",@"gf_tp_3_3",@"gf_tp_3_4",@"gf_tp_4_0",@"gf_tp_4_1",@"gf_tp_4_2",@"gf_tp_4_3",@"gf_tp_4_4",@"gf_tp_5_0",@"gf_tp_5_1",@"gf_tp_5_2",@"gf_tp_5_3",@"gf_tp_5_4",@"gf_tp_6_0",@"gf_tp_6_1",@"gf_tp_6_2",@"gf_tp_6_3",@"gf_tp_shoushi_0",@"gf_tp_shoushi_1", nil];
    
}

# pragma mark - 乐药列表下载
-(void)GetResourceslist
{
    [GlobalCommon showMBHudWithView:self.view];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/resources/list/%@.jhtml",UrlPre,[UserShareOnce shareOnce].uid];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceslistErrorw:)];
    [request setDidFinishSelector:@selector(requestResourceslistCompletedw:)];
    [request startAsynchronous];
}

- (void)requestResourceslistErrorw:(ASIHTTPRequest *)request
{
    [self shifanyinSourceList];
    [GlobalCommon hideMBHudWithView:self.view];
    [self showAlertWarmMessage:requestErrorMessage];
}
- (void)requestResourceslistCompletedw:(ASIHTTPRequest *)request
{
    [self shifanyinSourceList];
   [GlobalCommon hideMBHudWithView:self.view];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        NSArray *dicArray=[dic objectForKey:@"data"];
        //UIImage* statusviewImg = nil;
        NSString* filepath=[self Createfilepath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (NSDictionary *dic in dicArray) {
            NSString* NewFileName=[[[dic objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
            NSArray*Urlarray=[NewFileName componentsSeparatedByString:@"/"];
            NSString* urlpathname= [Urlarray objectAtIndex:Urlarray.count-1];
            NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", urlpathname]];
            BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
            if (fileExists) {
               // [self.yueYaoArray addObject:urlpath];
            }
        }
        
    }
    else if ([status intValue]==44)
    {
        
        
    }else{
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:str];
    }
    
}

# pragma mark - 请求示范音
- (void)shifanyinSourceList{
    
    [GlobalCommon showMBHudWithView:self.view];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/resources/list.jhtml?sn=%@",UrlPre,@"ZY-YDSFY"];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrlle]];
    [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestshifanyinSourceError:)];
    [request setDidFinishSelector:@selector(requestResourcesshifanyinCompletedw:)];
    [request startAsynchronous];
}

- (void)requestshifanyinSourceError:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    [self showAlertWarmMessage:requestErrorMessage];
}

- (void)requestResourcesshifanyinCompletedw:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        NSArray *shifanyinDicArr = [[dic objectForKey:@"data"] objectForKey:@"content"];
        NSString* filepath=[self Createfilepath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (NSDictionary *dic in shifanyinDicArr) {
           
            NSString* urlpathname= [[[dic objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"];
            NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", urlpathname]];
            BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
            if(fileExists){
                [self.shifanyinPlayArr addObject:urlpath];
            }
        }
        
    }else{
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:str];
    }
}

# pragma mark - 处理示范音数据
- (void)dealWithShiFanYinYueYaoData
{
    NSString* filepath=[self Createfilepath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(self.shifanyinPlayArr.count>0){
        [self.shifanyinPlayArr removeAllObjects];
    }
    for (NSString *urlpathname in self.imageArr) {
        NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", urlpathname]];
        BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
        if(fileExists){
            [self.shifanyinPlayArr addObject:urlpath];
        }
    }
    
    /*******乐药数据*********/
    NSString *yueyaoFilePath = [GlobalCommon Createfilepath];
    self.yueYaoArray = [fileManager subpathsAtPath: yueyaoFilePath];
    yueyaoCount = 0;
   
}

-(NSString*) Createfilepath
{
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *folderPath = [path stringByAppendingPathComponent:@"temp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    if(!fileExists)
    {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folderPath;
}

# pragma mark - 轮播暂停
- (void)voiceAction:(UIButton *)sender
{
    if (sender.selected) {
        if (shifanyinButton.selected) {
            
        }else{
            sender.selected = NO;
            if(timer.isValid){
                [timer setFireDate:[NSDate distantPast]];
            }else{
                [self startTimer];
            }
        }
    }else{
        if (shifanyinButton.selected || yueYaoButton.selected) {
            return;
        }else{
            sender.selected = YES;
            [timer setFireDate:[NSDate distantFuture]];
        }
    }
}

# pragma mark - 乐药播放
- (void)yueYaoAction:(UIButton *)button
{
    if(self.yueYaoArray.count==0){
        
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"您还没有乐药产品,是否去下载") preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *suerAction = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            self.isNextVC = YES;
            YueYaoController *sportDemonVC = [[YueYaoController alloc]init];
            [self.navigationController pushViewController:sportDemonVC animated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:(UIAlertActionStyleCancel) handler:nil];
        [alerVC addAction:suerAction];
        [alerVC addAction:cancelAction];
        [self presentViewController:alerVC animated:YES completion:nil];
        return;
    }
    
    if(button.selected){
        self.isPlayYueYao = NO;
        button.selected = NO;
        [[ZYAudioManager defaultManager] pauseMusic:self.cureentPlayUrl];
    }else{
        //示范音点击了 关闭示范音
        if(shifanyinButton.selected){
            shifanyinButton.selected = NO;
            collectionV.userInteractionEnabled = YES;
            [[ZYAudioManager defaultManager] stopMusic:self.cureentPlayUrl];
        }
        voiceButton.selected = NO;
        button.selected = YES;
        self.isPlayShiFanYin = NO;
        [self startTimer];
        
        self.isPlayYueYao = YES;
    
        if(self.yueYaoPlayUrl){
            [self refreshAudioPlayWithName:self.yueYaoPlayUrl];
        }else{
            NSString *yueyaoUrlStr = [[GlobalCommon Createfilepath] stringByAppendingPathComponent:[self.yueYaoArray objectAtIndex:0]];
            self.yueYaoPlayUrl = yueyaoUrlStr;
            [self refreshAudioPlayWithName:yueyaoUrlStr];
        }
    }
    
}

# pragma mark - 示范音播放
- (void)shifanyinAction:(UIButton *)sender
{
    if (self.shifanyinPlayArr.count == 0) {
        
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"您还没有音乐示范音产品,是否去下载") preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *suerAction = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            self.isNextVC = YES;
            SportDemonstratesViewController *sportDemonVC = [[SportDemonstratesViewController alloc]init];
            [self.navigationController pushViewController:sportDemonVC animated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:(UIAlertActionStyleCancel) handler:nil];
        [alerVC addAction:suerAction];
        [alerVC addAction:cancelAction];
        [self presentViewController:alerVC animated:YES completion:nil];
        
        
        return;
    }
     if (sender.selected){
         
         sender.selected = NO;
         self.isPlayShiFanYin = NO;
         
         [self refreshAudioPlayWithName:nil];
         collectionV.userInteractionEnabled = YES;
//         回到第一页
         shifanyinCount = 0;
         _pageIndex = 0;
         [self timerRefreshedWithAnimated:NO];
         
         [self startTimer];
         
         
     }else{ //按钮没被选中
         sender.selected = YES;
         self.isPlayShiFanYin = YES;
         
         shifanyinCount = 0;
         _pageIndex = 0;
         [self timerRefreshedWithAnimated:NO];
         collectionV.userInteractionEnabled = NO;
         //有乐药播放，乐药暂停
         if(yueYaoButton.selected){
             yueYaoButton.selected = NO;
             self.isPlayYueYao = NO;
             [[ZYAudioManager defaultManager] pauseMusic:self.yueYaoPlayUrl];
         }
         voiceButton.selected = NO;
         
         //示范音数据
         NSString *shifanStr = [self.imageArr objectAtIndex:_pageIndex];
         
         //示范音本地路径
         NSString *shifanYinStr = [self stringMP3WithFileName:shifanStr];
         
         //判断本地是否存在该示范音
         BOOL isHaveShiFan = [self.shifanyinPlayArr containsObject:shifanYinStr];
         if(isHaveShiFan){
             [self stopTimer];
             [self refreshAudioPlayWithName:shifanYinStr];
         }else{
             //_pageIndex+=1;
             [self startTimer];
         }
     }
}

- (NSString *)stringMP3WithFileName:(NSString *)nameStr
{
    NSString *filepath = [self Createfilepath];
    NSString *str = [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",nameStr]];
    return str;
}


- (void)refreshAudioPlayWithName:(NSString *)fileName
{
    
    if(fileName){
        self.cureentPlayUrl = fileName;
        //开发播放音乐
        //[[ZYAudioManager defaultManager] playingMusic:fileName];
        audioPlay = [[ZYAudioManager defaultManager] playingMusic:fileName];
        audioPlay.delegate = self;
    }else{
        [[ZYAudioManager defaultManager] stopMusic:self.cureentPlayUrl];
        audioPlay = nil;
    }
   
    /*
    if(audioPlay.playing){
        [audioPlay pause];
        self.audioPlay = nil;
    }else{
        if(fileName){
            if(!audioPlay){
                audioPlay = nil;
            }else{
                //audioPlay.url = 
            }
            audioPlay = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:fileName] error:nil];
            audioPlay.volume = 5;
            audioPlay.delegate = self;
            [audioPlay play];
        }else{
            return;
        }
    }
     */
}

- (void)startPlayingMusic:(NSString *)fileName
{
    self.audioPlay = [[ZYAudioManager defaultManager] playingMusic:fileName];
    self.audioPlay.delegate = self;
    
}


- (void)refreshCountImgV
{
    UIImageView *countV = (UIImageView *)[self.view viewWithTag:2001];
    UILabel *label2 = (UILabel *)[countV viewWithTag:2003];
    NSInteger index = _pageIndex+1;
    label2.text = [NSString stringWithFormat:@"%ld/%lu",(long)index,(unsigned long)_imageArr.count];
}

- (void)countImgV2WithIndex:(NSInteger )index
{
    UIImageView *countV = (UIImageView *)[self.view viewWithTag:2001];
    UILabel *label1 = (UILabel *)[countV viewWithTag:2002];
    if(index == 0){
        label1.text = ModuleZW(@"全部   ");
    }else{
        label1.text =ModuleZW( [GlobalCommon getSportNameWithIndex:index]);
    }
    UIImageView *downV = (UIImageView*)[countV viewWithTag:2004];
    UILabel *label2 = (UILabel *)[countV viewWithTag:2003];
    label2.text = [NSString stringWithFormat:@"%ld/%lu",(long)_pageIndex+1,(unsigned long)_imageArr.count];
    
    CGRect textRect = [label1.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 15)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                            context:nil];
    countV.width = textRect.size.width;
    label1.width = textRect.size.width;
    label2.width = textRect.size.width;
    downV.left = textRect.size.width/2 - 4;
    
    
}


- (void)tapAction:(UIGestureRecognizer *)tap
{
    if(shifanyinButton.selected){
        return;
    }
    NSArray *arr = [NSArray arrayWithObjects:ModuleZW(@"全部   "),ModuleZW(@"预备   "),ModuleZW( @"第一式   起式"), ModuleZW(@"第二式   剑指后仰式"), ModuleZW(@"第三式   俯身下探式"), ModuleZW(@"第四式   左右扭转式"), ModuleZW(@"第五式   体侧弯腰式"), ModuleZW(@"第六式   俯身下探加强式"), ModuleZW(@"第七式   婴儿环抱式"), ModuleZW(@"第八式   收式"), nil];
    MenuTypeView *menuView = [[MenuTypeView alloc] initWithFrame:CGRectMake(10, kNavBarHeight, 220, 320)];
    menuView.menuArr = arr;
    menuView.delegate = self;

    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    maskView.backgroundColor = [UIColor clearColor];
    maskView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMenuView:)];
    [maskView addGestureRecognizer:tap2];
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    maskView.tag = 1001;
    menuView.tag = 1002;

    [[UIApplication sharedApplication].keyWindow addSubview:menuView];
}

- (void)removeMenuView:(UIGestureRecognizer *)tap
{
    MenuTypeView *menuView = (MenuTypeView *)[[UIApplication sharedApplication].keyWindow viewWithTag:1002];
    [menuView removeFromSuperview];
    
    UIView *maskView = [[UIApplication sharedApplication].keyWindow viewWithTag:1001];
    [maskView removeFromSuperview];
}
# pragma mark - 运动样式的选择
- (void)selectMenuTypeWithIndex:(NSInteger)index
{
    if(shifanyinButton.selected){
        return;
    }
    
    MenuTypeView *menuView = (MenuTypeView *)[[UIApplication sharedApplication].keyWindow viewWithTag:1002];
    [menuView removeFromSuperview];
    
    UIView *maskView = [[UIApplication sharedApplication].keyWindow viewWithTag:1001];
    [maskView removeFromSuperview];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sportImageType" ofType:@"plist"];
    NSArray *fileArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:ModuleZW(@"sportImageText") ofType:@"plist"];
    NSArray *fileArr2 = [NSArray arrayWithContentsOfFile:filePath2];
    if(index==0){
        if(self.imageArr.count==35){
            return;
        }
        NSMutableArray *mutableArr = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i=0;i<fileArr.count;i++){
            NSArray *arr = [fileArr objectAtIndex:i];
            for(NSString *str in arr){
                [mutableArr addObject:str];
            }
        }
        self.imageArr = [mutableArr copy];
        
        NSMutableArray *mutableArr2 = [NSMutableArray arrayWithCapacity:0];
        for(NSInteger i=0;i<fileArr2.count;i++){
            NSArray *arr2 = [fileArr2 objectAtIndex:i];
            for(NSString *str in arr2){
                [mutableArr2 addObject:str];
            }
        }
        self.titleArr = [mutableArr2 copy];
        
    }else{
        self.imageArr = [fileArr objectAtIndex:index - 1];
        self.titleArr = [fileArr2 objectAtIndex:index - 1];
    }
    _pageIndex = 0;
    [self stopTimer];
    [self countImgV2WithIndex:index];
    [self.collectionV reloadData];
    [self.collectionV setContentOffset:CGPointMake(0, 1)];
    
    [self dealWithShiFanYinYueYaoData];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MySportCell *cell = (MySportCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    NSString *imagenName = [NSString stringWithFormat:@"%@",[self.imageArr objectAtIndex:indexPath.row]];
    cell.imageV.image = [UIImage imageNamed:ModuleZW(imagenName)];
    NSString *titleStr = [self.titleArr objectAtIndex:indexPath.row];
    if(titleStr == nil || [titleStr isEqualToString:@""]){
        cell.bottomView.hidden = YES;
    }else{
        cell.bottomView.hidden = NO;
        [cell titleHeightWithStr:titleStr];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)startTimer {
    [self stopTimer];
    self.timer = [NSTimer timerWithTimeInterval:6.0
                                                   target:self
                                                 selector:@selector(timerRefreshed)
                                                 userInfo:nil
                                                  repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

# pragma mark - 定时器操作
- (void)timerRefreshed{
    if (_pageIndex == [self.imageArr count]) {
        [self stopTimer];
        
    }else
    {
        if(shifanyinButton.selected){ //示范音模式
           _pageIndex += 1;
            if (_pageIndex == [self.imageArr count]) {
                [self stopTimer];
                return;
            }
            [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_pageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [self refreshCountImgV];
        }else{ //其他模式
            if (_pageIndex == [self.imageArr count]) {
                [self stopTimer];
                return;
            }
            [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_pageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            [self refreshCountImgV];
            _pageIndex+=1;
        }
    }
}

- (void)timerRefreshedWithAnimated:(BOOL)animate{
    if (_pageIndex == [self.imageArr count]) {
        [self stopTimer];
    }else
    {
        [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_pageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animate];
        [self refreshCountImgV];
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(timer){
        [timer setFireDate:[NSDate distantFuture]];
    }
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!voiceButton.selected){
        [timer setFireDate:[NSDate distantPast]];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_isScrol) {
        [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        _isScrol = NO;
    }
    NSLog(@"index*******:%ld",(long)_pageIndex);
    if(self.isPlayShiFanYin){
        
        if(!self.isHaveShiFan){
            //示范音数据
            NSString *shifanStr = [self.imageArr objectAtIndex:_pageIndex];
            
            //示范音本地路径
            NSString *shifanYinStr = [self stringMP3WithFileName:shifanStr];
            
            //判断本地是否存在该示范音
            BOOL isHaveShiFan = [self.shifanyinPlayArr containsObject:shifanYinStr];
            
            if(isHaveShiFan){
                [self stopTimer];
                [self refreshAudioPlayWithName:shifanYinStr];
            }
        }
        
    }else{
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    currentPage = currentPage % self.imageArr.count;
    _pageIndex = currentPage;
    [self refreshCountImgV];
    [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

# pragma mark - 音频每次播放结束后触发
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    
    if(self.isPlayShiFanYin){ //示范音播放
        //上一个播放完的 删除
        [[ZYAudioManager defaultManager] stopMusic:self.cureentPlayUrl];
        shifanyinCount ++;
        _pageIndex+=1;
        if (self.shifanyinCount > self.shifanyinPlayArr.count-1) {
            shifanyinCount = 0;
            shifanyinButton.selected = NO;
            //停止播放器
            [self refreshAudioPlayWithName:nil];
            return;
        }
        //示范音数据
        NSString *shifanStr = [self.imageArr objectAtIndex:_pageIndex];
        
        //示范音本地路径
        NSString *shifanYinStr = [self stringMP3WithFileName:shifanStr];
        
        //判断本地是否存在该示范音
        BOOL isHaveShiFan = [self.shifanyinPlayArr containsObject:shifanYinStr];
        if(isHaveShiFan){
            self.isHaveShiFan = YES;
            [self timerRefreshedWithAnimated:YES];
            [self refreshAudioPlayWithName:shifanYinStr];
        }else{
            self.isHaveShiFan = NO;
            [self timerRefreshedWithAnimated:YES];
            [self startTimer];
        }
        
    }
    /******乐药播放*******/
    else{
        //上一个播放完的 删除
        [[ZYAudioManager defaultManager] stopMusic:self.yueYaoPlayUrl];
        yueyaoCount ++ ;
        if(yueyaoCount == self.yueYaoArray.count){
            yueyaoCount=0;
        }
        
        NSString *yueyaoStr = [[GlobalCommon Createfilepath] stringByAppendingPathComponent:[self.yueYaoArray objectAtIndex:yueyaoCount]];
        self.yueYaoPlayUrl = yueyaoStr;
        [self refreshAudioPlayWithName:yueyaoStr];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
