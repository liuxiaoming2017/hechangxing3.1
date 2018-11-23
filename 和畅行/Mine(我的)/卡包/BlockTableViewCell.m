//
//  BlockTableViewCell.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/8.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "BlockTableViewCell.h"

@implementation BlockTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imageV = [[UIImageView alloc]init];
        _backImage = [[UIImageView alloc] init];
        _backImage.image = [UIImage imageNamed:@"我的卡包_04.png"];
        [self addSubview:_backImage];

        _imageV.image = [UIImage imageNamed:@"我的咨询_21.png"];
        [self addSubview:_imageV];
        _mLabel = [[UILabel alloc] init];
        _mLabel.text = @"500";
        _mLabel.textAlignment = NSTextAlignmentCenter;
        _mLabel.font = [UIFont systemFontOfSize:17];
        _mLabel.textColor = [UIColor whiteColor];
        [self addSubview:_mLabel];
        _hLabel = [[UILabel alloc] init];
        _hLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _hLabel.text = @"会员卡：";
        _hLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_hLabel];
        _yLabel = [[UILabel alloc] init];
        _yLabel.text = @"有效期：";
        _yLabel.font = [UIFont systemFontOfSize:10];
        _yLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        [self addSubview:_yLabel];
        _wLabel = [[UILabel alloc]init];
        _wLabel.text = @"1000元";
        _wLabel.textColor = [UtilityFunc colorWithHexString:@"#575e64"];
        _wLabel.font= [UIFont systemFontOfSize:10];
        [self addSubview:_wLabel];
        _tLabel = [[UILabel alloc]init];
        _tLabel.textColor = [UtilityFunc colorWithHexString:@"#fc5856"];
        _tLabel.text = @"2015.02.30";
        _tLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:_tLabel];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _backImage.frame = CGRectMake(0, 0, self.frame.size.width, 139 / 2);
    _imageV.frame  =CGRectMake(0, 0, 101, 139 / 2);
    _mLabel.frame = CGRectMake(0, 0, 101, 139 /2 );
    _hLabel.frame = CGRectMake(105, 15, 60, 15);
    _yLabel.frame = CGRectMake(105, 40, 60, 15);
    _wLabel.frame = CGRectMake(145, 15, 80, 15);
    _tLabel.frame = CGRectMake(145, 40, 200, 15);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
