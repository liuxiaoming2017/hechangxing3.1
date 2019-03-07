//
//  SportViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/13.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "SportViewController.h"

#import "AMPopTip.h"
#import "NIDropDown.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "MBProgressHUD.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SubMemberView.h"

#define MENU_POPOVER_FRAME  CGRectMake(8, 0, 140, 88)
#define kTabsHeight 46.5
#define LeftWidth 36.5
#define SingWidth 2
#define SflowviewHeight 64
#define WIDTH self.view.frame.size.width
#define HEIGHT self.view.frame.size.height

#define imageW ScreenWidth * 0.98
#define imageH ScreenHeight * 0.83


@interface SportViewController ()<UIScrollViewDelegate,NIDropDownDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate,MBProgressHUDDelegate,UIScrollViewDelegate,AVAudioPlayerDelegate>
{
    
    MBProgressHUD* progress_;
    UIButton *voiceButton;
    NSMutableArray *ImagesArray;
    NSTimer* playTime;
    NSTimer* playmp3;
    NSInteger  countstr;
    NIDropDown *dropDown;
    int AllAppCount;
    int AppCount;
    NSTimer *zongTime;
    UIView *yingcangView;
    NSTimer *timer;
    
    NSInteger pindex;
}
@property (nonatomic ,assign) NSInteger count;
@property (nonatomic ,assign) NSInteger shifanyinCount;
//@property (nonatomic ,strong) NSTimer *playmp3;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) AVAudioPlayer *play;
@property (nonatomic ,strong) NSMutableArray *dicArray;
@property (nonatomic, strong) AMPopTip *popTip;
@property (strong,nonatomic)UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *ScrollView;
@property (strong,nonatomic)UIScrollView *scrollImgView;
@property (strong,nonatomic)NSMutableArray *slideImages;
@property (strong,nonatomic)NSMutableArray *slideImagesYB;
@property (strong,nonatomic)NSMutableArray *slideImages1;
@property (strong,nonatomic)NSMutableArray *slideImages2;
@property (strong,nonatomic)NSMutableArray *slideImages3;
@property (strong,nonatomic)NSMutableArray *slideImages4;
@property (strong,nonatomic)NSMutableArray *slideImages5;
@property (strong,nonatomic)NSMutableArray *slideImages6;
@property (strong,nonatomic)NSMutableArray *slideImages7;
@property (strong,nonatomic)NSMutableArray *slideImages8;

@property (nonatomic ,strong) NSString * strtitle;

//@property (nonatomic, strong) CafRecordWriter *cafWriter;
//@property (nonatomic, strong) AmrRecordWriter *amrWriter;
@property(nonatomic,strong) NSArray *menuItems;
@property (nonatomic ,strong) NSMutableArray *shifanyinArray;
@property (nonatomic ,strong) NSMutableArray *shifanyinPlayArr;
@property (nonatomic ,strong) NSMutableArray *shifanyinDicArr;
@property (nonatomic ,strong) AVAudioPlayer *shifanyinPlay;
@property (nonatomic ,strong) NSTimer *shifanyinTime;
@property (nonatomic ,strong) UIButton *leyaoButton;
@property (nonatomic ,strong) UIButton *shifanyinButton;
@property (nonatomic ,strong) NSMutableArray *titleArray;
@property (nonatomic ,strong) NSMutableArray *titlesArray;
@property (nonatomic ,assign) int bofangCount;
/**CountBtn*/
@property (nonatomic,strong) UIButton *countBtn;
@property (nonatomic ,strong) NSDictionary *styleDictionary;

@end

@implementation SportViewController
@synthesize pageControl;
@synthesize ScrollView;
@synthesize scrollImgView;
@synthesize slideImages,slideImagesYB,slideImages1,slideImages2,slideImages3,slideImages4,slideImages5,slideImages6,slideImages7,slideImages8;

-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //显示子账户列表
    [self showChildView];
    
    
}

- (void)setup{
    // Do any additional setup after loading the view.
    self.titlesArray = [[NSMutableArray alloc]init];
    self.titleArray = [NSMutableArray arrayWithObjects:@"gf_tp_yubeidongzuo_0",@"gf_tp_yubeidongzuo_1",@"gf_tp_qishi_0",@"gf_tp_qishi_1",@"gf_tp_1_0",@"gf_tp_1_1",@"gf_tp_1_2",@"gf_tp_1_3",@"gf_tp_1_4",@"gf_tp_2_0",@"gf_tp_2_1",@"gf_tp_2_2",@"gf_tp_2_3",@"gf_tp_2_4",@"gf_tp_3_0",@"gf_tp_3_1",@"gf_tp_3_2",@"gf_tp_3_3",@"gf_tp_3_4",@"gf_tp_4_0",@"gf_tp_4_1",@"gf_tp_4_2",@"gf_tp_4_3",@"gf_tp_4_4",@"gf_tp_5_0",@"gf_tp_5_1",@"gf_tp_5_2",@"gf_tp_5_3",@"gf_tp_5_4",@"gf_tp_6_0",@"gf_tp_6_1",@"gf_tp_6_2",@"gf_tp_6_3",@"gf_tp_shoushi_0",@"gf_tp_shoushi_1", nil];
    
    
    self.shifanyinArray = [[NSMutableArray alloc]init];
    self.shifanyinPlayArr = [[NSMutableArray alloc]init];
    self.shifanyinDicArr = [[NSMutableArray alloc]init];
    self.count = 0;
    self.shifanyinCount = 0;
    pindex = _integ;
    
    self.navTitleLabel.text = @"和畅经络运动";
   
    self.dicArray = [[NSMutableArray alloc]init];
    self.dataArray = [[NSMutableArray alloc]init];
    self.menuItems = [NSArray arrayWithObjects:@"YD_JingYin.png", @"YD_YInYueSF.png", @"YD_BF.png",nil];
    self.view.backgroundColor=UIColorFromHex(0x407deb);
    //UIImage* leftImg=[UIImage imageNamed:@"New_bofang.png"];
    
    
    //定时器循环
    
    playTime=[NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    //[playTime setFireDate:[NSDate distantFuture]];
    //初始化scrollImgView
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, ScreenWidth, ScreenHeight-44-70)];
    scrollView.bounces = YES;
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollImgView=scrollView;
    [self.view addSubview:self.scrollImgView];
    UIImage* Img_SetSCR=[UIImage imageNamed:@"Newiphone5_gf_tp_yubeidongzuo_0.png"];
    UIImage* TypeImg=[UIImage imageNamed:@"YD_Type.png"];
    UIImageView* TypeImgView=[[UIImageView alloc] init];
    //    TypeImgView.frame=CGRectMake((ScreenWidth-Img_SetSCR.size.width/2)/2, 64, TypeImg.size.width/2, TypeImg.size.height/2);
    
#pragma mark 1/5
    //    TypeImgView.frame=CGRectMake((ScreenWidth-Img_SetSCR.size.width)/2, 84, TypeImg.size.width/2, TypeImg.size.height/2);
    TypeImgView.frame=CGRectMake((ScreenWidth- imageW)/2, 74, TypeImg.size.width/2, TypeImg.size.height/2);
    
    TypeImgView.image=TypeImg;
    [self.view addSubview:TypeImgView];
    yingcangView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, self.view.frame.size.width, self.view.frame.size.height - 115)];
    yingcangView.userInteractionEnabled = YES;
    yingcangView.hidden = YES;
    [[[UIApplication  sharedApplication]keyWindow]addSubview:yingcangView];
    UIButton* CountTypebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    CountTypebtn.frame=CGRectMake(TypeImgView.frame.origin.x, 74, TypeImgView.frame.size.width, TypeImg.size.height/3-10);
    CountTypebtn.titleLabel.font=[UIFont systemFontOfSize:12];
    //        leftallActive
    [CountTypebtn addTarget:self action:@selector(leftallActive:) forControlEvents:UIControlEventTouchUpInside];
    CountTypebtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [CountTypebtn setTitle:@"预备" forState:UIControlStateNormal];
    [CountTypebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CountTypebtn.tag=10001;
    [self.view addSubview:CountTypebtn];
    
    UIButton* CountBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    CountBtn.frame=CGRectMake(TypeImgView.frame.origin.x, CountTypebtn.frame.origin.y+CountTypebtn.frame.size.height, TypeImgView.frame.size.width, TypeImg.size.height/3-30);
    CountBtn.titleLabel.font=[UIFont systemFontOfSize:11];
    CountBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    if ([self.countStr isEqualToString:@"5"]) {
        [CountBtn setTitle:@"1/5" forState:UIControlStateNormal];
    }else{
        [CountBtn setTitle:@"1/35" forState:UIControlStateNormal];
    }
    CountBtn.tag=10002;
    [CountBtn addTarget:self action:@selector(leftallActive:) forControlEvents:UIControlEventTouchUpInside];
    
    [CountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.countBtn = CountBtn;
    [self.view addSubview:CountBtn];
    
    UIImage* DownImg=[UIImage imageNamed:@"DownImg.png"];
    UIButton* DownBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    DownBtn.frame=CGRectMake(TypeImgView.frame.origin.x+(TypeImgView.frame.size.width-DownImg.size.width/2)/2, CountBtn.frame.origin.y+CountBtn.frame.size.height+6, DownImg.size.width/2, DownImg.size.height/2);
    [DownBtn setImage:DownImg forState:UIControlStateNormal];
    [DownBtn addTarget:self action:@selector(leftallActive:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:DownBtn];
    
    UILabel* Sport_Title_Lb=[[UILabel alloc] init];
    Sport_Title_Lb.frame=CGRectMake((ScreenWidth-200)/2, CountTypebtn.frame.origin.y+20, 200, 21);
    Sport_Title_Lb.text=@"预备11";
    Sport_Title_Lb.textAlignment=1;
    Sport_Title_Lb.tag=10005;
    Sport_Title_Lb.font=[UIFont systemFontOfSize:15];
    Sport_Title_Lb.textColor=[UtilityFunc colorWithHexString:@"#666666"];
    //[self.view addSubview:Sport_Title_Lb];
    
    self.popTip = [AMPopTip popTip];
    
    // 初始化 数组 并添加四张图片
    
    NSMutableArray* slideImagesarray = [[NSMutableArray alloc] init];
    //预备动作
    NSMutableArray* slideImagesarrayYB = [[NSMutableArray alloc] init];
    
    [slideImagesarrayYB addObject:@"Newiphone5_gf_tp_yubeidongzuo_0.png"];
    [slideImagesarrayYB addObject:@"Newiphone5_gf_tp_yubeidongzuo_1.png"];
    self.slideImagesYB=slideImagesarrayYB;
    [slideImagesarray addObject:@"Newiphone5_gf_tp_yubeidongzuo_0.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_yubeidongzuo_1.png"];
    //第一式 起式
    NSMutableArray* slideImagesarray1 = [[NSMutableArray alloc] init];
    [slideImagesarray1 addObject:@"Newiphone5_gf_tp_qishi_0.png"];
    [slideImagesarray1 addObject:@"Newiphone5_gf_tp_qishi.png"];
    self.slideImages1=slideImagesarray1;
    
    [slideImagesarray addObject:@"Newiphone5_gf_tp_qishi_0.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_qishi.png"];
    //第二式 剑指长天
    NSMutableArray* slideImagesarray2 = [[NSMutableArray alloc] init];
    [slideImagesarray2 addObject:@"Newiphone5_gf_tp_1_0.png"];
    [slideImagesarray2 addObject:@"Newiphone5_gf_tp_1_1.png"];
    [slideImagesarray2 addObject:@"Newiphone5_gf_tp_1_2.png"];
    [slideImagesarray2 addObject:@"Newiphone5_gf_tp_1_3.png"];
    [slideImagesarray2 addObject:@"Newiphone5_gf_tp_1_4.png"];
    self.slideImages2=slideImagesarray2;
    
    [slideImagesarray addObject:@"Newiphone5_gf_tp_1_0.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_1_1.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_1_2.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_1_3.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_1_4.png"];
    //第三式 海底捞月
    NSMutableArray* slideImagesarray3 = [[NSMutableArray alloc] init];
    [slideImagesarray3 addObject:@"Newiphone5_gf_tp_2_0.png"];
    [slideImagesarray3 addObject:@"Newiphone5_gf_tp_2_1.png"];
    [slideImagesarray3 addObject:@"Newiphone5_gf_tp_2_2.png"];
    [slideImagesarray3 addObject:@"Newiphone5_gf_tp_2_3.png"];
    [slideImagesarray3 addObject:@"Newiphone5_gf_tp_2_4.png"];
    self.slideImages3=slideImagesarray3;
    
    [slideImagesarray addObject:@"Newiphone5_gf_tp_2_0.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_2_1.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_2_2.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_2_3.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_2_4.png"];
    // 第四式 太极云手
    NSMutableArray* slideImagesarray4 = [[NSMutableArray alloc] init];
    [slideImagesarray4 addObject:@"Newiphone5_gf_tp_3_0.png"];
    [slideImagesarray4 addObject:@"Newiphone5_gf_tp_3_1.png"];
    [slideImagesarray4 addObject:@"Newiphone5_gf_tp_3_2.png"];
    [slideImagesarray4 addObject:@"Newiphone5_gf_tp_3_3.png"];
    [slideImagesarray4 addObject:@"Newiphone5_gf_tp_3_4.png"];
    self.slideImages4=slideImagesarray4;
    
    [slideImagesarray addObject:@"Newiphone5_gf_tp_3_0.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_3_1.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_3_2.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_3_3.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_3_4.png"];
    //第五式 高山流水
    NSMutableArray* slideImagesarray5 = [[NSMutableArray alloc] init];
    [slideImagesarray5 addObject:@"Newiphone5_gf_tp_4_0.png"];
    [slideImagesarray5 addObject:@"Newiphone5_gf_tp_4_1.png"];
    [slideImagesarray5 addObject:@"Newiphone5_gf_tp_4_2.png"];
    [slideImagesarray5 addObject:@"Newiphone5_gf_tp_4_3.png"];
    [slideImagesarray5 addObject:@"Newiphone5_gf_tp_4_4.png"];
    self.slideImages5=slideImagesarray5;
    
    [slideImagesarray addObject:@"Newiphone5_gf_tp_4_0.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_4_1.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_4_2.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_4_3.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_4_4.png"];
    //  第六式 俯身探海
    NSMutableArray* slideImagesarray6 = [[NSMutableArray alloc] init];
    [slideImagesarray6 addObject:@"Newiphone5_gf_tp_5_0.png"];
    [slideImagesarray6 addObject:@"Newiphone5_gf_tp_5_1.png"];
    [slideImagesarray6 addObject:@"Newiphone5_gf_tp_5_2.png"];
    [slideImagesarray6 addObject:@"Newiphone5_gf_tp_5_3.png"];
    [slideImagesarray6 addObject:@"Newiphone5_gf_tp_5_4.png"];
    self.slideImages6=slideImagesarray6;
    
    [slideImagesarray addObject:@"Newiphone5_gf_tp_5_0.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_5_1.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_5_2.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_5_3.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_5_4.png"];
    // 第七式 俯身抱月
    NSMutableArray* slideImagesarray7 = [[NSMutableArray alloc] init];
    [slideImagesarray7 addObject:@"Newiphone5_gf_tp_6_0.png"];
    [slideImagesarray7 addObject:@"Newiphone5_gf_tp_6_1.png"];
    [slideImagesarray7 addObject:@"Newiphone5_gf_tp_6_2.png"];
    [slideImagesarray7 addObject:@"Newiphone5_gf_tp_6_3.png"];
    self.slideImages7=slideImagesarray7;
    
    [slideImagesarray addObject:@"Newiphone5_gf_tp_6_0.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_6_1.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_6_2.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_6_3.png"];
    // 第八式 收式
    NSMutableArray* slideImagesarray8 = [[NSMutableArray alloc] init];
    [slideImagesarray8 addObject:@"Newiphone5_gf_tp_shoushi_0.png"];
    [slideImagesarray8 addObject:@"Newiphone5_gf_tp_shoushi_1.png"];
    self.slideImages8=slideImagesarray8;
    
    [slideImagesarray addObject:@"Newiphone5_gf_tp_shoushi_0.png"];
    [slideImagesarray addObject:@"Newiphone5_gf_tp_shoushi_1.png"];
    self.slideImages=slideImagesarray;
    countstr=self.slideImages.count;
    
   
    UIPageControl* nspageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(120,440,100,18)]; // 初始化mypagecontrol
    [nspageControl setCurrentPageIndicatorTintColor:[UIColor clearColor]];
    [nspageControl setPageIndicatorTintColor:[UIColor clearColor]];
    nspageControl.numberOfPages = [self.slideImages count];
    nspageControl.currentPage = 0;
    [nspageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged];
    self.pageControl=nspageControl;
    [self.view addSubview:self.pageControl];
    
    // 创建四个图片 imageview
    for (int i = 0;i<[self.slideImages count];i++)
    {
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.slideImages objectAtIndex:i]]];
        // imageView.frame = CGRectMake((320 * i), 0, 320, ScreenHeight-124-35);
        
        UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
        [btn setBackgroundImage:[UIImage imageNamed:[self.slideImages objectAtIndex:i]] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        //[imageView release];
    }
    [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages count]),ScreenHeight-64-51)];
    [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
    [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
    
    if (pindex!=0) {
        [self MoveScroll];
    }
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 55, WIDTH, 55)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    
    voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceButton.frame = CGRectMake((WIDTH - 28 * 3) / 6, 5, 28, 28);
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"yundongtupian2.png"] forState:UIControlStateNormal];
    [voiceButton setBackgroundImage:[UIImage imageNamed:@"yundongtupian1.png"] forState:UIControlStateSelected];
    [voiceButton addTarget:self action:@selector(voiceButton:) forControlEvents:UIControlEventTouchUpInside];
    voiceButton.selected = YES;
    [footView addSubview:voiceButton];
    UILabel *lunbotu = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 28 * 3) / 6 - 22, 35, (WIDTH - 28 * 3) / 6 + 34, 15)];
    lunbotu.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    lunbotu.text = @"轮播暂停";
    lunbotu.textAlignment = NSTextAlignmentCenter;
    lunbotu.font = [UIFont systemFontOfSize:12];
    [footView addSubview:lunbotu];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    _leyaoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leyaoButton.frame = CGRectMake((WIDTH - 28 * 3) / 2 + 28, 5, 28, 28);
    
    [_leyaoButton setBackgroundImage:[UIImage imageNamed:@"yudongbofang2.png"] forState:UIControlStateNormal];
    [_leyaoButton setBackgroundImage:[UIImage imageNamed:@"yundongbofang1.png"] forState:UIControlStateSelected];
    if (self.play.playing) {
        _leyaoButton.selected = YES;
    }else{
        _leyaoButton.selected = NO;
    }
    [_leyaoButton addTarget:self action:@selector(leyaoButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [footView addSubview:_leyaoButton];
    UILabel *bofangleyao = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 28 * 3) / 2 + 18, 35, (WIDTH - 28 * 3) / 2 + 62, 15)];
    bofangleyao.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    
    bofangleyao.text = @"播放乐药";
    //bofangleyao.textAlignment = NSTextAlignmentCenter;
    bofangleyao.font = [UIFont systemFontOfSize:12];
    [footView addSubview:bofangleyao];
    _shifanyinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shifanyinButton.frame = CGRectMake((WIDTH - 28 * 3) * 5 / 6 + 56, 5, 28, 28);
    [_shifanyinButton setBackgroundImage:[UIImage imageNamed:@"yundongyueyaoting.png"] forState:UIControlStateNormal];
    [_shifanyinButton setBackgroundImage:[UIImage imageNamed:@"yundongyueyao.png"] forState:UIControlStateSelected];
    [_shifanyinButton addTarget:self action:@selector(playButton:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:_shifanyinButton];
    UILabel *shifanyin = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 28 * 3) * 5 / 6 + 39, 35, (WIDTH - 28 * 3) * 5 / 6 + 90, 15)];
    shifanyin.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    shifanyin.text = @"动作示范音";
    //shifanyin.textAlignment = NSTextAlignmentCenter;
    shifanyin.font = [UIFont systemFontOfSize:12];
    [footView addSubview:shifanyin];
    //    UIButton *playsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    playsButton.frame = CGRectMake((WIDTH - 28 * 4) * 7 / 8 + 84, 2, 28, 28);
    //    [playsButton setBackgroundImage:[UIImage imageNamed:@"yundongshengyin2.png"] forState:UIControlStateNormal];
    //    [playsButton setBackgroundImage:[UIImage imageNamed:@"yundongshengyi1.png"] forState:UIControlStateSelected];
    //    [playsButton addTarget:self action:@selector(playssButton:) forControlEvents:UIControlEventTouchUpInside];
    //    [footView addSubview:playsButton];
    //    UILabel *jingyin = [[UILabel alloc]initWithFrame:CGRectMake((WIDTH - 28 * 4) * 7 / 8 + 86, 32, 60, 15)];
    //    jingyin.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    //    jingyin.text = @"静音";
    //    jingyin.font = [UIFont systemFontOfSize:12];
    //    [footView addSubview:jingyin];
    //    [jingyin release];
    [self shifanyinWithPlay];
    [self GetResourceslist];
    
    //  self.popTip.hidden = NO;
    //UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 300);
    //    button.userInteractionEnabled = YES;
    //    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:button];
    //    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    //
    //    tap.numberOfTapsRequired=1;
    //
    //    tap.numberOfTouchesRequired=1;
    //
    //    [self.scrollImgView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBarColor:) name:@"ChangeColor" object:nil];
}

- (void)changeBarColor:(NSNotification *)notification
{
    
    //    [playTime setFireDate:[NSDate distantFuture]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    yingcangView.hidden = YES;
    if (_shifanyinButton.selected) {
        if (_shifanyinPlay.playing) {
            
        }else{
            if (self.play.playing) {
                
            }else{
                
                [playmp3 setFireDate:[NSDate distantFuture]];
            }
        }
    }
    
    [self.play pause];
    self.play = nil;
    [self.shifanyinPlay pause];
    self.shifanyinPlay = nil;
    _shifanyinButton.selected = NO;
    
    
    
}
- (void)shifanyinWithPlay{
    //[self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/resources/list.jhtml?sn=%@",UrlPre,@"ZY-YDSFY"];
    aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourcesshifanyinErrorw:)];
    [request setDidFinishSelector:@selector(requestResourcesshifanyinCompletedw:)];
    [request startAsynchronous];
}
- (void)requestResourcesshifanyinErrorw:(ASIHTTPRequest *)request
{
    //[self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
}
- (void)requestResourcesshifanyinCompletedw:(ASIHTTPRequest *)request
{
    //[self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        self.shifanyinDicArr = [[dic objectForKey:@"data"] objectForKey:@"content"];
        //UIImage* statusviewImg = nil;
        NSString* filepath=[self Createfilepath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (NSString *titleStr in self.titleArray) {
            NSString* urlpaths= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", titleStr]];
            [self.titlesArray addObject:urlpaths];
        }
        for (NSDictionary *dic in self.shifanyinDicArr) {
            // NSString* NewFileName=[[[dic objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
            //            NSArray*Urlarray=[NewFileName componentsSeparatedByString:@"/"];
            NSString* urlpathname= [[[dic objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"];
            NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", urlpathname]];
            
            //            NSString *title = [[[dic objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"];
            //            [self.titlesArray addObject:title];
            BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
            [self.shifanyinArray addObject:urlpath];
            if (fileExists) {
                //urlpath = [urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                
                [self.shifanyinPlayArr addObject:urlpath];
                
                
                //                self.play = [[AVAudioPlayer alloc] initWithContentsOfURL:self.dataArray[0] error:nil];
                //                [self.play setDelegate:self];//设置代理
                //                self.play.volume = 0.5;
            }
        }
        
    }
    else if ([status intValue]==44)
    {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        av.tag = 100008;
        [av show];
    }else{
        NSString *str = [dic objectForKey:@"data"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        //av.tag = 100008;
        [av show];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"finish");//设置代理的AVAudioPlayer对象每次播放结束都会触发这个函数
    if (player == self.play) {
        self.count++;
        if (self.count > self.dataArray.count - 1) {
            self.count = 0;
            
        }
        [self playNext];
        
    }else if (player == self.shifanyinPlay){
        self.shifanyinCount ++;
        if (self.shifanyinCount > self.shifanyinPlayArr.count - 1) {
            
            yingcangView.hidden = YES;
            [self.shifanyinPlay pause];
            self.shifanyinPlay = nil;
            self.bofangCount = 0;
            self.shifanyinCount = 0;
            voiceButton.selected = YES;
            _shifanyinButton.selected = NO;
            [self.scrollImgView scrollRectToVisible:CGRectMake(ScreenWidth*self.bofangCount,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
            UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
            [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
            
            playTime=[NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
            //[playTime setFireDate:[NSDate distantPast]];
            return;
            
        }
       
        
        int counts = 0;
        
        
        
        for (int j = 0; j < self.shifanyinPlayArr.count; j ++) {
            if ([self.titlesArray[self.bofangCount]isEqualToString:self.shifanyinPlayArr[j]]) {
                counts++;
            }
        }
        [_shifanyinPlay pause];
        _shifanyinPlay = nil;
        if (counts > 0) {
            
            _shifanyinPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.titlesArray[self.bofangCount]] error:nil];
            self.shifanyinPlay.volume = 5;
            self.shifanyinPlay.delegate = self;
            // [self.shifanyinPlay setNumberOfLoops:1];
            
            [self.shifanyinPlay play];
            //[self.titlesArray removeObjectAtIndex:i];
            
            
            
            
            [self.scrollImgView scrollRectToVisible:CGRectMake(ScreenWidth*self.bofangCount,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
            UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
            [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
            self.bofangCount ++;
        }else{
            
            
            [self.scrollImgView scrollRectToVisible:CGRectMake(ScreenWidth*self.bofangCount,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
            UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
            [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
            self.bofangCount++;
            playmp3 = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(runTimePages) userInfo:nil repeats:NO];
            //[playmp3 setFireDate:[NSDate distantPast]];
        }
    }
    
    
    
    
}

- (void)playNext{
    _play = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.dataArray[self.count]] error:nil];
    //[_play setNumberOfLoops:1];
    _play.delegate = self;
    [_play play];
}
- (void) prepareToRecord
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
}

-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.labelText = @"加载中...";
    [progress_ show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    progress_ = nil;
    
}

-(void)GetResourceslist
{
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/resources/list/%@.jhtml",UrlPre,[UserShareOnce shareOnce].uid];
    aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceslistErrorw:)];
    [request setDidFinishSelector:@selector(requestResourceslistCompletedw:)];
    [request startAsynchronous];
}

- (void)requestResourceslistErrorw:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
}
- (void)requestResourceslistCompletedw:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        self.dicArray=[dic objectForKey:@"data"];
        //UIImage* statusviewImg = nil;
        NSString* filepath=[self Createfilepath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        for (NSDictionary *dic in self.dicArray) {
            NSString* NewFileName=[[[dic objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
            NSArray*Urlarray=[NewFileName componentsSeparatedByString:@"/"];
            NSString* urlpathname= [Urlarray objectAtIndex:Urlarray.count-1];
            NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", urlpathname]];
            BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
            if (fileExists) {
                //urlpath = [urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                
                [self.dataArray addObject:urlpath];
                
                
                //                self.play = [[AVAudioPlayer alloc] initWithContentsOfURL:self.dataArray[0] error:nil];
                //                [self.play setDelegate:self];//设置代理
                //                self.play.volume = 0.5;
            }
            if (self.dataArray.count == 0) {
                
                
                //return;
            }else{
                _play = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.dataArray[0]] error:nil];
                self.play.volume = 5;
                self.play.delegate = self;
                //[_play setNumberOfLoops:1];
                [self.play stop];
            }
        }
        
    }
    else if ([status intValue]==44)
    {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        av.tag = 100008;
        [av show];
    }else{
        NSString *str = [dic objectForKey:@"data"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        //av.tag = 100008;
        [av show];
    }
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==100008)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
-(NSString*) Createfilepath
{
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *folderPath = [path stringByAppendingPathComponent:@"temp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    if(!fileExists)
    {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folderPath;
}
- (void)playssButton:(UIButton *)sender{
    if (sender.selected) {
        self.play.volume = 5;
        self.shifanyinPlay.volume = 5;
        sender.selected = NO;
    }else{
        self.shifanyinPlay.volume = 0;
        self.play.volume = 0;
        sender.selected = YES;
    }
}
- (void)voiceButton:(UIButton *)sender{
    if (sender.selected) {
        if (_shifanyinButton.selected) {
            
        }else{
            sender.selected = NO;
            [playTime setFireDate:[NSDate distantFuture]];
        }
    }else{
        if (_shifanyinButton.selected) {
            
        }else{
            sender.selected = YES;
            
            [playTime setFireDate:[NSDate distantPast]];
        }
    }
    
    
}
# pragma mark - 乐药播放
- (void)leyaoButton:(UIButton *)sender{
    
    if (self.dataArray.count == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有乐药产品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        return;
    }
    
    if (self.play.playing) {
        
        [self.play pause];
        
        sender.selected = NO;
        
        
    }else{
        if (_shifanyinPlay.playing) {
            self.shifanyinCount = 0;
            self.bofangCount = 0;
            [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
            UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
            [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
            playTime=[NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        }
        timer=[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(runTimePagess) userInfo:nil repeats:YES];
        [timer setFireDate:[NSDate distantPast]];
        [self.play play];
        yingcangView.hidden = YES;
        [self.shifanyinPlay pause];
        [playTime setFireDate:[NSDate distantPast]];
        _shifanyinButton.selected = NO;
        sender.selected = YES;
        
    }
    
}
-(void)runTimePagess{
    if (_shifanyinPlay.playing) {
        [_shifanyinPlay pause];
        _shifanyinPlay = nil;
    }
}
# pragma mark - 示范音播放
- (void)playButton:(UIButton *)sender{
    
    if (self.shifanyinPlayArr.count == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有音乐示范音产品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        return;
    }
   
    if (sender.selected ) {
        
        if (_shifanyinPlay.playing) {
            [self.shifanyinPlay pause];
            self.shifanyinPlay = nil;
        }else{
            [playmp3 setFireDate:[NSDate distantFuture]];
        }
        
        
        
        yingcangView.hidden = YES;
        
        self.shifanyinCount = 0;
        self.bofangCount = 0;
        [self.scrollImgView scrollRectToVisible:CGRectMake(ScreenWidth*self.bofangCount,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
        UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
        [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
        playTime=[NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        sender.selected = NO;
        
        
    }else{
        
        
        if(dropDown == nil) {
            
        }
        else {
            [dropDown hideDropDown:nil];
            [self rel];
        }
        voiceButton.selected = YES;
        yingcangView.hidden = NO;
        [_shifanyinPlay pause];
        _shifanyinPlay = nil;
        pindex = 0;
        [self MoveScroll];
        //self.scrollImgView.contentSize=CGSizeMake(0, ScreenHeight-64-51);
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-70-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
        UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
        [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
        //voiceButton.selected = NO;
        [timer setFireDate:[NSDate distantFuture]];
        [playTime setFireDate:[NSDate distantFuture]];
        [playTime invalidate];
        playTime = nil;
        self.bofangCount = 0;
        
        [self.play pause];
        _leyaoButton.selected = NO;
        sender.selected = YES;
        int counts = 0;
        
        for (int j = 0; j < self.shifanyinPlayArr.count; j ++) {
            if ([self.titlesArray[self.bofangCount]isEqualToString:self.shifanyinPlayArr[j]]) {
                counts++;
            }
        }
        if (counts > 0) {
            
            _shifanyinPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.titlesArray[self.bofangCount]] error:nil];
            self.shifanyinPlay.volume = 5;
            self.shifanyinPlay.delegate = self;
            // [self.shifanyinPlay setNumberOfLoops:1];
            
            [self.shifanyinPlay play];
            //[self.titlesArray removeObjectAtIndex:i];
            
            
            
            
            [self.scrollImgView scrollRectToVisible:CGRectMake(ScreenWidth*self.bofangCount,0,ScreenWidth,ScreenHeight-70-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
            UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
            [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
            self.bofangCount ++;
            
            
            
            
            
        }else{
            
            self.bofangCount++;
            playmp3 = [NSTimer scheduledTimerWithTimeInterval:6.0f target:self selector:@selector(runTimePages) userInfo:nil repeats:NO];
            
        }
        //                if (a>0) {
        //                    [NSThread sleepForTimeInterval:6];
        //                }
        
    }
    
    
    
}


- (void)runTimePages{
    
    int counts = 0;
    
    
    
    for (int j = 0; j < self.shifanyinPlayArr.count; j ++) {
        if ([self.titlesArray[self.bofangCount]isEqualToString:self.shifanyinPlayArr[j]]) {
            counts++;
        }
    }
    if (counts > 0) {
        
        _shifanyinPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.titlesArray[self.bofangCount]] error:nil];
        self.shifanyinPlay.volume = 5;
        self.shifanyinPlay.delegate = self;
        // [self.shifanyinPlay setNumberOfLoops:1];
        
        [self.shifanyinPlay play];
        //[self.titlesArray removeObjectAtIndex:i];
        
        
        
        
        [self.scrollImgView scrollRectToVisible:CGRectMake(ScreenWidth*self.bofangCount,0,ScreenWidth,ScreenHeight-70-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
        UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
        [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
        self.bofangCount ++;
        
        
        
        
        
    }else{
        
        
        [self.scrollImgView scrollRectToVisible:CGRectMake(ScreenWidth*self.bofangCount,0,ScreenWidth,ScreenHeight-70-51) animated:YES];
        [self.scrollImgView scrollRectToVisible:CGRectMake(ScreenWidth*self.bofangCount,0,ScreenWidth,ScreenHeight-70-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
        self.bofangCount++;
        playmp3 = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(runTimePages) userInfo:nil repeats:NO];
        //[playmp3 setFireDate:[NSDate distantPast]];
    }
    
}
//- (void)zongTime{
//    [self.scrollImgView scrollRectToVisible:CGRectMake(ScreenWidth*0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
//    UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
//    [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
//}
//- (void)playButtonWithAction{
//    [_play play];//播放音乐
//   // NSLog(@"%@",[UserShareOnce shareOnce].mp3.playing);
//
//    [_playmp3 invalidate];
//}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    int page = floor(self.scrollImgView.contentOffset.x/320 )+1;//- pagewidth/([self.slideImages count]))/pagewidth);
    page --;  // 默认从第二页开始
    self.pageControl.currentPage = page;
    UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
    // [pagecountlb setTitle:@"1/5" forState:UIControlStateNormal];
    [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
    //pagecountlb.titleLabel.text=[NSString stringWithFormat:@"%d/%d",self.pageControl.currentPage+1,countstr];
    UIButton* TitleBtn=(UIButton*)[self.view viewWithTag:10001];
    UILabel* Sport_Tile=(UILabel *)[self.view viewWithTag:10005];
    [self.popTip hide];
    self.popTip = [AMPopTip popTip];
    if (countstr==35)
    {
        if (page==0)
        {
            Sport_Tile.text=@"";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
            [TitleBtn setTitle:@"全部" forState:UIControlStateNormal];
        }
        if (page==1)
        {
            // Sport_Tile.text=@"预备";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"首先，将和畅行调整到适宜坡度，坡度选择需循序渐进，以脚踝、小腿、膝盖、大腿后侧的肌肉略有拉抻感为宜。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==2) {
            Sport_Tile.text=@"";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
            [TitleBtn setTitle:@"全部" forState:UIControlStateNormal];
        }
        
        if (page==3)
        {
            //Sport_Tile.text=@"起式";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            
            [self.popTip showText:@"沉肩、坠肘、松胯，两手臂自然垂直于身体两侧，尽量放松身体，保持身体与地面垂直。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        
        if (page==4) {
            //Sport_Tile.text=@"";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
            [TitleBtn setTitle:@"全部" forState:UIControlStateNormal];
        }
        if (page==5)
        {
            //Sport_Tile.text=@"剑指长天";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"脚尖并拢，脚跟分开45度，呈内八字型；舌舐上腭，鼻息调匀。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==6)
        {
            //Sport_Tile.text=@"剑指长天";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"自然呼吸，两臂自体侧缓缓向上抬起，自然伸直紧贴双耳，掌心相对，两手相握，食指伸直，成“剑指”。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==7)
        {
            //Sport_Tile.text=@"剑指长天";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"自双臂、头、颈、背、腰依次缓缓向后弯曲至极限，随着呼吸，身体不断向极限拉抻，完成10个呼吸即可。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==8) {
            //Sport_Tile.text=@"剑指长天";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
        }
        if (page==9) {
            //Sport_Tile.text=@"";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
            [TitleBtn setTitle:@"全部" forState:UIControlStateNormal];
        }
        if (page==10)
        {
            //Sport_Tile.text=@"海底捞月";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"双脚保持原有姿势不变，舌舐上腭，鼻息调匀，双腿保持直立。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==11)
        {
            //Sport_Tile.text=@"海底捞月";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"吸气，随之身体慢慢向下弯曲，双臂从体侧自然下垂至身前，头、颈、肩、臀依次松弛下来。轻轻左右依次摆动臀部、背部、肩部、颈部和头部，保持自然的呼吸。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==12)
        {
            //Sport_Tile.text=@"海底捞月";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"于极限处保持3分钟，此时腘窝会出现紧绷感，可拉抻足少阴肾经，有助于疏通此处的“筋结”，能明显缓解腰背痛。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==13) {
            // Sport_Tile.text=@"海底捞月";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
            
        }
        if (page==14) {
            //Sport_Tile.text=@"";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
            [TitleBtn setTitle:@"全部" forState:UIControlStateNormal];
        }
        if (page==15)
        {
            // Sport_Tile.text=@"太极云手";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"双脚打开，与肩同宽，脚尖内扣，脚跟呈45度内八字形,舌抵上腭，鼻息调匀。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==16)
        {
            //Sport_Tile.text=@"太极云手";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"左手缓缓抬起至额前，目视手心。右侧手臂抬起至小腹肚脐处左手臂带动上半身缓缓左转，至极限处，稍停顿3-5秒（注意髋关节保持不动）。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==17)
        {
            //Sport_Tile.text=@"太极云手";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:16];
            [self.popTip showText:@"缓缓回归正位的同时，右手臂抬起至额前，目视右手心。左侧手臂抬起至小腹肚脐处；右手臂带动上半身缓缓右转，至极限处，稍停顿3-5秒（注意髋关节保持不动）。如此左右往复10次。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==18)
        {
            //Sport_Tile.text=@"太极云手";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
        }
        
        if (page==19) {
            // Sport_Tile.text=@"";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
            [TitleBtn setTitle:@"全部" forState:UIControlStateNormal];
        }
        if (page==20)
        {
            // Sport_Tile.text=@"高山流水";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"双脚打开，与肩同宽，脚尖内扣，脚跟呈45度内八字形,舌抵上腭，鼻息调匀。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==21)
        {
            // Sport_Tile.text=@"高山流水";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"身体缓缓左倾下拉，左手沿裤线下探至极限，与此同时，右手上行至腋下，头部自然左倾，靠近肩部，稍作停顿。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==22)
        {
            //Sport_Tile.text=@"高山流水";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"身体缓缓右倾下拉，右手沿裤线下探至极限，与此同时，左手上行至腋下，头部自然左倾，靠近肩部，稍作停顿。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==23)
        {
            // Sport_Tile.text=@"高山流水";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
        }
        if (page==24) {
            // Sport_Tile.text=@"";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
            [TitleBtn setTitle:@"全部" forState:UIControlStateNormal];
        }
        if (page==25)
        {
            //Sport_Tile.text=@"俯身探海";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"保持姿势不变,舌抵上腭，鼻息调匀。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==26)
        {
            // Sport_Tile.text=@"俯身探海";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"双腿保持直立，身体慢慢向下弯曲，双臂从体侧尽量下垂至身前，臀、背、肩、颈、头依次松弛下来，保持呼吸均匀。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==27)
        {
            // Sport_Tile.text=@"俯身探海";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"轻轻的左右依次摆动头部、颈部、肩部和臀部，有助于不断向下拉伸至极限，于极限处保持3分钟，可加强对足少阴肾经、足厥阴肝经、足太阴脾经的拉抻。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==28) {
            // Sport_Tile.text=@"俯身探海";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
        }
        if (page==29) {
            //Sport_Tile.text=@"";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
            [TitleBtn setTitle:@"全部" forState:UIControlStateNormal];
        }
        if (page==30)
        {
            //Sport_Tile.text=@"俯身抱月";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"身体后转，双脚并拢直立于和畅行上；双手自然垂于体侧，下颏微收，唇齿合拢，舌自然平贴于上腭。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==31)
        {
            //Sport_Tile.text=@"俯身抱月";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"身体前俯经骶椎、腰椎、胸椎、颈椎，依次放松，逐节缓慢牵引前屈。两腿缓缓下蹲，双手合抱于膝上，头部贴于膝上1分钟。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
        if (page==32) {
            //Sport_Tile.text=@"俯身抱月";
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
        }
        if (page==33) {
            if (self.popTip.isVisible) {
                [self.popTip hide];
            }
            [TitleBtn setTitle:@"全部" forState:UIControlStateNormal];
        }
        if (page==34)
        {
            //Sport_Tile.text=@"收式";
            UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
            [self.popTip showText:@"慢慢站起，从和畅行上走下，轻轻拍打四肢。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
        }
    }
    else
    {
        if ([TitleBtn.titleLabel.text isEqualToString:@"预备"])
        {
            if (page==0)
            {
                Sport_Tile.text=@"";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            if (page==1)
            {
                // Sport_Tile.text=@"预备";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"首先，将和畅行调整到适宜坡度，坡度选择需循序渐进，以脚踝、小腿、膝盖、大腿后侧的肌肉略有拉抻感为宜。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
        }
        else if ([TitleBtn.titleLabel.text isEqualToString:@"第一式"])
        {
            if (page==0) {
                Sport_Tile.text=@"";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
                
            }
            
            if (page==1)
            {
                // Sport_Tile.text=@"起式";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"沉肩、坠肘、松胯，两手臂自然垂直于身体两侧，尽量放松身体，保持身体与地面垂直。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            
        }
        else if ([TitleBtn.titleLabel.text isEqualToString:@"第二式"])
        {
            if (page==0) {
                //  Sport_Tile.text=@"";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            if (page==1)
            {
                //Sport_Tile.text=@"剑指长天";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"脚尖并拢，脚跟分开45度，呈内八字型；舌舐上腭，鼻息调匀。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame ];
            }
            if (page==2)
            {
                //Sport_Tile.text=@"剑指长天";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"自然呼吸，两臂自体侧缓缓向上抬起，自然伸直紧贴双耳，掌心相对，两手相握，食指伸直，成“剑指”。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==3)
            {
                //Sport_Tile.text=@"剑指长天";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"自双臂、头、颈、背、腰依次缓缓向后弯曲至极限，随着呼吸，身体不断向极限拉抻，完成10个呼吸即可。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==4) {
                //Sport_Tile.text=@"剑指长天";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
        }
        else if ([TitleBtn.titleLabel.text isEqualToString:@"第三式"])
        {
            if (page==0) {
                Sport_Tile.text=@"";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            if (page==1)
            {
                // Sport_Tile.text=@"海底捞月";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"双脚保持原有姿势不变，舌舐上腭，鼻息调匀，双腿保持直立。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==2)
            {
                //Sport_Tile.text=@"海底捞月";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"吸气，随之身体慢慢向下弯曲，双臂从体侧自然下垂至身前，头、颈、肩、臀依次松弛下来。轻轻左右依次摆动臀部、背部、肩部、颈部和头部，保持自然的呼吸。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==3)
            {
                //Sport_Tile.text=@"海底捞月";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"于极限处保持3分钟，此时腘窝会出现紧绷感，可拉抻足少阴肾经，有助于疏通此处的 “筋结”，能明显缓解腰背痛。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==4) {
                //  Sport_Tile.text=@"海底捞月";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
                
            }
            
        }
        else if ([TitleBtn.titleLabel.text isEqualToString:@"第四式"])
        {
            if (page==0) {
                Sport_Tile.text=@"";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            if (page==1)
            {
                //Sport_Tile.text=@"太极云手";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"双脚打开，与肩同宽，脚尖内扣，脚跟呈45度内八字形，保持姿势不变,舌抵上腭，鼻息调匀。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==2)
            {
                //Sport_Tile.text=@"太极云手";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"左手缓缓抬起至额前，目视手心。右侧手臂抬起至小腹肚脐处左手臂带动上半身缓缓左转，至极限处，稍停顿3-5秒（注意髋关节保持不动）。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==3)
            {
                //Sport_Tile.text=@"太极云手";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"缓缓回归正位的同时，右手臂抬起至额前，目视右手心。左侧手臂抬起至小腹肚脐处；右手臂带动上半身缓缓右转，至极限处，稍停顿3-5秒（注意髋关节保持不动）。如此左右往复10次。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==4)
            {
                //Sport_Tile.text=@"太极云手";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            
        }
        else if ([TitleBtn.titleLabel.text isEqualToString:@"第五式"])
        {
            if (page==0) {
                Sport_Tile.text=@"";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            if (page==1)
            {
                //Sport_Tile.text=@"高山流水";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"双脚打开，与肩同宽，脚尖内扣，脚跟呈45度内八字形，保持姿势不变,舌抵上腭，鼻息调匀。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==2)
            {
                //Sport_Tile.text=@"高山流水";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"身体缓缓左倾下拉，左手沿裤线下探至极限，与此同时，右手上行至腋下，头部自然左倾，靠近肩部，稍作停顿。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==3)
            {
                //Sport_Tile.text=@"高山流水";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"身体缓缓右倾下拉，右手沿裤线下探至极限，与此同时，左手上行至腋下，头部自然左倾，靠近肩部，稍作停顿。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==4)
            {
                //Sport_Tile.text=@"高山流水";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            
        }
        else if ([TitleBtn.titleLabel.text isEqualToString:@"第六式"])
        {
            if (page==0) {
                // Sport_Tile.text=@"";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            if (page==1)
            {
                //Sport_Tile.text=@"俯身探海";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"保持姿势不变,舌抵上腭，鼻息调匀。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==2)
            {
                //Sport_Tile.text=@"俯身探海";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"双腿保持直立，身体慢慢向下弯曲，双臂从体侧尽量下垂至身前，臀、背、肩、颈、头依次松弛下来，保持呼吸均匀。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==3)
            {
                // Sport_Tile.text=@"俯身探海";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"轻轻的左右依次摆动头部、颈部、肩部和臀部，有助于不断向下拉伸至极限，于极限处保持3分钟，可加强对足少阴肾经、足厥阴肝经、足太阴脾经的拉抻。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==4) {
                // Sport_Tile.text=@"俯身探海";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            
        }
        else if ([TitleBtn.titleLabel.text isEqualToString:@"第七式"])
        {
            if (page==0) {
                Sport_Tile.text=@"";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            if (page==1)
            {
                // Sport_Tile.text=@"附身抱月";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"身体后转，双脚并拢直立于和畅行上；双手自然垂于体侧，下颏微收，唇齿合拢，舌自然平贴于上腭。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==2)
            {
                //Sport_Tile.text=@"附身抱月";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"身体前俯经骶椎、腰椎、胸椎、颈椎，依次放松，逐节缓慢牵引前屈。两腿缓缓下蹲，双手合抱于膝上，头部贴于膝上1分钟。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
            if (page==3) {
                //Sport_Tile.text=@"附身抱月";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            
        }
        else if ([TitleBtn.titleLabel.text isEqualToString:@"第八式"])
        {
            if (page==0) {
                Sport_Tile.text=@"";
                if (self.popTip.isVisible) {
                    [self.popTip hide];
                }
            }
            if (page==1)
            {
                //Sport_Tile.text=@"收式";
                UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:page];
                [self.popTip showText:@"慢慢站起，从和畅行上走下，轻轻拍打四肢。" direction:AMPopTipDirectionDown maxWidth:320 inView:self.view fromFrame:imageImg.frame];
            }
        }
    }
    
    
}
-(void)leftallActive:(id)sender
{
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"全部",@"预备", @"第一式", @"第二式", @"第三式", @"第四式", @"第五式", @"第六式", @"第七式", @"第八式",nil];
    if(dropDown == nil) {
        CGFloat f = 405;
        dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr:self.view];
        dropDown.delegate = self;
    }
    else {
        [dropDown hideDropDown:sender];
        [self rel];
    }
}
/*
 方法名:Play:(id)sender
 作用:播放和暂停动画
 参数:UIButton对象
 */
-(void)PlayWithDismiss:(id)sender
{
    [self.play pause];
    self.play = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) MoveScroll
{
    UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10001];
    for (int m=0; m<self.scrollImgView.subviews.count;m++) {
        UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:m];
        [imageImg removeFromSuperview];
    }
    
    if (pindex==0)
    {
        [pagecountlb setTitle:@"全部" forState:UIControlStateNormal];
        countstr=self.slideImages.count;
        self.pageControl.numberOfPages = [self.slideImages count];
        self.pageControl.currentPage = 0;
        //创建四个图片 imageview
        for (int i = 0;i<[self.slideImages count];i++)
        {
            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            [btn setBackgroundImage:[UIImage imageNamed:[self.slideImages objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
            
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
    }
    if (pindex==1) {
        [pagecountlb setTitle:@"第一式" forState:UIControlStateNormal];
        countstr=self.slideImages1.count;
        self.pageControl.numberOfPages = [self.slideImages1 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages1 count];i++)
        {
            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            [btn setBackgroundImage:[UIImage imageNamed:[self.slideImages1 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
            
        }
        
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages1 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
    }
    if (pindex==2) {
        [pagecountlb setTitle:@"第二式" forState:UIControlStateNormal];
        countstr=self.slideImages2.count;
        self.pageControl.numberOfPages = [self.slideImages2 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages2 count];i++)
        {
            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            [btn setBackgroundImage:[UIImage imageNamed:[self.slideImages2 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
            
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages2 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
    }
    if (pindex==3) {
        
        [pagecountlb setTitle:@"第三式" forState:UIControlStateNormal];
        countstr=self.slideImages3.count;
        self.pageControl.numberOfPages = [self.slideImages3 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages3 count];i++)
        {
            
            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages3 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
            
        }
        [self.scrollImgView setContentSize:CGSizeMake(320 * ([self.slideImages3 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
        
    }
    if (pindex==4) {
        [pagecountlb setTitle:@"第四式" forState:UIControlStateNormal];
        countstr=self.slideImages4.count;
        self.pageControl.numberOfPages = [self.slideImages4 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages4 count];i++)
        {
            
            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages4 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
            
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages4 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
        
    }
    if (pindex==5) {
        [pagecountlb setTitle:@"第五式" forState:UIControlStateNormal];
        countstr=self.slideImages5.count;
        self.pageControl.numberOfPages = [self.slideImages5 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages5 count];i++)
        {
            
            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages5 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages5 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
        
    }
    if (pindex==6) {
        [pagecountlb setTitle:@"第六式" forState:UIControlStateNormal];
        countstr=self.slideImages6.count;
        self.pageControl.numberOfPages = [self.slideImages6 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages6 count];i++)
        {
            
            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages6 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
            
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages6 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
        
    }
    if (pindex==7) {
        
        [pagecountlb setTitle:@"第七式" forState:UIControlStateNormal];
        countstr=self.slideImages7.count;
        self.pageControl.numberOfPages = [self.slideImages7 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages7 count];i++)
        {
            
            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages7 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
            
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages7 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
        
    }
    if (pindex==8) {
        [pagecountlb setTitle:@"第八式" forState:UIControlStateNormal];
        countstr=self.slideImages8.count;
        self.pageControl.numberOfPages = [self.slideImages8 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages8 count];i++)
        {
            
            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame= CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
//            btn.frame=CGRectMake(((ScreenWidth-img.size.width/2)/2)+(ScreenWidth * i), 0, img.size.width/2, img.size.height/2);
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages8 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages8 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
        
    }
    [self.countBtn setTitle:[NSString stringWithFormat:@"1/%ld",(long)countstr] forState:UIControlStateNormal];
}
/*
 方法名:turnPage
 作用:pagecontrol 选择器的方法
 参数:null
 */
- (void)turnPage
{
    NSInteger page = pageControl.currentPage; // 获取当前的page
    [self.scrollImgView scrollRectToVisible:CGRectMake(ScreenWidth*(page),0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 触摸pagecontroller那个点点 往后翻一页 +1
    UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10002];
    [pagecountlb setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)self.pageControl.currentPage+1,(long)countstr] forState:UIControlStateNormal];
    
    // pagecountlb.titleLabel.text=[NSString stringWithFormat:@"%d/%ld",self.pageControl.currentPage+1,(long)countstr];
}
-(void)gongfaActive:(id)sender
{
    if (self.popTip.hidden == YES) {
        self.popTip.hidden = NO;
    }else{
        self.popTip.hidden = YES;
    }
    NSLog(@"dddddddddd");
    [dropDown hideDropDown:nil ];
    [self rel];
}
-(void)rel{
    dropDown = nil;
}

/*
 方法名:initScrollView
 作用:初始化Scrollview
 参数:null
 */

//-(void)initScrollView
//{
//    UIScrollView *scrview=[[UIScrollView alloc]init];
//    self.scrollView=scrview;
//    [scrview release];
//    //self.ScrollView.backgroundColor = [UIColor redColor];
//    self.ScrollView.pagingEnabled = NO;
//    self.ScrollView.bounces = YES;
//    [self.ScrollView setDelegate:self];
//    self.ScrollView.showsHorizontalScrollIndicator = NO;
//    self.ScrollView.directionalLockEnabled=YES;
//    if (iPhone5)
//    {
//        AppCount = 12;
//    }
//    else
//    {
//        AppCount = 9;
//    }
//
//    int page = 0;
//    int pagel = 0;
//    int p = AllAppCount%AppCount;
//    if (p==0) {
//        page = AllAppCount/AppCount;
//        pagel =page;
//    }else{
//        page = AllAppCount/AppCount+1;
//        pagel = AllAppCount/AppCount;
//    }
//    self.ScrollView.frame=CGRectMake(0, SflowviewHeight, ScreenWidth, ScreenHeight-35-SflowviewHeight);
//    [self.ScrollView setContentSize:CGSizeMake(ScreenWidth,(ScreenHeight-35-SflowviewHeight-9+ScreenHeight-35-SflowviewHeight-9))];
//    int pp=0;
//    for (int p=0; p<AllAppCount; p++)
//    {
//        UIButton *IcoinBtn = [UIButton buttonWithType: UIButtonTypeCustom];
//        CGRect frame;
//        [IcoinBtn setBackgroundImage:[ImagesArray objectAtIndex:p] forState:UIControlStateNormal];
//        //设置边角背景颜色
//        //IcoinBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
//        IcoinBtn.layer.borderColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_2_1"]] CGColor];
//        IcoinBtn.layer.borderWidth = 1.5f;
//        //给按钮设置弧度,这里将按钮变成了圆形
//        IcoinBtn.layer.cornerRadius = 15.0f;
//
//        //IcoinBtn.backgroundColor = [UIColor redColor];
//        IcoinBtn.layer.masksToBounds = YES;
//        IcoinBtn.tag = p+1;
//        frame.size.width =81;
//        frame.size.height = 67;
//        if (iPhone5)
//        {
//            frame.origin.y = floor(pp/3)*(67)+SingWidth*(p/3)+(4*67)*(p/12)+(self.ScrollView.frame.size.height-(5*67))/2-10;
//            frame.origin.x = (p%3)*(81)+LeftWidth+SingWidth*(p%3);
//        }
//        else
//        {
//            //            frame.origin.y = floor(pp/3)*(67)+SingWidth*(p/3)+(4*67)*(p/12)+(self.ScrollView.frame.size.height-(5*67))/2;
//            frame.origin.y = floor(pp/3)*(67)+SingWidth*(p/3)+(3*67)*(p/9)+(self.ScrollView.frame.size.height-(5*67))/2-10;
//            frame.origin.x = (p%3)*(81)+LeftWidth+SingWidth*(p%3);
//        }
//
//        [IcoinBtn setFrame:frame];
//        [IcoinBtn setBackgroundColor:[UIColor clearColor]];
//        [IcoinBtn addTarget:self action:@selector(btnPressed:parm1:) forControlEvents:UIControlEventTouchUpInside];
//        [self.ScrollView addSubview:IcoinBtn];
//        pp++;
//        if (pp==AppCount) {
//            pp=0;
//        }
//
//    }
//    int p1=AllAppCount%3;
//    int p2=0;
//    if (p1==0)
//    {
//        p2=AllAppCount/3;
//    }
//    else
//    {
//        p2=AllAppCount/3+1;
//    }
//    self.scrollImgView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.ScrollView];
//}
- (void)runTimePage
{
    NSInteger page = pageControl.currentPage; // 获取当前的page
    //    if (page == 35) {
    //        page = 0;
    //    }
    page++;
    pageControl.currentPage = page;
    [self turnPage];
}
/*
 方法名:niDropDownDelegateMethod
 作用:下拉菜单响应事件
 参数:NIDropDown对象和下拉菜单索引值
 */
- (void) niDropDownDelegateMethod: (NIDropDown *) sender :(NSInteger)index{
    
    UIButton* pagecountlb=(UIButton*)[self.view viewWithTag:10001];
    
    
    for (int m=0; m<self.scrollImgView.subviews.count;m++) {
        
        UIButton* imageImg=[self.scrollImgView.subviews objectAtIndex:m];
        [imageImg removeFromSuperview];
    }
    voiceButton.selected = NO;
    [playTime setFireDate:[NSDate distantFuture]];
    if (index==0)
    {
        
        [pagecountlb setTitle:@"全部" forState:UIControlStateNormal];
        countstr=self.slideImages.count;
        self.pageControl.numberOfPages = [self.slideImages count];
        self.pageControl.currentPage = 0;
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages count];i++)
        {
            
            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
    }
    if (index==1) {
        
        [pagecountlb setTitle:@"预备" forState:UIControlStateNormal];
        countstr=self.slideImagesYB.count;
        self.pageControl.numberOfPages = [self.slideImagesYB count];
        self.pageControl.currentPage = 0;
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImagesYB count];i++)
        {
            
            UIImage* img=[UIImage imageNamed:[self.slideImagesYB objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImagesYB objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImagesYB count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
    }
    if (index==2) {
        
        [pagecountlb setTitle:@"第一式" forState:UIControlStateNormal];
        countstr=self.slideImages1.count;
        self.pageControl.numberOfPages = [self.slideImages1 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages1 count];i++)
        {
            
            
            UIImage* img=[UIImage imageNamed:[self.slideImages1 objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages1 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages1 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-35) animated:YES]; // 默认从序号1位置放第1页
    }
    if (index==3) {
        
        [pagecountlb setTitle:@"第二式" forState:UIControlStateNormal];
        countstr=self.slideImages2.count;
        self.pageControl.numberOfPages = [self.slideImages2 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages2 count];i++)
        {
            UIImage* img=[UIImage imageNamed:[self.slideImages2 objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages2 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages2 count]),ScreenHeight-115)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
    }
    if (index==4) {
        [pagecountlb setTitle:@"第三式" forState:UIControlStateNormal];
        countstr=self.slideImages3.count;
        self.pageControl.numberOfPages = [self.slideImages3 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages3 count];i++)
        {
            UIImage* img=[UIImage imageNamed:[self.slideImages3 objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages3 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages3 count]),ScreenHeight-115)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
    }
    if (index==5) {
        
        [pagecountlb setTitle:@"第四式" forState:UIControlStateNormal];
        countstr=self.slideImages4.count;
        self.pageControl.numberOfPages = [self.slideImages4 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages4 count];i++)
        {
            UIImage* img=[UIImage imageNamed:[self.slideImages4 objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages4 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages4 count]),ScreenHeight-115)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
        
    }
    if (index==6) {
        [pagecountlb setTitle:@"第五式" forState:UIControlStateNormal];
        countstr=self.slideImages5.count;
        self.pageControl.numberOfPages = [self.slideImages5 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages5 count];i++)
        {
            
            UIImage* img=[UIImage imageNamed:[self.slideImages5 objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages5 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
            
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages5 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
        
    }
    if (index==7) {
        [pagecountlb setTitle:@"第六式" forState:UIControlStateNormal];
        countstr=self.slideImages6.count;
        self.pageControl.numberOfPages = [self.slideImages6 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages6 count];i++)
        {
            
            
            UIImage* img=[UIImage imageNamed:[self.slideImages6 objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages6 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages6 count]),ScreenHeight-115)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
        
    }
    if (index==8) {
        
        [pagecountlb setTitle:@"第七式" forState:UIControlStateNormal];
        countstr=self.slideImages7.count;
        self.pageControl.numberOfPages = [self.slideImages7 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages7 count];i++)
        {
            
            UIImage* img=[UIImage imageNamed:[self.slideImages7 objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages7 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages7 count]),ScreenHeight-64-51)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
        
    }
    if (index==9) {
        
        [pagecountlb setTitle:@"第八式" forState:UIControlStateNormal];
        countstr=self.slideImages8.count;
        self.pageControl.numberOfPages = [self.slideImages8 count];
        self.pageControl.currentPage = 0;
        
        // 创建四个图片 imageview
        for (int i = 0;i<[self.slideImages8 count];i++)
        {
            UIImage* img=[UIImage imageNamed:[self.slideImages8 objectAtIndex:i]];
            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
            
            btn.frame=CGRectMake(((ScreenWidth- imageW)/2)+(ScreenWidth * i), 0, imageW, imageH);
            
            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages8 objectAtIndex:i]] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
        }
        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages8 count]),ScreenHeight-115)];
        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页

    }
    //    if (index==9) {
    //
    //        countstr=self.slideImages8.count;
    //        self.pageControl.numberOfPages = [self.slideImages8 count];
    //        self.pageControl.currentPage = 0;
    //
    //        // 创建四个图片 imageview
    //        for (int i = 0;i<[self.slideImages8 count];i++)
    //        {
    //
    //            UIImage* img=[UIImage imageNamed:[self.slideImages objectAtIndex:i]];
    //            UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    //            btn.frame=CGRectMake(((ScreenWidth-img.size.width/2)/2)+(ScreenWidth * i), 0, img.size.width/2, img.size.height/2);
    //            [btn setBackgroundImage:[UIImage imageNamed:[self.self.slideImages8 objectAtIndex:i]] forState:UIControlStateNormal];
    //            [btn addTarget:self action:@selector(gongfaActive:) forControlEvents:UIControlEventTouchUpInside];
    //            [self.scrollImgView addSubview:btn]; // 首页是第0页,默认从第1页开始的。所以+320
    //        }
    //        [self.scrollImgView setContentSize:CGSizeMake(ScreenWidth * ([self.slideImages8 count]),ScreenHeight-64-51)];
    //        [self.scrollImgView setContentOffset:CGPointMake(0, 0)];
    //        [self.scrollImgView scrollRectToVisible:CGRectMake(0,0,ScreenWidth,ScreenHeight-64-51) animated:YES]; // 默认从序号1位置放第1页
    //        
    //    }
    
    [self.countBtn setTitle:[NSString stringWithFormat:@"1/%ld",(long)countstr] forState:UIControlStateNormal];
    
    [self rel];
}


- (void)showChildView{
    //显示子账户
    
    
}

- (NSDictionary *)styleDictionary{
    if (_styleDictionary == nil) {
        _styleDictionary = @{@"商":@"3",@"羽":@"4",@"徵":@"5",@"角":@"6",@"宫":@"7"};
    }
    
    return _styleDictionary;
}
@end
