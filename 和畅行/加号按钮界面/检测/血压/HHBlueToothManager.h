//
//  HHBlueToothManager.h
//  Voicediagno
//
//


#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface HHBlueToothManager : NSObject

@property (nonatomic,copy) NSString *connectState;//蓝牙连接状态

-(NSString *)getConnectState;
-(void)cancelPeripheralConnection;

@end
