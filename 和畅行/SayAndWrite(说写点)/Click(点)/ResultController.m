        //
//  ResultController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ResultController.h"
#import <WebKit/WebKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "JSONKit.h"

#import "QuestionListController.h"
#import "TipClickController.h"

@interface ResultController ()<WKUIDelegate,WKNavigationDelegate>

@end

@implementation ResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = ModuleZW(@"健康档案");
    NSString *str = [NSString stringWithFormat:@"member/service/reshow.jhtml?sn=%@&device=1",self.TZBSstr];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,str];
    
    
    [self customeViewWithStr:urlStr];
}



# pragma mark - 解决侧滑返回指定控制器
- (void)willMoveToParentViewController:(UIViewController*)parent
{
    
    
}

- (void)didMoveToParentViewController:(UIViewController*)parent
{
    NSMutableArray *tempArr = self.navigationController.viewControllers.mutableCopy;
    for(UIViewController *vc in self.navigationController.viewControllers){
        if([vc isKindOfClass:[QuestionListController class]]||[vc isKindOfClass:[TipClickController class]]){
            [tempArr removeObject:vc];
        }
    }
    self.navigationController.viewControllers = tempArr;
}



- (void)goBack:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.endTimeStr = [GlobalCommon getCurrentTimes];
    [GlobalCommon pageDurationWithpageId:@"8" withstartTime:self.startTimeStr withendTime:self.endTimeStr];
}



@end
