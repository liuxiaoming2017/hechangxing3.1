//
//  UIButton+Bootstrap.h
//  UIButton+Bootstrap
//
//  Created by Oskar Groth on 2013-09-29.
//  Copyright (c) 2013 Oskar Groth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+FontAwesome.h"
@interface UIButton (Bootstrap)
- (void)addAwesomeIcon:(FAIcon)icon beforeTitle:(BOOL)before;
-(void)bootstrapStyle;
-(void)defaultStyle;
-(void)primaryStyle;
-(void)successStyle;
-(void)infoStyle;
-(void)warningStyle;
-(void)dangerStyle;

-(void)myselfStyle;
-(void)myselfStyle2;
-(void)myselfStyle3;
- (void)normalColor:(UIColor*)nc pressedColor:(UIColor*)pc;
- (void)normalColor2:(UIColor*)nc pressedColor:(UIColor*)pc;
- (void)titleColor:(UIColor*)tc normalColor:(UIColor*)nc pressedColor:(UIColor*)pc;
- (void)normalColor:(UIColor*)nc pressedColor:(UIColor*)pc radius:(float)radiusSize;
- (void)titleColor2:(UIColor*)tc normalColor:(UIColor*)nc pressedColor:(UIColor*)pc;
- (void)withBorder:(int)val normalColor:(UIColor*)nc pressedColor:(UIColor*)pc;
-(void)addrStyle;
- (void)addTreatStyle;
-(void)redBoundStyle;
- (void)goodsAttrStyle;
- (void)shoppingBuyButtonStyle;


@end
