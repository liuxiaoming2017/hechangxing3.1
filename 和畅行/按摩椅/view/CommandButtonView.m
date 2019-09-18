//
//  CommandButtonView.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/11.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "CommandButtonView.h"
#import "ArmChairModel.h"

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
    if(self.width == 56){
        self.commandButton.frame = CGRectMake((self.width-33)/2.0, 5, 33, 33);
    }
    else if(self.width >= 53){
        self.commandButton.frame = CGRectMake((self.width-53)/2.0, 5, 53, 53);
    }else{
        self.commandButton.frame = CGRectMake((self.width-33)/2.0, 5, 33, 33);
    }
    
    [self.commandButton setImage:[UIImage imageNamed:title] forState:UIControlStateNormal];
    [self.commandButton setImage:[UIImage imageNamed:title] forState:UIControlStateHighlighted];
    
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
    label.frame = CGRectMake(0,self.commandButton.bottom+5,self.width,20);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = label;
    [self addSubview:label];
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
    if([self.delegate respondsToSelector:@selector(commandActionWithModel:)]){
        [self.delegate commandActionWithModel:self.model];
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
