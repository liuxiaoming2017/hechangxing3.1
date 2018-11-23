//
//  OrganDiseaseListViewController.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/4.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "SayAndWriteController.h"

typedef void (^refreshCellBlock)(NSInteger row);

@interface OrganDiseaseListViewController : SayAndWriteController

@property (nonatomic,retain) NSMutableArray *upData;
@property (nonatomic,assign) int sex;



@property (nonatomic,copy) refreshCellBlock refreshBlock;
-(void)refreshCellWith:(refreshCellBlock )block;

@end
