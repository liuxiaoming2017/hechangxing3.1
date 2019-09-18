//
//  SublayerView.h
//  和畅行
//
//  Created by 刘晓明 on 2019/9/9.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArmChairModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SublayerView : UIView

@property (nonatomic,strong) ArmChairModel *model;

-(void)insertSublayerFromeView:(UIView *)view;

- (void)setImageVandTitleLabelwithModel:(ArmChairModel *)model;

@end

NS_ASSUME_NONNULL_END
