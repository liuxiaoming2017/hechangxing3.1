//
//  MessageCell.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/29.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *icon;
@property (retain, nonatomic) IBOutlet UILabel *title;
@property (retain, nonatomic) IBOutlet UILabel *content;
@property (retain, nonatomic) IBOutlet UILabel *time;
@property (retain, nonatomic) IBOutlet UIImageView *arrowImage;


@end
