//
//  NoteController.m
//  和畅行
//
//  Created by 刘晓明 on 2019/10/27.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "NoteController.h"

@interface NoteController ()

@end

@implementation NoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.view.backgroundColor = [UIColor orangeColor];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, kNavBarHeight, ScreenWidth-20, ScreenHeight-kNavBarHeight*2)];
    [self.view addSubview:textView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSString *noteStr = yueYaoNote;
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:noteStr attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor blackColor],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    textView.attributedText = string2;
    textView.textAlignment = NSTextAlignmentLeft;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
