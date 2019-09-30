//
//  ArmchairHomeVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/2.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairHomeVC.h"
#import "ArmchairHomeCell.h"
#import "SublayerView.h"
#import "ArmchairThemeVC.h"
#import "ArmchairDetailVC.h"
#import "OGBluetoothListView.h"
#import "ArmchairAcheTestVC.h"

#import "MeridianIdentifierViewController.h"
#import "TipSpeakController.h"

#import "ResultSpeakController.h"
#import "MeridianIdentifierViewController.h"

#import "ArmchairTestResultVC.h"

#define margin ((ScreenWidth-107*3)/4.0)

#define startDevice @"启动设备"
#define connectDevice @"连接设备"
#define scanDevice @"搜索中"
#define noneDevice @"未发现可连接的蓝牙设备"

@interface ArmchairHomeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UIView *recommendV;

@property (nonatomic, strong) UIButton *bluetoothBtn;

@property (nonatomic, weak) OGBluetoothListView *listView;

@property (nonatomic, strong) OGA530Subscribe *subscribe;

@property (nonatomic, strong) MBProgressHUD *progressHud;

@property (nonatomic, assign) BOOL isManual;

@property (nonatomic, assign) BOOL isHitSpeak;

@end

@implementation ArmchairHomeVC
@synthesize bluetoothBtn,isManual;

- (void)dealloc
{
    self.recommendV = nil;
    self.dataArr = nil;
    self.bgScrollView = nil;
    self.collectionV = nil;
    self.progressHud = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.navTitleLabel.text = @"一推";
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    

    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(14,kNavBarHeight+20,107.5,115);
    
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = 8;
    [self.bgScrollView addSubview:view];
    
    [self createRecommendView];
    
    [self createBottomView];
 
    
    bluetoothBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bluetoothBtn.frame = CGRectMake(self.rightBtn.left-42, 2+kStatusBarHeight, 37, 40);
    [bluetoothBtn setImage:[UIImage imageNamed:@"按摩椅蓝牙_未"] forState:UIControlStateNormal];
    [bluetoothBtn setImage:[UIImage imageNamed:@"按摩椅蓝牙_已"] forState:UIControlStateSelected];
    bluetoothBtn.selected = NO;
    [bluetoothBtn addTarget:self action:@selector(bluetoothBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:bluetoothBtn];
    
    [self scanPeripheral];
    
    __weak typeof(self) weakSelf = self;
    self.subscribe = [[OGA530Subscribe alloc] init];
    [[OGA530BluetoothManager shareInstance] addSubscribe:self.subscribe];
    [self.subscribe setRespondBlock:^(OGA530Respond * _Nonnull respond) {
        
        [weakSelf didUpdateValueForChair:respond];
    }];
    
    //UIApplicationWillEnterForegroundNotification UIApplicationWillResignActiveNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

# pragma mark - 应用进入前台,以及上拉出设置栏通知执行方法
- (void)DidBecomeActive
{
    NSLog(@"DidBecomeActive");
    BOOL isBlueToothPoweredOn = [[OGA530BluetoothManager shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        bluetoothBtn.selected = NO;
        self.rightBtn.selected = NO;
        [UserShareOnce shareOnce].ogaConnected = NO;
    }else{
        [self scanPeripheral];
    }
}

- (void)didUpdateValueForChair:(OGA530Respond *)respond {
    
    self.rightBtn.selected = respond.powerOn;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    [self.dataArr removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.isHitSpeak){
        NSString *jlbsName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
        if(![jlbsName isEqualToString:@""] && jlbsName!=nil){
            UIButton *speakBtn = (UIButton *)[self.recommendV viewWithTag:111];
            UILabel *label = (UILabel *)[self.recommendV viewWithTag:222];
            SublayerView *layerView = (SublayerView *)[self.recommendV viewWithTag:2008];
            ArmChairModel *model = [self recommendModelWithStr];
            [layerView setImageAndTitleWithModel:model withName:@""];
            label.top = layerView.top;
            label.height = 75;
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
            label.attributedText = [self attributedStringWithTitle:[NSString stringWithFormat:@"1、您的经络检测类型为%@\n2、建议您选用%@推拿手法",str,str]];
            speakBtn.frame = CGRectMake(label.left, label.bottom+10, label.width, 20);
            [speakBtn setTitle:@"3、点我再次检测" forState:UIControlStateNormal];
        }
        
    }
    
    
    if(![[OGA530BluetoothManager shareInstance] isBlueToothPoweredOn]){
        [UserShareOnce shareOnce].ogaConnected = NO;
        bluetoothBtn.selected = NO;
    }else{
        bluetoothBtn.selected = [UserShareOnce shareOnce].ogaConnected;
    }
    
    if(self.dataArr.count==0){
        NSArray *arr = [[CacheManager sharedCacheManager] getArmchairModel];
        
        if(arr.count>0){
            [self.dataArr addObjectsFromArray:arr];
        }
        
        [self addLocalTack];
    }
    
    if(self.dataArr.count>12){
        int count = (int)ceil(self.dataArr.count/3.0);
        self.collectionV.height = 125*count+50+20;
    }else{
        self.collectionV.height = 125*4+50;
    }
    self.bgScrollView.contentSize = CGSizeMake(1, self.collectionV.bottom+10);
    [self.collectionV reloadData];

}

- (void)bluetoothBtnAction:(UIButton *)button
{
    
    BOOL isBlueToothPoweredOn = [[OGA530BluetoothManager shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        [GlobalCommon showMessage2:@"请先打开蓝牙" duration2:1.0];
        return ;
    }
    if(!bluetoothBtn.selected){
        [self manualScanPeripheral];
    }
}

- (void)addLocalTack
{
    NSArray *arr = [self loadHomeData];
    [self.dataArr addObjectsFromArray:arr];
    NSArray *commandArr = @[k530Command_MassageIntellect,@"",@""];
    NSArray *nameArr = @[@"酸疼检测",@"高级按摩",@"更多按摩"];
    for(NSInteger i =0;i<nameArr.count;i++){
        ArmChairModel *model = [[ArmChairModel alloc] init];
        model.name = [nameArr objectAtIndex:i];
        model.command = [commandArr objectAtIndex:i];
        [self.dataArr addObject:model];
    }
}



- (void)initUI
{
    
    if (!self.bgScrollView){
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight)];
        self.bgScrollView.showsVerticalScrollIndicator = NO;
        
        self.bgScrollView.backgroundColor = [UIColor whiteColor];
        self.bgScrollView.bounces = YES;
        self.bgScrollView.contentSize = CGSizeMake(1, ScreenHeight-kNavBarHeight);
        [self.view addSubview:self.bgScrollView];
    }
}

- (void)createRecommendView
{
    
    self.recommendV = [[UIView alloc] initWithFrame:CGRectMake(0, 15, ScreenWidth, 148)];
    [self.bgScrollView addSubview:self.recommendV];
    
    UILabel *recommendLabel = [[UILabel alloc] init];
    recommendLabel.frame = CGRectMake(margin,0,240,22.5);
    recommendLabel.text = @"推拿处方";
    recommendLabel.textAlignment = NSTextAlignmentLeft;
    recommendLabel.font = [UIFont fontWithName:@"PingFang SC" size:16*[UserShareOnce shareOnce].fontSize];
    [self.recommendV addSubview:recommendLabel];
    
    
    ArmChairModel *model = [self recommendModelWithStr];
    
    SublayerView *sublayerView = [[SublayerView alloc] initWithFrame:CGRectMake(recommendLabel.left, recommendLabel.bottom+10, 108, 115)];
    sublayerView.tag = 2008;
    [sublayerView setImageAndTitleWithModel:model withName:@""];
    [sublayerView insertSublayerFromeView:self.recommendV];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [sublayerView addGestureRecognizer:tapGesture];
    
    [self.recommendV addSubview:sublayerView];
    
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(sublayerView.right+19,sublayerView.top+20,240.5+15,75);
    label1.numberOfLines = 0;
    label1.tag = 222;
    [self.recommendV addSubview:label1];
    
    NSString *recommandStr = @"";
    NSString *btnStr = @"";
    NSString *jlbsName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
    if([jlbsName isEqualToString:@""] || jlbsName==nil ){
        recommandStr = @"1、您尚未进行经络检测";
        label1.height = 30;
        btnStr = @"2、点我立即检测";
    }else{
        label1.top = sublayerView.top;
        recommandStr = [NSString stringWithFormat:@"1、您的经络检测类型为%@\n2、建议您选用%@推拿手法",[[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"],[[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"]];
        btnStr = @"3、点我再次检测";
    }
    
    
    label1.attributedText = [self attributedStringWithTitle:recommandStr];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.alpha = 1.0;
    
    UIButton *speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    speakBtn.frame = CGRectMake(label1.left, label1.bottom+10, label1.width, 20);
    [speakBtn setTitle:btnStr forState:UIControlStateNormal];
    [speakBtn setTitleColor:[UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0] forState:UIControlStateNormal];
    speakBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    speakBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:13*[UserShareOnce shareOnce].fontSize];
    [speakBtn addTarget:self action:@selector(speakBtnAction) forControlEvents:UIControlEventTouchUpInside];
    speakBtn.tag = 111;
    [self.recommendV addSubview:speakBtn];
    
   
}

- (NSMutableAttributedString *)attributedStringWithTitle:(NSString *)recommandStr
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 15;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:recommandStr attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size:13*[UserShareOnce shareOnce].fontSize],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    return string;
}

- (void)createBottomView
{
    

  //  CGFloat margin = ((ScreenWidth-107*3)/4.0);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(margin,self.recommendV.bottom+15,120,20);
    //label.frame = CGRectMake(margin,kNavBarHeight+15,120,20);
    label.font = [UIFont fontWithName:@"PingFang SC" size:16*[UserShareOnce shareOnce].fontSize];
    label.text = @"按摩手法";
    label.textAlignment = NSTextAlignmentLeft;
    label.alpha = 1.0;
    [self.bgScrollView addSubview:label];
    //[self.view addSubview:label];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(107+margin, 111+margin);
    //layout.itemSize = CGSizeMake(130, 106);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(margin/2.0,label.bottom, ScreenWidth-margin, 125*4+50) collectionViewLayout:layout];
     //self.collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(margin/2.0,label.bottom+8, ScreenWidth-margin, ScreenHeight-label.bottom-8) collectionViewLayout:layout];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.backgroundColor = [UIColor clearColor];
    self.collectionV.scrollEnabled = NO;
    
    [self.collectionV registerClass:[ArmchairHomeCell class] forCellWithReuseIdentifier:@"cellId"];
    
    //[self.view addSubview:self.collectionV];
    
    [self.bgScrollView addSubview:self.collectionV];

    self.bgScrollView.contentSize = CGSizeMake(1, self.collectionV.bottom+10);
}

# pragma mark - 推荐按摩点击事件
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    SublayerView *layerView = (SublayerView *)[gesture view];
    ArmChairModel *model = layerView.model;
    model.name = [model.name stringByAppendingString:@"推拿手法"];
    NSString *statusStr = [self resultStringWithStatus];
    if(![statusStr isEqualToString:@""]){
        [GlobalCommon showMessage2:statusStr duration2:1.0];
        return;
    }else{
        self.armchairModel = model;
        if([model.name isEqualToString:@"大师精选"]){
            return;
        }
        if([OGA530BluetoothManager shareInstance].respondModel.powerOn == NO){
            
            [self showProgressHUD:startDevice];
            
            [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_PowerOn success:^(BOOL success) {
                NSLog(@"启动设备成功啦");
            }];
        }else{
            NSLog(@"开机了开机了");
            [self nextVCWithModel:model];
        }
    }
    

    
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArmchairHomeCell *cell = (ArmchairHomeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    ArmChairModel *model = [self.dataArr objectAtIndex:indexPath.row];
    cell.imageV.image = [UIImage imageNamed:model.name];
    if([model.name isEqualToString:@"肩颈4D"]){
        cell.imageV.image = [UIImage imageNamed:@"肩颈"];
    }
    cell.titleLabel.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ArmChairModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
//    [self nextVCWithModel:model];
//    return;
    
    
    if([model.name isEqualToString:@"更多按摩"]){
        ArmchairThemeVC *vc = [[ArmchairThemeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSString *statusStr = [self resultStringWithStatus];
        if(![statusStr isEqualToString:@""]){
            [GlobalCommon showMessage2:statusStr duration2:1.0];
            return;
        }else{
            self.armchairModel = model;
            if([OGA530BluetoothManager shareInstance].respondModel.powerOn == NO){
                
                [self showProgressHUD:startDevice];
                
                [[OGA530BluetoothManager shareInstance] sendCommand:k530Command_PowerOn success:^(BOOL success) {
                    NSLog(@"启动设备成功啦");
                }];
            }else{
                NSLog(@"开机了开机了");
                [self nextVCWithModel:model];
            }
        }
        
        
    }
}

- (void)nextVCWithModel:(ArmChairModel *)model
{
    if ([model.name isEqualToString:@"高级按摩"] || [model.name isEqualToString:@"肩颈4D"]){
        ArmchairDetailVC *vc = [[ArmchairDetailVC alloc] initWithType:YES withTitleStr:model.name];
        vc.armchairModel = model;
        if([model.name isEqualToString:@"肩颈4D"]){
            [vc commandActionWithModel:model];
        }
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([model.name isEqualToString:@"酸疼检测"]){
        ArmchairAcheTestVC *vc = [[ArmchairAcheTestVC alloc] init];
        vc.armchairModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        ArmchairDetailVC *vc = [[ArmchairDetailVC alloc] initWithType:NO withTitleStr:model.name];
        vc.armchairModel = model;
        [vc commandActionWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


# pragma mark - 按摩椅连接相关

- (OGBluetoothListView *)listView {
    if (!_listView) {
        
        OGBluetoothListView *bluetoothListView = [[OGBluetoothListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:bluetoothListView];
        
        __weak typeof(self) weakself = self;
        [bluetoothListView setSelectedPeripheral:^(CBPeripheral *peripheral) {
            
            [weakself connect:peripheral];
        }];
        [bluetoothListView setScanPeripheralCancel:^{
            
            [[OGA530BluetoothManager shareInstance] stopSacnPeripheral:nil];
        }];
        _listView = bluetoothListView;
    }
    return _listView;
}

# pragma mark - 搜索设备
- (void)scanPeripheral
{
    __weak typeof(self) weakSelf = self;
    if([UserShareOnce shareOnce].ogaConnected){
        return;
    }
    
    [[OGA530BluetoothManager shareInstance] scanPeripheral:^(NSMutableArray * _Nonnull array) {
        
        if(weakSelf.bluetoothBtn.selected){
            return;
        }
       // BOOL isHave = NO;
        
        //下次进来自动连接
        if(array.count>0){
            NSString *uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:OGADeviceUUID];
            if(uuidStr){
                for(CBPeripheral *peripheral in array){
                    NSString *identifier = [NSString stringWithFormat:@"%@",peripheral.identifier];
                    if([identifier isEqualToString:uuidStr]){
                        [weakSelf connect:peripheral];
                        return ;
                    }
                }
                [weakSelf showProgressHUD:connectDevice];
            }else{
                weakSelf.listView.array = array;
            }
            
        }else{
            if(!weakSelf.progressHud){
                [GlobalCommon showMessage2:noneDevice duration2:1.0];
            }
        }
    } timeoutSacn:nil];
}

# pragma mark - 手动搜索设备
- (void)manualScanPeripheral
{
    __weak typeof(self) weakSelf = self;
    isManual = YES;
    if(self.progressHud){
        self.progressHud = nil;
    }
    if([[OGA530BluetoothManager shareInstance] isBlueToothPoweredOff]){
        [GlobalCommon showMessage2:@"请先打开蓝牙" duration2:1.0];
        return;
    }
    
    [self showProgressHUD:scanDevice];
    
    [[OGA530BluetoothManager shareInstance] scanPeripheral:^(NSMutableArray * _Nonnull array)
     {
        [weakSelf.progressHud removeFromSuperview];
        weakSelf.progressHud = nil;
        weakSelf.listView.array = array;
    
     } timeoutSacn:^{
         if(weakSelf.progressHud){
             [weakSelf.progressHud removeFromSuperview];
             weakSelf.progressHud = nil;
             [GlobalCommon showMessage2:noneDevice duration2:1.0];
         }
         
     }];
}

# pragma mark - 提示框自动消失方法,进入到这个方法代表设备连接失败
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    //self.progressHud = nil;
    
    if([hud.label.text isEqualToString:scanDevice]){
        if(self.progressHud == nil){
            return;
        }else{
            [GlobalCommon showMessage2:noneDevice duration2:1.0];
            return;
        }
    }
    
    if([hud.label.text isEqualToString:startDevice]){
        self.progressHud = nil;
        if([OGA530BluetoothManager shareInstance].respondModel.powerOn == YES){
            [self nextVCWithModel:self.armchairModel];
        }
        return;
    }
    
    NSString *uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:OGADeviceUUID];
    if(!uuidStr || (isManual && !self.bluetoothBtn.selected)){
        [GlobalCommon showMessage2:@"设备连接失败" duration2:1.0];
        return;
    }
    if(!self.bluetoothBtn.selected){
        [GlobalCommon showMessage2:noneDevice duration2:1.0];
    }
}

- (void)showProgressHUD:(NSString *)titleStr
{
    if(!self.progressHud){
        self.progressHud = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
        
        self.progressHud.label.text = titleStr;
        self.progressHud.tag = 102;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self.progressHud];
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self.progressHud];
        [self.progressHud showAnimated:YES];
        
        self.progressHud.delegate = self;
        
        if([titleStr isEqualToString:startDevice]){
            [self.progressHud hideAnimated:YES afterDelay:6.0];
        }else{
            [self.progressHud hideAnimated:YES afterDelay:4.0];
        }
        
    }
}

# pragma mark - 连接设备
- (void)connect:(CBPeripheral *)peripheral {
    

    __weak typeof(self) weakself = self;
    
    [self showProgressHUD:connectDevice];
    
//    MBProgressHUD *progress = [[MBProgressHUD alloc] initWithView:[[UIApplication sharedApplication] keyWindow]];
//
//    progress.label.text = @"连接设备";
//    progress.tag = 102;
//    [[[UIApplication sharedApplication] keyWindow] addSubview:progress];
//    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:progress];
//    [progress showAnimated:YES];
//
//    progress.delegate = self;
//
//    [progress hideAnimated:YES afterDelay:3.0];
    
    [[OGA530BluetoothManager shareInstance] stopSacnPeripheral:^{
        
    }];
    
    [[OGA530BluetoothManager shareInstance] connectPeripheral:peripheral connect:^{
        
        NSLog(@"uuid:%@",peripheral.identifier);
        
        NSString *uuidStr = [NSString stringWithFormat:@"%@",peripheral.identifier];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:uuidStr forKey:OGADeviceUUID];
        [userDefaults synchronize];
       
        NSLog(@"连接成功");
        dispatch_async(dispatch_get_main_queue(), ^{
           
            //[progress removeFromSuperview];
            
            [weakself.progressHud removeFromSuperview];
            weakself.progressHud = nil;
            
            [weakself.listView removeFromSuperview];
            weakself.listView = nil;
            weakself.bluetoothBtn.selected = YES;
            
            [UserShareOnce shareOnce].ogaConnected = YES;
        });
        
    }];
}


# pragma mark - 根据一说结果获取推荐的按摩手法
- (ArmChairModel *)recommendModelWithStr
{
    NSString *jlbsName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
    if([jlbsName isEqualToString:@""] || jlbsName==nil){
        ArmChairModel *model = [[ArmChairModel alloc] init];
        model.name = @"大师精选";
        model.command = k530Command_MassageMaster;
        return model;
    }else{
       // jlbsName = [jlbsName substringFromIndex:[jlbsName length]-1];
//        NSDictionary *dic = @{
//                @"徵":@{@"name":@"肩颈4D",@"command":k530Command_NeckShoulder4D},
//                @"羽":@{@"name":@"活血循环",@"command":k530Command_MassageBloodCirculation},
//                @"宫":@{@"name":@"美臀塑型",@"command":k530Command_MassageHipsShapping},
//                @"角":@{@"name":@"运动派",@"command":k530Command_Athlete},
//                @"商":@{@"name":@"低头族",@"command":k530Command_TextNeck}
//                };
        NSDictionary *dic = @{
                              @"少宫":@{@"name":@"少宫",@"command":k530Command_MassageEnergyRecovery},
                              @"左角宫":@{@"name":@"左角宫",@"command":k530Command_MassageEnergyRecovery},
                              @"上宫":@{@"name":@"上宫",@"command":k530Command_MassageHipsShapping},
                              @"加宫":@{@"name":@"加宫",@"command":k530Command_Sedentary},
                              @"大宫":@{@"name":@"大宫",@"command":k530Command_CosyComfort},
                              @"少商":@{@"name":@"少商",@"command":k530Command_Balinese},
                              @"左商":@{@"name":@"左商",@"command":k530Command_MassageBalanceMind},
                              @"上商":@{@"name":@"上商",@"command":k530Command_NeckShoulder4D},
                              @"右商":@{@"name":@"右商",@"command":k530Command_MassageRelease},
                              @"钛商":@{@"name":@"钛商",@"command":k530Command_MassageMaster},
                              @"少徵":@{@"name":@"少徵",@"command":k530Command_MassageMiddayRest},
                              @"判徵":@{@"name":@"判徵",@"command":k530Command_MassageDeepTissue},
                              @"上徵":@{@"name":@"上徵",@"command":k530Command_MassageSweetDreams},
                              @"右徵":@{@"name":@"右徵",@"command":k530Command_TextNeck},
                              @"质徵":@{@"name":@"质徵",@"command":k530Command_TextNeck},
                              @"少羽":@{@"name":@"少羽",@"command":k530Command_Shopping},
                              @"桎羽":@{@"name":@"桎羽",@"command":k530Command_Shopping},
                              @"上羽":@{@"name":@"上羽",@"command":k530Command_Athlete},
                              @"众羽":@{@"name":@"众羽",@"command":k530Command_Traceller},
                              @"大羽":@{@"name":@"大羽",@"command":k530Command_SpinalReleasePressure},
                              @"少角":@{@"name":@"少角",@"command":k530Command_MassageAMRoutine},
                              @"判角":@{@"name":@"判角",@"command":k530Command_MassageThai},
                              @"上角":@{@"name":@"上角",@"command":k530Command_MassageBloodCirculation},
                              @"钛角":@{@"name":@"钛角",@"command":k530Command_KneeCare},
                              @"大角":@{@"name":@"大角",@"command":k530Command_MassageChinese},
                              };
        NSDictionary *dic1 = [dic objectForKey:jlbsName];
        ArmChairModel *model = [ArmChairModel mj_objectWithKeyValues:dic1];
        
        return model;
    }
   
}

# pragma mark - 进入一说 经络检测
- (void)speakBtnAction
{
    SayAndWriteController *vc = nil;
    
    if(![UserShareOnce shareOnce].languageType&&![[UserShareOnce shareOnce].bindCard isEqualToString:@"1"]){
        [self showAlertWarmMessage:@"您还不是会员"];
        return;
    }
    self.isHitSpeak = YES;
    if([self isFirestClickThePageWithString:@"speak"]){
        vc = [[MeridianIdentifierViewController alloc] init];
        vc.haveAnmo = YES;
    }else{
        vc = [[TipSpeakController alloc] init];
        vc.haveAnmo = YES;
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)isFirestClickThePageWithString:(NSString *)string
{
    NSString *userName = [UserShareOnce shareOnce].username;
    NSString *writeKey = [NSString stringWithFormat:@"%@_%@",userName,string];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([[userDefaults objectForKey:writeKey] isEqualToString:@"1"]){
        return YES;
    }else{
        [userDefaults setObject:@"1" forKey:writeKey];
        [userDefaults synchronize];
        return NO;
    }
    return NO;
}

- (void)goBack:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//# pragma mark - 解决侧滑返回指定控制器
- (void)didMoveToParentViewController:(UIViewController*)parent
{
    
    NSMutableArray *tempArr = self.navigationController.viewControllers.mutableCopy;
    for(UIViewController *vc in self.navigationController.viewControllers){
        if(!self.isHitSpeak){
            if([vc isKindOfClass:[ResultSpeakController class]] || [vc isKindOfClass:[MeridianIdentifierViewController class]]){
                [tempArr removeObject:vc];
            }
        }
    }
    self.navigationController.viewControllers = tempArr;
    
    
}


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (void)messageBtnAction:(UIButton *)btn
{
    ArmchairAcheTestVC *vc = [[ArmchairAcheTestVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
