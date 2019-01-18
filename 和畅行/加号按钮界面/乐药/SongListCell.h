//
//  SongListCell.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongListCell;
@protocol songListCellDelegate<NSObject>
@optional

- (void)downLoadButton:(UIButton *)btn withDownload:(BOOL)isplay;

@end

@interface SongListCell : UITableViewCell

@property (nonatomic,strong) UIImageView *iconImage;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *downloadBtn;
@property (nonatomic,assign) BOOL PlayOrdownload;//是播放状态还是下载状态
@property (nonatomic,weak) id<songListCellDelegate>delegate;

@property (nonatomic,assign) BOOL currentSelect;//选中


- (void)setDownLoadButton:(BOOL)isHidden;

- (void)setTitleColor:(UIColor *)color;

- (void)setIconImageWith:(NSString *)str;

- (void)downloadSuccess;

- (void)downloadFailWithImageStr:(NSString *)nameStr;
@end
