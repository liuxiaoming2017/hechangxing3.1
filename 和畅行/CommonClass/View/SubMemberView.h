//
//  SubMemberView.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/25.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectCellBlock)(NSString *subId);

@interface SubMemberView : UIView

@property (nonatomic, assign) CGFloat cellHeight;//设置cell高度

-(void)hideHintView;//隐藏view

@property (nonatomic, copy) SelectCellBlock myBlock;
-(void)receiveSubIdWith:(SelectCellBlock )block;

@end
