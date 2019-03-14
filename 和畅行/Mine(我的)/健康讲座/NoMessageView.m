//
//  NoMessageView.m
//  quyubianshi
//
//  Created by ZhangYunguang on 16/3/16.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "NoMessageView.h"

@implementation NoMessageView

+(UIView *)createImageWith:(CGFloat)Y{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, Y, kScreenSize.width, 220)];
    UIImageView *noMessageImage = [Tools creatImageViewWithFrame:CGRectMake(kScreenSize.width/2-219.5/2, 0, 219.5, 189.5) imageName:@"noMessage"];
    [view addSubview:noMessageImage];
    UILabel *instructionLabel = [Tools labelWith:ModuleZW(@"您当前还没有数据哦") frame:CGRectMake(0, noMessageImage.frame.origin.y+noMessageImage.frame.size.height+10, kScreenSize.width, 10) textSize:15 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentCenter];
    [view addSubview:instructionLabel];
    return view;
}

@end
