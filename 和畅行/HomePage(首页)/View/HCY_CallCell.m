//
//  HCY_CallCell.m
//  和畅行
//
//  Created by 出神入化 on 2018/12/12.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_CallCell.h"

@implementation HCY_CallCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutView];
}

-(void)layoutView{
    
    
    self.backView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0,1);
    self.backView.layer.shadowOpacity = 0.4;
    self.backView.layer.shadowRadius = 4;
    self.typeImageView.frame = CGRectMake(Adapter(10), Adapter(10), Adapter(90), Adapter(90));
    
    self.typeLabel.font = [UIFont systemFontOfSize:17];
    self.oneLabel.font = [UIFont systemFontOfSize:14];
    self.twoLabel.font = [UIFont systemFontOfSize:14];
    self.threeLabel.font = [UIFont systemFontOfSize:14];
    [self.comeButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top).offset(Adapter(10.0));
        make.size.mas_equalTo(CGSizeMake(Adapter(90), Adapter(90)));
        make.leading.equalTo(self.backView.mas_leading).offset(Adapter(10.0));
    }];
    
    [self.typeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeImageView.mas_bottom);
        make.bottom.equalTo(self.backView.mas_bottom);
        make.leading.equalTo(self.backView.mas_leading).offset(Adapter(20.0));
        make.width.mas_equalTo(200);
    }];
    

    [self.oneLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_top);
        make.left.equalTo(self.typeImageView.mas_right).offset(Adapter(10));
        make.right.equalTo(self.contentView.mas_right).offset(Adapter(-10));
        make.height.mas_equalTo(Adapter(35));

    }];
    [self.twoLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.oneLabel.mas_bottom);
        make.left.equalTo(self.typeImageView.mas_right).offset(Adapter(10));
        make.right.equalTo(self.backView.mas_right).offset(Adapter(-10));
        make.height.mas_equalTo(Adapter(35));
        
    }];
    [self.threeLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.twoLabel.mas_bottom);
        make.left.equalTo(self.typeImageView.mas_right).offset(Adapter(10));
        make.right.equalTo(self.backView.mas_right).offset(Adapter(-10));
        make.height.mas_equalTo(Adapter(35));
    }];


    [self.comeButton  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom).offset(Adapter(-36));
        make.left.equalTo(self.backView.mas_right).offset(Adapter(-75));
        make.right.equalTo(self.backView.mas_right).offset(Adapter(-10));
        make.size.mas_equalTo(CGSizeMake(Adapter(65), Adapter(26)));
    }];
   
    
    
}



-(void)cellsetAttributewithIndexPath:(NSIndexPath *)indexPath {
    
    if (![UserShareOnce shareOnce].languageType){
        self.oneLabel.text       = ModuleZW(@"1.不用跑医院");
        self.twoLabel.text       = ModuleZW(@"2.和医生面对面问诊");
        self.threeLabel.text     = ModuleZW(@"3.咨询更方便");
        if (indexPath.row == 0) {
            self.typeImageView.image = [UIImage imageNamed:@"儿童咨询"];
            self.typeLabel.text      = ModuleZW(@"儿童咨询");
        }else if (indexPath.row == 1) {
            self.typeImageView.image = [UIImage imageNamed:@"成人咨询"];
            self.typeLabel.text      = ModuleZW(@"成人咨询");
        }else{
            self.typeImageView.image = [UIImage imageNamed:@"图文"];
            self.typeLabel.text      = ModuleZW(@"图文咨询");
            self.oneLabel.text       = ModuleZW(@"1.可以通过文字的形式");
            self.twoLabel.text       = ModuleZW(@"2.对小病进行咨询");
        }
    }else{
        self.typeImageView.image = [UIImage imageNamed:@"图文"];
        self.typeLabel.text      = ModuleZW(@"图文咨询");
        self.oneLabel.text       = ModuleZW(@"1.可以通过文字的形式");
        self.twoLabel.text       = ModuleZW(@"2.对小病进行咨询");
        self.threeLabel.text     = ModuleZW(@"3.咨询更方便");
        [self.comeButton setTitle:ModuleZW(@"进入") forState:(UIControlStateNormal)];
    }
  
    
  
    
}
- (IBAction)comeAction:(id)sender {
    
    if (self.comeToNextBlock) {
        self.comeToNextBlock(self);
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
