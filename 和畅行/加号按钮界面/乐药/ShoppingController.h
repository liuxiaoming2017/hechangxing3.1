//
//  ShoppingController.h
//  和畅行
//
//  Created by 刘晓明 on 2019/1/18.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "SayAndWriteController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingController : SayAndWriteController

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,assign) float prices;
@end

NS_ASSUME_NONNULL_END
