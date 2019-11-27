//
//  PostButtonView.m
//  和畅行
//
//  Created by 刘晓明 on 2019/11/19.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "PostButtonView.h"
#import "ArmChairModel.h"
#define Adapterbody(d) (ISPaid ? Adapter(d)*0.8 : Adapter(d))
@implementation PostButtonView

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
    CGFloat buttonWidth = Adapterbody(42);
    CGFloat labelWidth = Adapterbody(80);
    CGFloat margin = (ScreenWidth - labelWidth*4)/5.0;
    
    self.commandButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.commandButton.frame = CGRectMake((self.width-buttonWidth)/2.0, 5, buttonWidth, buttonWidth);
    
    [self.commandButton setImage:[[UIImage imageNamed:title] transformWidth:Adapterbody(30) height:Adapterbody(22)] forState:UIControlStateNormal];
    [self.commandButton setImage:[[UIImage imageNamed:title] transformWidth:Adapterbody(30) height:Adapterbody(22)] forState:UIControlStateHighlighted];
    
    self.commandButton.layer.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
    self.commandButton.layer.cornerRadius = self.commandButton.width/2.0;
    self.commandButton.layer.masksToBounds = YES;
    [self addSubview:self.commandButton];
    
    NSArray *arr = [title componentsSeparatedByString:@"_"];
    if(arr.count>0){
        title = [arr objectAtIndex:[arr count] - 1];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0,self.commandButton.bottom+Adapterbody(5),self.width,Adapterbody(20));
    label.font = [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].padSizeFloat];
    label.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = label;
    [self addSubview:label];
}

- (void)setButtonViewSelect:(BOOL)select
{
    self.commandButton.selected = select;
    if(select){
        self.titleLabel.textColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0];
        //self.commandButton.layer.backgroundColor = [UIColor colorWithRed:30/255.0 green:130/255.0 blue:210/255.0 alpha:1.0].CGColor;
    }else{
        self.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        self.commandButton.layer.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0].CGColor;
    }
}
@end
