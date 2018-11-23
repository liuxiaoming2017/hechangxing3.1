//
//  ColumnBar.m
//  ColumnBarDemo
//
//  Created by chenfei on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ColumnBar.h"



@implementation ColumnBar
{
    BOOL _isFirstLoadColumnBar;//是否是第一次加载栏目条
    
    BOOL _isFirstNewsVC;
}
@synthesize scrollView, selectedIndex, dataSource, delegate, enabled;

- (id)initWithFrame:(CGRect)frame withIsFirstNewsVC:(BOOL)isFirstNewsVC
{
    _isFirstNewsVC = isFirstNewsVC;
    self = [self initWithFrame:frame];
    if (self) {

            scrollView.frame = CGRectMake(5, 0, ScreenWidth-40+30, 40);
        
            }

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.enabled = YES;
        
        UIImageView *imageView = [[UIImageView alloc] init];

        imageView.image = [GlobalCommon columnBarImage];

        
        imageView.frame = self.bounds;
        [self addSubview:imageView];
        scrollView = [[UIScrollView alloc] init];
        scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollView.delegate = self;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.userInteractionEnabled = YES;
        [self addSubview:scrollView];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39, ScreenWidth, 1)];
        lineLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0];
        //[self addSubview:lineLabel];
        lastSelectIndex = -1;
    }
    return self;
}

-(void)setColumnBarY:(CGFloat)y{
    
    return;
}

- (void)reloadData:(NSString *)parentColumn
{
    if(scrollView.subviews && scrollView.subviews.count > 0){
        
        for (id object in scrollView.subviews) {
            if ([object isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)object;
                [btn removeObserver:self forKeyPath:@"selected" context:@"KVO_CONTEXT_SELECTED_CHANGED"];
            }
        }
        
        [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if(!self.dataSource)
        return;
    
    int items = [self.dataSource numberOfTabsInColumnBar:self];
    if (items == 0)
        return;
    
    float origin_x = [self configCell:items parentColumn:parentColumn];
    scrollView.contentSize = CGSizeMake(origin_x-10, scrollView.frame.size.height);
    self.selectedIndex = selectedIndex;
}

-(float)configCell:(NSInteger)buttonNummbers parentColumn:(NSString *)parentColumn
{
    int x;
    float origin_x = 5;
    for(x = 0; x < buttonNummbers; x++) {
        
        //添加栏目条按钮
        NSString *column = [self.dataSource columnBar:self titleForTabAtIndex:x];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button addObserver:self forKeyPath:@"selected" options:0 context:@"KVO_CONTEXT_SELECTED_CHANGED"];
        
        CGFloat bottomTagY = 0;
        
        
        button.titleLabel.font = [UIFont systemFontOfSize:16];
            
            NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:button.titleLabel.font, NSFontAttributeName,nil];
            CGSize size = [parentColumn boundingRectWithSize:CGSizeMake(320, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;

        
            button.frame = CGRectMake(origin_x, 0.0f, size.width+5, scrollView.frame.size.height);
        
    
            origin_x += size.width + 15 + 5;
            
            if(buttonNummbers == 1){
                button.frame = CGRectMake((scrollView.width-ScreenWidth/4)/2.0f, button.frame.origin.y, ScreenWidth/4, button.frame.size.height);
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
            }
            
            button.titleLabel.alpha = 1;
            [button setTitle:column forState:UIControlStateNormal];
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromHex(0x1e82d2) forState:UIControlStateSelected];
        [scrollView addSubview:button];
        }
        
    
    return origin_x;
}

#pragma mark KVO method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSString *conText = (__bridge NSString *)context;
    if ([conText isEqualToString:@"KVO_CONTEXT_SELECTED_CHANGED"]) {
        //UIButton *currentButton = (UIButton *)object;
        
            //圆矩形选中背景颜色和未选中背景颜色
           // currentButton.backgroundColor = currentButton.selected ?  [UIColor blackColor] : [UIColor blueColor];
        
    }
}

- (void)buttonClicked:(UIButton *)button
{
    if (!self.enabled) return;

    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (UIButton *btn in scrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
            [buttons addObject:btn];
        }
    }
    
    
    button.selected = YES;
    selectedIndex = (int)[buttons indexOfObject:button];
    CGRect rect = button.frame;
    if (lastSelectIndex < selectedIndex) {
        rect.size.width += self.frame.size.width/3;
    }
    else{
        rect.origin.x -= self.frame.size.width/3;
        if(rect.origin.x < 0)
            rect.origin.x = 0;
    }
    [scrollView scrollRectToVisible:rect animated:YES];
    
    lastSelectIndex = selectedIndex;
    if(self.delegate && [self.delegate respondsToSelector:@selector(columnBar:didSelectedTabAtIndex:)]){
        [self.delegate columnBar:self didSelectedTabAtIndex:selectedIndex];
    }
		
}

-(void)setButtonTitleColor:(UIColor *)color
{
    UIButton *button = (UIButton *)[self.scrollView viewWithTag:500];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateSelected];
    
}

-(NSString *)currentButtonTitle
{
    UIButton *button = (UIButton *)[self.scrollView viewWithTag:500];
    return button.currentTitle;
}


- (void)selectTabAtIndex:(int)index
{
    //selectedIndex = index;
    //lastSelectIndex = selectedIndex;
    [self setSelectedIndex:index];
    if(self.delegate && [self.delegate respondsToSelector:@selector(columnBar:didSelectedTabAtIndex:)])
        [self.delegate columnBar:self didSelectedTabAtIndex:selectedIndex];
   

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)inScrollView
{
    
}

//左右切换栏目时，设置导航条的对应按钮为选中
- (void)setSelectedIndex:(int)index{
    
    selectedIndex = index;
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for (UIButton *btn in scrollView.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            btn.selected = NO;
            [buttons addObject:btn];
        }
    }
    if ([buttons count]==0)
        return;
    UIButton *button = [buttons objectAtIndex:index];
    button.selected = YES;
    
    CGRect rect = button.frame;
    if (lastSelectIndex < selectedIndex) {
        rect.size.width += self.frame.size.width/3;
    }
    else{
        rect.origin.x -= self.frame.size.width/3;
        if(rect.origin.x < 0)
            rect.origin.x = 0;
    }
    [scrollView scrollRectToVisible:rect animated:YES];
}

@end
