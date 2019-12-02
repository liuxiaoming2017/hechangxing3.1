//
//  OGA730BDetailVC.h
//  和畅行
//
//  Created by 刘晓明 on 2019/11/18.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "OGA730BCommonVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OGA730BDetailVC : OGA730BCommonVC

- (id)initWithType:(BOOL )isAdvanced withTitleStr:(NSString *)titleStr;

- (id)initWithRecommend:(BOOL )isRecommend withTitleStr:(NSString *)titleStr;

- (void)commandActionWithModel:(ArmChairModel *)model;

- (void)commandActionWithModel:(ArmChairModel *)model withTag:(NSInteger )tag;

@end

NS_ASSUME_NONNULL_END
