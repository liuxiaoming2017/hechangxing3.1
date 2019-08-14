//
//  AMPopTip.m
//  PopTipDemo
//
//  Created by Andrea Mazzini on 11/07/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "AMPopTip.h"
#import <CoreText/CoreText.h>
#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

#define kDefaultFont [UIFont systemFontOfSize:[UIFont systemFontSize]]
#define kDefaultTextColor  [UIColor colorWithRed:255/255 green:255/255 blue:173/255 alpha:1]
#define kDefaultBackgroundColor [UIColor lightGrayColor];
#define kDefaultRadius 0
#define kDefaultPadding 6
#define kDefaultArrowSize CGSizeMake(0, 0)
#define kDefaultAnimationIn 0
#define kDefaultAnimationOut 0.2

@interface AMPopTip()

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) AMPopTipDirection direction;
@property (nonatomic, unsafe_unretained  ) UIView *containerView;
@property (nonatomic, assign) CGRect textBounds;
@property (nonatomic, assign) CGPoint arrowPosition;
@property (nonatomic, strong) NSMutableParagraphStyle *paragraphStyle;
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGRect fromFrame;

@end

@implementation AMPopTip

+ (instancetype)popTip
{
    
    
    return [[AMPopTip alloc] init];
}

- (instancetype)initWithFrame:(CGRect)ignoredFrame
{
    return [self init];
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        _paragraphStyle.alignment = NSTextAlignmentCenter;
        _font = kDefaultFont;
        _textColor = [UIColor whiteColor];// 字体颜色  [UIColor whiteColor]
        _popoverColor = kDefaultBackgroundColor;
        _radius = kDefaultRadius;
        _padding = kDefaultPadding;
        _arrowSize = kDefaultArrowSize;
        _animationIn = kDefaultAnimationIn;
        _animationOut = kDefaultAnimationOut;
        _isVisible = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [self setup];
}
- (CGSize)frameSizeForAttributedString:(NSAttributedString *)attributedString
{
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
    
    CFIndex offset = 0, length;
    CGFloat y = 0;
    do {
        length = CTTypesetterSuggestLineBreak(typesetter, offset, width);
        CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(offset, length));
        
        CGFloat ascent, descent, leading;
        CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        
        CFRelease(line);
        
        offset += length;
        y += ascent + descent + leading;
    } while (offset < [attributedString length]);
    
    CFRelease(typesetter);
    
    return CGSizeMake(width, ceil(y));
}
- (void)setup
{
    if (self.direction == AMPopTipDirectionLeft) {
        self.maxWidth = MIN(self.maxWidth, self.fromFrame.origin.x - self.padding * 2 - self.arrowSize.width);
    }
    if (self.direction == AMPopTipDirectionRight) {
        self.maxWidth = MIN(self.maxWidth, self.containerView.bounds.size.width - self.fromFrame.origin.x - self.fromFrame.size.width - self.padding * 2 - self.arrowSize.width);
    }
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          self.font, NSFontAttributeName,
                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                          nil];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.text attributes:attributesDictionary];

    CGSize size11= [self frameSizeForAttributedString:attributedString];//[self.text boundingRectWithSize:CGSizeMake(self.maxWidth, DBL_MAX )

    self.textBounds=CGRectMake(0, 0, size11.width, size11.height);
    _textBounds.origin = (CGPoint){self.padding, self.padding};
    
    CGRect frame = CGRectZero;
    if (self.direction == AMPopTipDirectionUp || self.direction == AMPopTipDirectionDown) {
        frame.size = (CGSize){self.textBounds.size.width + self.padding * 2.0+8, self.textBounds.size.height + self.padding * 2.0 + self.arrowSize.height};
        
        CGFloat x = self.fromFrame.origin.x + self.fromFrame.size.width / 2 - frame.size.width / 2;
        if (x < 0) { x = 0; }
        if (x + frame.size.width > self.containerView.bounds.size.width) { x = self.containerView.bounds.size.width - frame.size.width; }
        if (self.direction == AMPopTipDirectionDown) {
            frame.origin = (CGPoint){ 0, ScreenHeight -66-self.textBounds.size.height};
        } else {
            frame.origin = (CGPoint){ 0, self.fromFrame.origin.y- 11 - frame.size.height};
        }
    } else {
        frame.size = (CGSize){ self.textBounds.size.width + self.padding * 2.0 + self.arrowSize.width, self.textBounds.size.height + self.padding * 2.0};
        
        CGFloat x = 0;
        if (self.direction == AMPopTipDirectionLeft) {
            x = self.fromFrame.origin.x - frame.size.width;
        }
        if (self.direction == AMPopTipDirectionRight) {
            x = self.fromFrame.origin.x + self.fromFrame.size.width;
        }
        
        CGFloat y = self.fromFrame.origin.y + self.fromFrame.size.height / 2 - frame.size.height / 2;
        
        if (y < 0) { y = 0; }
        if (y + frame.size.height > self.containerView.bounds.size.height) { y = self.containerView.bounds.size.height - frame.size.height; }
        frame.origin = (CGPoint){ x, y };
    }
    
    switch (self.direction) {
        case AMPopTipDirectionDown: {
            self.arrowPosition = (CGPoint){
                self.fromFrame.origin.x + self.fromFrame.size.width / 2 - frame.origin.x,
                self.fromFrame.origin.y + self.fromFrame.size.height - frame.origin.y
            };
            CGFloat anchor = self.arrowPosition.x / frame.size.width;
            _textBounds.origin = (CGPoint){ self.textBounds.origin.x, self.textBounds.origin.y + self.arrowSize.height };
            self.layer.anchorPoint = (CGPoint){ anchor, 0 };
            self.layer.position = (CGPoint){ self.layer.position.x + frame.size.width * anchor, self.layer.position.y - frame.size.height / 2 };
            
            break;
        }
        case AMPopTipDirectionUp: {
            self.arrowPosition = (CGPoint){
                self.fromFrame.origin.x + self.fromFrame.size.width / 2 - frame.origin.x,
                frame.size.height
            };
            CGFloat anchor = self.arrowPosition.x / frame.size.width;
            self.layer.anchorPoint = (CGPoint){ anchor, 1 };
            self.layer.position = (CGPoint){ self.layer.position.x + frame.size.width * anchor, self.layer.position.y + frame.size.height / 2 };
            
            break;
        }
        case AMPopTipDirectionLeft: {
            self.arrowPosition = (CGPoint){
                self.fromFrame.origin.x - frame.origin.x,
                self.fromFrame.origin.y + self.fromFrame.size.height / 2 - frame.origin.y
            };
            CGFloat anchor = self.arrowPosition.y / frame.size.height;
            self.layer.anchorPoint = (CGPoint){ 1, anchor };
            self.layer.position = (CGPoint){ self.layer.position.x - frame.size.width / 2, self.layer.position.y + frame.size.height * anchor };
            
            break;
        }
        case AMPopTipDirectionRight: {
            self.arrowPosition = (CGPoint){
                self.fromFrame.origin.x + self.fromFrame.size.width - frame.origin.x,
                self.fromFrame.origin.y + self.fromFrame.size.height / 2 - frame.origin.y
            };
            _textBounds.origin = (CGPoint){ self.textBounds.origin.x + self.arrowSize.width, self.textBounds.origin.y };
            CGFloat anchor = self.arrowPosition.y / frame.size.height;
            self.layer.anchorPoint = (CGPoint){ 0, anchor };
            self.layer.position = (CGPoint){ self.layer.position.x + frame.size.width / 2, self.layer.position.y + frame.size.height * anchor };
            
            break;
        }
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = frame;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGRect frame = rect;
    frame.origin.x = 5;
    frame.origin.y = 3;
    rect = frame;
    
    UIBezierPath *arrow = [[UIBezierPath alloc] init];
    
    CGRect baloonFrame;
    // Drawing a round rect and the arrow alone sometime show a white halfpixel line, so here's a fun bit of code...
    switch (self.direction) {
        case AMPopTipDirectionDown: {
            baloonFrame = (CGRect){ (CGPoint) { 0, self.arrowSize.height }, (CGSize){ self.frame.size.width, self.frame.size.height - self.arrowSize.height } };
            [arrow moveToPoint:self.arrowPosition];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x + self.arrowSize.width / 2, self.arrowPosition.y + self.arrowSize.height }];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width - self.radius, self.arrowSize.height }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius,  self.arrowSize.height + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width, self.arrowSize.height + baloonFrame.size.height - self.radius }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius,  self.arrowSize.height + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ self.radius, self.arrowSize.height + baloonFrame.size.height }];
            [arrow addArcWithCenter:(CGPoint){ self.radius,  self.arrowSize.height + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ 0, self.arrowSize.height + self.radius }];
            [arrow addArcWithCenter:(CGPoint){ self.radius, self.arrowSize.height + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x - self.arrowSize.width / 2, self.arrowPosition.y + self.arrowSize.height - 30 }];
            
            [[UIColor colorWithRed:53/255 green:53/255 blue:53/255 alpha:0.7] setFill];
            [arrow fill];
            
            break;
        }
        case AMPopTipDirectionUp: {
            baloonFrame = (CGRect){ (CGPoint) { 0, 0 }, (CGSize){ self.frame.size.width, self.frame.size.height - self.arrowSize.height } };
            
            [arrow moveToPoint:self.arrowPosition];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x + self.arrowSize.width / 2, self.arrowPosition.y - self.arrowSize.height }];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + baloonFrame.size.height }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(0) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width, baloonFrame.origin.y + self.radius }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(270) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ self.radius, baloonFrame.origin.y }];
            [arrow addArcWithCenter:(CGPoint){ self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(180) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ 0, baloonFrame.origin.y + baloonFrame.size.height - self.radius }];
            [arrow addArcWithCenter:(CGPoint){ self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(90) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x - self.arrowSize.width / 2, self.arrowPosition.y - self.arrowSize.height }];
            
            [self.popoverColor setFill];
            [arrow fill];
            
            break;
        }
        case AMPopTipDirectionLeft: {
            baloonFrame = (CGRect){ (CGPoint) { 0, 0 }, (CGSize){ self.frame.size.width - self.arrowSize.width, self.frame.size.height } };
            
            [arrow moveToPoint:self.arrowPosition];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x - self.arrowSize.width, self.arrowPosition.y - self.arrowSize.height / 2 }];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width, baloonFrame.origin.y + self.radius }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(270) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ self.radius, baloonFrame.origin.y }];
            [arrow addArcWithCenter:(CGPoint){ self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(180) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ 0, baloonFrame.origin.y + baloonFrame.size.height - self.radius }];
            [arrow addArcWithCenter:(CGPoint){ self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(90) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + baloonFrame.size.height }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.size.width - self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(0) clockwise:NO];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x - self.arrowSize.width, self.arrowPosition.y + self.arrowSize.height / 2 }];
            
            [self.popoverColor setFill];
            [arrow fill];
            
            break;
        }
        case AMPopTipDirectionRight: {
            baloonFrame = (CGRect){ (CGPoint) { self.arrowSize.width, 0 }, (CGSize){ self.frame.size.width - self.arrowSize.width, self.frame.size.height } };
            
            [arrow moveToPoint:self.arrowPosition];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x + self.arrowSize.width, self.arrowPosition.y - self.arrowSize.height / 2 }];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.origin.x, baloonFrame.origin.y + self.radius }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.origin.x + self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(180) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.origin.x + baloonFrame.size.width - self.radius, baloonFrame.origin.y }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.origin.x + baloonFrame.size.width - self.radius, baloonFrame.origin.y + self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.origin.x + baloonFrame.size.width, baloonFrame.origin.y + baloonFrame.size.height - self.radius }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.origin.x + baloonFrame.size.width - self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ baloonFrame.origin.x + self.radius, baloonFrame.origin.y + baloonFrame.size.height }];
            [arrow addArcWithCenter:(CGPoint){ baloonFrame.origin.x + self.radius, baloonFrame.origin.y + baloonFrame.size.height - self.radius } radius:self.radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180) clockwise:YES];
            [arrow addLineToPoint:(CGPoint){ self.arrowPosition.x + self.arrowSize.width, self.arrowPosition.y + self.arrowSize.height / 2 }];
            
            [self.popoverColor setFill];
            [arrow fill];
            
            break;
        }
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    [self.text drawInRect:rect withFont:self.font lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
    
    // [self.text drawInRect:self.textBounds withAttributes:titleAttributes];
}

- (void)showText:(NSString *)text direction:(AMPopTipDirection)direction maxWidth:(CGFloat)maxWidth inView:(UIView *)view fromFrame:(CGRect)frame
{
    self.text = text;
    //self.textColor = [UIColor whiteColor];
    self.direction = direction;
    self.containerView = view;
    self.maxWidth = maxWidth;
    self.fromFrame = frame;
    
    //self.transform = CGAffineTransformMakeScale(0, 0);
    [self.containerView addSubview:self];
    _isVisible = YES;
    [self setNeedsLayout];
    //    [UIView animateWithDuration:self.animationIn delay:0 usingSpringWithDamping:7.5 initialSpringVelocity:6 options:(UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction) animations:^{
    //        self.transform = CGAffineTransformIdentity;
    //    } completion:nil];
}

- (void)hide
{
    //    [UIView animateWithDuration:self.animationOut delay:0 options:(UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction) animations:^{
    //        self.transform = CGAffineTransformMakeScale(0.000001, 0.000001);
    //    } completion:^(BOOL finished) {
    //        if (finished) {
    //            [self removeFromSuperview];
    //            self.transform = CGAffineTransformIdentity;
    //            self->_isVisible = NO;
    //        }
    //    }];
    [self removeFromSuperview];
    self->_isVisible = NO;
}

@end
