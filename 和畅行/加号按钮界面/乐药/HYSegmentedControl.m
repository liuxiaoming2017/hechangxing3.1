//
//  HYSegmentedControl.m
//  CustomSegControlView
//
//  Created by sxzw on 14-6-12.
//  Copyright (c) 2014年 sxzw. All rights reserved.
//

#import "HYSegmentedControl.h"

#define HYSegmentedControl_Height Adapter(32)
#define HYSegmentedControl_Width ([UIScreen mainScreen].bounds.size.width)
#define Min_Width_4_Button Adapter(80)

#define Define_Tag_add 1000

#define UIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HYSegmentedControl()

@property (strong, nonatomic)UIScrollView *scrollView;
@property (strong, nonatomic)NSMutableArray *array4Btn;
@property (strong, nonatomic)UIView *bottomLineView;

@end

@implementation HYSegmentedControl
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithOriginY:(CGFloat)y Titles:(NSArray *)titles delegate:(id)delegate
{
    CGRect rect4View = CGRectMake(.0f, y, HYSegmentedControl_Width, HYSegmentedControl_Height);
    if (self = [super initWithFrame:rect4View]) {
        
        self.backgroundColor = UIColorFromRGBValue(0xf3f3f3);
        [self setUserInteractionEnabled:YES];
        
        self.delegate = delegate;
        
        //
        //  array4btn
        //
        _array4Btn = [[NSMutableArray alloc] initWithCapacity:[titles count]];
        
        
        //
        //  set button
        //
        CGFloat width4btn = rect4View.size.width/[titles count];
        //if (width4btn < Min_Width_4_Button) {
          //  width4btn = Min_Width_4_Button;
        //}
        
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = RGB_AppWhite;
        _scrollView.userInteractionEnabled = YES;
        
        _scrollView.contentSize = CGSizeMake([titles count]*width4btn, HYSegmentedControl_Height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        
       
        
        for (int i = 0; i<[titles count]; i++) {
            
            CGRect textRect = [titles[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, HYSegmentedControl_Height)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                      context:nil];
            
            CGFloat with = textRect.size.width + Adapter(26);
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if(!FIRST_FLAG){
                CGFloat marginW = ScreenWidth/5.0-6;
                CGFloat btnW = with > marginW ? marginW : with;
                with = btnW;
                NSString *str = [titles objectAtIndex:i];
                NSString *title = [[str componentsSeparatedByString:@" "] objectAtIndex:0];
                [btn setTitle:title forState:UIControlStateNormal];
            }else{
                [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            }
            btn.frame = CGRectMake(ScreenWidth*(2*i+1)/(titles.count*2) -with/2 , .0f, with, HYSegmentedControl_Height);
            [btn setTitleColor:RGB_TextAppGray forState:UIControlStateNormal];
            btn.layer.borderColor = [RGB_TextAppGray CGColor];
            btn.layer.borderWidth = 0.5f;
            btn.layer.cornerRadius = btn.height/2;
            btn.layer.masksToBounds = YES;
            [btn setBackgroundColor:RGB_AppWhite];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            btn.titleLabel.font=[UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(segmentedControlChange:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = Define_Tag_add+i;
            [_scrollView addSubview:btn];
            [_array4Btn addObject:btn];
        }

        [self addSubview:_scrollView];
    }
    return self;
}
-(void) setBtnorline:(NSArray*) titles
{
    for (int i=0; i<titles.count; i++) {
        CGRect textRect = [titles[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, HYSegmentedControl_Height)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                  context:nil];
        CGFloat with = textRect.size.width + Adapter(26);
        UIButton* btn=[_array4Btn objectAtIndex:i];
        //btn.titleLabel.text=[titles objectAtIndex:i];
        if(!FIRST_FLAG){
            CGFloat marginW = ScreenWidth/5.0-6;
            CGFloat btnW = with > marginW ? marginW : with;
            with = btnW;
            NSString *str = [titles objectAtIndex:i];
            NSString *title = [[str componentsSeparatedByString:@" "] objectAtIndex:0];
            [btn setTitle:title forState:UIControlStateNormal];
        }else{
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        }
         btn.frame = CGRectMake(ScreenWidth*(2*i+1)/(titles.count*2) -with/2 , .0f, with, HYSegmentedControl_Height);
    }
}

-(NSMutableArray*) GetSegArray
{
    return _array4Btn;
}
//
//  btn clicked
//

- (void)segmentedControlChange:(UIButton *)btn
{
    btn.selected = YES;
    [btn setBackgroundColor:RGB(51, 151, 238)];
    btn.layer.borderWidth = 0.0f;
    for (UIButton *subBtn in _array4Btn) {
        if (subBtn != btn) {
            subBtn.selected = NO;
            subBtn.layer.borderWidth = 0.5f;
            [subBtn setBackgroundColor:RGB_AppWhite];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(hySegmentedControlSelectAtIndex:)]) {
        [self.delegate hySegmentedControlSelectAtIndex:btn.tag - 1000];
    }
}


// delegete method
- (void)changeSegmentedControlWithIndex:(NSInteger)index
{
    if (index > [_array4Btn count]-1) {
        NSLog(@"index 超出范围");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"index 超出范围" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
        return;
    }
    
    UIButton *btn = [_array4Btn objectAtIndex:index];
    [self segmentedControlChange2:btn];
}


- (void)segmentedControlChange2:(UIButton *)btn
{
    btn.selected = YES;
    [btn setBackgroundColor:RGB(51, 151, 238)];
    btn.layer.borderWidth = 0.0f;
    for (UIButton *subBtn in _array4Btn) {
        if (subBtn != btn) {
            subBtn.selected = NO;
            subBtn.layer.borderWidth = 1.0f;
            [subBtn setBackgroundColor:RGB_AppWhite];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(hySegmentedControlSelectAtIndex:)]) {
        [self.delegate hySegmentedControlSelectAtIndex:btn.tag - 1000];
    }
}


@end
