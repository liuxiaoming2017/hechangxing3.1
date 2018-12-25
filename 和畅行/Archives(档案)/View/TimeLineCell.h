//
//  TimeLineCell.h
//  和畅行
//
//  Created by 刘晓明 on 2018/11/7.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeLineCell : UITableViewCell

@property (nonatomic,strong) CALayer *subLayer;
@property (nonatomic,strong) UIImageView *leftImageV;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *createDateLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong)UIImageView *lineImageV2;


- (void)assignmentCellWithModel:(HealthTipsModel *)model;
- (void)configCellWithModel1;
- (void)configCellWithModel2;

@end
