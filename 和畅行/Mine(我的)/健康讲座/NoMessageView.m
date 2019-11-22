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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2 - Adapter(120), kScreenSize.width, Adapter(220))];
    UIImageView *noMessageImage = [Tools creatImageViewWithFrame:CGRectMake(kScreenSize.width/2-Adapter(219.5)/2, 0, Adapter(219.5), Adapter(189.5)) imageName:@"noMessage"];
    [view addSubview:noMessageImage];
    UILabel *instructionLabel = [Tools labelWith:ModuleZW(@"您当前还没有数据哦") frame:CGRectMake(0, noMessageImage.frame.origin.y+noMessageImage.frame.size.height+Adapter(10), kScreenSize.width, Adapter(15)) textSize:15 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentCenter];
    [view addSubview:instructionLabel];
    return view;
}

@end
