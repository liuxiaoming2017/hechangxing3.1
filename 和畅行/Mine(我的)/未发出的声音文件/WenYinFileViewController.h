//
//  WenYinFileViewController.h
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/12.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "SayAndWriteController.h"

@interface WenYinFileViewController : SayAndWriteController
{
    NSString* mp3name;
    MBProgressHUD* progress_;
}

@property ( nonatomic,retain) UITableView* WenYinTabView;
@property (nonatomic,retain) NSMutableArray* WenYinArray;
@property( nonatomic,retain) NSString* fieldpath;
@property( nonatomic,retain) NSString* mp3name;
@end
