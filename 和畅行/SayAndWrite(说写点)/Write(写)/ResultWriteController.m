//
//  ResultWriteController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/20.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ResultWriteController.h"

#import "HpiViewController.h"
#import "OrganDiseaseListViewController.h"
#import "WriteListController.h"
#import "TipWriteController.h"



@interface ResultWriteController ()

@end

@implementation ResultWriteController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = self.titleStr;
    [self customeViewWithStr:self.urlStr];
}

- (void)goBack:(UIButton *)btn
{
    if(self.isReturnTop){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSString *pageIDStr = @"";
    if ([self.navTitleLabel.text isEqualToString:ModuleZW(@"脏腑辨识")]) {
        pageIDStr = @"7";
    }
    if (![pageIDStr isEqualToString:@""]) {
        self.endTimeStr = [GlobalCommon getCurrentTimes];
        [GlobalCommon pageDurationWithpageId:pageIDStr withstartTime:self.startTimeStr withendTime:self.endTimeStr];
    }
}

# pragma mark - 解决侧滑返回指定控制器
- (void)didMoveToParentViewController:(UIViewController*)parent
{
    if(self.isReturnTop){
        NSMutableArray *tempArr = self.navigationController.viewControllers.mutableCopy;
        for(UIViewController *vc in self.navigationController.viewControllers){
            if([vc isKindOfClass:[HpiViewController class]]||[vc isKindOfClass:[OrganDiseaseListViewController class]]||[vc isKindOfClass:[WriteListController class]]||[vc isKindOfClass:[TipWriteController class]]){
                [tempArr removeObject:vc];
            }
        }
        self.navigationController.viewControllers = tempArr;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
