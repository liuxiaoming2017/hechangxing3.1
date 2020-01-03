//
//  VersionUpdateView.m
//  FounderReader-2.5
//
//  Created by Julian on 2016/11/9.
//
//

#import "VersionUpdateView.h"
#import "UIViewExt.h"
//#import "ColorStyleConfig.h"

#define kScale ScreenWidth/375.0

@implementation VersionUpdateView

+ (instancetype)versionUpdateViewWithContent:(NSString *)content type:(NSString *)typeStr
{
    return [[self alloc] initAlertViewWithContent:content type:typeStr];
}

- (instancetype)initAlertViewWithContent:(NSString *)content type:(NSString *)typeStr
{
    self = [super init];
    if (nil != self) {
        [self setupUI:content type:typeStr];
    }
    return self;
}

- (void)setupUI:(NSString *)content type:(NSString *)typeStr
{
    
    if([GlobalCommon stringEqualNull:content]){
        content = @"有更新,是否升级";
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = Adapter(10);
    //300
    CGFloat viewWidth = ScreenWidth*0.73;
    
    UILabel *alerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Adapter(10), viewWidth, Adapter(30))];
    alerLabel. text = ModuleZW(@"发现新版本");
    alerLabel.textColor = RGB_TextOrange;
    alerLabel.textAlignment = NSTextAlignmentCenter;
    alerLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:alerLabel];
    
    // 计算高度，但是如果有换行符，计算不出实际高度
    CGFloat contentH = 0;
    if ([content containsString:@"\r\n"]) {
        NSArray *arr = [content componentsSeparatedByString:@"\r\n"];
        contentH = arr.count*Adapter(35);
    }else {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize size = [content boundingRectWithSize:CGSizeMake(viewWidth-Adapter(20)*2, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        contentH = size.height;
    }
    
    
    
    UIScrollView *contentBgView = [[UIScrollView alloc] init];
    CGFloat bgViewH = contentH >= Adapter(35)*4 ? Adapter(35)*4 : contentH+Adapter(10);
    contentBgView.frame = CGRectMake(0, alerLabel.bottom, viewWidth, bgViewH);
    contentBgView.contentSize = CGSizeMake(viewWidth, bgViewH);

    [self addSubview:contentBgView];
    
    UITextView *contentTextView = [[UITextView alloc] init];
    contentTextView.editable = NO;
    contentTextView.text = content;
    contentTextView.backgroundColor = [UIColor clearColor];
    contentTextView.font = [UIFont systemFontOfSize:14];
    contentTextView.frame = CGRectMake(Adapter(20), 0, viewWidth-Adapter(40), bgViewH);
    [contentBgView addSubview:contentTextView];


    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(Adapter(10), contentBgView.bottom + Adapter(10), (viewWidth-Adapter(30))/2.0f, Adapter(36));
    cancelBtn.backgroundColor = RGB_ButtonBlue;
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelBtn setTitle:ModuleZW(@"残忍拒绝") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelUpdate) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = cancelBtn.height/2;
    cancelBtn.layer.masksToBounds = YES;
    [self addSubview:cancelBtn];
    

    
    UIButton *affirmBtn = [[UIButton alloc] init];
    affirmBtn.frame =  CGRectMake(cancelBtn.right + Adapter(10), cancelBtn.top, cancelBtn.width, Adapter(36));
    affirmBtn.backgroundColor = RGB_ButtonBlue;
    affirmBtn.layer.cornerRadius = affirmBtn.height/2;
    affirmBtn.layer.masksToBounds = YES;
    [affirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [affirmBtn setTitle:ModuleZW(@"立即更新") forState:UIControlStateNormal];
    [affirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [affirmBtn addTarget:self action:@selector(affirmUpdate) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:affirmBtn];
    

    if([typeStr isEqualToString:@"1"]){
        cancelBtn.hidden = YES;
        affirmBtn.frame = CGRectMake(Adapter(30), contentBgView.bottom + Adapter(10), viewWidth -  Adapter(60), Adapter(36));
    }
    
    
    CGFloat viewHeight = contentBgView.height  + Adapter(1) + affirmBtn.height + Adapter(20);
    self.frame = CGRectMake((ScreenWidth-viewWidth)/2.0f , (ScreenHeight-viewHeight)/2.0f - Adapter(25), viewWidth, viewHeight+Adapter(40));
}



- (void)affirmUpdate
{
    if (self.versionUpdateBlock) {
        self.versionUpdateBlock(YES);
    }
}

- (void)cancelUpdate
{
    if (self.versionUpdateBlock) {
        self.versionUpdateBlock(NO);
    }
}

- (void)cutCircleByAngle:(UIView *)view AngleType:(UIRectCorner)corners
{
    // 指定角切圆弧 maskPath、maskLayer变量不能重新赋值给别的view，因为运行时才发生切割
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = view.bounds;
    maskLayer1.path = maskPath1.CGPath;
    view.layer.mask = maskLayer1;
}


//-----------------购买弹框界面-----------------------
+ (instancetype)showWeiGouMaiViewWithContent:(NSString *)content
{
    return [[self alloc] initShowWeiGouMaiViewWithContent:content];
}

- (instancetype)initShowWeiGouMaiViewWithContent:(NSString *)content
{
    self = [super init];
    if (nil != self) {
        [self createUIWithContent:content];
    }
    return self;
}

- (void)createUIWithContent:(NSString *)content
{
    self.backgroundColor = [UIColor clearColor];
    
    //300
    CGFloat viewWidth = ScreenWidth*0.73;
    
    
    // 计算高度，但是如果有换行符，计算不出实际高度
    CGFloat contentH = 0;
    if ([content containsString:@"\r\n"]) {
        NSArray *arr = [content componentsSeparatedByString:@"\r\n"];
        contentH = arr.count*Adapter(35);
    }else {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize size = [content boundingRectWithSize:CGSizeMake(viewWidth-30, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        contentH = size.height;
    }
    
    CGFloat topMargin = 60;
    
    UIScrollView *contentBgView = [[UIScrollView alloc] init];
    contentBgView.frame = CGRectMake(0, topMargin, viewWidth, 200);
    contentBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentBgView];
    
    UIImageView *topImageV = [[UIImageView alloc] initWithFrame:CGRectMake((contentBgView.width-180)/2.0, 0, 180, 156)];
    topImageV.image = [UIImage imageNamed:@"未购买"];
    [self addSubview:topImageV];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, topImageV.height-topMargin+20, viewWidth-30,contentH)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = content;
    [contentBgView addSubview:titleLabel];
    
    
    UIButton *affirmBtn = [[UIButton alloc] init];
    affirmBtn.frame =  CGRectMake((contentBgView.width - 150)/2.0, titleLabel.bottom+20, 150, 35);
    affirmBtn.backgroundColor = RGB_ButtonBlue;
    affirmBtn.layer.cornerRadius = affirmBtn.height/2;
    affirmBtn.layer.masksToBounds = YES;
    [affirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [affirmBtn setTitle:@"去购买" forState:UIControlStateNormal];
    [affirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [affirmBtn addTarget:self action:@selector(affirmUpdate) forControlEvents:UIControlEventTouchUpInside];
    [contentBgView addSubview:affirmBtn];
    
    
    contentBgView.height = affirmBtn.bottom + 20;
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake((viewWidth-Adapter(36))/2.0, contentBgView.bottom + Adapter(10), Adapter(36), Adapter(36));
    [cancelBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelUpdate) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    

    CGFloat viewHeight = topMargin + contentBgView.height  + Adapter(1) + cancelBtn.height + Adapter(20);
    
    self.frame = CGRectMake((ScreenWidth-viewWidth)/2.0f , (ScreenHeight-viewHeight)/2.0, viewWidth, viewHeight);
}

@end
