//
//  EEGDetailController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/26.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "EEGDetailController.h"
#import "HeartLive.h"

@interface EEGDetailController ()

@property (nonatomic , strong) NSArray *dataSource;
@property (nonatomic , strong) HeartLive *refreshMoniterView;
@property (nonatomic, assign) NSInteger number;

@property (nonatomic,strong) NSTimer *timer;
@end

@implementation EEGDetailController
@synthesize timer;

- (void)dealloc
{
    self.dataSource = nil;
    [self.refreshMoniterView removeFromSuperview];
    self.refreshMoniterView = nil;
}

- (HeartLive *)refreshMoniterView
{
    if (!_refreshMoniterView) {
        CGFloat xOffset = 10;
        _refreshMoniterView = [[HeartLive alloc] initWithFrame:CGRectMake(xOffset, kNavBarHeight+xOffset, ScreenWidth - 2 * xOffset, 240)];
        _refreshMoniterView.backgroundColor = [UIColor blackColor];
    }
    return _refreshMoniterView;
}

- (void)goBack:(UIButton *)btn
{
    if(timer.valid){
        [timer invalidate];
    }
    timer = nil;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = @"心电图查看";
    self.navTitleLabel.textColor = [UIColor whiteColor];
    self.topView.backgroundColor = UIColorFromHex(0x1e82d2);
 //   [self.leftBtn setImage:[UIImage imageNamed:@"user_01"] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:@"message_01"] forState:UIControlStateNormal];
    self.rightBtn.userInteractionEnabled = NO;
    self.leftBtn.userInteractionEnabled = NO;
    self.preBtn.hidden = NO;
    self.leftBtn.hidden = YES;
    
    NSURL *url = [NSURL URLWithString:self.dataPath];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [data writeToFile:uploadHealthData atomically:YES];
    
    NSLog(@"haha:%@,number:%ld",uploadHealthData,self.number);
    
    //获取心电数据
    Byte *bytes = (Byte *)[data bytes];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < data.length; i +=7) {
        int num = bytes[i];
        
        if (num != 0) {
            [dataArray addObject:[NSString stringWithFormat:@"%d",num]];
        }
        
    }
    self.number = 0;
    self.dataSource = dataArray;
    
    [self.view addSubview:self.refreshMoniterView];
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timerRefresnFun) userInfo:nil repeats:YES];
    timer = [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(timerRefresnFun) userInfo:nil repeats:YES];
    //加入主循环池中
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    //开始循环
    [timer fire];
}



//刷新方式绘制
- (void)timerRefresnFun
{
    [[PointContainer sharedContainer] addPointAsRefreshChangeform:[self bubbleRefreshPoint]];
    [[PointContainer sharedContainer] addPointAsRefreshChangeform:[self bubbleRefreshPoint]];
    [[PointContainer sharedContainer] addPointAsRefreshChangeform:[self bubbleRefreshPoint]];
    [[PointContainer sharedContainer] addPointAsRefreshChangeform:[self bubbleRefreshPoint]];
    
    
    [self.refreshMoniterView fireDrawingWithPoints:[PointContainer sharedContainer].refreshPointContainer pointsCount:[PointContainer sharedContainer].numberOfRefreshElements];
    
}

#pragma mark - DataSource

- (CGPoint)bubbleRefreshPoint
{
    static NSInteger dataSourceCounterIndex = -1;
    dataSourceCounterIndex ++;
    
    if(self.dataSource.count == 0) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"数据错误" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertVC addAction:alertAct1];
        [self presentViewController:alertVC animated:YES completion:NULL];
        
    }
    
    dataSourceCounterIndex %= [self.dataSource count];
    
    
    float pixelPerPoint = 0.3;
    static float xCoordinateInMoniter = 0;
    
    CGPoint targetPointToAdd = (CGPoint){xCoordinateInMoniter,[self.dataSource[dataSourceCounterIndex] integerValue] * -0.5 + 150};
    xCoordinateInMoniter += pixelPerPoint;
    if (xCoordinateInMoniter >= (int)(CGRectGetWidth(self.refreshMoniterView.frame))) {
        xCoordinateInMoniter = 0;
        [self changeDataSource];
        //        [[PointContainer sharedContainer] fixOffSet];
    }
    
    return targetPointToAdd;
}

- (void)changeDataSource
{
    self.number ++;
    if (self.number > 6) {
        self.number = 0;
    }
    
    
    
   // NSURL *url = [NSURL URLWithString:self.dataPath];
    NSData *data = [NSData dataWithContentsOfFile:uploadHealthData];
    
    //[data writeToFile:uploadHealthData atomically:YES];
    
    //NSLog(@"haha:%@",uploadHealthData);
    
    //获取心电数据
    Byte *bytes = (Byte *)[data bytes];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (NSInteger i = self.number; i < data.length; i +=7) {
        int num = bytes[i];
        
        if (num != 0) {
            [dataArray addObject:[NSString stringWithFormat:@"%d",num]];
        }
        
    }
    
    self.dataSource = dataArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
