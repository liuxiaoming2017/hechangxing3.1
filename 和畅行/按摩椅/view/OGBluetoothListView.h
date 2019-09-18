//
//  OGBluetoothListView.h
//  EC628Set
//  蓝牙搜索列表
//  Created by jerry on 2018/9/26.
//  Copyright © 2018年 HLin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface OGBluetoothListView : UIView

typedef void (^SelectedPeripheral)(CBPeripheral *peripheral);

typedef void (^ScanPeripheralCancel)(void);

@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, copy) SelectedPeripheral selectedPeripheral;

@property (nonatomic, copy) ScanPeripheralCancel scanPeripheralCancel;
/**
 发现新设备，刷新列表
 */
- (void)reloadBluetoothList;

- (void)stopIndicatorAnimating;

- (void)removeSuperView;

@end
