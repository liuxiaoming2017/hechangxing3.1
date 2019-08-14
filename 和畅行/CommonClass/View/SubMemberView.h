//
//  SubMemberView.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/25.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectCellBlock)(NSString *subId);
typedef void(^SelectNameCellBlock)(NSString *nameString);
@interface SubMemberView : UIView

@property (nonatomic, assign) CGFloat cellHeight;//设置cell高度

-(void)hideHintView;//隐藏view

@property (nonatomic, copy) SelectCellBlock myBlock;
@property (nonatomic, copy) SelectNameCellBlock mynameBlock;
-(void)receiveSubIdWith:(SelectCellBlock )block;
-(void)receiveNameWith:(SelectNameCellBlock )block;
@end
