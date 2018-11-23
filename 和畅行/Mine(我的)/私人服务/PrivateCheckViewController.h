//
//  PrivateCheckViewController.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/11/27.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "SayAndWriteController.h"
#import "SelectedAdvisorModel.h"

@interface PrivateCheckViewController : SayAndWriteController

@property (nonatomic,retain) SelectedAdvisorModel *model;
@property (nonatomic,copy) NSString *category;

@end
