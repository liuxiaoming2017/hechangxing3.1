//
//  HCY_ConsumptionListCell.h
//  和畅行
//
//  Created by Wei Zhao on 2018/12/10.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCY_ConsumptionListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;

@end

NS_ASSUME_NONNULL_END
