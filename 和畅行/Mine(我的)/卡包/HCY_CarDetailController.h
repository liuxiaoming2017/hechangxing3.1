//
//  HCY_CarDetailController.h
//  和畅行
//
//  Created by Wei Zhao on 2018/12/10.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SayAndWriteController.h"
#import "HYC_CardsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HCY_CarDetailController : SayAndWriteController
@property (nonatomic,strong)HYC_CardsModel *model;
@property (nonatomic,strong)NSDictionary *dateDic;
@end

NS_ASSUME_NONNULL_END
