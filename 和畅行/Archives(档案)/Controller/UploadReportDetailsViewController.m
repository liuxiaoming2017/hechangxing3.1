//
//  UploadReportDetailsViewController.m
//  和畅行
//
//  Created by Wei Zhao on 2019/9/4.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "UploadReportDetailsViewController.h"
#import "PYPhotosView.h"
@interface UploadReportDetailsViewController ()<PYPhotosViewDelegate>
@property(nonatomic,strong)UIImageView *backImageView;
@end

@implementation UploadReportDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = ModuleZW(@"报告详情");
    self.startTimeStr = [GlobalCommon getCurrentTimes];
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftBtn.hidden = YES;
    self.preBtn.hidden =NO;
    //添加返回按钮
    UIButton *leftBtn = [[UIButton alloc] init];
    //    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    [leftBtn setTitle:ModuleZW(@"返回") forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 50, 50);
    leftBtn.adjustsImageWhenHighlighted = NO;
    //[preBtn sizeToFit];
    leftBtn.titleEdgeInsets = UIEdgeInsetsMake(1, -5, 0, 0);
    leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationController.navigationBar.barTintColor = UIColorFromHex(0x1e82d2);
    
    [self layoutUploadReportDView];
    
 
}



-(void)layoutUploadReportDView{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight  - kNavBarHeight - Adapter(20))];
    [self.view addSubview:scrollView];
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Adapter(15), Adapter(15), ScreenWidth - Adapter(30), ScreenHeight - kNavBarHeight - kTabBarHeight + Adapter(14) )];
    backImageView.layer.cornerRadius = 8.0;
    backImageView.backgroundColor = [UIColor whiteColor];
    backImageView.userInteractionEnabled = YES;
    [scrollView  addSubview:backImageView];
    self.backImageView = backImageView;
    
    backImageView.layer.shadowColor = RGB_TextGray.CGColor;
    backImageView.layer.shadowOffset = CGSizeMake(0,0);
    backImageView.layer.shadowOpacity = 0.5;
    backImageView.layer.shadowRadius = 5;
    
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, Adapter(20) , backImageView.width, Adapter(20))];
    timeLab.font = [UIFont systemFontOfSize:14];
    timeLab.textColor = UIColorFromHex(0X808080);
    NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:[self.model.createDate longValue]/1000.00];
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
    [backImageView addSubview:timeLab];
    
    
    UILabel *answerLabel = [[UILabel alloc]init];
    answerLabel.font = [UIFont systemFontOfSize:12];
    [backImageView addSubview:answerLabel];
    
    
    UILabel *contentlabel = [[UILabel alloc]init];
    contentlabel.textColor = UIColorFromHex(0X808080);
    contentlabel.font = [UIFont systemFontOfSize:16];
    contentlabel.numberOfLines = 0;
    if (![GlobalCommon stringEqualNull:self.model.content]) {
        contentlabel.text = self.model.content;
    }else{
        contentlabel.text = ModuleZW(@"我的上传报告");
    }
    
    [backImageView addSubview:contentlabel];
    
    CGRect rect = [contentlabel.text boundingRectWithSize:CGSizeMake(backImageView.width - 30, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];
    float heiget = rect.size.height;
    
    
    contentlabel.frame = CGRectMake(Adapter(15), timeLab.bottom +Adapter(30), backImageView.width - Adapter(30), heiget);
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];


    PYPhotosView * photosView = [PYPhotosView photosViewWithThumbnailUrls:self.model.pictures originalUrls:self.model.pictures];
    photosView.py_x = Adapter(15);
    photosView.placeholderImage = [UIImage imageNamed:@"默认1:1"];
    photosView.py_y = contentlabel.bottom + Adapter(30);
    photosView.photoWidth =  (backImageView.width-Adapter(50))/4 ;;
    photosView.photoHeight = (backImageView.width-Adapter(50))/4 ; ;
    photosView.photosMaxCol = 4;
    photosView.delegate = self;
    [backImageView addSubview:photosView];

    backImageView.height =  photosView.bottom + Adapter(30);
    scrollView.contentSize = CGSizeMake(ScreenWidth, backImageView.height + Adapter(40));
}

#pragma mark - PYPhotosViewDelegate


// 进入预览图片时调用, 可以在此获得预览控制器，实现对导航栏的自定义
- (void)photosView:(PYPhotosView *)photosView didPreviewImagesWithPreviewControlelr:(PYPhotosPreviewController *)previewControlelr{
    //    previewControlelr.navigationItem.leftBarButtonItem.hidden = YES;
    NSLog(@"进入预览图片");
}



-(void)leftBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.endTimeStr = [GlobalCommon getCurrentTimes];
    [GlobalCommon pageDurationWithpageId:@"59" withstartTime:self.startTimeStr withendTime:self.endTimeStr];
}

@end
