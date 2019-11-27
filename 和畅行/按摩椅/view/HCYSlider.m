//
//  HCYSlider.m
//  和畅行
//
//  Created by 刘晓明 on 2019/9/12.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "HCYSlider.h"
#import "UIButton+ExpandScope.h"
#define Adapterbody(d) (ISPaid ? Adapter(d)*0.8 : Adapter(d))
@interface HCYSlider()

@property (nonatomic,strong) UIView *leftView;
@property (nonatomic) CGFloat hyMaxValue;
@property (nonatomic,strong) UIView *sliderView;
@property (nonatomic,assign) NSInteger myTag;
@end

@implementation HCYSlider

- (void)dealloc
{
    self.leftView = nil;
    self.sliderView = nil;
}

- (id)initWithFrame:(CGRect)frame withTag:(NSInteger )tag{
    self = [super initWithFrame:frame];
    if (self) {
        self.myTag = tag;
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setCurrentSliderValue:(CGFloat)currentSliderValue
{
    _currentSliderValue = currentSliderValue;
    
    //_leftView.frame = CGRectMake(0, 0,currentSliderValue / (_hyMaxValue/self.frame.size.width), self.frame.size.height);
    
    _leftView.frame = CGRectMake(self.sliderView.frame.origin.x, self.sliderView.frame.origin.y,currentSliderValue / (_hyMaxValue/self.sliderView.frame.size.width), self.sliderView.frame.size.height);
}

-(void)setMaxValue:(CGFloat)maxValue{
    
    _hyMaxValue = maxValue;
    
}

-(void)setCurrentValueColor:(UIColor *)currentValueColor{
    
    self.leftView.backgroundColor = currentValueColor;
}

- (void)setup{
    
    
    
    self.sliderView = [[UIView alloc] initWithFrame:CGRectMake(Adapterbody(30), Adapterbody(8), self.frame.size.width -Adapterbody(60), self.frame.size.height - Adapterbody(16))];
    self.sliderView.layer.cornerRadius = (self.frame.size.height - Adapterbody(16))/2.0;
    self.sliderView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
    [self addSubview:self.sliderView];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //addBtn.frame = CGRectMake(0, 0, 15, 15);
    addBtn.frame = CGRectMake(Adapterbody(10), Adapterbody(8), Adapterbody(15), Adapterbody(15));
    [addBtn setBackgroundImage:[UIImage imageNamed:@"按摩_减"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(reduceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    
    UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceBtn.frame = CGRectMake(self.frame.size.width-Adapterbody(25), Adapterbody(8), Adapterbody(15), Adapterbody(15));
    [reduceBtn setBackgroundImage:[UIImage imageNamed:@"按摩_加"] forState:UIControlStateNormal];
    [reduceBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reduceBtn];
    
    [addBtn setHitTestEdgeInsets:UIEdgeInsetsMake(Adapterbody(50), Adapterbody(50), Adapterbody(50), Adapterbody(50))];
    [reduceBtn setHitTestEdgeInsets:UIEdgeInsetsMake(Adapterbody(50), Adapterbody(50), Adapterbody(50), Adapterbody(50))];
    
    /** 数值视图*/
    _leftView = [[UIView alloc]init];
    _leftView.layer.cornerRadius = self.sliderView.frame.size.height/2;
    [self addSubview:_leftView];
    
   
    
    /** 默认最大值*/
    _hyMaxValue = 5.0;

}


- (void)addBtnAction:(UIButton *)button
{
//    if(self.currentSliderValue < 5){
//        self.currentSliderValue += 1;
//    }
    if([self.delegate respondsToSelector:@selector(HCYSliderButtonAction:withTag:)]){
        [self.delegate HCYSliderButtonAction:YES withTag:self.myTag];
    }
    
}


- (void)reduceBtnAction:(UIButton *)button
{
//    if(self.currentSliderValue > 0){
//        self.currentSliderValue -= 1;
//    }
    if([self.delegate respondsToSelector:@selector(HCYSliderButtonAction:withTag:)]){
        [self.delegate HCYSliderButtonAction:NO withTag:self.myTag];
    }
}


@end
