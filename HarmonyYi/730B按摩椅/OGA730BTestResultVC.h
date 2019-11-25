//
//  OGA730BTestResultVC.h
//  和畅行
//
//  Created by 刘晓明 on 2019/11/18.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "OGA730BCommonVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OGA730BTestResultVC : OGA730BCommonVC
@property (nonatomic,strong) UILabel *pilaoLabel;
@property (nonatomic,strong) UILabel *suantengLabel;

- (id)initWithacheResult:(int )acheResult withfatigueResult:(int )fatigueResult;
@end

NS_ASSUME_NONNULL_END
