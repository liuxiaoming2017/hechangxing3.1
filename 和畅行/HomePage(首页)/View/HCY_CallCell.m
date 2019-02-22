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
    
    
    
}



-(void)cellsetAttributewithIndexPath:(NSIndexPath *)indexPath {
    
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
    [self.comeButton setTitle:ModuleZW(@"进入") forState:(UIControlStateNormal)];
    
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
