//
//  CommandButtonView.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "CommandButtonView.h"
#import "ArmChairModel.h"
#define Adapterbody(d) (ISPaid ? Adapter(d)*0.8 : Adapter(d))
@implementation CommandButtonView

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if(self){
        [self initUIwithTitle:title];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withModel:(ArmChairModel *)model
{
    self = [super initWithFrame:frame];
    if(self){
        self.model = model;
        [self initUIwithTitle:model.name];
    }
    return self;
}


- (void)initUIwithTitle:(NSString *)title
{
    
    self.commandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if(self.width == Adapterbody(56)){
        self.commandButton.frame = CGRectMake((self.width-Adapterbody(33))/2.0, Adapterbody(5), Adapterbody(33), Adapterbody(33));
    }
    else if(self.width >= Adapterbody(53)){
        self.commandButton.frame = CGRectMake((self.width-Adapterbody(53))/2.0, Adapterbody(5), Adapterbody(53), Adapterbody(53));
    }else{
        self.commandButton.frame = CGRectMake((self.width-Adapterbody(33))/2.0, Adapterbody(5), Adapterbody(33), Adapterbody(33));
    }
    
//    CGSize size = self.CommandButton.frame.size;
//    CGFloat radius = self.CommandButton.width/2.0;
//    [self.CommandButton setImage:[self createImageWithColor:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0] size:size radius:radius] forState:UIControlStateNormal];
   // [self.CommandButton setImage:[self createImageWithColor:[UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0] size:size radius:radius] forState:UIControlStateSelected];
    self.commandButton.layer.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
    self.commandButton.layer.cornerRadius = self.commandButton.width/2.0;
    self.commandButton.layer.masksToBounds = YES;
    [self.commandButton addTarget:self action:@selector(commandAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.commandButton];
    
    NSArray *arr = [title componentsSeparatedByString:@"_"];
    if(arr.count>0){
        title = [arr objectAtIndex:[arr count] - 1];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(-Adapterbody(10),self.commandButton.bottom+Adapterbody(5),self.width+Adapterbody(20),Adapterbody(20));
//    if (ISPaid) {
         label.font = [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].padSizeFloat];
//    }else{
//         label.font = [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].fontSize > 16.0 ? 16.0 : 14*[UserShareOnce shareOnce].fontSize];
//    }
   
    label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = label;
    [self addSubview:label];
    
    if ([title isEqualToString:@"Neck"]) {
        title = @"NeckNext";
    }
    [self.commandButton setImage:[[UIImage imageNamed:title] transformWidth:Adapterbody(22) height:Adapterbody(22)]  forState:(UIControlStateNormal)];
    [self.commandButton setImage:[[UIImage imageNamed:title] transformWidth:Adapterbody(22) height:Adapterbody(22)]  forState:(UIControlStateHighlighted)];
}


- (void)commandAction:(UIButton *)button
{
//    button.selected = !button.selected;
//    if(button.selected){
//        self.titleLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
//        button.layer.backgroundColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0].CGColor;
//
//    }else{
//        self.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
//        button.layer.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
//
//    }
    if([self.delegate respondsToSelector:@selector(commandActionWithModel:withTag:)]){
        [self.delegate commandActionWithModel:self.model withTag:self.tag];
    }
}

- (void)setButtonViewSelect:(BOOL)select
{
    self.commandButton.selected = select;
    if(select){
        self.titleLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
        self.commandButton.layer.backgroundColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0].CGColor;
        
    }else{
        self.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        self.commandButton.layer.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
    }
}

- (void)setButtonViewSelect:(BOOL)select WithImageStr:(NSString *)str
{
    self.commandButton.selected = select;
    if(select){
        self.titleLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
        [self.commandButton setImage:[[UIImage imageNamed:str] transformWidth:Adapterbody(22) height:Adapterbody(22)] forState:UIControlStateNormal];
        self.commandButton.layer.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
    }else{
        self.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        [self.commandButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        self.commandButton.layer.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
    }
}

// 根据颜色生成UIImage
- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size radius:(CGFloat)radius {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
