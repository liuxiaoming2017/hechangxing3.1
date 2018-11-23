//
//  TestBaseViewController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/8/21.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SayAndWriteController.h"

@interface TestBaseViewController : SayAndWriteController

@property (nonatomic,strong) MBProgressHUD *progressView;

- (void)showPreogressView;

- (void)hidePreogressView;

@end
