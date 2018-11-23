//
//  WYViewController.h
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/13.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "SayAndWriteController.h"
#import "MBProgressHUD.h"


@interface WYViewController : SayAndWriteController

{
    CGPoint ptCenter;
    MBProgressHUD* progress_;
}
@property( nonatomic ,retain) UITextField* OriginalSec_TF;
@property( nonatomic ,retain) UITextField* NewSec_TF;
@property( nonatomic ,retain) UITextField* NewSure_TF;

@end
