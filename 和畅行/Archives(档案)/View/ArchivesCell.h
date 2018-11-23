//
//  ArchivesCell1.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/23.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArchiveModel;
@interface ArchivesCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImage;

@property (nonatomic,strong) UILabel *typeLabel;

@property (nonatomic,strong) UILabel *resultLabel;

@property (nonatomic,strong) UILabel *checkResultLabel;

@property (nonatomic,strong) UILabel *doctorHintLabel;


@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) ArchiveModel *archiveModel;

@property (nonatomic,strong) UIImageView *lineImage;
-(void)configMiddleCellWithArchive:(ArchiveModel *)archive;
-(void)configZangFuCellWithArchive:(ArchiveModel *)archive;
-(void)configXinLvCellWithArchive:(ArchiveModel *)archive;

@end
