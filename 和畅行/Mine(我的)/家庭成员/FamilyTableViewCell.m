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
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 15)];
        _nameLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nameLabel];
        _sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, 70, 15)];
        _sexLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _sexLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_sexLabel];
        _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 20, 100, 15)];
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
