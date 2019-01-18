//
//  PayMentViewController.h
//  hechangyi
//
//  Created by ZhangYunguang on 16/5/4.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "SayAndWriteController.h"

@interface PayMentViewController : SayAndWriteController
@property (nonatomic ,copy) NSString *price;
@property (nonatomic ,strong) NSMutableArray *pricesArr;
@property (nonatomic ,strong) NSMutableArray *namesArr;
@property (nonatomic ,strong) NSMutableArray *idArr;
@property (nonatomic ,assign) NSInteger count;
@end
