//
//  HCY_DAVisceraNoTimeCell.h
//  和畅行
//
//  Created by Wei Zhao on 2018/12/6.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCY_DAVisceraNoTimeCell : UITableViewCell


@property (nonatomic,strong) CALayer *subLayer;
@property (nonatomic,strong) UIImageView *leftImageV;
@property (nonatomic,strong) UILabel *topLabel;
@property (nonatomic,strong) UILabel *lowLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *createDateLabel;
@property (nonatomic, strong) UILabel *typeLabel;


- (void)assignmentNoVisceraWithModel:(HealthTipsModel *)model;

@end

NS_ASSUME_NONNULL_END
