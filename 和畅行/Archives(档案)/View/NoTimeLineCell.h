//
//  NoTimeLineCell.h
//  和畅行
//
//  Created by 刘晓明 on 2018/11/23.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoTimeLineCell : UITableViewCell

@property (nonatomic,strong) UIImageView *leftImageV;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *createDateLabel;
@property (nonatomic, strong)UIImageView *lineImageV2;
@property (nonatomic, strong) UILabel *kindLabel;
@property (nonatomic, strong)UIImageView *kindImage;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)assignmentNoCellWithModel:(HealthTipsModel *)model withType:(NSInteger )typeInteger;

@end

NS_ASSUME_NONNULL_END
