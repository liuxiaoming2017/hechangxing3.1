//
//  AllServiceCell.m
//  和畅行
//
//  Created by Wei Zhao on 2019/9/4.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "AllServiceCell.h"

@implementation AllServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self setupView];
    }
    return self;
}

- (void)setupView
{
    
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.layer.cornerRadius = 8.0;
    imageV.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:imageV];
    imageV.layer.shadowColor = RGB(200, 200, 200).CGColor;
    imageV.layer.shadowOffset = CGSizeMake(0,0);
    imageV.layer.shadowOpacity = 0.5;
    imageV.layer.shadowRadius = 5;
    
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.font=[UIFont systemFontOfSize:15];
    self.typeLabel.textColor=RGB(128, 128, 128);
    self.typeLabel.text = ModuleZW(@"暂无数据");
    self.typeLabel.numberOfLines = 0;
    [imageV addSubview:self.typeLabel];
    
    
    self.numberLabel = [[UILabel alloc]init];
    self.numberLabel.font=[UIFont systemFontOfSize:15];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.textColor=UIColorFromHex(0x8E8E93);
    self.numberLabel.text = ModuleZW(@"暂无数据");
    self.numberLabel.numberOfLines = 0;
    [self.contentView addSubview:self.numberLabel];
    
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(Adapter(8));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(Adapter(-8));
        make.leading.equalTo(self.contentView.mas_leading).offset(Adapter(15));
        make.trailing.equalTo(self.contentView.mas_trailing).offset(Adapter(-15));
        
    }];
    
    
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_top).offset(Adapter(10));
        make.bottom.equalTo(imageV.mas_bottom).offset(Adapter(-10));
        make.leading.equalTo(imageV.mas_leading).offset(Adapter(5));
        make.trailing.equalTo(imageV.mas_trailing).offset(Adapter(-100));
        make.height.greaterThanOrEqualTo(@(Adapter(35)));
    }];
    
    [self.numberLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_top).offset(Adapter(5));
        make.bottom.equalTo(imageV.mas_bottom).offset(Adapter(-5));
        make.trailing.equalTo(imageV.mas_trailing).offset(Adapter(-5));
        make.width.mas_equalTo(Adapter(95));
    }];
    
    
}
-(void)setAllServicValueWithModel:(HYC_CardsModel *)model {
    
    self.typeLabel.text = model.name;
    self.numberLabel.text = model.value;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
