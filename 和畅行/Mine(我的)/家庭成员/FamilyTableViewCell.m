//
//  FamilyTableViewCell.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/16.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "FamilyTableViewCell.h"

@implementation FamilyTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 70, 15)];
        _nameLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nameLabel];
        _sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.right, 20, ScreenWidth - 195 -90, 15)];
        _sexLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _sexLabel.textAlignment = NSTextAlignmentCenter;
        _sexLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_sexLabel];
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 195, 20, 80, 15)];
        _phoneLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _phoneLabel.font = [UIFont systemFontOfSize:12];
        _phoneLabel.textAlignment = NSTextAlignmentRight;
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
