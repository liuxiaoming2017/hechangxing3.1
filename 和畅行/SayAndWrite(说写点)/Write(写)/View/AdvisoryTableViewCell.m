//
//  AdvisoryTableViewCell.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/20.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "AdvisoryTableViewCell.h"

@implementation AdvisoryTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 60, 15)];
        _nameLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nameLabel];
        _sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 20, 50, 15)];
        _sexLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _sexLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_sexLabel];
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 20, 50, 15)];
        _phoneLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _phoneLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_phoneLabel];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
