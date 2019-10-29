//
//  YueYaoController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/27.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "YueYaoController.h"
#import "CCSegmentedControl.h"
#import "HYSegmentedControl.h"
#import "SongListCell.h"
#import "DownloadHandler.h"
#import "SongListModel.h"
#import "ProgressIndicator.h"
#import <AVFoundation/AVFoundation.h>
#import "MuisicNoraml.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ShoppingController.h"

#import "NoteController.h"
#import "NoteView.h"

#import <MediaPlayer/MediaPlayer.h>
#import <notify.h>



#define SCREEN_WIDTH_Size ([UIScreen mainScreen].bounds.size.width)/375

@interface YueYaoController ()<UITableViewDelegate,UITableViewDataSource,songListCellDelegate,CBCentralManagerDelegate,CBPeripheralDelegate,MuscicNoramlDeleaget,GKAudioPlayerDelegate>

{
    NSInteger SegIndex;
    id _playerTimeObserver;
    NSInteger _gouMaiCount;
}

@property (nonatomic,strong) HYSegmentedControl *hysegmentControl;
@property (nonatomic,strong) DownloadHandler *downhander;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic ,strong) MuisicNoraml *musciView;

@property (nonatomic,copy) NSString *selectSongName;//当前播放的乐药

@property (strong, nonatomic) AVPlayer *avPlayer;



@property (assign, nonatomic) BOOL isOnPay; //YES 需要购买


@property (nonatomic,strong) UILabel *jinerLabel;

@property (nonatomic,assign) float allPrice;

@property (nonatomic,copy) NSString *typeStr;
@property (nonatomic,strong) UIView *backView;

@property (nonatomic,assign) BOOL isPlaying;

@property (nonatomic,assign) BOOL isBackground;

@property (nonatomic,copy) NSString *currentSubjectSn;

@property (nonatomic,strong) NSIndexPath *currentIndexPath; //拿来做 类型切换 乐药播放时 找到暂停上一首乐药cell

/**
 *  蓝牙连接必要对象
 */
@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic* writeCharacteristic;

/**
 乐药开关
 */
@property (nonatomic,assign) BOOL isleyaoOnOff;

/**
 判读蓝牙设备连接状态
 */
@property (nonatomic,assign) BOOL isBleLink;
@property (nonatomic,strong) UIButton *blueTBT;



@end


@implementation YueYaoController
@synthesize hysegmentControl,downhander,jinerLabel,allPrice;

- (void)dealloc
{

    downhander = nil;
    self.dataArr = nil;
    self.avPlayer = nil;
    self.tableView = nil;
    self.hysegmentControl = nil;
    
    kPlayer.noDelegate = YES;
    
   // [self removeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PayStatues" object:nil];
    [UserShareOnce shareOnce].allYueYaoPrice = 0.0;
    [[UserShareOnce shareOnce].yueYaoBuyArr removeAllObjects];
}


+ (instancetype)sharePlayerController
{
    static YueYaoController *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isOnPay = YES;
    self.isPlaying = NO;
    if(self.isYueLuoyi){
        self.navTitleLabel.text = @"樂絡怡";
    }else{
        self.navTitleLabel.text = @"樂藥";
    }
    
    
    [self createTopGongView];
    
    allPrice = 0;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PaySuccess) name:@"PayStatues" object:nil];
    
    if(self.isYueLuoyi){
        if(![[[NSUserDefaults standardUserDefaults]valueForKey:@"YueLuoyi"] isEqualToString:@"1111"]){
            [self layoutPromptView];
        }
    }
    
    
    NSString *yueyaoHint = [[NSUserDefaults standardUserDefaults] objectForKey:hintYueYao];
    if([GlobalCommon stringEqualNull:yueyaoHint]){
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf addNoteView];
        });
        
    }
    
}

- (void)addNoteView
{
    NoteView *noteV = [NoteView noteViewInitUIWithContent:yueYaoNote withTypeStr:hintYueYao];
    [[UIApplication sharedApplication].keyWindow addSubview:noteV];
}

-(void)layoutPromptView{
    
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.8;
    [self.view addSubview:blackView];
    
    
    UIButton *iKnowBT = [UIButton buttonWithType:(UIButtonTypeCustom)];
    iKnowBT.frame = CGRectMake(ScreenWidth - 150,  kScreenSize.height- kNavBarHeight - 160 - 100, 100, 50);
    __weak typeof(self) weakSelf = self;
    [iKnowBT setBackgroundImage:[UIImage imageNamed:ModuleZW(@"我知道了")] forState:(UIControlStateNormal)];
    [[iKnowBT rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSUserDefaults standardUserDefaults]setValue:@"1111" forKey:@"YueLuoyi"];
        [blackView removeFromSuperview];
        weakSelf.musciView.userInteractionEnabled = YES;
        weakSelf.blueTBT.userInteractionEnabled = YES;
    }];
    [blackView addSubview:iKnowBT];
    
    NSArray *imageArray = @[@"左边箭头",@"右边箭头"];
    for (int i = 0; i < 2; i++) {
        UIImageView *leftImagaView = [[UIImageView alloc]initWithFrame:CGRectMake(40 + (ScreenWidth - 180 - 40)*i, kScreenSize.height- kNavBarHeight - 180, 120, 120)];
        leftImagaView.image = [UIImage imageNamed:ModuleZW(imageArray[i])];
        [blackView addSubview:leftImagaView];
    }
    
    self.musciView.userInteractionEnabled = NO;
    self.blueTBT.userInteractionEnabled = NO;
    [self.view addSubview:self.musciView];
    [self.view addSubview:self.blueTBT];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"songRemoteControlNotification" object:self userInfo:@{@"eventSubtype":@(event.subtype)}];
}



# pragma mark - 乐药购买成功回调
- (void)PaySuccess
{
    [self requestYueyaoListWithType:self.typeStr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.backView){
        if([UserShareOnce shareOnce].yueYaoBuyArr.count == 0){
            if(_backView.top == ScreenHeight - kTabBarHeight - 16){
                [UIView animateWithDuration:0.3 animations:^{
                    self->_backView.top  = ScreenHeight ;
                }];
            }
        }else{
            if(_backView.top == ScreenHeight){
                [UIView animateWithDuration:0.3 animations:^{
                    self->_backView.top  = ScreenHeight  - kTabBarHeight - 16;
                }];
            }
        }
    }
    
    if([UserShareOnce shareOnce].yueYaoBuyArr.count == 0&&self.backView){
        if(self->_backView.top == ScreenHeight - kTabBarHeight - 16){
            [UIView animateWithDuration:0.3 animations:^{
                self->_backView.top  = ScreenHeight ;
            }];
        }
    }else{
        if(self->_backView.top == ScreenHeight){
            [UIView animateWithDuration:0.3 animations:^{
                self->_backView.top  = ScreenHeight - kTabBarHeight - 16;
            }];
        }
    }
    
    self->jinerLabel.text = [NSString stringWithFormat:@"¥%.2f",[UserShareOnce shareOnce].allYueYaoPrice];
    
    if(_gouMaiCount != [UserShareOnce shareOnce].yueYaoBuyArr.count){
        _gouMaiCount = [UserShareOnce shareOnce].yueYaoBuyArr.count;
        [self.tableView reloadData];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (id)initWithType:(BOOL )isYueLuoyi
{
    self = [super init];
    if(self){
        self.isYueLuoyi = isYueLuoyi;
    }
    return self;
}

# pragma mark - 创建视图
- (void)createTopGongView
{
    
    NSArray *titleArray = @[@"宫", @"商", @"角", @"徵",@"羽"];
    UISegmentedControl *topSegment = [[UISegmentedControl alloc]initWithItems:titleArray];
    topSegment.frame = CGRectMake(0, kNavBarHeight+5, 250, 50);
    topSegment.tintColor = [UIColor whiteColor];
    NSDictionary *selectedDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:28],
                                  NSForegroundColorAttributeName:[UIColor blackColor]};
    NSDictionary *noSelectedDic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:25],
                                    NSForegroundColorAttributeName:RGB_TextAppGray};
    [topSegment setTitleTextAttributes:selectedDic forState:(UIControlStateSelected)];
    [topSegment setTitleTextAttributes:noSelectedDic forState:(UIControlStateNormal)];
    topSegment.selectedSegmentIndex = 0;
    [topSegment addTarget:self action:@selector(valuesegChanged:) forControlEvents:(UIControlEventValueChanged)];
    topSegment.tag = 1024;
    [self.view addSubview:topSegment];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(topSegment.right, topSegment.top, 37, 40);
    [rightBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(noteVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightBtn];
    
    
    hysegmentControl = [[HYSegmentedControl alloc] initWithOriginY:topSegment.bottom + 15 Titles: @[@"少宫", @"左角宫", @"上宫", @"加宫",@"大宫",] delegate:self];
    [self.view addSubview:hysegmentControl];


    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, hysegmentControl.bottom+20, ScreenWidth, ScreenHeight-hysegmentControl.bottom) style:UITableViewStylePlain];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    
    if(self.isYueLuoyi){
        [self BluBluetoothView];
        [self BluetoothConnection];
    }
   
    [self getPayRequest];
    
    NSLog(@"url:%@",kPlayer.playUrlStr);
    
    // 设置播放器的代理
    kPlayer.delegate = self;
    kPlayer.noDelegate = NO;
    if(kPlayer.playUrlStr != nil && kPlayer.playerState == 2){
        self.isPlaying = YES;
        self.selectSongName = kPlayer.playUrlStr;
        SongListModel *model = [kPlayer.musicArr objectAtIndex:0];
        [self dealHysegmentControlWithStr:model.subjectSn];
        return;
    }
    
    //根据个人经络最新一条信息展示
    NSString *physicalStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"Physical"];
    
    if (![GlobalCommon stringEqualNull:physicalStr]) {
        
        [self dealHysegmentControlWithStr:physicalStr];
    }
    if ([GlobalCommon stringEqualNull:physicalStr] || [physicalStr isEqualToString:@""]){
        [hysegmentControl changeSegmentedControlWithIndex:0];
    }
    
}

- (void)dealHysegmentControlWithStr:(NSString *)nameStr
{
    UISegmentedControl *topSegment = (UISegmentedControl *)[self.view viewWithTag:1024];
    
    NSArray * segmentedArray = @[
                                 @[@"少宫", @"左角宫", @"上宫", @"加宫",@"大宫"],
                                 @[ @"少商", @"左商",@"上商",@"右商", @"钛商"],
                                 @[@"少角",@"判角",@"上角", @"钛角",@"大角"],
                                 @[@"少徵",@"判徵",@"上徵",@"右徵", @"质徵"],
                                 @[@"少羽", @"桎羽",@"上羽",@"众羽",@"大羽"]
                                 ];
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            NSString *str = segmentedArray[i][j];
            if([ModuleZW(nameStr) isEqualToString:str]){
                topSegment.selectedSegmentIndex = i;
                [self hysegmentInitBtnorline:topSegment];
                [hysegmentControl changeSegmentedControlWithIndex:j];
                self.typeStr = nameStr; //用于支付成功刷新
            }
        }
    }
}


-(void)getPayRequest {
    

    if([[NSUserDefaults standardUserDefaults] objectForKey:@"noAppstoreCheck"]){
        [self createConsumeView];
        self.isOnPay = YES;
        //[self.tableView reloadData];
    }else{
        self.isOnPay = NO;
      //  [self.tableView reloadData];
    }
    
}
# pragma mark - 下方金额视图
- (void)createConsumeView
{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth  , 60)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    self.backView = backView;
    
    UIButton *jiesuanButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    jiesuanButton.frame = CGRectMake(ScreenWidth-  105,10, 80, 40);
    [jiesuanButton addTarget:self action:@selector(jiesuanButton) forControlEvents:(UIControlEventTouchUpInside)];
    [jiesuanButton.layer addSublayer:[UIColor setGradualChangingColor:jiesuanButton fromColor:@"f5c366" toColor:@"e79036"]];
    jiesuanButton.layer.cornerRadius = 20;
    jiesuanButton.layer.masksToBounds = YES;
    [jiesuanButton setTitle:ModuleZW(@"结算") forState:(UIControlStateNormal)];
    [jiesuanButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    jiesuanButton.backgroundColor = RGB(68, 204, 82);
    [backView addSubview:jiesuanButton];
    
    UIImageView *gouwucheImage = [[UIImageView alloc]initWithFrame:CGRectMake(25, 20, 20, 20)];
    gouwucheImage.image = [UIImage imageNamed:@"购物车icon"];
    [backView addSubview:gouwucheImage];
    
    UILabel *zongjinerLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 50, 60)];
    zongjinerLabel.text = ModuleZW(@"总计: ");
    zongjinerLabel.textColor = RGB_TextAppGray;
    zongjinerLabel.font = [UIFont systemFontOfSize:16];
    [backView addSubview:zongjinerLabel];
    
    jinerLabel = [[UILabel alloc]initWithFrame:CGRectMake(zongjinerLabel.right, 0, 100, 60)];
    jinerLabel.textColor = RGB(222, 119, 36);
    jinerLabel.font = [UIFont boldSystemFontOfSize:16];
    [backView addSubview:jinerLabel];

    
}

# pragma mark - 去结算按钮
- (void)jiesuanButton
{
    if([UserShareOnce shareOnce].yueYaoBuyArr.count == 0){
        [GlobalCommon showMessage:ModuleZW(@"请去添加商品") duration:1.0];
        return;
    }
    ShoppingController *vc = [[ShoppingController alloc] init];
    vc.dataArr = [UserShareOnce shareOnce].yueYaoBuyArr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SongListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songListCell"];
    if(cell == nil){
        cell = [[SongListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"songListCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(self.dataArr.count>0){
        SongListModel *model = [self.dataArr objectAtIndex:indexPath.row];

        if (self.isOnPay == YES){
            NSString *priceStr = [NSString stringWithFormat:@"¥%0.2f",model.price];
            NSString *str = [NSString stringWithFormat:@"%@\n%@",model.title,priceStr];
            
            NSMutableAttributedString *salaryStr = [[NSMutableAttributedString alloc]initWithString:str];
            [salaryStr beginEditing];
            [salaryStr addAttribute:NSForegroundColorAttributeName value:RGB(222, 119, 36) range:NSMakeRange(str.length - priceStr.length ,priceStr.length)];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:8];
            [salaryStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [salaryStr length])];
            [salaryStr endEditing];
            cell.titleLabel.attributedText = salaryStr;
          
        }else{
            cell.titleLabel.text = model.title;
        }
        cell.currentSelect = NO;
        NSString *imageStr = @"";
        
        NSLog(@"url:%@,***:%lu",kPlayer.playUrlStr,kPlayer.playerState);
        
        if(kPlayer.playUrlStr && [model.source isEqualToString:kPlayer.playUrlStr] && kPlayer.playerState == 2){
            cell.currentSelect = YES;
            [cell downloadFailWithImageStr:@"乐药暂停icon"];
            //cell.selected = YES;
        }else{
            
            if(self.isOnPay == NO){ //不需要付费leyaoweigoumai
               imageStr = @"乐药播放icon";
            }else{
                if([self containGouMaiModel:model]){
                    imageStr = @"已加入购物车";
                }else{
                    if([model.status isKindOfClass:[NSNull class]]){
                        imageStr = @"乐药未购买icon";
                    }else if (model.price == 0 || [model.status isEqualToString:@"paid"]){
                        imageStr = @"乐药播放icon";
                    }else{
                        imageStr = @"乐药未购买icon";
                    }
                }
            }
            [cell downloadFailWithImageStr:imageStr];
        }
        
        
    }
    
        switch (SegIndex) {
            case 0:
                [cell setIconImageWith:@"宫icon"];
                break;
            case 1:
                [cell setIconImageWith:@"商icon"];
                break;
            case 2:
                [cell setIconImageWith:@"角icon"];
                break;
            case 3:
                [cell setIconImageWith:@"徵icon"];
                break;
            case 4:
                [cell setIconImageWith:@"羽icon"];
                break;
            default:
                break;
        }
        
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    SongListCell *cell = (SongListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.PlayOrdownload){ //播放暂停
        
        if(self.currentIndexPath && self.currentIndexPath.row != indexPath.row) { //乐药类型切换时,处理正在播放的状态
            [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:self.currentIndexPath];
            self.currentIndexPath = nil;
        }
        
        cell.currentSelect = !cell.currentSelect;
        SongListModel *model = [self.dataArr objectAtIndex:indexPath.row];
        
        if(cell.currentSelect){
            [cell.downloadBtn setImage:[UIImage imageNamed:@"乐药暂停icon"] forState:UIControlStateNormal];
            if(![model.subjectSn isEqualToString:self.currentSubjectSn]){ //切换乐药播放列表
                self.currentSubjectSn = model.subjectSn;
                [self currentPlayYueYaoList];
            }
            
            self.currentIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
            
            [self playActionWithModel:model];
            
            self.selectSongName = model.source; //播放链接
        }else{
            [cell.downloadBtn setImage:[UIImage imageNamed:@"乐药播放icon"] forState:UIControlStateNormal];
          //  self.selectSongName = @"";
            [self pauseMusic];
        }
        
    }else{ //购买
        [self downloadWithIndex:indexPath.row withBtn:cell.downloadBtn];
    }
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    SongListCell *cell = (SongListCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell.PlayOrdownload){
        [cell.downloadBtn setImage:[UIImage imageNamed:@"乐药播放icon"] forState:UIControlStateNormal];
        cell.currentSelect = NO;
        self.selectSongName = @"";
        [self stopMusic];
    }
    
}

# pragma mark - 乐药播放 只在当前选中的经络类型 循环
- (void)currentPlayYueYaoList
{
    
    NSMutableArray *playList = [NSMutableArray arrayWithCapacity:0];
    
    for(SongListModel *model in self.dataArr){
        if (self.isOnPay == NO){ //不需要付费leyaoweigoumai
            [playList addObject:model];
        }else{
            if (![model.status isKindOfClass:[NSNull class]] && (model.price == 0 || [model.status isEqualToString:@"paid"])){
                [playList addObject:model];
            }
        }
        
    }
    
    kPlayer.musicArr = [playList copy];
    
}

# pragma mark - 判断本地目录是否存在该音频文件
- (BOOL)existFileWithName:(NSString *)fileName
{
    NSString* filepath=[GlobalCommon Createfilepath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *urlPathName = [NSString stringWithFormat:@"%@.mp3",fileName];
    NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", urlPathName]];
    BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
    return fileExists;
}

#pragma mark - 获取乐药列表
- (void)requestYueyaoListWithType:(NSString *)typeStr
{
   NSString *subjectSn = [GlobalCommon getSubjectSnFrom:typeStr];
    NSString *aUrlle= [NSString stringWithFormat:@"resources/listBySubject.jhtml?subjectSn=%@&mediaType=%@",subjectSn,@"audio"];
    [GlobalCommon showMBHudWithView:self.view];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:aUrlle parameters:nil successBlock:^(id response) {
        [GlobalCommon hideMBHudWithView:weakSelf.view];
        id status=[response objectForKey:@"status"];
        if([status intValue] == 100){
            NSArray *arr = [response objectForKey:@"data"];
            NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
            
            BOOL isSelectRow = NO;
            NSInteger rowIndex = 0;
            
            
            
            for(NSInteger i =0;i<arr.count;i++){
                NSDictionary *dic = [arr objectAtIndex:i];
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
                model.subjectSn = typeStr;
                [arr2 addObject:model];
                
                if(kPlayer.playerState == 2 && kPlayer.playUrlStr){
                    if([model.source isEqualToString:kPlayer.playUrlStr]){
                        isSelectRow = YES;
                        rowIndex = i;
                    }
                }
            }
            weakSelf.dataArr = arr2;
            [weakSelf.tableView reloadData];
            
            if(isSelectRow){
                
                weakSelf.currentIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowIndex inSection:0];
//                if(indexPath){
//                    [weakSelf.tableView.delegate tableView:weakSelf.tableView didSelectRowAtIndexPath:indexPath];
//                }
            }else{
                weakSelf.currentIndexPath = nil;
            }
            
        }else if ([status intValue] == 44)
        {
            [weakSelf showAlertWarmMessage:ModuleZW(@"登录超时，请重新登录")];
            return;
        }else{
            NSString *str = [response objectForKey:@"data"];
            [weakSelf showAlertWarmMessage:str];
            return;
        }
    } failureBlock:^(NSError *error) {
        [GlobalCommon hideMBHudWithView:weakSelf.view];
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
}

# pragma mark - 已购买乐药列表(暂时不需要)
-(void)gouMaiMusicResourceslist
{
    NSString *aUrlle= [NSString stringWithFormat:@"member/resources/list/%@.jhtml",[UserShareOnce shareOnce].uid];
    [GlobalCommon showMBHudWithView:self.view];
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedNetworkManager] requestWithType:2 urlString:aUrlle parameters:nil successBlock:^(id response) {
        [GlobalCommon hideMBHudWithView:weakSelf.view];
        id status=[response objectForKey:@"status"];
        if([status intValue] == 100){
            NSArray *dicArray=[response objectForKey:@"data"];
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
            
            kPlayer.musicArr = [arr2 copy];
                
        }else if ([status intValue] == 44)
        {
            [weakSelf showAlertWarmMessage:ModuleZW(@"登录超时，请重新登录")];
            return;
        }else{
            NSString *str = [response objectForKey:@"data"];
            [weakSelf showAlertWarmMessage:str];
            return;
        }
    } failureBlock:^(NSError *error) {
        [GlobalCommon hideMBHudWithView:weakSelf.view];
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
}


#pragma mark - 乐药购买事件
- (void)downloadWithIndex:(NSInteger)index withBtn:(UIButton *)btn
{
   
    NSLog(@"haha:%@",[UserShareOnce shareOnce].yueYaoBuyArr);
    
        if(![UserShareOnce shareOnce].yueYaoBuyArr){
            _gouMaiCount = 0;
            [UserShareOnce shareOnce].yueYaoBuyArr = [NSMutableArray arrayWithCapacity:0];
        }
        SongListModel *model = [self.dataArr objectAtIndex:index];
        if([self containGouMaiModel:model]){
           [GlobalCommon showMessage:ModuleZW(@"乐药已加入购物车") duration:2.0];
        }else{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"确定购买曲目吗？") message:[NSString stringWithFormat:@"¥%.2f",model.price] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:ModuleZW(@"取消") style:UIAlertActionStyleCancel handler:NULL];
            UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UserShareOnce shareOnce].yueYaoBuyArr addObject:model];
                [UserShareOnce shareOnce].allYueYaoPrice = [UserShareOnce shareOnce].allYueYaoPrice + model.price;
                //self->allPrice = self->allPrice + model.price;
                self->jinerLabel.text = [NSString stringWithFormat:@"¥%.2f",[UserShareOnce shareOnce].allYueYaoPrice];
                SongListCell *cell = (SongListCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                cell.downloadBtn.backgroundColor = RGB_TextAppGray;
                 [GlobalCommon showMessage:ModuleZW(@"乐药已加入购物车") duration:2.0];
                self->_gouMaiCount += 1;
                if(self->_backView.top == ScreenHeight){
                    [UIView animateWithDuration:0.3 animations:^{
                        self->_backView.top  = ScreenHeight - kTabBarHeight - 16;
                    }];
                }

            }];
            [alertVC addAction:alertAct1];
            [alertVC addAction:alertAct12];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertVC animated:YES completion:nil];
            });
        }
}

# pragma mark - 判断该乐药是否已经加入到购买列表里
- (BOOL)containGouMaiModel:(SongListModel *)songListModel
{
    if([[UserShareOnce shareOnce].yueYaoBuyArr count] == 0){
        return NO;
    }
    for(SongListModel *model in [UserShareOnce shareOnce].yueYaoBuyArr){
        if([model.idStr isEqualToString:songListModel.idStr]){
            return YES;
        }
    }
    return NO;
}


# pragma mark - 播放乐药
- (void)playActionWithModel:(SongListModel *)model
{
    NSString *urlStr = model.source;
    
    if(self.selectSongName != nil || ![self.selectSongName isEqualToString:@""]){
        if([urlStr isEqualToString:self.selectSongName]){
            [kPlayer resume];
            return;
        }else{
            if(kPlayer.playerState == 2){
                [self stopMusic];
            }
        }
    }
    kPlayer.model = model;
    kPlayer.playUrlStr = urlStr;
    [kPlayer play];

}


- (void)pauseMusic
{
    
    [kPlayer pause];
    
}

- (void)stopMusic {
    [kPlayer stop];
}

- (void)noteVC
{
//    self.definesPresentationContext = YES;
//
//    NoteController *vc = [[NoteController alloc] init];
//    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//
//    vc.view.superview.frame = CGRectMake(15, 30, 300, 300);
//    [self presentViewController:vc animated:YES completion:^{
//
//    }];
    
//    NSString *content = yueYaoNote;
//
//    NoteView *noteV = [NoteView noteViewInitUIWithContent:content withTypeStr:hintYueYao];
//    [[UIApplication sharedApplication].keyWindow addSubview:noteV];
    
    
    [self nextMusic];
}

- (void)nextMusic
{
    NSString *currentUrl = @"";
    if(kPlayer.playUrlStr){
        currentUrl = kPlayer.playUrlStr;
        self.selectSongName = nil;
        [self stopMusic];
    }
    
    if(kPlayer.musicArr.count == 1){ //只购买了一首乐药,循环播放
        [self playActionWithModel:kPlayer.model];
        return;
    }
    
    int index = arc4random() % kPlayer.musicArr.count;

    //NSLog(@"yyyy:%@",kPlayer.musicArr);
    
    SongListModel *model = [kPlayer.musicArr objectAtIndex:index];
    
    if([model.source isEqualToString:currentUrl]){
        if(index == kPlayer.musicArr.count -1){
            index = index - 1;
        }else{
            index = index + 1;
        }
        model = [kPlayer.musicArr objectAtIndex:index];
    }
    
    [self playActionWithModel:model];
    
    //播放完一首歌后,切换cell按钮的状态
    
    __block NSInteger row = 0;
    
    [self.dataArr enumerateObjectsUsingBlock:^(SongListModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj.idStr isEqualToString:model.idStr]){
            row = idx;
            *stop = YES;
        }
    }];
    
    if(self.currentIndexPath.row != row){
        [self.tableView.delegate tableView:self.tableView didDeselectRowAtIndexPath:self.currentIndexPath];
        [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        self.currentIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    }
    
    
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
            NSLog(@"播放结束了哈哈哈");
            
                // 播放结束，自动播放下一首
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self nextMusic];
            });
            
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



# pragma mark - 宫商角选择事件

- (void)valuesegChanged:(UISegmentedControl *)segment
{
    
    [self hysegmentInitBtnorline:segment];
    UIButton* btn=[[hysegmentControl GetSegArray] objectAtIndex:0];
    [hysegmentControl segmentedControlChange:btn];
    
}

- (void)hysegmentInitBtnorline:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex==0)
    {
        SegIndex=0;
        [hysegmentControl setBtnorline:@[@"少宫", @"左角宫", @"上宫", @"加宫",@"大宫"]];
        
        
    }
    else if (segment.selectedSegmentIndex==1)
    {
        SegIndex=1;
        [hysegmentControl setBtnorline:@[ @"少商", @"左商",@"上商",@"右商", @"钛商" ]];
        
        
    }
    else if (segment.selectedSegmentIndex==2)
    {
        SegIndex=2;
        [hysegmentControl setBtnorline:@[@"少角",@"判角",@"上角", @"钛角",@"大角"]];
        
    }
    else if (segment.selectedSegmentIndex==3)
    {
        SegIndex=3;
        [hysegmentControl setBtnorline:@[@"少徵",@"判徵",@"上徵",@"右徵", @"质徵"]];
        
    }
    else
    {
        SegIndex=4;
        [hysegmentControl setBtnorline:@[@"少羽", @"桎羽",@"上羽",@"众羽",@"大羽"]];
        
    }
}

# pragma mark - hySegmentedControl代理
- (void)hySegmentedControlSelectAtIndex:(NSInteger)index
{
    UIButton* btn=[[hysegmentControl GetSegArray] objectAtIndex:index];
    self.typeStr = btn.titleLabel.text;
    //NSLog(@"haha：%@",btn.titleLabel.text);
    [self requestYueyaoListWithType:btn.titleLabel.text];
}


# pragma mark - 注册音频监听事件
- (void)customAddNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(audioRouteChangeListenerCallback:)
                                                 name:AVAudioSessionRouteChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(otherAppAudioSessionCallBack:)
                                                 name:AVAudioSessionSilenceSecondaryAudioHintNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(systermAudioSessionCallBack:)
                                                 name:AVAudioSessionInterruptionNotification object:nil];
}

#pragma mark - 监听 插／拔耳机
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    // AVAudioSessionRouteChangeReasonKey：change reason
    
    switch (routeChangeReason) {
            // new device available
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:{
            NSLog(@"headset input");
            break;
        }
            // device unavailable
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:{
            NSLog(@"pause play when headset output");
            [self.avPlayer pause];
            break;
        }
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark - 监听音频系统中断响应

- (void)otherAppAudioSessionCallBack:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger interuptType = [[interuptionDict valueForKey:AVAudioSessionSilenceSecondaryAudioHintTypeKey] integerValue];
    
    switch (interuptType) {
        case AVAudioSessionSilenceSecondaryAudioHintTypeBegin:{
            [self.avPlayer pause];
            NSLog(@"pause play when other app occupied session");
            break;
        }
        case AVAudioSessionSilenceSecondaryAudioHintTypeEnd:{
            NSLog(@"occupied session");
            break;
        }
        default:
            break;
    }
}

// phone call or alarm
- (void)systermAudioSessionCallBack:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger interuptType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    
    switch (interuptType) {
            // That interrupted the start, we should pause playback and collection
        case AVAudioSessionInterruptionTypeBegan:{
            [self.avPlayer pause];
            NSLog(@"pause play when phone call or alarm ");
            break;
        }
            // That interrupted the end, we can continue to play and capture
        case AVAudioSessionInterruptionTypeEnded:{
            break;
        }
        default:
            break;
    }
}


# pragma mark - ----------------蓝牙相关--------------------


#pragma -mark 蓝牙初始化界面
- (void)BluBluetoothView{
    //ScreenHeight  - kTabBarHeight - 16
    self.musciView = [[MuisicNoraml alloc]initWithFrame:CGRectMake(0, kScreenSize.height- kTabBarHeight - 80, kScreenSize.width, 100/2*SCREEN_WIDTH_Size + 20)];
    self.musciView.delegate = self;
    [self.view addSubview:self.musciView];
    
    UIButton *blueTBT = [UIButton buttonWithType:(UIButtonTypeCustom)];
    blueTBT.frame = CGRectMake(40,  self.musciView.top +10 , self.musciView.height - 20, self.musciView.height - 20);
    [blueTBT setBackgroundImage:[UIImage imageNamed:@"蓝牙未连接"] forState:(UIControlStateNormal)];
    __weak typeof(self) weakSelf = self;
    [[blueTBT rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [weakSelf showAlertWarmMessage:ModuleZW(@"请先连接设备")];
    }];
    [self.view addSubview:blueTBT];
    self.blueTBT = blueTBT;
    blueTBT.userInteractionEnabled = YES;
}

#pragma mark - 主动断开连接
-(void)cancelPeripheralConnection{
    //    NSLog(@"%@",self.peripheral);
    if (self.discoveredPeripheral) {//已经连接外设，则断开
        [self.centralMgr cancelPeripheralConnection:self.discoveredPeripheral];
    }else{//未连接，则停止搜索外设
        [self.centralMgr stopScan];
    }
    
}

/**
 *  蓝牙初始化 连接
 */
- (void)BluetoothConnection{
    self.centralMgr = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
}

#pragma mark -- CBCentralManagerDelegate
#pragma mark- 扫描设备，连接

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"name:%@",peripheral);
    /**
     当扫描到蓝牙数据为空时,停止扫描
     */
    if (!peripheral || !peripheral.name || ([peripheral.name isEqualToString:@""])) {
        return;
    }
    
    /**
     当扫描到服务UUID与设备UUID相等时,进行蓝牙与设备链接
     */
    if ((!self.discoveredPeripheral || (self.discoveredPeripheral.state == CBPeripheralStateDisconnected))&&([peripheral.name isEqualToString:kPERIPHERAL_NAME])) {
        self.discoveredPeripheral = [peripheral copy];
        //self.peripheral.delegate = self;
        NSLog(@"connect peripheral:  %@",peripheral);
        [self.centralMgr connectPeripheral:peripheral options:nil];
    }
    
}


#pragma mark - 连接成功,扫描services
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (!peripheral) {
        return;
    }
    [self.centralMgr stopScan];
    
    NSLog(@"peripheral did connect:  %@",peripheral);
    [self.discoveredPeripheral setDelegate:self];
    [self.discoveredPeripheral discoverServices:nil];
    //[self.peripheral discoverServices:@[KUUID_SERVICE]];
    
}

#pragma mark- 连接外设失败
- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>连接到名称（%@)的设备－失败:%@",[peripheral name],[error localizedDescription]);
}

#pragma mark- 外设断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"外设断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    
    //重连外设
    
    /**
     *  耳诊仪断开上设备
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:LeyaoBluetoothOFF object:nil userInfo:nil];
    //蓝牙链接失败
    self.isBleLink = NO;
    // [self.centralMgr connectPeripheral:peripheral options:nil];
    self.musciView.bluetoothBg.image = [UIImage imageNamed:@"关蓝牙"];
    [_blueTBT setBackgroundImage:[UIImage imageNamed:@"蓝牙未连接"] forState:(UIControlStateNormal)];
    _blueTBT.userInteractionEnabled = YES;
    
    
}

#pragma mark - 扫描service
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray *services = nil;
    
    if (peripheral != self.discoveredPeripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    services = [peripheral services];
    NSLog(@"%@",services);
    if (!services || ![services count]) {
        NSLog(@"No Services");
        return ;
    }
    
    for (CBService *service in services) {
        NSLog(@"该设备的service:%@",service);
        /*
         该设备的service:<CBService: 0x59851a0, isPrimary = YES, UUID = FFE0>
         
         */
        if ([[service.UUID UUIDString] isEqualToString:KUUID_SERVICE]) {
            [peripheral discoverCharacteristics:nil forService:service];
            return ;
        }
    }
    
}


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *c in service.characteristics)
    {
        NSLog(@"\n>>>\t特征UUID FOUND(in 服务UUID:%@): %@ (data:%@)",service.UUID.description,c.UUID,c.UUID.data);
       
        
        //假如你和硬件商量好了，某个UUID时写，某个读的，那就不用判断啦
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:kUUID_CHARACTER_RECEIVE]]) {
            self.writeCharacteristic = c;
            [_discoveredPeripheral setNotifyValue:YES forCharacteristic:self.writeCharacteristic];
            /**
             *  耳诊仪链接上设备
             */
            [[NSNotificationCenter defaultCenter] postNotificationName:LeyaoBluetoothON object:nil userInfo:nil];
            
            self.musciView.bluetoothBg.image = [UIImage imageNamed:@"开蓝牙"];
            [_blueTBT setBackgroundImage:[UIImage imageNamed:@"蓝牙已连接"] forState:(UIControlStateNormal)];
            _blueTBT.userInteractionEnabled = NO;
            //蓝牙链接成功
            self.isBleLink = YES;
        }
        
        
        if([c.UUID isEqual:[CBUUID UUIDWithString:kUUID_CHARACTER_CONFIG]]){
            self.writeCharacteristic = c;
            
        }
        
    }
}

#pragma mark - 读取数据

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"didUpdateValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    
    NSData *data = characteristic.value;
    NSLog(@"蓝牙返回值------>%@",data);
    
    NSLog(@"\nFindtheValueis (UUID:%@):%@ ",characteristic.UUID,characteristic.value);
    
    
}

#pragma mark - 蓝牙的状态
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"无法获取设备的蓝牙状态");
        }
            break;
        case CBCentralManagerStateResetting:
        {
            NSLog(@"蓝牙重置");
            
        }
            break;
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"该设备不支持蓝牙");
            
        }
            break;
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"未授权蓝牙权限");
        }
            break;
        case CBCentralManagerStatePoweredOff:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:LeyaoBluetoothOFF object:nil userInfo:nil];
            NSLog(@"蓝牙已关闭");
            [_blueTBT setBackgroundImage:[UIImage imageNamed:@"蓝牙未连接"] forState:(UIControlStateNormal)];
            _blueTBT.userInteractionEnabled = YES;
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已打开");
            [self.centralMgr scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:KUUID_SERVICE]]  options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
            
        }
            break;
            
        default:
        {
            NSLog(@"未知的蓝牙错误");
            [_blueTBT setBackgroundImage:[UIImage imageNamed:@"蓝牙未连接"] forState:(UIControlStateNormal)];
            _blueTBT.userInteractionEnabled = YES;
        }
            break;
    }
    //[self getConnectState];
    
}

//打印蓝牙返回的错误数据值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
    }
}

//向peripheral中写入数据后的回调函数
- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"didWriteValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    
    NSLog(@"write value success : %@", characteristic);
}

/**
 *  实现MuisicNoraml 代理方法
 */
/**
 *  增加  强度
 */

- (void)volumeWithIncreaseAndReduce:(NSString *)number{
    
    NSLog(@"%@",number);
    /**
     *  number 为增加的数值
     增大命令 0xFA 0xE3 OxXX  XX---> 增大数字 00~60
     */
    if(!_writeCharacteristic){
        NSLog(@"writeCharacteristic is nil!");
        return;
    }
    
    NSString *increaseStr = [NSString stringWithFormat:@"FAE3%@",number];
    NSData *value = [self stringToByte:increaseStr];
    NSLog(@"%@",value);
    [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}


/**
 *  减少 强度
 *
 */
- (void)volumeWithReduce:(NSString *)number{
    NSLog(@"%@",number);
    /**
     *  number 减少的数值
     减少命令 0xFA 0xE4 OxXX  XX---> 减少数字 00~60
     
     */
    if(!_writeCharacteristic){
        NSLog(@"writeCharacteristic is nil!");
        return;
    }
    
    NSString *reduceStr = [NSString stringWithFormat:@"FAE4%@",number];
    NSData *value = [self stringToByte:reduceStr];
    [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
}



/**
 *  开始 停止命令
 */


- (void)commandWithONandOFF:(NSInteger)command{
    NSLog(@"%ld",(long)command);
    switch (command) {
        case 0:
        {
            /**
             *  停止命令  0xFA 0xE2 Ox00
             */
            if(!_writeCharacteristic){
                NSLog(@"writeCharacteristic is nil!");
                return;
            }
            
            Byte byte[] = {0xFA,0xE2,0x00};
            printf("%s",byte);
            // NSData* value = [self stringToByte:string];
            NSData *value = [NSData dataWithBytes:byte length:3];
            NSLog(@"Witedata: %@",value);
            
            self.isleyaoOnOff = NO;
            [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
            break;
        case 1:{
            /**
             *  开始命令 0xFA 0xE1 Ox00
             */
            if(!_writeCharacteristic){
                
                NSLog(@"writeCharacteristic is nil!");
                return;
            }
            
            Byte byte[] = {0xFA,0xE1,0x00};
            printf("%s",byte);
            // NSData* value = [self stringToByte:string];
            NSData *value = [NSData dataWithBytes:byte length:3];
            NSLog(@"Witedata: %@",value);
            
            self.isleyaoOnOff = YES;
            [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
            
        }
        default:
            break;
    }
    
}

/**
 *  暂停 恢复 命令
 */
- (void)commandWithSuspendedAndRestore:(NSInteger)command{
    NSLog(@"%ld",(long)command);
    switch (command) {
        case 0:
        {
            /**
             *  暂停命令 0xFA 0xE5 Ox00
             */
            if(!_writeCharacteristic){
                NSLog(@"writeCharacteristic is nil!");
                return;
            }
            
            Byte byte[] = {0xFA,0xE5,0x00};
            printf("%s",byte);
            // NSData* value = [self stringToByte:string];
            NSData *value = [NSData dataWithBytes:byte length:3];
            NSLog(@"Witedata: %@",value);
            [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
            
        }
            break;
        case 1:{
            /**
             *  恢复命令 0xFA 0xE6 Ox00
             */
            if(!_writeCharacteristic){
                NSLog(@"writeCharacteristic is nil!");
                return;
            }
            
            Byte byte[] = {0xFA,0xE6,0x00};
            printf("%s",byte);
            // NSData* value = [self stringToByte:string];
            NSData *value = [NSData dataWithBytes:byte length:3];
            NSLog(@"Witedata: %@",value);
            
            
            [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
        default:
            break;
    }
    
}

/**
 *  设备给蓝牙传输数据 必须以十六进制数据传给蓝牙 蓝牙设备才会执行
 因为iOS 蓝牙库中方法 传输书记是以NSData形式 这个方法 字符串 ---> 十六进制数据 ---> NSData数据
 *
 *  @param string 传入字符串命令
 *
 *  @return 将字符串 ---> 十六进制数据 ---> NSData数据
 */

-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
