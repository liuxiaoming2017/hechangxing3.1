//
//  HCY_ReportCell.h
//  和畅行
//
//  Created by 出神入化 on 2018/12/14.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HealthTipsModel.h"
@interface HCY_ReportCell : UITableViewCell

@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UILabel     *quarterLabel;
@property (nonatomic,strong) UILabel     *timeLabel;


-(void)setReportModel:(HealthTipsModel *)model withIndex:(NSIndexPath *)indexpath;
@end

