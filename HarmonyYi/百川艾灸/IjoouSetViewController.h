//
//  IjoouSetViewController.h
//  HarmonyYi
//
//  Created by Wei Zhao on 2019/12/13.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "NavBarViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^PopBlock)(NSMutableArray *dataArray);
typedef void (^DisconnectBlock)(NSMutableArray *dataArray);
@interface IjoouSetViewController : NavBarViewController
@property(nonatomic,assign)int pushType;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,copy)PopBlock popBlack;
@property(nonatomic,copy)DisconnectBlock DisconnecBlack;

@end

NS_ASSUME_NONNULL_END
