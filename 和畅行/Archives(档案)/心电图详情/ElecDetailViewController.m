//
//  ElecDetailViewController.m
//  hechangyi
//
//  Created by ZhangYunguang on 16/4/13.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "ElecDetailViewController.h"
#import "LiveMonitorVC.h"
#import "HeartLive.h"

#define allCount  self.scrollView.contentSize.width / ScreenWidth
#define currentCount self.scrollView.contentOffset.x / ScreenHeight

@interface ElecDetailViewController()<UIScrollViewDelegate>
/**scrollView*/
@property (nonatomic,strong) UIScrollView *scrollView;
/**upBtn*/
@property (nonatomic,strong) UIButton *upBtn;
/**downBtn*/
@property (nonatomic,strong) UIButton *downBtn;


@end

@implementation ElecDetailViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    self.view.backgroundColor = UIColorFromHex(0x1e82d2);
    
    self.title = ModuleZW(@"心电图查看");
    UIColor *color = [UIColor whiteColor];
    NSDictionary *dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
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
    
    CGFloat duration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
    [UIView animateWithDuration:duration animations:^{
        self.navigationController.view.transform = CGAffineTransformIdentity;
        self.navigationController.view.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    }];


    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.frame = CGRectMake(0, 0, ScreenHeight, ScreenWidth);
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    NSURL *url = [NSURL URLWithString:self.dataPath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [data writeToFile:uploadHealthData atomically:YES];
    
    NSLog(@"haha:%@",uploadHealthData);
    
    //获取心电数据
    Byte *bytes = (Byte *)[data bytes];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < data.length; i +=7) {
        int num = bytes[i];

        if (num != 0) {
            [dataArray addObject:[NSString stringWithFormat:@"%d",num]];
        }
        
    }
    
    
    
    LiveMonitorVC *lm = [[LiveMonitorVC alloc] init];
    lm.tempData = dataArray;
    //心电图绘画的速度
    lm.drawingInterval = 0.000004;
    lm.sampleRate = 5000000;

    NSInteger pageCount = lm.tempData.count / ScreenHeight * 0.5 + 1;
    lm.frame = CGRectMake(0, 0, ScreenHeight * pageCount,ScreenWidth-45-kNavHeight);
    [lm heartView];
    
    scrollView.contentSize = CGSizeMake(lm.frame.size.width,0);
    [scrollView addSubview:lm];
    
    UIButton *upBtn = [[UIButton alloc] init];
    upBtn.enabled = NO;
    [upBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [upBtn setImage:[UIImage imageNamed:@"up_disabled"] forState:UIControlStateDisabled];
    [upBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    upBtn.frame = CGRectMake(0, ScreenWidth - upBtn.currentImage.size.height - 10, ScreenHeight * 0.5, upBtn.currentImage.size.height);
    //    upBtn.frame = CGRectMake(0, 300, ScreenW * 0.5, upBtn.currentImage.size.height);
    [upBtn addTarget:self action:@selector(upBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.upBtn = upBtn;
    [self.view addSubview:upBtn];
    NSLog(@"h:%f",upBtn.currentImage.size.height);
    UIButton *downBtn = [[UIButton alloc] init];
    [downBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"down_disabled"] forState:UIControlStateDisabled];
    [downBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    downBtn.frame = CGRectMake(ScreenHeight * 0.5, ScreenWidth - downBtn.currentImage.size.height - 10, ScreenHeight * 0.5, downBtn.currentImage.size.height);
    [downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.downBtn = downBtn;
    [self.view addSubview:downBtn];
    
}


- (void)upBtnClick{
    
    if (currentCount > 0) {
        self.scrollView.contentOffset = CGPointMake(ScreenHeight * (currentCount - 1), self.scrollView.contentOffset.y);
        self.downBtn.enabled = YES;
    }
    
    if (currentCount == 0) {
        // 上一页 失效
        self.upBtn.enabled = NO;
    }
}

- (void)downBtnClick{
    
    if (currentCount <  allCount - 1) {
        self.scrollView.contentOffset = CGPointMake(ScreenHeight * (currentCount + 1), self.scrollView.contentOffset.y);
        self.upBtn.enabled = YES;
    }
    
    if (currentCount == allCount - 1) {
        // 下一页 失效
        self.downBtn.enabled = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    NSLog(@"self.scrollView.contentOffset.x : %f ",scrollView.contentOffset.x);
}

- (void)leftBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden{
    return YES;//隐藏为YES，显示为NO
}



#pragma mark - 强制横屏
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

-(BOOL)shouldAutorotate{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight;
}

@end
