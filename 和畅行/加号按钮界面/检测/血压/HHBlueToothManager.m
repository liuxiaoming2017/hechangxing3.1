//
//  HHBlueToothManager.m
//  Voicediagno
//
//

#import "HHBlueToothManager.h"



@interface HHBlueToothManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic,retain) CBCentralManager *manager;
@property (nonatomic,retain) CBPeripheral *peripheral;
@property (nonatomic,retain) CBCharacteristic *characteristic;

@property (nonatomic,assign) BOOL isInitiativeDisconnect;//主动断开连接

@end

@implementation HHBlueToothManager

- (instancetype )init{
    if (self = [super init]) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        
    }
    return self;
}

#pragma mark -- CBCentralManagerDelegate
#pragma mark- 扫描设备，连接
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    if (!peripheral || !peripheral.name || ([peripheral.name isEqualToString:@""])) {
        return;
    }
    
    if ((!self.peripheral || (self.peripheral.state == CBPeripheralStateDisconnected))&&([peripheral.name isEqualToString:kPERIPHERAL_NAME])) {
        self.peripheral = [peripheral copy];
        [self.manager connectPeripheral:peripheral options:nil];
    }
    
}
#pragma park- 连接成功,扫描services
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (!peripheral) {
        return;
    }
    [self.manager stopScan];
    
    NSLog(@"设备连接成功 :  %@",peripheral);
    [[NSNotificationCenter defaultCenter] postNotificationName:kPERIPHERAL_CONNECTED object:nil userInfo:nil];
    
    [self.peripheral setDelegate:self];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kPERIPHERAL_BEGIN object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"开始检测！");
        [self.peripheral discoverServices:nil];
        
    }];
    
}
#pragma mark- 连接外设失败
- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"（%@)的设备连接失败:%@",[peripheral name],[error localizedDescription]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kPERIPHERAL_CONNECT_FAILED object:nil userInfo:nil];
}
#pragma mark - 扫描service
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray *services = nil;
    
    if (peripheral != self.peripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    services = [peripheral services];
    if (!services || ![services count]) {
        NSLog(@"No Services");
        return ;
    }
    
    for (CBService *service in services) {
        if ([[service.UUID UUIDString] isEqualToString:KUUID_SERVICE]) {
            [peripheral discoverCharacteristics:nil forService:service];
            return ;
        }
    }
    
}
#pragma mark - 发现characteristic
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
//    NSLog(@"该设备的characteristics:%@",[service characteristics]);
    NSArray *characteristics = [service characteristics];
    
    if (peripheral != self.peripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    for (CBCharacteristic *character in characteristics) {
        
        NSLog(@"[character.UUID UUIDString] : %@",[character.UUID UUIDString]);
        
        if ([[character.UUID UUIDString] isEqualToString:kUUID_CHARACTER_RECEIVE]) {
            self.characteristic = character;
            [self.peripheral setNotifyValue:YES forCharacteristic:self.characteristic];
            //取到characteristic后发出通知，把此时当做与设备真正的连接，在接收通知的地方进行相应的处理
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:kPERIPHERAL_CONNECTED object:nil userInfo:nil];
        }
        
        if ([[character.UUID UUIDString] isEqualToString:kUUID_CHARACTER_SEND]) {
            self.characteristic = character;
            
            Byte byte[] = {0x02,0x40,0xdc,0x01,0xa1,0x3c};
            
            NSData *data = [NSData dataWithBytes:byte length:6];
            
            [self.peripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
            //取到characteristic后发出通知，把此时当做与设备真正的连接，在接收通知的地方进行相应的处理
            
                   //     [[NSNotificationCenter defaultCenter] postNotificationName:kPERIPHERAL_CONNECTED object:nil userInfo:nil];
            
        }
        
    }
}


#pragma mark - 读取数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    NSData *data = characteristic.value;
    //NSLog(@"data:%@",data);
    NSMutableArray *array = [self handleTheData:data];
    //NSLog(@"获取的血压数据：%@",array);
    
    if (array) {
        NSDictionary *dict = @{@"dataArray":array};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kPERIPHERAL_DATA object:nil userInfo:dict];
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
     NSLog(@"写数据！");
}

#pragma mark - 蓝牙的状态
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"无法获取设备的蓝牙状态");
            self.connectState = kCONNECTED_UNKNOWN_STATE;
        }
            break;
        case CBCentralManagerStateResetting:
        {
            NSLog(@"蓝牙重置");
            self.connectState = kCONNECTED_RESET;
        }
            break;
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"该设备不支持蓝牙");
            self.connectState = kCONNECTED_UNSUPPORTED;
        }
            break;
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"未授权蓝牙权限");
            self.connectState = kCONNECTED_UNAUTHORIZED;
        }
            break;
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"蓝牙已关闭");
            self.connectState = kCONNECTED_POWERED_OFF;
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已打开");
            self.connectState = kCONNECTED_POWERD_ON;
            [_manager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
            
        default:
        {
            NSLog(@"未知的蓝牙错误");
            self.connectState = kCONNECTED_ERROR;
        }
            break;
    }
    //[self getConnectState];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCONNECTED_STATE_CHANGED object:nil userInfo:nil];
}

-(NSString *)getConnectState{
    return self.connectState;
}

#pragma mark- 外设断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"外设断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    [[NSNotificationCenter defaultCenter] postNotificationName:kPERIPHERAL_DISCONNECTED object:nil userInfo:nil];
    //重连外设
    if (!self.isInitiativeDisconnect) {
        [self.manager connectPeripheral:peripheral options:nil];
    }
    
}
#pragma mark - 主动断开连接
-(void)cancelPeripheralConnection{
    
    self.isInitiativeDisconnect = YES;
    if (self.peripheral) {//已经连接外设，则断开
        [self.manager cancelPeripheralConnection:self.peripheral];
    }else{//未连接，则停止搜索外设
        [self.manager stopScan];
    }
    
}

#pragma mark- 数据处理
-(NSMutableArray *) handleTheData:(NSData *) data{
    
    NSMutableArray  *array = [NSMutableArray array];
    Byte *byte = (Byte *)[data bytes];
    for (int i=0; i < data.length; i++) {
        NSInteger num = (NSInteger) byte[i];
        [array addObject:@(num)];
    }
    
    NSData * newData = [self encrypt:data];
    Byte *newByte = (Byte *)[newData bytes];
    
    if (newByte[newData.length - 1] == [[array lastObject] integerValue]) {
        NSLog(@"校验和错误");
        return nil;
    }else{
        NSLog(@"校验和正确");
        return array;
    }
    
}

#pragma mark- 血压值异或校验
- (NSData *)encrypt:(NSData *)data {
    
    char *dataP = (char *)[data bytes];
    for (int i = 0; i < data.length; i++) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunsequenced"
        *dataP = *(++dataP) ^ 1;
#pragma clang diagnostic pop
    }
    
    return data;
}


- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPERIPHERAL_BEGIN object:nil];
    
}
@end
