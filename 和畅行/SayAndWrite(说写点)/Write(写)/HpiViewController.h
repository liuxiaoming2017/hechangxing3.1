//
//  HpiViewController.h
//  和畅行
//
//  Created by 出神入化 on 2019/4/30.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "SayAndWriteController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HpiViewController : SayAndWriteController
@property (nonatomic,strong)NSMutableArray *topArray;
@property (nonatomic,strong)NSMutableArray *bottomArray;
@property (nonatomic,assign) int sex;
@end

NS_ASSUME_NONNULL_END
