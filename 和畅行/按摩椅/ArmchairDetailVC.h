//
//  ArmchairDetailVC.h
//  和畅行
//
//  Created by 刘晓明 on 2019/9/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ArmchairCommonVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArmchairDetailVC : ArmchairCommonVC

- (id)initWithType:(BOOL )isAdvanced withTitleStr:(NSString *)titleStr;

- (id)initWithRecommend:(BOOL )isRecommend withTitleStr:(NSString *)titleStr;

- (void)commandActionWithModel:(ArmChairModel *)model;

@end

NS_ASSUME_NONNULL_END
