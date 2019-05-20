//
//  MoxaHelpViewController.m
//  MoxaAdvisor
//
//  Created by wangdong on 15/6/12.
//  Copyright (c) 2015年 jiudaifu. All rights reserved.
//

#import "MoxaHelpViewController.h"
#import <moxibustion/BlueToothCommon.h>


@interface MoxaHelpViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *starLbale;
@property (weak, nonatomic) IBOutlet UILabel *one3Label;
@property (weak, nonatomic) IBOutlet UILabel *touchLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoTLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeTLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIView *page1View;
@property (strong, nonatomic) IBOutlet UIView *page2View;

@property (retain, nonatomic) NSArray *menuArray;
@property (assign, nonatomic) CGFloat page1Hei;
@property (assign, nonatomic) CGFloat page2Hei;
@property (assign, nonatomic) CGFloat page3Hei;
@property (assign, nonatomic) BOOL isFirstIn;


@property (weak, nonatomic) id<UIGestureRecognizerDelegate> restoreInteractivePopGestureDelegate;

@end



@implementation MoxaHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _isFirstIn = true;
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //self.navigationController.interactivePopGestureRecognizer.delegate = self;
/*
 @property (weak, nonatomic) IBOutlet UILabel *starLbale;
 @property (weak, nonatomic) IBOutlet UILabel *one3Label;
 @property (weak, nonatomic) IBOutlet UILabel *touchLabel;
 @property (weak, nonatomic) IBOutlet UILabel *twoLabel;
 @property (weak, nonatomic) IBOutlet UILabel *twoTLabel;
 @property (weak, nonatomic) IBOutlet UILabel *threeLabel;
 @property (weak, nonatomic) IBOutlet UILabel *threeTLabel;*/
    
    self.starLbale.text = ModuleZW(@"1.启动/关闭灸疗连接");
    self.touchLabel.text = ModuleZW(@"①点击“一键开”按钮，可控制所有灸头的“开”或“关”");
    self.one3Label.text = ModuleZW(@"②点击单个灸头图标，可独立控制该灸头的“开”或“关”");
    self.twoLabel.text = ModuleZW(@"2. 调整灸头的温度和时间");
    self.twoTLabel.text = ModuleZW(@"点击需要调整参数的灸头，在弹出的调整界面，通过左右滑动或者点击“+”“-”符号，可调整具体的灸疗温度和时间");
    self.threeLabel.text = ModuleZW(@"3. 长按灸头震动三下");
    self.threeTLabel.text = ModuleZW(@"用手点击灸头并长按，即可震动三下，便于查找相应的灸头");
    
    self.leftBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    self.preBtn.hidden = NO;
    self.navTitleLabel.text = ModuleZW(@"操作指引");
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//        self.navigationItem.title = @"操作指引";
//        [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}


-(void)viewDidLayoutSubviews{
    if (_isFirstIn) {
        _isFirstIn = false;
        [self initViewsAndDatas];
    }
}


#pragma mark - mtself
- (void)initViewsAndDatas {
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    
    [_pageControl setBackgroundColor:[UIColor clearColor]];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    
    _scrollView.delegate = self;
    
    _menuArray = [[NSArray alloc]initWithObjects:ModuleZW(@"操作指引"), ModuleZW(@"艾灸禁忌"), ModuleZW(@"注意事项"), nil];
    
//    if([AppDelegate getmoxaMode] == MOXAMODE_ONE){
//        _page1Hei = 568;
//        _page1View.frame = CGRectMake(0, 0, self.view.frame.size.width, _page1Hei);
//        [_scrollView addSubview:_page1View];
//    }else{
        _page1Hei = 866;
        _page2View.frame = CGRectMake(0, 0, self.view.frame.size.width, _page1Hei);
        [_scrollView addSubview:_page2View];
//    }
    _scrollView.pagingEnabled = YES;
    UILabel *label = [[UILabel alloc]init];
    UIFont *font = [UIFont systemFontOfSize:16.0];

    NSString *str = ModuleZW(@"1、装有心脏起搏器者禁用CAJ-68/66型隔物灸仪，建议使用CAJ-100A型隔物灸仪。\n2、醉酒、空腹、过饥、过饱、大惊、大怒、大渴、大汗、极度疲劳以及对灸法恐惧者禁灸！\n3、孕妇的腹部和腰骶部禁灸！\n4、皮肤溃疡处、瘢痕处禁灸！瘢痕体质者必须在医生指导下灸疗！\n5、患有高热、昏迷、抽搐等急症或危重病人禁灸！\n6、婴幼儿、不配合灸疗的儿童、感\n7、心力衰竭及呼吸衰竭者禁灸！\n8、对颜面、五官和有大血管的部位以及关节活动部位慎灸，以防起泡留下瘢痕，影响美容。\n9、体弱者，初次灸疗温度不宜超过45℃，时间不宜超过30分钟。\n10、严禁未成年人、精神病患者以及有意识障碍者使用隔物灸仪自灸！\n11、中医诊断为湿热症、阴虚内热者，需要在医生指导下灸疗！\n12、糖尿病、高血压、心脏病、结核病患者，需要在医生指导下灸疗\n");
    CGFloat hei = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width-2*6, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size.height;
    [label setFrame:CGRectMake(SCREEN_WID+6, 6, SCREEN_WID-2*6, hei)];
    label.font = font;
    label.text = str;
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    _page2Hei = (hei+6);
    [_scrollView addSubview:label];
    
    str = ModuleZW(@"1、使用过程中应密切留意作用部位,若出现不适应立即停止使用。\n2、隔物灸仪工作时，灸头工作面中间的发热体的温度较高，严禁触摸！\n3、注意保暖:\n\t⑴ 一切准备妥当后再宽衣解带；\n\t ⑵ 除贴护垫和放置灸头时，短时间内暴露灸疗部位外，灸疗时不允许暴露灸疗部位，应有厚毛巾或棉被覆盖。身体的其他部位更不允许暴露；\n\t⑶ 冬天最好在温度不低于28℃、通风良好的室内施灸；夏天炎热，选择早晚凉爽时施灸。如果在空调房里施灸，空调温度不得低于28℃，并且要避开空调的出风口；春天、秋天施灸，也要注意保暖。\n\t⑷ 每次施灸结束时，特别是外感症，不要立即将灸头拿开，使施灸穴位的温度骤减。应停留几分钟，待施灸穴位的温度逐渐下降后再将灸头拿开。这样可避免风寒邪气乘穴道大开之时侵入。\n4、身上有汗、有水或油腻时，先擦拭干净后，再系绑带施灸，以防护垫滑落。\n5、灸疗过程中，每个人对热的耐受度不一样，不同的人应使用不同的灸疗温度;同一人不同的时间段、不同的部位、不同的穴位、不同经络耐温都不一样，应根据灸疗时的感觉分别调节输出温度。以不起泡为原则，以本人对热的耐受为度。\n6、建议灸疗时不要离开灸疗操作界面，以便感觉温度过高时，及时调低输出温度。\n7、灸疗结束后，不能马上离开灸疗的地方。应穿好衣服在原地停留10～15分钟才能离开；出汗者应等汗停后再离开。\n8、灸疗结束后，护垫的医用粘胶有可能和皮肤粘贴过紧，所以拆卸护垫时，动作应轻柔，避免弄伤皮肤。\n9、灸疗后，灸疗部位4小时内不能接触低于40℃以下的冷水。\n10、灸疗后调养：多喝热水，多吃营养丰富食物。\n11、一般每次灸疗时间以30~60分钟为宜；温度以45℃左右为宜。");
    
    UILabel *label2 = [[UILabel alloc]init];
    hei = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width-2*6, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil].size.height;
    [label2 setFrame:CGRectMake(SCREEN_WID*2+6, 6, SCREEN_WID-2*6, hei)];
    label2.font = font;
    label2.text = str;
    label2.numberOfLines = 0;
    _page3Hei = (hei+6);
    [_scrollView addSubview:label2];
    
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, _page1Hei);
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.view.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControl.currentPage = page;
    self.navigationItem.title = [_menuArray objectAtIndex:page];
    self.navTitleLabel.text = [_menuArray objectAtIndex:page];
    if (page == 0) {
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, _page1Hei);
    }else if (page == 1) {
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, _page2Hei);
    }else if (page == 2) {
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, _page3Hei);
    }
};


- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    
    return NO;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan && _scrollView.contentOffset.x == 0) {
            return NO;
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc {
    NSLog(@"");
}

@end
