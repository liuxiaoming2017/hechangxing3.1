//
//  BreathCheckViewController.h
//  Voicediagno
//
//  Created by Mymac on 15/9/25.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "TestBaseViewController.h"

@interface BreathCheckViewController : TestBaseViewController


@property (nonatomic ,strong) NSMutableArray *headArray;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *sexLabel;
@property (nonatomic ,copy) NSString *memberChildId;
@property (nonatomic ,strong) UIView *personView;
@property (nonatomic ,strong) UIView *showView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end
