//
//  CustomNavigationController.m
//  FounderReader-2.5
//
//  Created by 黄柳姣 on 2018/2/5.
//

#import "CustomNavigationController.h"
#import "MoxaHelpViewController.h"
#import "MySportController.h"
#import "ResultSpeakController.h"

@interface CustomNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id target = self.interactivePopGestureRecognizer.delegate;

    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

#pragma mark - UIGestureRecognizerDelegate
//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    // 根据具体控制器对象决定是否开启全屏右滑返回
    
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    if(self.viewControllers>0){
        UIViewController *vc = (UIViewController *)[self.viewControllers objectAtIndex:[self.viewControllers count] - 1];
        if([[self.viewControllers objectAtIndex:[self.viewControllers count] - 1] isKindOfClass:[MoxaHelpViewController class]] || [[self.viewControllers objectAtIndex:[self.viewControllers count] - 1] isKindOfClass:[MySportController class]] ){
            
            return NO;
        }
        if([vc isKindOfClass:[ResultSpeakController class]]){
            ResultSpeakController *vcc = ( ResultSpeakController *)vc;
            if([vcc.titleStr isEqualToString:@"季度报告详情"]){
                return NO;
            }
        }
    }
    
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return self.childViewControllers.count == 1 ? NO : YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
