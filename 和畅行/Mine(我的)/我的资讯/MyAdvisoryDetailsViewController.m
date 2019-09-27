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
 
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 , ScreenWidth, 20)];
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
    
    UIImageView *rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 64, timeLab.bottom + 10, 44, 44)];
    rightImageView.image = [UIImage imageNamed:@"右边头像"];
    [scrollView addSubview:rightImageView];
    
    UIImageView *rightTextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70, rightImageView.top, ScreenWidth - 144, 44)];
    UIImage *rihgtimage = [UIImage imageNamed:@"右边对话框"];
    rightTextImageView.userInteractionEnabled = YES;
    rightTextImageView.image = [rihgtimage resizableImageWithCapInsets:UIEdgeInsetsMake(120, 60,60, 100) resizingMode:UIImageResizingModeStretch];

    [scrollView addSubview:rightTextImageView];
    
    UILabel *contentlabel = [[UILabel alloc]init];
    contentlabel.textColor = UIColorFromHex(0X808080);
    contentlabel.font = [UIFont systemFontOfSize:16];
    contentlabel.numberOfLines = 0;
    contentlabel.text = [self.dataDic objectForKey:@"content"];
    [rightTextImageView addSubview:contentlabel];

    CGRect rect = [contentlabel.text boundingRectWithSize:CGSizeMake(rightTextImageView.width - 20, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    float heiget = rect.size.height;
    
    
    contentlabel.frame = CGRectMake(10, 10, rightTextImageView.width - 20, heiget);
  
 
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    

    
    UIScrollView *scrollViews = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 101+heiget, self.view.frame.size.width, 80)];
    [scrollView addSubview:scrollViews];
    
    NSArray *array = [self.dataDic objectForKey:@"userConsultationImages"];
    if(array.count > 4){
        array = [array subarrayWithRange:NSMakeRange(0, 4)];
    }
    if (array.count == 0) {
        rightTextImageView.height = heiget + 20;
    }else{
        // 1. 常见一个发布图片时的photosView
        PYPhotosView * photosView = [PYPhotosView photosViewWithThumbnailUrls:array originalUrls:array];
        photosView.py_x = 5;
        photosView.py_y = contentlabel.bottom + 10;
        photosView.photoWidth =  45;
        photosView.photoHeight = 45 ;
        photosView.photosMaxCol = 4;
        photosView.placeholderImage = [UIImage imageNamed:@"默认1:1"];
        [rightTextImageView addSubview:photosView];
        rightTextImageView.height = heiget + 80;
        if(array.count == 1){
            rightTextImageView.height = heiget + 120;
        }
        if(array.count == 4){
            rightTextImageView.height = heiget + 120;
        }

    }
    [self insertSublayerWithImageView:rightTextImageView with:scrollView];
    scrollViews.contentSize = CGSizeMake(82*array.count+10, 0) ;
    heiget+=100;
    if ([[self.dataDic objectForKey:@"replyUserConsultations"] isEqual:[NSNull null]]) {
        scrollView.contentSize = CGSizeMake(ScreenWidth, rightTextImageView.height + 60 );
    }else{
        
        UILabel *timeLabs = [[UILabel alloc]initWithFrame:CGRectMake(0, rightTextImageView.bottom + 20, ScreenWidth, 20)];
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
        
        UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, timeLabs.bottom + 10, 44, 44)];
        leftImageView.image = [UIImage imageNamed:@"左边头像"];
        [scrollView addSubview:leftImageView];
        
        UIImageView *leftTextImageView = [[UIImageView alloc]initWithFrame:CGRectMake(74, leftImageView.top, ScreenWidth - 134, 44)];
        UIImage *image = [UIImage imageNamed:@"左边对话框"];
        leftTextImageView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height - 15, image.size.width/2, image.size.height - 15, image.size.width/2) resizingMode:UIImageResizingModeStretch];
        [scrollView addSubview:leftTextImageView];
        
        
        CGRect rect = [[[self.dataDic objectForKey:@"replyUserConsultations"]objectForKey:@"content"] boundingRectWithSize:CGSizeMake(leftTextImageView.width - 20, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
        float labelHeight = rect.size.height;
        
        UILabel *replyUserConsultations = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, leftTextImageView.width - 20, labelHeight )];
        replyUserConsultations.numberOfLines = 0;
        replyUserConsultations.text = [NSString stringWithFormat:@"%@",[[self.dataDic objectForKey:@"replyUserConsultations"]objectForKey:@"content"]];
        replyUserConsultations.font = [UIFont systemFontOfSize:16];
        replyUserConsultations.textColor = [UtilityFunc colorWithHexString:@"#7d7d7d"];
        [leftTextImageView addSubview:replyUserConsultations];
        leftTextImageView.height =  labelHeight + 20;
        scrollView.contentSize = CGSizeMake(0, 250 +heiget +labelHeight);
        
        [self insertSublayerWithImageView:leftTextImageView with:scrollView];

        scrollView.contentSize = CGSizeMake(ScreenWidth, rightTextImageView.height + 120 + leftTextImageView.height);
    }
}

#pragma mark - PYPhotosViewDelegate

// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr{
//    previewControlelr.navigationItem.leftBarButtonItem.hidden = YES;
    NSLog(@"进入预览图片");
}


@end
