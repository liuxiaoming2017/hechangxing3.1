//
//  NoteView.m
//  和畅行
//
//  Created by 刘晓明 on 2019/10/27.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "NoteView.h"

@interface NoteView ()

@property (nonatomic,strong) CALayer *subLayer;

@end

@implementation NoteView
@synthesize subLayer;

+ (instancetype)noteViewInitUIWithContent:(NSString *)content
{
    return [[self alloc] initUIwithContent:content];
}

- (instancetype)initUIwithContent:(NSString *)content
{
    self = [super init];
    if (nil != self) {
        [self setupUI:content];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        //[self setupUI];
    }
    return self;
}

- (void)setupUI:(NSString *)content
{
    self.backgroundColor = [UIColor whiteColor];
    
//    self.layer.borderWidth = 1.0;
//    self.layer.borderColor = [UIColor blackColor].CGColor;
//
    
    CGFloat viewWidth = ScreenWidth-30;
    
    // 计算高度，但是如果有换行符，计算不出实际高度
    CGFloat contentH = ScreenHeight-kNavBarHeight*4;
    
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,viewWidth , contentH)];
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.layer.cornerRadius = 10;
    backImageView.layer.masksToBounds = YES;
    backImageView.userInteractionEnabled = YES;
    [self  insertSublayerWithImageView:backImageView];
    [self addSubview:backImageView];
    
    
//    if ([content containsString:@"\r\n"]) {
//        NSArray *arr = [content componentsSeparatedByString:@"\r\n"];
//        contentH = arr.count*35;
//    }else {
//        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
//        CGSize size = [content boundingRectWithSize:CGSizeMake(viewWidth, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//        contentH = size.height;
//    }
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5, viewWidth, contentH)];
    [self addSubview:textView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSString *noteStr = yueYaoNote;
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:noteStr attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 17],NSForegroundColorAttributeName: [UIColor blackColor],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    textView.attributedText = string2;
    textView.editable = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.textAlignment = NSTextAlignmentLeft;
    
    self.frame = CGRectMake((ScreenWidth-viewWidth)/2.0, (ScreenHeight-contentH)/2.0, viewWidth, contentH);
    
    //遮罩
    UIView *styleView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    styleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    styleView.tag = 8888;
    styleView.alpha = 0.3;
    styleView.backgroundColor = [UIColor grayColor];
    [[UIApplication sharedApplication].keyWindow addSubview:styleView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [styleView addGestureRecognizer:tap];
    
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
    UIView *styleView = (UIView *)[[UIApplication sharedApplication].keyWindow viewWithTag:8888];
    [styleView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)insertSublayerWithImageView:(UIImageView *)imageV
{
    if(!subLayer){
        subLayer=[CALayer layer];
        CGRect fixframe = imageV.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=8;
        subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        subLayer.masksToBounds=NO;
        subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        subLayer.shadowRadius = 4;//阴影半径，默认3
        [self.layer insertSublayer:subLayer below:imageV.layer];
    }else{
        subLayer.frame = imageV.frame;
    }
    
}

@end
