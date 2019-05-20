//
//  HPITableViewCell.m
//  和畅行
//
//  Created by 出神入化 on 2019/4/30.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "HPITableViewCell.h"

@implementation HPITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
      if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
          self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, (ScreenWidth -20)/2 - 35, 39)];
          self.titleLabel.font = [UIFont systemFontOfSize:16];
          self.titleLabel.numberOfLines = 2;
          [self addSubview:self.titleLabel];
          self.stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.titleLabel.right, 0, 80, 39)];
          self.stateLabel.font = [UIFont systemFontOfSize:14];
          [self addSubview:self.stateLabel];
          self.deletButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
          self.deletButton.frame = CGRectMake(ScreenWidth - 80, 9, 20, 22);
          [self.deletButton setBackgroundImage:[UIImage imageNamed:@"ICD10_delete"] forState:(UIControlStateNormal)];
          [self.deletButton addTarget:self action:@selector(deletAction) forControlEvents:(UIControlEventTouchUpInside)];
          [self addSubview:self.deletButton];
          UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth - 20, 1)];
          lineView.backgroundColor = RGB(236, 236, 236);
          [self addSubview:lineView];
          
      }
    return self;
}
-(void)deletAction{
    if(self.deletBlock){
        self.deletBlock();
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
