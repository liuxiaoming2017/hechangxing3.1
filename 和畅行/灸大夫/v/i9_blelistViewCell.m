//
//  i9_blelistViewCell.m
//  MoxaYS
//
//  Created by xuzengjun on 16/9/19.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import "i9_blelistViewCell.h"

@implementation i9_blelistViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)ConnectBtnOnclinck:(id)sender {
    [_delegate ConnectOnclink:sender];
}

@end
