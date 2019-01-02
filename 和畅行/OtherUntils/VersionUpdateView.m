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

+ (instancetype)versionUpdateViewWithContent:(NSString *)content
{
    return [[self alloc] initAlertViewWithContent:content];
}

- (instancetype)initAlertViewWithContent:(NSString *)content
{
    self = [super init];
    if (nil != self) {
        [self setupUI:content];
    }
    return self;
}

- (void)setupUI:(NSString *)content
{
    //300
    CGFloat viewWidth = ScreenWidth*0.73;
    
    // 计算高度，但是如果有换行符，计算不出实际高度
    CGFloat contentH = 0;
    if ([content containsString:@"\r\n"]) {
        NSArray *arr = [content componentsSeparatedByString:@"\r\n"];
        contentH = arr.count*35;
    }else {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
        CGSize size = [content boundingRectWithSize:CGSizeMake(viewWidth-20*2, CGFLOAT_MAX) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        contentH = size.height+40;
    }
    
    UIScrollView *contentBgView = [[UIScrollView alloc] init];
    CGFloat bgViewH = contentH >= 35*4 ? 35*4 : contentH;
    contentBgView.frame = CGRectMake(0, 0, viewWidth, bgViewH);
    contentBgView.contentSize = CGSizeMake(viewWidth, contentH);
    contentBgView.backgroundColor = [UIColor whiteColor];
    
    //设置圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: contentBgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = contentBgView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    contentBgView.layer.mask = maskLayer;
    
    [self addSubview:contentBgView];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = content;
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = 5*kScale;
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:17],
//                                 NSParagraphStyleAttributeName:paragraphStyle
//                                 };
//    //content = [NSString isNilOrEmpty:content] ? @"": content;
//    NSAttributedString *atrStr = [[NSAttributedString alloc] initWithString:contentLabel.text attributes:attributes];
//    contentLabel.attributedText = atrStr;
    contentLabel.frame = CGRectMake(20, 0, viewWidth-20*2, contentH);
    [self addSubview:contentLabel];
    
    UIView *separateView = [[UIView alloc] init];
    separateView.frame = CGRectMake(0, CGRectGetMaxY(contentBgView.frame), viewWidth, 10);
    separateView.backgroundColor = [UIColor whiteColor];
    //separateView.backgroundColor = [UIColor redColor];
   // [self addSubview:separateView];
    
    UIView *line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(0, CGRectGetMaxY(contentLabel.frame), viewWidth, 0.5);
    line1.backgroundColor = UIColorFromHex(0Xbbbbbb);
    [self addSubview:line1];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), viewWidth/2.0f, 50);
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"残忍拒绝" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromHex(0x1e82d2) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelUpdate) forControlEvents:UIControlEventTouchUpInside];
    // 指定角切割圆弧
    [self cutCircleByAngle:cancelBtn AngleType:UIRectCornerBottomLeft];
    [self addSubview:cancelBtn];
    
    UIView *line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(viewWidth/2.0f, cancelBtn.top, 0.5, 50);
    line2.backgroundColor = UIColorFromHex(0Xbbbbbb);;
    [self addSubview:line2];
    
    UIButton *affirmBtn = [[UIButton alloc] init];
    affirmBtn.frame =  CGRectMake(CGRectGetMaxX(line2.frame), cancelBtn.top, viewWidth/2.0f-0.5, 50);
    affirmBtn.backgroundColor = [UIColor whiteColor];
    [affirmBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    [affirmBtn setTitleColor:UIColorFromHex(0x1e82d2) forState:UIControlStateNormal];
    [affirmBtn addTarget:self action:@selector(affirmUpdate) forControlEvents:UIControlEventTouchUpInside];
    [self cutCircleByAngle:affirmBtn AngleType:UIRectCornerBottomRight];
    [self addSubview:affirmBtn];
    
    UIView *line3 = [[UIView alloc] init];
    line3.frame = CGRectMake(line2.left, CGRectGetMaxY(line2.frame), 0.5, 30);
    line3.backgroundColor = UIColorFromHex(0X7f7f7f);
    [self addSubview:line3];
    
    UIButton *cancelBtn2 = [[UIButton alloc] init];
    UIImage *cancelImage = [UIImage imageNamed:@"icon-versionupdate_close"];
    cancelBtn2.frame = CGRectMake((viewWidth-cancelImage.size.width)/2.0f, CGRectGetMaxY(line3.frame), cancelImage.size.width, cancelImage.size.height);
    [cancelBtn2 setImage:cancelImage forState:UIControlStateNormal];
    [cancelBtn2 addTarget:self action:@selector(cancelUpdate) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn2];
 
    
    
    CGFloat viewHeight = contentBgView.height  + line1.height + affirmBtn.height + line3.height + cancelBtn2.height;
    self.frame = CGRectMake((ScreenWidth-viewWidth)/2.0f, (ScreenHeight-viewHeight)/2.0f, viewWidth, viewHeight);
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

@end
