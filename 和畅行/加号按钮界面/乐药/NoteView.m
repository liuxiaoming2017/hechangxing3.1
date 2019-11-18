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

@property (nonatomic,copy) NSString *typeStr;

@end

@implementation NoteView
@synthesize subLayer;

+ (instancetype)noteViewInitUIWithContent:(NSString *)content withTypeStr:(NSString *)str
{
    return [[self alloc] initUIwithContent:content withTypeStr:str];
}

- (instancetype)initUIwithContent:(NSString *)content withTypeStr:(NSString *)str
{
    self = [super init];
    if (nil != self) {
        self.typeStr = str;
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
    self.layer.cornerRadius = 8.0;
//    self.layer.borderWidth = 1.0;
//    self.layer.borderColor = [UIColor blackColor].CGColor;
//
    
    CGFloat viewWidth = ScreenWidth-30;
    
    // 计算高度，但是如果有换行符，计算不出实际高度
    CGFloat contentH = ScreenHeight-kNavBarHeight*2.5;
    
    UILabel *alerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, viewWidth, 26)];
    alerLabel. text = @"解读";
    alerLabel.textColor = RGB_TextOrange;
    alerLabel.textAlignment = NSTextAlignmentCenter;
    alerLabel.font = [UIFont systemFontOfSize:17.0];
    [self addSubview:alerLabel];
    
//    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,viewWidth , contentH)];
//    backImageView.backgroundColor = [UIColor whiteColor];
//    backImageView.layer.cornerRadius = 10;
//    backImageView.layer.masksToBounds = YES;
//    backImageView.userInteractionEnabled = YES;
//    [self  insertSublayerWithImageView:backImageView];
//    [self addSubview:backImageView];
    
    
//    if ([content containsString:@"\r\n"]) {
//        NSArray *arr = [content componentsSeparatedByString:@"\r\n"];
//        contentH = arr.count*35;
//    }else {
//        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
//        CGSize size = [content boundingRectWithSize:CGSizeMake(viewWidth, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//        contentH = size.height;
//    }
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(5, alerLabel.bottom, viewWidth-10, contentH-alerLabel.bottom-5-46)];
    [self addSubview:textView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.lineSpacing = 5;
    
    NSString *noteStr = content;
    
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:noteStr attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFang SC" size: 16.0*[UserShareOnce shareOnce].fontSize],NSForegroundColorAttributeName: [UIColor blackColor],NSParagraphStyleAttributeName:paragraphStyle.copy}];
    
    textView.attributedText = string2;
    textView.editable = NO;
    textView.showsVerticalScrollIndicator = NO;
    textView.textAlignment = NSTextAlignmentLeft;
    
    self.frame = CGRectMake((ScreenWidth-viewWidth)/2.0, (ScreenHeight-contentH)/2.0, viewWidth, contentH);
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(10, textView.bottom + 8, (viewWidth-30)/2.0f, 36);
    cancelBtn.backgroundColor = RGB_ButtonBlue;
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelUpdate) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 8;
    cancelBtn.layer.masksToBounds = YES;
    [self addSubview:cancelBtn];
    
    
    
    UIButton *affirmBtn = [[UIButton alloc] init];
    affirmBtn.frame =  CGRectMake(cancelBtn.right + 10, cancelBtn.top, cancelBtn.width, 36);
    affirmBtn.backgroundColor = RGB_ButtonBlue;
    affirmBtn.layer.cornerRadius = 8;
    affirmBtn.layer.masksToBounds = YES;
    [affirmBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [affirmBtn setTitle:@"不再提示" forState:UIControlStateNormal];
    [affirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [affirmBtn addTarget:self action:@selector(affirmUpdate) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:affirmBtn];
    
    
    //遮罩
    UIView *styleView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];
    styleView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    styleView.tag = 8888;
    styleView.backgroundColor = RGBA(0, 0, 0, 0.55);
    [[UIApplication sharedApplication].keyWindow addSubview:styleView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [styleView addGestureRecognizer:tap];
    
}

- (void)affirmUpdate
{
    [self removeView];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([self.typeStr isEqualToString:hintYueYao]){ //乐药
        [userDefaults setObject:hintYueYao forKey:hintYueYao];
    }else if ([self.typeStr isEqualToString:hintTuiNa]){
        [userDefaults setObject:hintTuiNa forKey:hintTuiNa];
    }
    [userDefaults synchronize];
}

- (void)cancelUpdate
{
    [self removeView];
}

- (void)tapAction:(UIGestureRecognizer *)gesture
{
    [self removeView];
}

- (void)removeView
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
