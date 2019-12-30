//
//  IJoouMainVC.m
//  HarmonyYi
//
//  Created by 刘晓明 on 2019/12/5.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "IJoouMainVC.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <BCBluetoothSDK/BCBluetoothSDK.h>
#import "IjoouCollectionCell.h"
#import "IjoouSetViewController.h"

@interface IJoouMainVC ()<CAAnimationDelegate,CBCentralManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,BCBluetoothManagerDelegate>
@property (nonatomic,strong)UIView *startView;
@property (nonatomic,strong)UIView *findView;
@property (nonatomic,strong)UIView *showView;
@property (nonatomic, strong) NSMutableArray *layerArray;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIButton *findBT;
@property (nonatomic,strong)UIButton *bindBT;
@property (nonatomic,strong)UIButton *cancelBT;
@property (nonatomic,strong)UIButton *setAllBT;
//解绑按钮
@property (nonatomic,strong)UIButton *unbindBT;
@property (nonatomic,strong)UILabel *showLabel;
@property (nonatomic,strong) UIButton *ijoouRightBT;
@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic , strong) CBCentralManager *manager;
@property (nonatomic , strong) NSMutableArray *peripheralArr;
@property (nonatomic, strong) NSMutableArray *chooseArray;
@property (nonatomic, strong) NSMutableArray *bindDeviceArray;
@property (nonatomic , strong) NSMutableArray *dataArr;
@property (nonatomic , assign) int canreload;
@property (nonatomic , assign) int showType;
@property (nonatomic , assign) int popType;
@property (nonatomic , assign) int deviceANumber;
@property (nonatomic , assign) int deviceBNumber;
@property (nonatomic , assign) BOOL canShowClose;
@end

@implementation IJoouMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _layerArray       = [NSMutableArray array];
    _chooseArray   = [NSMutableArray array];
    _dataArr          = [NSMutableArray array];
    _peripheralArr  = [NSMutableArray array];
    
    NSArray *bindDArray = [[NSUserDefaults standardUserDefaults]valueForKey:@"BindDeviceArray"];
    _bindDeviceArray = [NSMutableArray arrayWithArray:bindDArray];
    if (!_bindDeviceArray) {
        _bindDeviceArray = [NSMutableArray array];
    }

    _showType = 0;
    _deviceANumber = 1;
    _deviceBNumber = 1;
    _canShowClose = NO;
    //布局页面
    [self layoutStartIJooView];
    
}




# pragma mark - 布局初始页面
-(void)layoutStartIJooView{
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    self.canreload = 0;
//    [BCBluetoothManager shared].delegate = self;
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.navTitleLabel.text = @"ijoou";
    self.startView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight - kNavBarHeight)];
    self.startView.backgroundColor = RGB_AppWhite;
    [self.view addSubview:self.startView];

    UILabel *startLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(30), Adapter(40), ScreenWidth - Adapter(60), Adapter(40))];
    startLabel.numberOfLines = 2;
    startLabel.textAlignment = NSTextAlignmentCenter;
    startLabel.text = @"Welcome to ijoou and start your moxibustion trip!";
    startLabel.textColor = [UIColor blackColor];
    startLabel.font = [UIFont systemFontOfSize:16];
    [self.startView addSubview:startLabel];
    
    UIImageView *startImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2 - Adapter(85), startLabel.bottom + Adapter(30), Adapter(170), Adapter(235))];
    startImageView.image = [UIImage imageNamed:@"首页"];
    [self.startView addSubview:startImageView];
    
    UIButton *startButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    startButton.frame = CGRectMake(ScreenWidth/2 - Adapter(85), startImageView.bottom + Adapter(30), Adapter(170), Adapter(50));
    startButton.layer.cornerRadius = startButton.height/2;
    startButton.layer.masksToBounds = YES;
    [startButton setBackgroundColor:RGB_ButtonBlue];
    [startButton setTitle:@"Star" forState:(UIControlStateNormal)];
    [startButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [startButton addTarget:self  action:@selector(startAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.startView addSubview:startButton];

}

# pragma mark - 布局展示搜索结果页面
-(void)layoutShowView{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showFailView) object:nil];
    self.showView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight - kNavBarHeight)];
    self.showView.backgroundColor = RGB_AppWhite;
    [self.view addSubview:self.showView];
    
    CGFloat cellWithW;
    if (ISPaid) {
        cellWithW = (ScreenWidth - Adapter(40))/3;
    }else{
        cellWithW = (ScreenWidth - Adapter(30))/2;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellWithW , cellWithW);
    layout.sectionInset = UIEdgeInsetsMake(Adapter(10), Adapter(10), Adapter(10), Adapter(10));
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(0,Adapter(10), ScreenWidth, self.showView.height/4*3) collectionViewLayout:layout];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.backgroundColor = [UIColor clearColor];
    self.collectionV.hidden = YES;
    [self.collectionV registerClass:[IjoouCollectionCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.showView addSubview:self.collectionV];
    
    UILabel *showLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(20), self.collectionV.bottom + Adapter(10), ScreenWidth - Adapter(40), Adapter(40))];
    showLabel.numberOfLines = 2;
    showLabel.text = @"Please select the device you want to bind. After clicking Cancel, the device will be disconnectde";
    showLabel.textColor = [UIColor blackColor];
    showLabel.font = [UIFont systemFontOfSize:13];
    [self.showView addSubview:showLabel];
    self.showLabel = showLabel;
    
    NSArray *titleArray = @[@"cancel",@"bind"];
    NSArray *colorArray = @[RGB_TextGray,RGB_ButtonBlue];
    for (int i = 0; i< 2; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(Adapter(20) + ScreenWidth/2*i,showLabel.bottom + Adapter(10), ScreenWidth/2 -Adapter(40), Adapter(40));
        [button setTitle:titleArray[i] forState:(UIControlStateNormal)];
        [button setBackgroundColor:colorArray[i]];
        [button addTarget:self action:@selector(bindAction:) forControlEvents:(UIControlEventTouchUpInside)];
        button.layer.cornerRadius = button.height/2;
        button.layer.masksToBounds = YES;
        button.tag = 300 + i;
        [self.showView addSubview:button];
        if (i == 0) {
            self.cancelBT = button;
        }else{
            self.bindBT = button;
        }
    }
    
    UIButton *setAllBT = [UIButton buttonWithType:(UIButtonTypeCustom)];
    setAllBT.frame = CGRectMake(ScreenWidth/4, showLabel.bottom + Adapter(10), ScreenWidth/2, Adapter(40));
    setAllBT.layer.cornerRadius  =  setAllBT.height/2;
    setAllBT.layer.masksToBounds = YES;
    [setAllBT setBackgroundColor:RGB_ButtonBlue];
    [setAllBT addTarget:self action:@selector(setAllAction) forControlEvents:(UIControlEventTouchUpInside)];
    [setAllBT setTitle:@"Set up all" forState:(UIControlStateNormal)];
    setAllBT.hidden = YES;
    [self.showView addSubview:setAllBT];
    self.setAllBT = setAllBT;
  
}


# pragma  mark - 全部设置点击事件
-(void)setAllAction {
    if (self.dataArr.count == 0) {
        [GlobalCommon showMessage2:@"连接错误 请重新连接" duration2:2.0];
        [self findCancel:[UIButton buttonWithType:(UIButtonTypeCustom)]];
        return;
    }
    IjoouSetViewController *vc= [[IjoouSetViewController alloc]init];
    vc.dataArray = self.dataArr;
    vc.pushType = 100;
    self.popType = 1;
    __weak typeof(self) weakSelf = self;
    vc.popBlack = ^(NSMutableArray * _Nonnull dataArray) {
        weakSelf.dataArr = dataArray;
        [weakSelf.collectionV reloadData];
        [BCBluetoothManager shared].delegate = self;
    };
    vc.DisconnecBlack = ^(NSMutableArray * _Nonnull dataArray) {
        if (dataArray.count == weakSelf.dataArr.count) {
            for (int i = 0; i<dataArray.count; i++) {
                BCDeviceModel *chooseModel = dataArray[i];
                [[BCBluetoothManager shared] turnOffDevice:chooseModel];
            }
            [weakSelf findCancel:[UIButton buttonWithType:(UIButtonTypeCustom)]];
        }else{
            [BCBluetoothManager shared].delegate = self;
            for (int i = 0; i<dataArray.count; i++) {
                BCDeviceModel *chooseModel = dataArray[i];
                [[BCBluetoothManager shared] turnOffDevice:chooseModel];
                for (int i = 0; i < weakSelf.dataArr.count; i++) {
                    BCDeviceModel *dataModel = weakSelf.dataArr[i];
                    if ([chooseModel.macAddress isEqualToString:dataModel.macAddress]) {
                        [weakSelf.dataArr removeObject:dataModel];
                    }
                }
            }
            [weakSelf.chooseArray removeAllObjects];
            [weakSelf.collectionV reloadData];
        }
    };
    [self.navigationController pushViewController:vc animated:YES];
}

# pragma mark - 绑定按钮点击事件
-(void)bindAction:(UIButton *)button {
    if (button.tag == 300) {
        if (self.unbindBT.hidden == YES) {
            [self findCancel:[UIButton buttonWithType:(UIButtonTypeCustom)]];
        }else{
            self.cancelBT.hidden = YES;
            self.bindBT.hidden = YES;
            self.showLabel.hidden = YES;
            self.setAllBT.hidden = NO;
            [self.collectionV reloadData];
        }
    }else{
        
        if (![self.connectState isEqualToString:kCONNECTED_POWERD_ON]) {
            [GlobalCommon showMessage2:@"Please turn on bluetooth" duration2:2.0];
            return;
        }
        if (self.chooseArray.count == 0) {
            [GlobalCommon showMessage2:@"Please select at least one device" duration2:2.0];
            return;
        }
        if (self.unbindBT.hidden == YES) {
            if (self.chooseArray > 0) {
                [GlobalCommon showMBHudWithView:self.view];
                NSLog(@"%@",_chooseArray);
                for (int i  = 0 ; i < self.chooseArray.count; i++) {
                    [[BCBluetoothManager shared] bindDevice:self.chooseArray[i]];
                }
                [_dataArr removeAllObjects];
                _dataArr = [NSMutableArray arrayWithArray:self.chooseArray];
                NSLog(@"%@",_dataArr);
            }else{
                [GlobalCommon showMessage2:@"Please select at least one device" duration2:2.0];
            }
        }else{
            [GlobalCommon showMBHudWithView:self.view];
            NSLog(@"%@",_chooseArray);
            for (int i = 0;  i<self.chooseArray.count; i++) {
                BCDeviceModel *model = self.chooseArray[i];
                [[BCBluetoothManager shared] unbindDevice:model];
                for (int i = 0; i<_dataArr.count; i++) {
                    BCDeviceModel *dataModel = self.dataArr[i];
                    if ([model.deviceID isEqualToString:dataModel.deviceID]) {
                        [_dataArr removeObject:dataModel];
                    }
                }
                
                if ([_bindDeviceArray containsObject:[model.BCDevice.identifier UUIDString]]) {
                    [_bindDeviceArray removeObject:[model.BCDevice.identifier UUIDString]];
                    NSArray *bindDArray = [NSArray arrayWithArray:_bindDeviceArray];
                    [[NSUserDefaults standardUserDefaults] setObject:bindDArray forKey:@"BindDeviceArray"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }
            [self.chooseArray removeAllObjects];
            if (self.dataArr.count >0) {
                [self.collectionV reloadData];
            }else{
                [self findCancel:[UIButton buttonWithType:(UIButtonTypeCustom)]];
                self.showType = 0;
            }
            [GlobalCommon hideMBHudWithView:self.view];
            
        }
    }
}

# pragma mark - 开始搜索蓝牙设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    BOOL isCan = [[BCBluetoothManager shared] scanDevice:peripheral withAdvertisementData:advertisementData rssi:RSSI];
    if (isCan) {
        BOOL isCanbind = [[BCBluetoothManager shared] scanDeviceIsBind:peripheral withAdvertisementData:advertisementData];
        if (!isCanbind) {
            if (![_peripheralArr containsObject:peripheral]) {
                [_peripheralArr addObject:peripheral];
                [self.manager connectPeripheral:peripheral options:nil];
            }
            NSLog(@"-==-=-=-=-=-=-=-=-=-=-=-=-%@\n -------------%ld",peripheral.name , (long)peripheral.state);
        } else {
            for (int i = 0; i<_bindDeviceArray.count; i++) {
                if ([_bindDeviceArray[i]  isEqualToString:[peripheral.identifier UUIDString]]) {
                    if (![_peripheralArr containsObject:peripheral]) {
                        [_peripheralArr addObject:peripheral];
                        [self.manager connectPeripheral:peripheral options:nil];
                    }
                }
            }
        }
    }
}

# pragma mark - 设备鉴权
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    BCDeviceModel *model = [[BCDeviceModel alloc] initWithDevice:peripheral];
    
    if ([model.deviceName hasPrefix:@"ijoou-A"]) {
        model.deviceName = [NSString stringWithFormat:@"A%d",_deviceANumber];
        _deviceANumber++;
    }else if ([model.deviceName hasPrefix:@"ijoou-B"]) {
        model.deviceName = [NSString stringWithFormat:@"B%d",_deviceBNumber];
        _deviceBNumber++;
    }
    [self.dataArr addObject:model];
    self.canreload++;
    NSLog(@"--------------------------%d   -----------------------------------%d",self.canreload,(int)self.peripheralArr.count);
    if (self.canreload == (int)_peripheralArr.count) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            int deInt = 0;
            for (int i = 0; i < weakSelf.dataArr.count; i++) {
                BCDeviceModel *dataModel = weakSelf.dataArr[i];
                for (int j = 0; j < weakSelf.bindDeviceArray.count; j++) {
                    if ([[dataModel.BCDevice.identifier UUIDString] isEqualToString:weakSelf.bindDeviceArray[j]]) {
                        deInt++;
                    }
                }
            }
            if (deInt == weakSelf.dataArr.count) {
                [GlobalCommon showMBHudWithView:self.view];
                for (int i  = 0 ; i < weakSelf.dataArr.count; i++) {
                    [[BCBluetoothManager shared] bindDevice:weakSelf.dataArr[i]];
                }
            }
           
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self layoutShowView];
            self.canreload = 0;
            self.collectionV.hidden = NO;
            [self.manager stopScan];
            self.ijoouRightBT.hidden = YES;
            self.findView.hidden = YES;
            self.rightBtn.hidden = YES;
            [self.timer invalidate];
        });
        
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [BCBluetoothManager shared].delegate = self;
        [[BCBluetoothManager shared] authenticationDevice:model];
    });
}

//连接蓝牙设备失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
  
}
//断开蓝牙设备连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    
    if (_dataArr.count > 0) {
        for (int i = 0; i < _dataArr.count; i++) {
            BCDeviceModel *model = _dataArr[i];
            if ([[model.BCDevice.identifier UUIDString] isEqualToString:[peripheral.identifier UUIDString]]) {
                [_dataArr removeObject:model];
            }
        }
        [self.chooseArray removeAllObjects];
        if (_dataArr.count > 0) {
            [self.collectionV reloadData];
        }else{
            [self findCancel:[UIButton buttonWithType:(UIButtonTypeCustom)]];
        }
        
    }
    
}

# pragma mark - 绑定成功后
-(void)openDevice:(BCDeviceModel *)model {
    if (self.setAllBT.hidden == YES) {
        self.setAllBT.hidden = NO;
        self.cancelBT.hidden = YES;
        self.bindBT.hidden = YES;
        self.showLabel.hidden = YES;
        self.showType = 1;
        self.unbindBT.hidden = NO;
        [self.collectionV reloadData];
    }
}
# pragma mark - 开始搜索点击事件
-(void)startAction {
     if (![self.connectState isEqualToString:kCONNECTED_POWERD_ON]) {
         [GlobalCommon showMessage2:@"Please turn on bluetooth" duration2:2.0];
         return;
     }
    [self performSelector:@selector(showFailView) withObject:nil afterDelay:30];
    [self layoutFindView];
    
}
-(void)showFailView{
    [self stopFindActio];
}
-(void)stopFindActio {
    if (self.dataArr.count < 1&&_startView.hidden == YES) {
        //布局连接失败页面
        [self layoutFailView];
        [self findCancel:[UIButton buttonWithType:(UIButtonTypeCustom)]];
        return;
    }
    if (self.collectionV.hidden == YES) {
        [self layoutShowView];
        self.canreload = 0;
        self.collectionV.hidden = NO;
        [self findCancel:nil];
    }
   
}
# pragma mark -  布局搜索设备页面
-(void)layoutFindView{
    self.startView.hidden = YES;
    _canShowClose = YES;
    if (_peripheralArr.count>0) {
        for (int i = 0; i < _peripheralArr.count; i++) {
            [self.manager cancelPeripheralConnection:_peripheralArr[i]];
        }
        [_peripheralArr removeAllObjects];
    }
    [self.dataArr removeAllObjects];
    CBUUID *uuid = [CBUUID UUIDWithString:@"FFF0"];
    [self.manager scanForPeripheralsWithServices:@[uuid] options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@(YES)}];

    self.findView = [[UIView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight - kNavBarHeight)];
    self.findView.backgroundColor = RGB_AppWhite;
    [self.view addSubview:self.findView];
    
   
    UIButton *findBT = [UIButton buttonWithType:(UIButtonTypeCustom)];
    findBT.frame = CGRectMake(ScreenWidth/2 - Adapter(30), ScreenHeight/3 - Adapter(60), Adapter(60), Adapter(60));
    [findBT setImage:[UIImage imageNamed:@"ijoou蓝牙"] forState:(UIControlStateNormal)];
    [findBT setImage:[UIImage imageNamed:@"ijoou蓝牙"] forState:(UIControlStateHighlighted)];
    findBT.backgroundColor = RGB(107, 177, 215);
    findBT.layer.cornerRadius = findBT.width/2;
    findBT.layer.masksToBounds = YES;
    [self.findView addSubview:findBT];
    self.findBT = findBT;
    
    
    
    self.ijoouRightBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ijoouRightBT.frame = CGRectMake(ScreenWidth-Adapter(70), 2+kStatusBarHeight, Adapter(60), 40);
    [self.ijoouRightBT addTarget:self action:@selector(findCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.ijoouRightBT setTitle:@"cancel" forState:(UIControlStateNormal)];
    [self.ijoouRightBT setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self.topView addSubview:self.ijoouRightBT];
    
    self.unbindBT = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unbindBT.frame = CGRectMake(ScreenWidth-Adapter(110), 2+kStatusBarHeight, Adapter(100), 40);
    [self.unbindBT addTarget:self action:@selector(unbindAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.unbindBT.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self.unbindBT setTitle:@"Unbind device" forState:(UIControlStateNormal)];
    [self.unbindBT setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.unbindBT.hidden = YES;
    [self.topView addSubview:self.unbindBT];
    
   
    UILabel *findLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(30), ScreenHeight/2, ScreenWidth - Adapter(60), Adapter(40))];
    findLabel.numberOfLines = 2;
    findLabel.textAlignment = NSTextAlignmentCenter;
    findLabel.text = @"ijoou is being searched, please keep bluetooth open";
    findLabel.textColor = [UIColor blackColor];
    findLabel.font = [UIFont systemFontOfSize:16];
    [self.findView addSubview:findLabel];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(setUp) userInfo:nil repeats:YES];
    });
    
}



# pragma mark 解绑设备点击事件
-(void)unbindAction:(UIButton *)button {
    self.cancelBT.hidden = NO;
    self.bindBT.hidden = NO;
    [self.bindBT setTitle:@"unbind" forState:(UIControlStateNormal)];
    self.setAllBT.hidden = YES;
    self.showLabel.hidden = NO;
    self.showLabel.text = @"Warm prompt: after unbunding, will automatically disconnect with the equipment, to rebound next time";
    [self.collectionV reloadData];
}
# pragma mark -  蓝牙状态监听
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)central {
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"-=-=-=-=-=-=无法获取设备的蓝牙状态");
            self.connectState = kCONNECTED_UNKNOWN_STATE;
        }
            break;
        case CBCentralManagerStateResetting:
        {
            NSLog(@"-=-=-=-=-=-=--=-蓝牙重置");
            self.connectState = kCONNECTED_RESET;
        }
            break;
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"-=-=-=-=-=-=-该设备不支持蓝牙");
            self.connectState = kCONNECTED_UNSUPPORTED;
        }
            break;
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"-=-=-=-=-=-=未授权蓝牙权限");
            self.connectState = kCONNECTED_UNAUTHORIZED;
        }
            break;
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"-==-=-=-=-=-蓝牙已关闭");
            self.connectState = kCONNECTED_POWERED_OFF;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseBluetooth" object:nil userInfo:nil];
            if (_canShowClose) {
                [self closeBluetooth];
            }
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"-=-=-=-=-=--=-=蓝牙已打开");
            self.connectState = kCONNECTED_POWERD_ON;
//            [_manager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
            
        default:
        {
            NSLog(@"未知的蓝牙错误");
            self.connectState = kCONNECTED_ERROR;
            [self closeBluetooth];
        }
            break;
    }
    //[self getConnectState];
    
}

-(void)closeBluetooth {
    [self findCancel:[UIButton buttonWithType:(UIButtonTypeCustom)]];
    UIAlertController *alerVC= [UIAlertController alertControllerWithTitle:nil message:@"the connection failed,please open the bluetooth and confirm that your ijoou devices is near you ..." preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:nil];
    [alerVC addAction:cancelAction];
    [self presentViewController:alerVC animated:YES completion:nil];
}

#pragma mark <UICollectionView 代理方法>
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
    
    IjoouCollectionCell *cell = (IjoouCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
     BCDeviceModel *model =  self.dataArr[indexPath.row];
    cell.titleLabel1.text = model.deviceName;
    cell.selectedBT.hidden = self.showType;
    cell.timeLabel.hidden = !self.showType;
    cell.temperatureLabel.hidden = !self.showType;
    cell.voltameterView.hidden = !self.showType;
    NSLog(@"------------------%@",self.dataArr);
    if (self.showType == 1) {
        cell.voltameterView.batteryView.width = (model.voltameter*(cell.voltameterView.frame.size.width-cell.voltameterView.lineW*2))/100;
        cell.timeLabel.text =  [NSString stringWithFormat:@"%ldmin",(long)model.residueDuration];
        cell.temperatureLabel.text =[NSString stringWithFormat:@"%ld℃",(long)model.temperature];
        if (self.cancelBT.hidden == NO) {
            cell.voltameterView.hidden = YES;
            cell.selectedBT.hidden = NO;
            cell.timeLabel.hidden = YES;
            cell.temperatureLabel.hidden = YES;
             [cell.selectedBT setImage:[[UIImage imageNamed:@"ijoou未选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateNormal)];
            for (int i = 0; i<_chooseArray.count; i++) {
                BCDeviceModel *chooseModel =   _chooseArray[i];
                if ([chooseModel.macAddress isEqualToString:model.macAddress]) {
                    [cell.selectedBT setImage:[[UIImage imageNamed:@"ijoou选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateNormal)];
                }
            }
        }
    }
    
    __weak typeof(cell) weakCell= cell;
    cell.selectedBlock = ^{
        weakCell.selectedBT.selected = !weakCell.selectedBT.selected;
        if (weakCell.selectedBT.isSelected) {
            [weakCell.selectedBT setImage:[[UIImage imageNamed:@"ijoou选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateNormal)];
            [weakCell.selectedBT setImage:[[UIImage imageNamed:@"ijoou选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateHighlighted)];
            BCDeviceModel *model = self.dataArr[indexPath.row];
            if (![self.chooseArray containsObject:model]) {
                [self.chooseArray addObject:model];
            }
        }else{
            [weakCell.selectedBT setImage:[[UIImage imageNamed:@"ijoou未选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateNormal)];
            [weakCell.selectedBT setImage:[[UIImage imageNamed:@"ijoou未选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateHighlighted)];
            if ([self.chooseArray containsObject:model]) {
                [self.chooseArray removeObject:model];
            }
        }
    };
    return cell;
}
#pragma mark  cell 的点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IjoouCollectionCell * cell = (IjoouCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if (cell.selectedBT.hidden == NO) {
         [cell.selectedBT sendActionsForControlEvents:UIControlEventTouchUpInside];
    }else{
        IjoouSetViewController *vc= [[IjoouSetViewController alloc]init];
        vc.dataArray = self.dataArr;
        vc.pushType = (int)indexPath.row;
        __weak typeof(self) weakSelf = self;
        vc.popBlack = ^(NSMutableArray * _Nonnull dataArray) {
            weakSelf.dataArr = dataArray;
            [weakSelf.collectionV reloadData];
            [BCBluetoothManager shared].delegate = self;
        };
        vc.DisconnecBlack = ^(NSMutableArray * _Nonnull dataArray) {
            if (dataArray.count == weakSelf.dataArr.count) {
                for (int i = 0; i<dataArray.count; i++) {
                    BCDeviceModel *chooseModel = dataArray[i];
                    [[BCBluetoothManager shared] turnOffDevice:chooseModel];
                }
                [weakSelf findCancel:[UIButton buttonWithType:(UIButtonTypeCustom)]];
            }else{
                [BCBluetoothManager shared].delegate = self;
                for (int i = 0; i<dataArray.count; i++) {
                    BCDeviceModel *chooseModel = dataArray[i];
                    [[BCBluetoothManager shared] turnOffDevice:chooseModel];
                    for (int i = 0; i < weakSelf.dataArr.count; i++) {
                        BCDeviceModel *dataModel = weakSelf.dataArr[i];
                        if ([chooseModel.macAddress isEqualToString:dataModel.macAddress]) {
                            [weakSelf.dataArr removeObject:dataModel];
                        }
                    }
                }
                [weakSelf.chooseArray removeAllObjects];
                [weakSelf.collectionV reloadData];
            }
        };
        self.popType = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
  
}




# pragma mark - SDK 回调方法
- (void)didUpdateDatasWithDevice:(BCDeviceModel *)device statusCode:(BCBluetoothOperatestatusCode)code feedBackType:(BCBluetoothOperateFeedbackType)type
{
    
    NSLog(@"-=-=-=-=-=-=-=-=-=-=-=-=-=-=- 接受 代理 -=-=-=-=-=-------------");
    switch (type) {
            //获取设备基本信息
        case BCBluetoothOperateFeedbackTypeInfo:
            if (code == BCBluetoothOperatestatusCodeSuccess) {
                for (int i = 0; i < self.dataArr.count; i++) {
                    BCDeviceModel *model = self.dataArr[i];
                    if ([model.macAddress isEqualToString:device.macAddress]) {
                        model.temperature = device.temperature;
                        model.residueDuration = device.residueDuration;
                    }
                    [self.collectionV reloadData];
                }
                NSLog(@"获取设备基本信息成功");
            }
            break;
            //绑定设备
        case BCBluetoothOperateFeedbackTypeBindDevice: {
            [GlobalCommon hideMBHudWithView:self.view];
            NSLog(@"%@",_bindDeviceArray);
            NSLog(@"绑定设备成功");
            if (![_bindDeviceArray containsObject:[device.BCDevice.identifier UUIDString]]) {
                [_bindDeviceArray addObject:[device.BCDevice.identifier UUIDString]];
                NSArray *bindDArray = [NSArray arrayWithArray:_bindDeviceArray];
                [[NSUserDefaults standardUserDefaults] setObject:bindDArray forKey:@"BindDeviceArray"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            [[BCBluetoothManager shared] turnOnDevice:device];
            [self openDevice:device];
            for (int i = 0; i < self.dataArr.count; i++) {
                BCDeviceModel *model = self.dataArr[i];
                if ([model.macAddress isEqualToString:device.macAddress]) {
                    model.temperature = device.temperature;
                    model.residueDuration = device.residueDuration;
                }
                [self.collectionV reloadData];
            }
        }
            break;
            //解绑设备
        case BCBluetoothOperateFeedbackTypeUnBindDevice:
            NSLog(@"解绑 ----------------绑定设备成功  --------code %ld",(long)code);
            break;
            
            //设备权限鉴定
        case BCBluetoothOperateFeedbackTypeAuthentication:
            if (code == BCBluetoothOperatestatusCodeAuthenticationSuccess) {
//                for (int i = 0; i < _dataArr.count; i++) {
//                    BCDeviceModel *model = _dataArr[i];
//                    if (![model.deviceID isEqualToString:device.deviceID]) {
//                        [_dataArr addObject:model];
//                    }
//                }
//                [_collectionV reloadData];
                
                NSLog(@"设备权限鉴定成功");
            }else{
//                for (int i = 0; i < _dataArr.count; i++) {
//                    BCDeviceModel *model = _dataArr[i];
//                    if ([model.deviceID isEqualToString:device.deviceID]) {
//                        [_dataArr removeObject:model];
//                    }
//                }
//                [_collectionV reloadData];
                NSLog(@"设备权限鉴定失败");
            }
            break;

        default:
            break;
    }
    return;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.popType = 0;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(!self.popType){
        [self findCancel:nil];
    }
}


# pragma mark -  取消搜索点击事件
- (void)findCancel:(UIButton *)button {
    if (button) {
        self.startView.hidden = NO;
        [BCBluetoothManager shared].delegate =nil;
    }else{
        self.startView.hidden = YES;
    }
    if (_dataArr.count > 0) {
        [self.dataArr removeAllObjects];
        for (int i = 0 ; i<_dataArr.count; i++) {
            BCDeviceModel *model = _dataArr[i];
            [[BCBluetoothManager shared] turnOffDevice:model];
        }
    }
    [self.manager stopScan];
    self.showView.hidden = YES;
    self.ijoouRightBT.hidden = YES;
    self.findView.hidden = YES;
    self.unbindBT.hidden = YES;
    self.rightBtn.hidden = YES;
    [self.timer invalidate];
    _deviceANumber = 1;
    _deviceBNumber = 1;
}



#pragma mark  画雷达圆圈图
//画雷达圆圈图
-(void)setUp{
    CGPoint center = CGPointMake(500,500);
    
    //使用贝塞尔画圆
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:0 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, 0, 0);
    //填充颜色
    shapeLayer.fillColor = RGB(107, 177, 215).CGColor;
    //设置透明度、此处最好和动画里的一致、否则效果会不好
    shapeLayer.opacity = 0.8;
    shapeLayer.path = path.CGPath;
    
    [self.findView.layer insertSublayer:shapeLayer below:self.findBT.layer];
    
    [self addAnimation:shapeLayer];
}
-(void)addAnimation:(CAShapeLayer *)shapeLayer {
    
    [_layerArray addObject:shapeLayer];
    //雷达圈圈大小的动画
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"path";
    CGPoint center = CGPointMake(self.findBT.left + self.findBT.width/2 ,self.findBT.top + self.findBT.width/2 );
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:center radius:45 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:center radius:self.findBT.width*2 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    basicAnimation.fromValue = (__bridge id _Nullable)(path1.CGPath);
    basicAnimation.toValue = (__bridge id _Nullable)(path2.CGPath);
    //保持最新状态
    basicAnimation.fillMode = kCAFillModeForwards;
    
    
    //雷达圈圈的透明度
    CABasicAnimation *opacityAnimation = [CABasicAnimation animation];
    opacityAnimation.keyPath = @"opacity";
    
    opacityAnimation.fromValue = @(0.2);
    opacityAnimation.toValue = @(0);
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    //组动画
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[basicAnimation,opacityAnimation];
    group.duration = 2;
    //动画定时函数属性 先快后慢
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.delegate = self;
    //指定的时间段完成后,动画就自动的从层上移除
    group.removedOnCompletion = YES;
    //添加动画到layer
    [shapeLayer addAnimation:group forKey:nil];
    
}
- (BOOL)prefersStatusBarHidden{
    return NO;
}

#pragma mark 搜索设备失败弹出页面
-(void)layoutFailView {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    backView.backgroundColor = RGBA(1, 1, 1, 0.4);
    [self.view addSubview:backView];
    
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth -ScreenHeight/2)/2, ScreenHeight/6, ScreenHeight/2 , ScreenHeight/1.5)];
    showView.backgroundColor = [UIColor whiteColor];
    showView.layer.cornerRadius = Adapter(10);
    [backView addSubview:showView];
    
    UIImageView *topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, showView.width, showView.width/2)];
    topImageView.image = [UIImage imageNamed:@"ijoou连接错误"];
    [showView addSubview:topImageView];
    
    UILabel *titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(10), topImageView.bottom - Adapter(10), showView.width - Adapter(20), Adapter(30))];
    titleLabel.text = @"Connection Failed";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    [showView addSubview:titleLabel];
    
    UILabel *contentLabel  = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(10), titleLabel.bottom, showView.width - Adapter(20), showView.height - topImageView.height - Adapter(80))];
    contentLabel.text = @"Sorry,device could not be connected.Please confirm the following:\n①The device is within 3 meters from you and is not connected by another phone\n②The device is not in charging\n③The device ha sufficient power\n④If all the above are satisfied,you can try to long press the device fro above 10 second,and then connect after the white light appears";
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:13];
    [showView addSubview:contentLabel];
    
    UIButton *okButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    okButton.frame = CGRectMake(showView.width/2 - Adapter(50), showView.height  - Adapter(50), Adapter(100), Adapter(40));
    okButton.backgroundColor = RGB_ButtonBlue;
    okButton.layer.cornerRadius = okButton.height/2;
    okButton.layer.masksToBounds = YES;
    [okButton setTitle:@"ok" forState:(UIControlStateNormal)];
    [showView addSubview:okButton];
    [[okButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [backView removeFromSuperview];
    }];
    
}
@end
