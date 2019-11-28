//
//  730BOGA730BHomeVC.m
//  和畅行
//
//  Created by 刘晓明 on 2019/11/18.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "OGA730BHomeVC.h"
#import "ArmchairHomeCell.h"
#import "SublayerView.h"
#import "OGA730BThemeVC.h"
#import "OGA730BDetailVC.h"
#import "OGBluetoothListView.h"
#import "OGA730BAcheTestVC.h"

#import "MeridianIdentifierViewController.h"
#import "TipSpeakController.h"

#import "ResultSpeakController.h"
#import "MeridianIdentifierViewController.h"


#import "NoteView.h"



@interface OGA730BHomeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,MBProgressHUDDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) UIView *recommendV;

@property (nonatomic, strong) UIButton *bluetoothBtn;

@property (nonatomic, weak) OGBluetoothListView *listView;

@property (nonatomic, strong)  OGASubscribe_730B *subscribe;

@property (nonatomic, strong) MBProgressHUD *progressHud;

@property (nonatomic, assign) BOOL isManual;

@property (nonatomic, assign) BOOL isHitSpeak;

@end

@implementation OGA730BHomeVC
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
    
    self.navTitleLabel.text = @"Massage";
    
    
    self.dataArr = [self loadHomeData];
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(Adapter(14),kNavBarHeight+Adapter(20),Adapter(107.5),Adapter(115));
    
    view.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    view.layer.cornerRadius = Adapter(8);
    [self.bgScrollView addSubview:view];
    
    [self createRecommendView];
    
    [self createBottomView];
    
    
    bluetoothBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bluetoothBtn.frame = CGRectMake(self.rightBtn.left-Adapter(42), Adapter(2)+kStatusBarHeight, Adapter(37), 40);
    [bluetoothBtn setImage:[UIImage imageNamed:@"按摩椅蓝牙_未"] forState:UIControlStateNormal];
    [bluetoothBtn setImage:[UIImage imageNamed:@"按摩椅蓝牙_已"] forState:UIControlStateSelected];
    bluetoothBtn.selected = NO;
    [bluetoothBtn addTarget:self action:@selector(bluetoothBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:bluetoothBtn];
    
    [self scanPeripheral];
    
    
    //UIApplicationWillEnterForegroundNotification UIApplicationWillResignActiveNotification
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    NSString *tuinaHint = [[NSUserDefaults standardUserDefaults] objectForKey:hintTuiNa];
//    if([GlobalCommon stringEqualNull:tuinaHint]){
//        __weak typeof(self) weakSelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [weakSelf addNoteView];
//        });
//
//    }
    
}

- (void)addNoteView
{
    NoteView *noteV = [NoteView noteViewInitUIWithContent:tuiNaNote withTypeStr:hintTuiNa];
    [[UIApplication sharedApplication].keyWindow addSubview:noteV];
}

# pragma mark - 应用进入前台,以及上拉出设置栏通知执行方法
- (void)DidBecomeActive
{
    NSLog(@"DidBecomeActive");
    BOOL isBlueToothPoweredOn = [[OGABluetoothManager_730B shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        bluetoothBtn.selected = NO;
        self.rightBtn.selected = NO;
        [UserShareOnce shareOnce].ogaConnected = NO;
    }else{
        [self scanPeripheral];
    }
}

- (void)didUpdateValueForChair:(OGARespond_730B *)respond {
    
    self.rightBtn.selected = [self chairPowerOnWithRespond:respond];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[OGABluetoothManager_730B shareInstance] removeSubscribe:self.subscribe];
    self.subscribe = nil;
    
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    if(!self.subscribe){
        __weak typeof(self) weakSelf = self;
        self.subscribe = [[OGASubscribe_730B alloc] init];
        [[OGABluetoothManager_730B shareInstance] addSubscribe:self.subscribe];
        
        [self.subscribe setRespondBlock:^(OGARespond_730B * _Nonnull respond) {
            [weakSelf didUpdateValueForChair:respond];
        }];
        
    }
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
    
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
            //11.22
            str = [GlobalCommon getStringWithLanguageSubjectSn:str];
            label.attributedText = [self attributedStringWithTitle:[NSString stringWithFormat:@"1、Your meridian type is %@\n2、You are recommended to apply %@ massage technique",str,str]];
            CGSize attSize = [label.attributedText boundingRectWithSize:CGSizeMake(label.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
            label.height = attSize.height;
            if (label.height +  Adapter(20)  > layerView.height ) {
                label.top = layerView.top-Adapter(10);
            }
            speakBtn.frame = CGRectMake(label.left, label.bottom, label.width, Adapter(20));
            [speakBtn setTitle:@"3、Tap to retest" forState:UIControlStateNormal];
        }
        self.isHitSpeak = NO;
    }
    
    
    if(![[OGABluetoothManager_730B shareInstance] isBlueToothPoweredOn]){
        [UserShareOnce shareOnce].ogaConnected = NO;
        bluetoothBtn.selected = NO;
    }else{
        bluetoothBtn.selected = [UserShareOnce shareOnce].ogaConnected;
    }
    
    
    
}

- (void)bluetoothBtnAction:(UIButton *)button
{
    
    BOOL isBlueToothPoweredOn = [[OGABluetoothManager_730B shareInstance] isBlueToothPoweredOn];
    if(!isBlueToothPoweredOn){
        [GlobalCommon showMessage2:@"Please turn on bluetooth" duration2:1.0];
        return ;
    }
    if(!bluetoothBtn.selected){
        [self manualScanPeripheral];
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
    
    self.recommendV = [[UIView alloc] initWithFrame:CGRectMake(0, Adapter(15), ScreenWidth, Adapter(148))];
    [self.bgScrollView addSubview:self.recommendV];
    
    UILabel *recommendLabel = [[UILabel alloc] init];
    recommendLabel.frame = CGRectMake(margin,Adapter(5),ScreenWidth-margin*2,Adapter(22.5));
    recommendLabel.text = @"Massage Prescription";
    recommendLabel.textAlignment = NSTextAlignmentLeft;
    recommendLabel.font = [UIFont fontWithName:@"PingFang SC" size:16*[UserShareOnce shareOnce].fontSize];
    [self.recommendV addSubview:recommendLabel];
    
    
    ArmChairModel *model = [self recommendModelWithStr];
    
    SublayerView *sublayerView = [[SublayerView alloc] initWithFrame:CGRectMake(recommendLabel.left, recommendLabel.bottom+Adapter(10), Adapter(108), Adapter(115))];
    sublayerView.tag = 2008;
    [sublayerView setImageAndTitleWithModel:model withName:@""];
    [sublayerView insertSublayerFromeView:self.recommendV];
    
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [sublayerView addGestureRecognizer:tapGesture];
    
    [self.recommendV addSubview:sublayerView];
    
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(sublayerView.right+Adapter(19),recommendLabel.bottom+Adapter(10),ScreenWidth-sublayerView.right-Adapter(35),Adapter(90));

    label1.numberOfLines = 0;
    label1.tag = 222;
    [self.recommendV addSubview:label1];
    
    NSString *recommandStr = @"";
    NSString *btnStr = @"";
    NSString *jlbsName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
    if([jlbsName isEqualToString:@""] || jlbsName==nil ){
        recommandStr = @"1、You have not done meridian test";
        btnStr = @"2、Tap to test";
    }else{

        jlbsName = [GlobalCommon getStringWithLanguageSubjectSn:jlbsName];
        recommandStr = [NSString stringWithFormat:@"1、Your meridian type is %@\n2、You are recommended to apply %@ massage technique",jlbsName,jlbsName];
        btnStr = @"3、Tap to retest";
    }
    
    label1.attributedText = [self attributedStringWithTitle:recommandStr];
    CGSize attSize = [label1.attributedText boundingRectWithSize:CGSizeMake(label1.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    label1.height = attSize.height;
    if (label1.height +  Adapter(20)  > sublayerView.height ) {
         label1.top = sublayerView.top-Adapter(10);
    }
    label1.textAlignment = NSTextAlignmentLeft;
    label1.alpha = 1.0;
    
    UIButton *speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    speakBtn.frame = CGRectMake(label1.left, label1.bottom, label1.width, Adapter(20));
    [speakBtn setTitle:btnStr forState:UIControlStateNormal];
    [speakBtn setTitleColor:[UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0] forState:UIControlStateNormal];
    speakBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (ISPaid) {
         speakBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].fontSize> 30 ? 30 : 14*[UserShareOnce shareOnce].fontSize];
    }else{
         speakBtn.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].fontSize > 15.0 ? 15.0 : 14];
    }
    [speakBtn addTarget:self action:@selector(speakBtnAction) forControlEvents:UIControlEventTouchUpInside];
    speakBtn.tag = 111;
    [self.recommendV addSubview:speakBtn];
    
    
}

- (NSMutableAttributedString *)attributedStringWithTitle:(NSString *)recommandStr
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 2;
    
    if (ISPaid) {
          NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:recommandStr attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].fontSize> 30 ? 30 : 14*[UserShareOnce shareOnce].fontSize],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle.copy}];
        return string;
    }else{
          NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:recommandStr attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].fontSize > 15.0 ? 15.0 : 14],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0],NSParagraphStyleAttributeName:paragraphStyle.copy}];
        return string;
    }
   
    
    
}

- (void)createBottomView
{
    
    
    //  CGFloat margin = ((ScreenWidth-107*3)/4.0);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(margin,self.recommendV.bottom+Adapter(15),ScreenWidth-margin*2,Adapter(23));
    //label.frame = CGRectMake(margin,kNavBarHeight+15,120,20);
    label.font = [UIFont fontWithName:@"PingFang SC" size:16*[UserShareOnce shareOnce].fontSize];
    label.text = @"Massage Technique";
    label.textAlignment = NSTextAlignmentLeft;
    label.alpha = 1.0;
    [self.bgScrollView addSubview:label];
    //[self.view addSubview:label];
    CGFloat cellWithW;
    if (ISPaid) {
        cellWithW = (ScreenWidth - Adapter(50))/4;
    }else{
        cellWithW = (ScreenWidth - Adapter(40))/3;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellWithW , cellWithW);
    layout.sectionInset = UIEdgeInsetsMake(Adapter(10), Adapter(10), Adapter(10), Adapter(10));
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(0,label.bottom + Adapter(10), ScreenWidth, cellWithW*3+Adapter(50)) collectionViewLayout:layout];
    if (ISPaid) {
        self.collectionV.height = cellWithW*2+Adapter(30);
    }
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.backgroundColor = [UIColor clearColor];
    self.collectionV.scrollEnabled = NO;
    
    [self.collectionV registerClass:[ArmchairHomeCell class] forCellWithReuseIdentifier:@"cellId"];
    
    
    [self.bgScrollView addSubview:self.collectionV];
    
    self.bgScrollView.contentSize = CGSizeMake(1, self.collectionV.bottom+Adapter(10));
}

# pragma mark - 推荐按摩点击事件
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    SublayerView *layerView = (SublayerView *)[gesture view];
    ArmChairModel *model = layerView.model;
    
    
    NSString *statusStr = [self resultStringWithStatus];
    if(![statusStr isEqualToString:@""]){
        [GlobalCommon showMessage2:statusStr duration2:1.0];
        return;
    }else{
        self.armchairModel = model;
        
        if([self chairIsPowerOn] == NO){
            
            [self showProgressHUD:startDevice];
    
            [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_PowerOn success:^(BOOL success) {
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
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
     return Adapter(10);
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ArmchairHomeCell *cell = (ArmchairHomeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    ArmChairModel *model = [self.dataArr objectAtIndex:indexPath.row];
    cell.imageV.image = [UIImage imageNamed:model.name];
    cell.titleLabel.text = model.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    ArmChairModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    if([model.name isEqualToString:@"More"]){
        OGA730BThemeVC *vc = [[OGA730BThemeVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
       // [self nextVCWithModel:model];
        
        NSString *statusStr = [self resultStringWithStatus];
        if(![statusStr isEqualToString:@""]){
            [GlobalCommon showMessage2:statusStr duration2:1.0];
            return;
        }else{
            self.armchairModel = model;
            if([self chairIsPowerOn] == NO){

                [self showProgressHUD:startDevice];

                [[OGABluetoothManager_730B shareInstance] sendShortCommand:k730Command_PowerOn success:^(BOOL success) {
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
    if([model.name isEqualToString:@"推荐"]){
        //点击推荐的按摩,不让有收藏按钮
        NSString *jlbsName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
        NSString *nameStr = [GlobalCommon getStringWithLanguageSubjectSn:jlbsName];
        nameStr = [nameStr stringByAppendingString:@" Prescription"];
        OGA730BDetailVC *vc = [[OGA730BDetailVC alloc] initWithRecommend:YES withTitleStr:nameStr];
        vc.armchairModel = model;
        [vc commandActionWithModel:model];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([model.name isEqualToString:@"Custom"]){
        OGA730BDetailVC *vc = [[OGA730BDetailVC alloc] initWithType:YES withTitleStr:model.name];
        vc.armchairModel = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([model.name isEqualToString:@"Chair Doctor"]){
        OGA730BAcheTestVC *vc = [[OGA730BAcheTestVC alloc] init];
        vc.armchairModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        OGA730BDetailVC *vc = [[OGA730BDetailVC alloc] initWithType:NO withTitleStr:model.name];
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
            
            [[OGABluetoothManager_730B shareInstance] stopSacnPeripheral:nil];
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
    
    [[OGABluetoothManager_730B shareInstance] scanPeripheral:^(NSMutableArray * _Nonnull array) {
        
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
    if([[OGABluetoothManager_730B shareInstance] isBlueToothPoweredOff]){
        [GlobalCommon showMessage2:@"Please turn on bluetooth" duration2:1.0];
        return;
    }
    
    [self showProgressHUD:scanDevice];
    
    [[OGABluetoothManager_730B shareInstance] scanPeripheral:^(NSMutableArray * _Nonnull array)
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
        if([self chairIsPowerOn] == YES){
            [self nextVCWithModel:self.armchairModel];
        }
        return;
    }
    
    NSString *uuidStr = [[NSUserDefaults standardUserDefaults] objectForKey:OGADeviceUUID];
    if(!uuidStr || (isManual && !self.bluetoothBtn.selected)){
        [GlobalCommon showMessage2:failDevice duration2:1.0];
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
            [self.progressHud hideAnimated:YES afterDelay:4.0];
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
    
    [[OGABluetoothManager_730B shareInstance] stopSacnPeripheral:^{
        
    }];
    
    [[OGABluetoothManager_730B shareInstance] connectPeripheral:peripheral connect:^{
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
    } timeoutConnect:^{
        
    }];

}


# pragma mark - 根据一说结果获取推荐的按摩手法
- (ArmChairModel *)recommendModelWithStr
{
    NSString *jlbsName = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
    if([jlbsName isEqualToString:@""] || jlbsName==nil){
        ArmChairModel *model = [[ArmChairModel alloc] init];
        model.name = @"大师精选";
       // model.command = k530Command_MassageMaster;
        return model;
    }else{
        NSDictionary *dic = @{
                              @"JLBS-G4":@{@"name":@"JLBS-G4",@"command":k730Command_Relax},
                              @"JLBS-G5":@{@"name":@"JLBS-G5",@"command":k730Command_Relax},
                              @"JLBS-G3":@{@"name":@"JLBS-G3",@"command":k730Command_Balinese},
                              @"JLBS-G2":@{@"name":@"JLBS-G2",@"command":k730Command_Balinese},
                              @"JLBS-G1":@{@"name":@"JLBS-G1",@"command":k730Command_Balinese},
                              @"JLBS-S2":@{@"name":@"JLBS-S2",@"command":k730Command_Gentle},
                              @"JLBS-S5":@{@"name":@"JLBS-S5",@"command":k730Command_Gentle},
                              @"JLBS-S1":@{@"name":@"JLBS-S1",@"command":k730Command_UpperBack},
                              @"JLBS-S4":@{@"name":@"JLBS-S4",@"command":k730Command_UpperBack},
                              @"JLBS-S3":@{@"name":@"JLBS-S3",@"command":k730Command_UpperBack},
                              @"JLBS-Z3":@{@"name":@"JLBS-Z3",@"command":k730Command_NeckShoulder},
                              @"JLBS-Z1":@{@"name":@"JLBS-Z1",@"command":k730Command_NeckShoulder},
                              @"JLBS-Z2":@{@"name":@"JLBS-Z2",@"command":k730Command_Altheltic},
                              @"JLBS-Z4":@{@"name":@"JLBS-Z4",@"command":k730Command_Altheltic},
                              @"JLBS-Z5":@{@"name":@"JLBS-Z5",@"command":k730Command_Altheltic},
                              @"JLBS-Y3":@{@"name":@"JLBS-Y3",@"command":k730Command_FeetCalves},
                              @"JLBS-Y4":@{@"name":@"JLBS-Y4",@"command":k730Command_FeetCalves},
                              @"JLBS-Y2":@{@"name":@"JLBS-Y2",@"command":k730Command_Japanese},
                              @"JLBS-Y5":@{@"name":@"JLBS-Y5",@"command":k730Command_Japanese},
                              @"JLBS-Y1":@{@"name":@"JLBS-Y1",@"command":k730Command_LowerBack},
                              @"JLBS-J4":@{@"name":@"JLBS-J4",@"command":k730Command_Stretch},
                              @"JLBS-J2":@{@"name":@"JLBS-J2",@"command":k730Command_Thai},
                              @"JLBS-J3":@{@"name":@"JLBS-J3",@"command":k730Command_Stretch},
                              @"JLBS-J5":@{@"name":@"JLBS-J5",@"command":k730Command_Stretch},
                              @"JLBS-J1":@{@"name":@"JLBS-J1",@"command":k730Command_Chinese},
                              };
        NSDictionary *dic1 = [dic objectForKey:jlbsName];
        ArmChairModel *model = [ArmChairModel mj_objectWithKeyValues:dic1];
        model.name = @"推荐";
        
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

@end
