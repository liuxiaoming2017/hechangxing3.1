//
//  NoteView.m
//  和畅行
//
//  Created by 刘晓明 on 2019/10/27.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "NoteView.h"

@implementation NoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, kNavBarHeight, ScreenWidth-20, ScreenHeight-kNavBarHeight*2)];
    [self addSubview:textView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSString *noteStr = yueYaoNote;
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:noteStr attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor blackColor],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    textView.attributedText = string2;
    textView.textAlignment = NSTextAlignmentLeft;
}

@end
