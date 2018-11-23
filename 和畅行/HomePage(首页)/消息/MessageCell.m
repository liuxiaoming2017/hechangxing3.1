//
//  MessageCell.m
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/29.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 解决复用重叠的问题：在复用前将内容置为空
-(void)prepareForReuse{
    self.icon.image = nil;
    self.title.text = nil;
    self.content.text = nil;
    self.time.text = nil;
    self.arrowImage.image = nil;
}
//- (void)dealloc {
//    [_icon release];
//    [_title release];
//    [_content release];
//    [_time release];
//    [_arrowImage release];
//    [super dealloc];
//}
@end
