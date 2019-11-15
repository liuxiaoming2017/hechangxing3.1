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

#import "YueYaoController.h"
#import "SongListModel.h"

@interface MySportController ()<UICollectionViewDataSource,UICollectionViewDelegate,MenuTypeDelegate,AVAudioPlayerDelegate,GKAudioPlayerDelegate>
{
    NSInteger _pageIndex;
    BOOL _isScrol;
    NSInteger _lastSelect;
    NSInteger yueyaoCount;
}

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



@property (nonatomic ,strong) NSArray *yueYaoArray; //乐药数据


@property (nonatomic, strong) NSMutableArray *shifanyinPlayArr; //运动示范音地址

@property (nonatomic ,assign) NSInteger shifanyinCount;

@property (nonatomic, assign) BOOL isPlayYueYao; // 乐药播放

@property (nonatomic, assign) BOOL isPlayShiFanYin; //示范音播放

@property (nonatomic, assign) BOOL isHaveShiFan;

@property (nonatomic, copy) NSString *cureentPlayUrl;

@property (nonatomic, copy) NSString *yueYaoPlayUrl;

@property (nonatomic, assign) BOOL isNextVC;

@property (nonatomic,assign) BOOL isPlaying;

@end

@implementation MySportController

@synthesize collectionV,voiceButton,yueYaoButton,shifanyinButton,timer,shifanyinCount;

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
    
    [self stopMusic];
    
    //全局播放器初始化
    kPlayer.delegate = nil;
    kPlayer.musicArr = nil;
    kPlayer.playUrlStr = nil;
    
    self.titleArr = nil;
    self.imageArr = nil;
    self.collectionV = nil;
    self.yueYaoArray = nil;
    self.shifanyinPlayArr = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.isNextVC){
        [self GetMusicResourceslist];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self createUI];
    
    shifanyinCount = 0;
    
    self.shifanyinPlayArr = [NSMutableArray arrayWithCapacity:0];
    
   // [self dealWithShiFanYinYueYaoData];
    
    yueyaoCount = 0;
    
    // 设置播放器的代理
    kPlayer.delegate = self;
    kPlayer.noDelegate = NO;
    if(kPlayer.playUrlStr != nil && kPlayer.playerState == 2){
        yueYaoButton.selected = YES;
        self.yueYaoArray = kPlayer.musicArr;
    }
    [self shifanyinSourceList];
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

# pragma mark - 已购买乐药列表
-(void)GetMusicResourceslist
{
//    [GlobalCommon showMBHudWithView:self.view];
//    NSString *UrlPre=URL_PRE;
//    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/resources/list/%@.jhtml",UrlPre,[UserShareOnce shareOnce].uid];
//    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *url = [NSURL URLWithString:aUrlle];
//
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
//    NSString *nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString *headStr = [NSString stringWithFormat:@"ios_hcy-oem-%@",nowVersion];
//    //[request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"]; //ios_hcy-oem-3.1.3
//    [request addRequestHeader:@"version" value:headStr];
//    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//    [request setRequestMethod:@"GET"];
//    [request setTimeOutSeconds:20];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requestResourceslistErrorw:)];
//    [request setDidFinishSelector:@selector(requestResourceslistCompletedw:)];
//    [request startAsynchronous];
    
    [GlobalCommon showMBHudWithView:self.view];
    NSString *urlStr= [NSString stringWithFormat:@"member/resources/list/%@.jhtml",[UserShareOnce shareOnce].uid];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:2 urlString:urlStr parameters:nil successBlock:^(id dic) {
        [weakSelf requestResourceslistCompletedw:dic];
    } failureBlock:^(NSError *error) {
        [GlobalCommon hideMBHudWithView:weakSelf.view];
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
}


- (void)requestResourceslistCompletedw:(NSDictionary *)dic
{
    //[self shifanyinSourceList];
   [GlobalCommon hideMBHudWithView:self.view];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        NSArray *dicArray=[dic objectForKey:@"data"];
        NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dic in dicArray){
            SongListModel *model = [[SongListModel alloc] init];
            model.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            model.productId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productId"]];
            if([[dic objectForKey:@"price"] isKindOfClass:[NSNull class]]){
                model.price = 0;
            }else{
                model.price = [[dic objectForKey:@"price"] floatValue];
            }
            model.status = [dic objectForKey:@"status"];
            model.title = [dic objectForKey:@"name"];
            model.source = [[[dic objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
            [arr2 addObject:model];
        }
        self.yueYaoArray = arr2;
    }
    else if ([status intValue]==44)
    {
        
        
    }else{
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:str];
    }
    
}

# pragma mark - 示范音列表
- (void)shifanyinSourceList{
    
//    [GlobalCommon showMBHudWithView:self.view];
//    NSString *UrlPre=URL_PRE;
//    NSString *aUrlle= [NSString stringWithFormat:@"%@/resources/list.jhtml?sn=%@",UrlPre,@"ZY-YDSFY"];
//    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrlle]];
//    //[request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
//    NSString *nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//    NSString *headStr = [NSString stringWithFormat:@"ios_hcy-oem-%@",nowVersion];
//    [request addRequestHeader:@"version" value:headStr];
//    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
//    if([UserShareOnce shareOnce].languageType){
//        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
//    }
//    [request setRequestMethod:@"GET"];
//    [request setTimeOutSeconds:20];
//    [request setDelegate:self];
//    [request setDidFailSelector:@selector(requestshifanyinSourceError:)];
//    [request setDidFinishSelector:@selector(requestResourcesshifanyinCompletedw:)];
//    [request startAsynchronous];
    
    [GlobalCommon showMBHudWithView:self.view];
    NSString *urlStr= [NSString stringWithFormat:@"resources/list.jhtml?sn=%@",@"ZY-YDSFY"];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:2 urlString:urlStr parameters:nil successBlock:^(id dic) {
        [weakSelf requestResourcesshifanyinCompletedw:dic];
    } failureBlock:^(NSError *error) {
        [weakSelf requestshifanyinSourceError];
    }];
}

- (void)requestshifanyinSourceError
{
    if(kPlayer.playUrlStr != nil && kPlayer.playerState == 2){
        
    }else{
        [self GetMusicResourceslist];
    }
    [GlobalCommon hideMBHudWithView:self.view];
    [self showAlertWarmMessage:requestErrorMessage];
}

- (void)requestResourcesshifanyinCompletedw:(NSDictionary *)dic
{
    if(kPlayer.playUrlStr != nil && kPlayer.playerState == 2){
        
    }else{
        [self GetMusicResourceslist];
    }
    [GlobalCommon hideMBHudWithView:self.view];
    
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        NSArray *shifanyinDicArr = [[dic objectForKey:@"data"] objectForKey:@"content"];
        for (NSDictionary *dic in shifanyinDicArr) {
            SongListModel *model = [[SongListModel alloc] init];
            NSString* urlpathname= [[[dic objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
            model.title = [[[dic objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"];
            model.source = urlpathname;
            model.productId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"productId"]];
            model.idStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
            model.status = @"";
            model.price = 0;
            [self.shifanyinPlayArr addObject:model];
            
        }
        
    }else{
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:str];
    }
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
        
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"您还没有乐药产品,是否去购买") preferredStyle:(UIAlertControllerStyleAlert)];
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
        
        [self stopMusic];
        
    }else{
        //示范音点击了 关闭示范音
        if(shifanyinButton.selected){
            shifanyinButton.selected = NO;
            collectionV.userInteractionEnabled = YES;
            [self stopMusic];
        }
        voiceButton.selected = NO;
        
        /***********流量播放弹框********/
        if(![UserShareOnce shareOnce].wwanPlay){
            if([[UserShareOnce shareOnce].networkState isEqualToString:@"wwan"]){
                __weak typeof(self) weakSelf = self;
                [self showAlertMessage:@"当前正在使用流量，是否继续？" withSure:^(NSString *blockParam) {
                    [UserShareOnce shareOnce].wwanPlay = YES;
                    
                    button.selected = YES;
                    weakSelf.isPlayShiFanYin = NO;
                    [weakSelf startTimer];
                    
                    weakSelf.isPlayYueYao = YES;
                    
                    SongListModel *model = [weakSelf.yueYaoArray objectAtIndex:self->yueyaoCount];
                    weakSelf.yueYaoPlayUrl = model.source;
                    [weakSelf playMusicWithUrlStr:model.source];
                    
                } withCancel:^(NSString *blockParam) {
                    
                }];
                return;
            }
        }
        /**********END*********/
        
        button.selected = YES;
        self.isPlayShiFanYin = NO;
        [self startTimer];
        
        self.isPlayYueYao = YES;
    
        SongListModel *model = [self.yueYaoArray objectAtIndex:yueyaoCount];
        self.yueYaoPlayUrl = model.source;
        
        [self playMusicWithUrlStr:model.source];
        
    }
    
}

# pragma mark - 示范音按钮点击事件
- (void)shifanyinAction:(UIButton *)sender
{
    if (self.shifanyinPlayArr.count == 0) {
        
        [GlobalCommon showMessage2:@"您还没有示范音产品" duration2:1.0];
        
        return;
    }
     if (sender.selected){
         
         sender.selected = NO;
         self.isPlayShiFanYin = NO;
         
         [self stopMusic];
         
         collectionV.userInteractionEnabled = YES;
//         回到第一页
         shifanyinCount = 0;
         _pageIndex = 0;
         [self timerRefreshedWithAnimated:NO];
         
         [self startTimer];
         
         
     }else{ //按钮没被选中
         
         //有乐药播放，乐药暂停
         if(yueYaoButton.selected){
             yueYaoButton.selected = NO;
             self.isPlayYueYao = NO;
             [self stopMusic];
         }
         voiceButton.selected = NO;
         
         /***********流量播放弹框********/
         if(![UserShareOnce shareOnce].wwanPlay){
             if([[UserShareOnce shareOnce].networkState isEqualToString:@"wwan"]){
                 __weak typeof(self) weakSelf = self;
                 [self showAlertMessage:@"当前正在使用流量，是否继续？" withSure:^(NSString *blockParam) {
                     [UserShareOnce shareOnce].wwanPlay = YES;
                     
                     sender.selected = YES;
                     weakSelf.isPlayShiFanYin = YES;
                     
                     self->shifanyinCount = 0;
                     self->_pageIndex = 0;
                     [weakSelf timerRefreshedWithAnimated:NO];
                     
                     [weakSelf playShifanyinAction];
                     
                 } withCancel:^(NSString *blockParam) {
                     
                 }];
                 return;
             }
         }
         /*********END**********/
         
         sender.selected = YES;
         self.isPlayShiFanYin = YES;
         
         shifanyinCount = 0;
         _pageIndex = 0;
         [self timerRefreshedWithAnimated:NO];
         
         [self playShifanyinAction];
     }
}

# pragma mark - 示范音播放
- (void)playShifanyinAction
{
    //示范音数据
    if(_pageIndex>=self.imageArr.count){
        _pageIndex = self.imageArr.count - 1;
    }
    NSString *shifanStr = [self.imageArr objectAtIndex:_pageIndex];
    
    NSString *shifanyin = [self shifanYinUrlWithStr:shifanStr];
    
    [self playMusicWithUrlStr:shifanyin];
    
    [self stopTimer];
    
}

#pragma mark - GKPlayerDelegate
// 播放状态改变
- (void)gkPlayer:(GKAudioPlayer *)player statusChanged:(GKAudioPlayerState)status
{
    switch (status) {
        case GKAudioPlayerStateLoading:{    // 加载中
            
            self.isPlaying = NO;
        }
            break;
        case GKAudioPlayerStateBuffering: { // 缓冲中
            
            self.isPlaying = YES;
        }
            break;
        case GKAudioPlayerStatePlaying: {   // 播放中
            
            
            self.isPlaying = YES;
        }
            break;
        case GKAudioPlayerStatePaused:{     // 暂停
            
            self.isPlaying = NO;
        }
            break;
        case GKAudioPlayerStateStoppedBy:{  // 主动停止
            
            self.isPlaying = NO;
        }
            break;
        case GKAudioPlayerStateStopped:{    // 打断停止
            dispatch_async(dispatch_get_main_queue(), ^{
                [self pauseMusic];
            });
            self.isPlaying = NO;
        }
            break;
        case GKAudioPlayerStateEnded: {     // 播放结束
            NSLog(@"播放结束了");
            if (self.isPlaying) {
                
                
                self.isPlaying = NO;
                
                // 播放结束，自动播放下一首
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self playNextMusic];
                });
            }else {
                
                self.isPlaying = NO;
            }
        }
            break;
        case GKAudioPlayerStateError: {     // 播放出错
            NSLog(@"播放出错了");
            
            self.isPlaying = NO;
        }
            break;
        default:
            break;
    }
    
    
}

# pragma mark - 播放乐药
- (void)playMusicWithUrlStr:(NSString *)urlStr
{
    if(urlStr == nil || [urlStr isEqualToString:@""]){
        return;
    }
    kPlayer.playUrlStr = urlStr;
    [kPlayer play];
}

- (void)pauseMusic
{
    [kPlayer pause];
    self.isPlaying = NO;
}

- (void)stopMusic {
    [kPlayer stop];
    self.isPlaying = NO;
}

# pragma mark - 下一首
- (void)playNextMusic
{
    if(self.isPlayShiFanYin){ //示范音播放
        shifanyinCount ++;
        _pageIndex+=1;
        if (_pageIndex == self.imageArr.count || self.shifanyinCount > self.shifanyinPlayArr.count-1) {
            shifanyinCount = 0;
            shifanyinButton.selected = NO;
            self.isPlayShiFanYin = NO;
            //停止播放器
            [self stopMusic];
            return;
        }
        
        //上一个播放完的 删除
        [self stopMusic];
        
        //示范音数据
        NSString *shifanStr = [self.imageArr objectAtIndex:_pageIndex];
        
        //示范音url地址
        NSString *shifanYinStr = [self shifanYinUrlWithStr:shifanStr];
        
        [self playMusicWithUrlStr:shifanYinStr];
        
        //scrollview下一页
        [self timerRefreshedWithAnimated:YES];
        
    }
    /******乐药播放*******/
    else{
        //上一个播放完的 删除
        [self stopMusic];
        yueyaoCount ++ ;
        if(yueyaoCount == self.yueYaoArray.count){
            yueyaoCount=0;
        }
        
        SongListModel *model = [self.yueYaoArray objectAtIndex:yueyaoCount];
        
        NSString *yueyaoStr = model.source;
        self.yueYaoPlayUrl = yueyaoStr;
        [self playMusicWithUrlStr:yueyaoStr];
    }
}

- (NSString *)shifanYinUrlWithStr:(NSString *)str
{
    //示范音url地址
    __block NSString *shifanYinStr = @"";
    
    [self.shifanyinPlayArr enumerateObjectsUsingBlock:^(SongListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if([model.title isEqualToString:str]){
            shifanYinStr = model.source;
            *stop = YES;
        }
        
    }];
    
    return shifanYinStr;
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
//    if(shifanyinButton.selected){
//        return;
//    }
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
//    if(shifanyinButton.selected){
//        return;
//    }
    
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
    
    [self countImgV2WithIndex:index];
    [self.collectionV reloadData];
    [self.collectionV setContentOffset:CGPointMake(0, 1)];
    
    //[self dealWithShiFanYinYueYaoData];
    
    if(voiceButton.selected){
        voiceButton.selected = NO;
    }
    
    //正在播放示范音
    if(self.isPlayShiFanYin){
        
        [self stopTimer];
        
        //上一个播放完的 删除
        if(self.isPlaying){
            [self stopMusic];
        }
        shifanyinCount = 0;
        [self playShifanyinAction];
    }else{
        [self startTimer];
    }
    
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

# pragma mark - 切换collectionV下一页
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
    NSLog(@"DidEndScrolling_index*******:%ld",(long)_pageIndex);
//    if(self.isPlayShiFanYin){
//
//        if(!self.isHaveShiFan){
//            //示范音数据
//            NSString *shifanStr = [self.imageArr objectAtIndex:_pageIndex];
//
//            //示范音本地路径
//            NSString *shifanYinStr = [self stringMP3WithFileName:shifanStr];
//
//            //判断本地是否存在该示范音
//            BOOL isHaveShiFan = [self.shifanyinPlayArr containsObject:shifanYinStr];
//
//            if(isHaveShiFan){
//                [self stopTimer];
//                [self refreshAudioPlayWithName:shifanYinStr];
//            }
//        }
//
//    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    currentPage = currentPage % self.imageArr.count;
    BOOL isCurrent = currentPage == _pageIndex ? YES : NO;
    _pageIndex = currentPage;
    [self refreshCountImgV];
    [self.collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    if(self.isPlayShiFanYin && !isCurrent){
        //上一个播放完的 删除
        if(self.isPlaying){
            [self stopMusic];
        }
        [self playShifanyinAction];
    }
    NSLog(@"hahaha:%ld",currentPage);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
