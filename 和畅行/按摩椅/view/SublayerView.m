//
//  SublayerView.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/9.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "SublayerView.h"

@interface SublayerView ()

@property (nonatomic,strong) CALayer *subLayer;

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *titleLabel;


@end

@implementation SublayerView
@synthesize subLayer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = Adapter(10);
    self.layer.masksToBounds = YES;
    self.userInteractionEnabled = YES;
    
    //self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 19, self.frame.size.width-48, self.frame.size.height-19-47)];
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-Adapter(60))/2.0, (self.frame.size.height-Adapter(79))/2.0, Adapter(60), Adapter(49))];
    //NSLog(@"frame:%@",NSStringFromCGRect(self.imageV.frame));
    
    self.imageV.layer.cornerRadius = Adapter(8);
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adapter(2), CGRectGetMaxY(self.imageV.frame)+Adapter(10), self.frame.size.width-Adapter(2)*2, Adapter(20))];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //self.titleLabel.highlightedTextColor = [UIColor redColor];
    if(ISPaid) {
       self.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].fontSize];
    }else{
        self.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:14*[UserShareOnce shareOnce].fontSize > 16.0 ? 16.0 : 14*[UserShareOnce shareOnce].fontSize];
    }
    self.titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
    self.titleLabel.text = @"发卡拉";
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    
}

- (void)setImageVandTitleLabelwithModel:(ArmChairModel *)model
{
    self.model = model;
    self.imageV.image = [UIImage imageNamed:model.name];
    if([model.name isEqualToString:@"肩颈4D"]){
        self.imageV.image = [UIImage imageNamed:@"肩颈"];
    }
    self.titleLabel.text = model.name;
}

- (void)setImageAndTitleWithModel:(ArmChairModel *)model withName:(NSString *)name
{
    self.model = model;
    NSString *jlbsName2 = [[NSUserDefaults standardUserDefaults] objectForKey:@"Physical"];
    
    if([jlbsName2 isEqualToString:@""] || jlbsName2==nil){
        self.titleLabel.text = @"";
        self.imageV.image = [UIImage imageNamed:@"推荐_默认"];
        self.imageV.frame = CGRectMake((self.frame.size.width-Adapter(70))/2.0, (self.frame.size.height-Adapter(70))/2.0, Adapter(70), Adapter(70));
        self.titleLabel.frame = CGRectMake(Adapter(2), CGRectGetMaxY(self.imageV.frame)+Adapter(10), self.frame.size.width-Adapter(2)*2, Adapter(20));
    }else{
        //11.22
        NSString *jlbsName = [GlobalCommon getStringWithLanguageSubjectSn:jlbsName2];
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@推拿手法",jlbsName];
        if([UserShareOnce shareOnce].languageType){
            self.titleLabel.text = jlbsName;
        }
        //11.22
        NSString *imageStr = [GlobalCommon getStringWithSubjectSn:jlbsName2];
        imageStr = [imageStr substringFromIndex:[imageStr length]-1];
        self.imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon",imageStr]];
        self.imageV.frame = CGRectMake((self.frame.size.width-Adapter(55))/2.0, (self.frame.size.height-Adapter(85))/2.0, Adapter(55), Adapter(55));
        self.titleLabel.frame = CGRectMake(2, CGRectGetMaxY(self.imageV.frame)+10, self.frame.size.width-2*2, Adapter(20));
    }
    
}


-(void)insertSublayerFromeView:(UIView *)view
{
    if(!subLayer){
        subLayer=[CALayer layer];
        CGRect fixframe = self.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=8;
        subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        subLayer.masksToBounds=NO;
        subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        subLayer.shadowRadius = 4;//阴影半径，默认3
        [view.layer insertSublayer:subLayer below:self.layer];
    }else{
        subLayer.frame = self.frame;
    }
    
}



@end
