//
//  MyAdvisoryTableViewCell.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/21.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "MyAdvisoryTableViewCell.h"

@implementation MyAdvisoryTableViewCell
- (void)dealloc{
    
   
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIImageView *diImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 125)];
        diImageView.image = [UIImage imageNamed:@"zixundishitu.png"];
        [self addSubview:diImageView];
        _bottomView = [[UIImageView alloc]init];
        _bottomView.image = [UIImage imageNamed:@"我的咨询1_02.png"];
        [self addSubview:_bottomView];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _nameLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_nameLabel];
        _sexLabel = [[UILabel alloc]init];
        _sexLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _sexLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_sexLabel];
        
        _answerLabel = [[UILabel alloc]init];
        //_answerLabel.textColor = [UtilityFunc colorWithHexString:@"#fe6f5f"];
        _answerLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_answerLabel];
        
        _contentlabel = [[UILabel alloc]init];
        _contentlabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _contentlabel.font = [UIFont systemFontOfSize:11];
        _contentlabel.numberOfLines = 0;
        [self addSubview:_contentlabel];
       
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
        _timeLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_timeLabel];
        
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _nameLabel.frame = CGRectMake(23, 22,60, 15);
    _bottomView.frame = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 5);
    _sexLabel.frame = CGRectMake(90, 22, 100, 15);
    _answerLabel.frame = CGRectMake(self.frame.size.width - 83, 22, 60, 15);
    _contentlabel.frame = CGRectMake(23, 55, self.frame.size.width - 46, 50);
    _timeLabel.frame = CGRectMake(self.frame.size.width - 133, 105, 110, 15);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
