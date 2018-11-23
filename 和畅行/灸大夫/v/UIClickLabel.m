//
//  UIClickLabel.m
//  Acupoint
//
//  Created by wangdong on 12-11-2.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIClickLabel.h"

@implementation UIClickLabel
@synthesize delegate;
@synthesize mLabelColor;
@synthesize mClickColor;

// 璁剧疆鎹㈣妯″紡,瀛椾綋澶у皬,鑳屾櫙鑹?鏂囧瓧棰滆壊,寮€鍚笌鐢ㄦ埛浜や簰鍔熻兘,璁剧疆label琛屾暟,0涓轰笉闄愬埗
- (id)initWithFrame:(CGRect)frame LabelColor:(UIColor *)labelcolor ClickColor:(UIColor*)clickcolor
{
    if (self = [super initWithFrame:frame])
    {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_5_0        
        [self setLineBreakMode:NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail];
#else
        [self setLineBreakMode:UILineBreakModeWordWrap|UILineBreakModeTailTruncation];
#endif
//        [self setFont:[UIFont systemFontOfSize:fontsize]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTextColor:labelcolor];
        [self setUserInteractionEnabled:YES];
        [self setNumberOfLines:0];
        
        self.mLabelColor = labelcolor;
        self.mClickColor = clickcolor;
    }
    return self;
}

-(void)setClickColor:(UIColor*)cc
{
    self.mLabelColor = self.textColor;
    self.mClickColor = cc;
    [self setBackgroundColor:[UIColor clearColor]];
    [self setUserInteractionEnabled:YES];
    [self setNumberOfLines:0];
}

-(void)addUnderLine {
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.text];
    NSRange range = {0, [self.text length]};
    [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    self.attributedText = attr;
}

-(void)addUnderLine:(NSString*)s {
    if (s != nil) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:s];
        NSRange range = {0, [s length]};
        [attr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
        self.attributedText = attr;
    }
}

// 鐐瑰嚮璇abel鐨勬椂鍊? 鏉ヤ釜楂樹寒鏄剧ず
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTextColor:self.mClickColor];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setTextColor:self.mLabelColor];
}
// 杩樺師label棰滆壊,鑾峰彇鎵嬫寚绂诲紑灞忓箷鏃剁殑鍧愭爣鐐? 鍦╨abel鑼冨洿鍐呯殑璇濆氨鍙互瑙﹀彂鑷畾涔夌殑鎿嶄綔
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setTextColor:self.mLabelColor];
    if(delegate && [delegate respondsToSelector:@selector(onClickLabel:)])
    {
        [delegate onClickLabel:self];
    }
}

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    //    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)dealloc {
    
}


@end
