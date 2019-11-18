//
//  MyAdvisoryDetailsViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/12.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "MyAdvisoryDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "PYPhotosView.h"
@interface MyAdvisoryDetailsViewController ()<PYPhotosViewDelegate>
@property (nonatomic,strong)UITableView *myTableView;
@end

@implementation MyAdvisoryDetailsViewController
- (void)dealloc{
   
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = ModuleZW(@"咨询详情");
    

    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, self.view.frame.size.width, self.view.frame.size.height  - kNavBarHeight )];
    scrollView.backgroundColor = RGB_AppWhite;
    [self.view addSubview:scrollView];
 
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenWidth*0.053 , ScreenWidth, ScreenWidth*0.053)];
    timeLab.font = [UIFont systemFontOfSize:14];
    timeLab.textColor = UIColorFromHex(0X808080);
    NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:[[self.dataDic  objectForKey:@"modifyDate"] doubleValue]/1000.00];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd- HH:mm:ss"];
    if([UserShareOnce shareOnce].languageType){
        [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    }else{
        [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"us"]];//location设置为中国

    }
    
    NSString *confromTimespStr = [formatter stringFromDate:data];
    timeLab.text = confromTimespStr;
    timeLab.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:timeLab];
    
    UILabel *answerLabel = [[UILabel alloc]init];
    answerLabel.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:answerLabel];
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - ScreenWidth*0.17, timeLab.bottom + Adapter(10), ScreenWidth*0.118, ScreenWidth*0.118)];
    rightImageView.image = [UIImage imageNamed:@"右边头像"];
    [scrollView addSubview:rightImageView];
    
    UIImageView *rightTextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth*0.186, rightImageView.top, ScreenWidth - ScreenWidth*0.118 - ScreenWidth*0.26, ScreenWidth*0.118)];
    UIImage *rihgtimage = [UIImage imageNamed:@"右边对话框"];
    rightTextImageView.userInteractionEnabled = YES;
//    rightTextImageView.image = [rihgtimage resizableImageWithCapInsets:UIEdgeInsetsMake(120, 60,60, 100) resizingMode:UIImageResizingModeStretch];

    [scrollView addSubview:rightTextImageView];
    
    UILabel *contentlabel = [[UILabel alloc]init];
    contentlabel.textColor = UIColorFromHex(0X808080);
    contentlabel.font = [UIFont systemFontOfSize:16];
    contentlabel.numberOfLines = 0;
    contentlabel.text = [self.dataDic objectForKey:@"content"];
    [rightTextImageView addSubview:contentlabel];

    CGRect rect = [contentlabel.text boundingRectWithSize:CGSizeMake(rightTextImageView.width - Adapter(20), 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    float heiget = rect.size.height;
    
    if (heiget<rightImageView.height) {
        heiget = rightImageView.height;
    }
    contentlabel.frame = CGRectMake(Adapter(10), Adapter(10), rightTextImageView.width - Adapter(20), heiget);
  
 
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    

    
    UIScrollView *scrollViews = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ScreenWidth*0.27+heiget, self.view.frame.size.width, ScreenWidth*0.21)];
    [scrollView addSubview:scrollViews];
    
    NSArray *array = [self.dataDic objectForKey:@"userConsultationImages"];
    if(array.count > 4){
        array = [array subarrayWithRange:NSMakeRange(0, 4)];
    }
    if (array.count == 0) {
        rightTextImageView.height = heiget + Adapter(20);
    }else{
        // 1. 常见一个发布图片时的photosView
        PYPhotosView * photosView = [PYPhotosView photosViewWithThumbnailUrls:array originalUrls:array];
        photosView.py_x = Adapter(5);
        photosView.py_y = contentlabel.bottom + Adapter(10);
        photosView.photoWidth =  ScreenWidth*0.12;
        photosView.photoHeight = ScreenWidth*0.12 ;
        photosView.photosMaxCol = 4;
        photosView.placeholderImage = [UIImage imageNamed:@"默认1:1"];
        [rightTextImageView addSubview:photosView];
        rightTextImageView.height = heiget + ScreenWidth*0.213;
        if(array.count == 1 || array.count == 4){
            rightTextImageView.height = heiget + ScreenWidth*0.32;
        }
        if(ISPaid) {
            if(array.count == 1){
                  rightTextImageView.height = heiget + ScreenWidth*0.15;
            }
        }
    }
    [self insertSublayerWithImageView:rightTextImageView with:scrollView];
    scrollViews.contentSize = CGSizeMake(ScreenWidth*0.22*array.count+Adapter(10), 0) ;
    heiget+=ScreenWidth*0.27;
    if ([[self.dataDic objectForKey:@"replyUserConsultations"] isEqual:[NSNull null]]) {
        scrollView.contentSize = CGSizeMake(ScreenWidth, rightTextImageView.height + ScreenWidth*0.16 );
    }else{
        
        UILabel *timeLabs = [[UILabel alloc]initWithFrame:CGRectMake(0, rightTextImageView.bottom + ScreenWidth*0.053, ScreenWidth, ScreenWidth*0.053)];
        timeLabs.font = [UIFont systemFontOfSize:14];
        timeLabs.textColor = UIColorFromHex(0X808080);
        NSDate *datas = [[NSDate alloc]initWithTimeIntervalSince1970:[[[[self.dataDic objectForKey:@"replyUserConsultations"]objectForKey:@"memberChild"] objectForKey:@"modifyDate"] doubleValue]/1000.00];
        NSDateFormatter *formatters = [[NSDateFormatter alloc] init];
        [formatters setDateStyle:NSDateFormatterMediumStyle];
        [formatters setTimeStyle:NSDateFormatterShortStyle];
        [formatters setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        if([UserShareOnce shareOnce].languageType){
            [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        }else{
            [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"us"]];//location设置为中国
            
        }
        
        NSString *confromTimespStrs = [formatters stringFromDate:datas];
        timeLabs.text = confromTimespStrs;
        timeLabs.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:timeLabs];
        
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth*0.053, timeLabs.bottom + ScreenWidth*0.027, ScreenWidth*0.117, ScreenWidth*0.117)];
        leftImageView.image = [UIImage imageNamed:@"左边头像"];
        [scrollView addSubview:leftImageView];
        
        UIImageView *leftTextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth*0.197, leftImageView.top, ScreenWidth - ScreenWidth*0.357, ScreenWidth*0.117)];
        UIImage *image = [UIImage imageNamed:@"左边对话框"];
        leftTextImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height - 15, image.size.width/2, image.size.height - 15, image.size.width/2) resizingMode:UIImageResizingModeStretch];
        [scrollView addSubview:leftTextImageView];
        
        
        CGRect rect = [[[self.dataDic objectForKey:@"replyUserConsultations"]objectForKey:@"content"] boundingRectWithSize:CGSizeMake(leftTextImageView.width - 20, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        float labelHeight = rect.size.height;
        
        UILabel *replyUserConsultations = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(10), Adapter(10), leftTextImageView.width - Adapter(20), labelHeight )];
        replyUserConsultations.numberOfLines = 0;
        replyUserConsultations.text = [NSString stringWithFormat:@"%@",[[self.dataDic objectForKey:@"replyUserConsultations"]objectForKey:@"content"]];
        replyUserConsultations.font = [UIFont systemFontOfSize:16];
        replyUserConsultations.textColor = [UtilityFunc colorWithHexString:@"#7d7d7d"];
        [leftTextImageView addSubview:replyUserConsultations];
        leftTextImageView.height =  labelHeight + Adapter(20);
        scrollView.contentSize = CGSizeMake(0, ScreenWidth*0.67 +heiget +labelHeight);
        
        [self insertSublayerWithImageView:leftTextImageView with:scrollView];

        scrollView.contentSize = CGSizeMake(ScreenWidth, rightTextImageView.height + ScreenWidth*0.32 + leftTextImageView.height);
    }
}

#pragma mark - PYPhotosViewDelegate

// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr{
//    previewControlelr.navigationItem.leftBarButtonItem.hidden = YES;
    NSLog(@"进入预览图片");
}


@end
