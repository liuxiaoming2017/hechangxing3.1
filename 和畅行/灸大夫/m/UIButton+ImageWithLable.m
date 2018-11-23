//
//  UIButton+ImageWithLable.m
//  MoxaAdvisor
//
//  Created by wangdong on 15/4/14.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "UIButton+ImageWithLable.h"
#import "UIImage+Util.h"
#import "NSString+Util.h"

@implementation UIButton (ImageWithLable)

- (void) setImage:(UIImage *)image withTitle:(NSString *)title forState:(UIControlState)stateType
{
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    
    CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0], NSFontAttributeName, nil]];
    
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 32, 32)];
    [self setImage:image forState:stateType];
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self setTitleColor:[UIColor blackColor] forState:stateType];//用这个方法替换下面的方法，文字的颜色就可以显示了。
    //[self.titleLabel setTextColor:[UIColor blackColor]];
    if (stateType == UIControlStateSelected) {
        [self setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    }else{
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 32, 32, titleSize.width)];
    [self setTitle:title forState:stateType];
}

- (void) modifyImageSize:(CGSize)size {
    [self setContentMode:UIViewContentModeScaleAspectFill];
    UIImage *normalImg = [self imageForState:UIControlStateNormal];
    UIImage *highlightedImg = [self imageForState:UIControlStateHighlighted];
    
    UIImage *normalImg2 = [normalImg transformWidth:size.width height:size.height];
    UIImage *highlightedImg2 = [highlightedImg transformWidth:size.width height:size.height];
    
    [self setImage:normalImg2 forState:UIControlStateNormal];
    [self setImage:highlightedImg2 forState:UIControlStateHighlighted];
    
    normalImg = nil;
    highlightedImg = nil;
    
    normalImg2 = nil;
    highlightedImg2 = nil;
}

- (void) modifyImageWithSelectSize:(CGSize)size {
    [self setContentMode:UIViewContentModeScaleAspectFill];
    UIImage *normalImg = [self imageForState:UIControlStateNormal];
    UIImage *selectedImg = [self imageForState:UIControlStateSelected];
    
    UIImage *normalImg2 = [normalImg transformWidth:size.width height:size.height];
    UIImage *selectedImg2 = [selectedImg transformWidth:size.width height:size.height];
    [self setImage:normalImg2 forState:UIControlStateNormal];
    [self setImage:selectedImg2 forState:UIControlStateSelected];
    
    normalImg = nil;
    selectedImg = nil;
    
    normalImg2 = nil;
    selectedImg2 = nil;
}

- (void) modifyImageSize:(CGSize)size normalSate:(UIImage*)normalSateImg highlightState:(UIImage*)highlightStateImg {
    [self setContentMode:UIViewContentModeScaleAspectFill];
    UIImage *normalImg = [normalSateImg transformWidth:size.width height:size.height];
    UIImage *highlightedImg = [highlightStateImg transformWidth:size.width height:size.height];
    [self setImage:normalImg forState:UIControlStateNormal];
    [self setImage:highlightedImg forState:UIControlStateHighlighted];
    
    normalImg = nil;
    highlightedImg = nil;
}

- (void)bolsterImageSize:(CGSize)size {
    CGFloat originImgWid = self.imageView.frame.size.width;
    NSString *title = self.titleLabel.text;
    CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font, NSFontAttributeName, nil]];
    CGFloat originTitleWid = titleSize.width;
    
    [self modifyImageSize:size];
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(6/2, (self.frame.size.width-originImgWid)/2+(originImgWid-size.width)/2, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(size.height+6, (self.frame.size.width-originTitleWid)/2-size.width, 0, 0)];
}

- (void)bolsterImageSize:(CGSize)size normalSate:(UIImage*)normalSateImg highlightState:(UIImage*)highlightStateImg {
    CGFloat originImgWid = self.imageView.frame.size.width;
    NSString *title = self.titleLabel.text;
    CGSize titleSize = [title sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.titleLabel.font, NSFontAttributeName, nil]];
    CGFloat originTitleWid = titleSize.width;
    [self modifyImageSize:size normalSate:normalSateImg highlightState:highlightStateImg];
    //    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self setImageEdgeInsets:UIEdgeInsetsMake(6/2, (self.frame.size.width-originImgWid)/2+(originImgWid-size.width)/2, 0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(size.height+6, (self.frame.size.width-originTitleWid)/2-size.width, 0, 0)];
}

- (void) modifyImageSelectedSize:(CGSize)size {
    [self setContentMode:UIViewContentModeScaleAspectFill];
    UIImage *normalImg = [self imageForState:UIControlStateNormal];
    UIImage *selectedImg = [self imageForState:UIControlStateSelected];
    
    UIImage *normalImg2 = [normalImg transformWidth:size.width height:size.height];
    UIImage *selectedImg2 = [selectedImg transformWidth:size.width height:size.height];
    [self setImage:normalImg2 forState:UIControlStateNormal];
    [self setImage:selectedImg2 forState:UIControlStateSelected];
    
    normalImg = nil;
    selectedImg = nil;
    normalImg2 = nil;
    selectedImg2 = nil;
}

- (void) modifyImageEnlargeSize:(CGSize)size {
    [self setContentMode:UIViewContentModeScaleAspectFill];
    UIImage *normalImg = [self imageForState:UIControlStateNormal];
    UIImage *highlightedImg = [self imageForState:UIControlStateHighlighted];
    
    UIImage *normalImg2 = [normalImg transformWidth:size.width height:size.height];
    UIImage *highlightedImg2 = [highlightedImg transformWidth:size.width+5 height:size.height+5];
    [self setImage:normalImg2 forState:UIControlStateNormal];
    [self setImage:highlightedImg2 forState:UIControlStateHighlighted];
    
    normalImg = nil;
    highlightedImg = nil;
    normalImg2 = nil;
    highlightedImg2 = nil;
}

- (void)verticalImageAndTitle:(CGFloat)spacing
{
//    self.titleLabel.backgroundColor = [UIColor greenColor];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
//    CGSize textSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    CGSize textSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.titleLabel.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.titleLabel.font} context:nil].size;
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}

@end
