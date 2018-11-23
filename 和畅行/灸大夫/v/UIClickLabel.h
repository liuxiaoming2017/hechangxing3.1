//
//  UIClickLabel.h
//  Acupoint
//
//  Created by wangdong on 12-11-2.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIClickLabelDelegate;

@interface UIClickLabel : UILabel {
	id<UIClickLabelDelegate> _delegate;
}

@property (nonatomic, weak) id <UIClickLabelDelegate> delegate;
@property (nonatomic, strong)UIColor *mLabelColor;
@property (nonatomic, strong)UIColor *mClickColor;

- (id)initWithFrame:(CGRect)frame LabelColor:(UIColor *)labelcolor ClickColor:(UIColor*)clickcolor;
-(void)setClickColor:(UIColor*)cc;
-(void)addUnderLine;
-(void)addUnderLine:(NSString*)s;
@end

@protocol UIClickLabelDelegate <NSObject>
@optional
- (void)onClickLabel:(UIClickLabel *)label;
@end




