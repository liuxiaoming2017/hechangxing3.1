//
//  LectureDetailViewController.h
//  Voicediagno
//
//  Created by Mymac on 15/10/26.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//
#import "SayAndWriteController.h"
#import "HealthLectureModel.h"

@interface LectureDetailViewController : SayAndWriteController

@property (nonatomic,assign) NSString *url;
@property (nonatomic,assign) NSInteger leftPassengers;
@property (nonatomic,assign) float price;
@property (nonatomic,retain) HealthLectureModel *model;

@end
