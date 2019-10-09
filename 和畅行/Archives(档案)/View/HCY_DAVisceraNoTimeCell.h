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


@property (nonatomic,strong) UILabel *createDateLabel;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong)UIImageView *lineImageV2;


//病历
@property (nonatomic, strong) UILabel *doctorNameLabel;
@property (nonatomic, strong) UILabel *departmentNameLabel;
@property (nonatomic, strong) UILabel *CCLabel;

- (void)assignmentNoVisceraWithModel:(HealthTipsModel *)model;

@end

NS_ASSUME_NONNULL_END
