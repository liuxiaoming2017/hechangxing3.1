//
//  MyAdvisoryTableViewCell.h
//  Voicediagno
//
//  Created by 李传铎 on 15/9/21.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAdvisoryTableViewCell : UITableViewCell
@property (nonatomic ,strong) UILabel *answerLabel;
@property (nonatomic ,strong) UILabel *contentlabel;
@property (nonatomic ,strong) UILabel *timeLabel;
@property (nonatomic,strong) CALayer *subLayer;
@end
