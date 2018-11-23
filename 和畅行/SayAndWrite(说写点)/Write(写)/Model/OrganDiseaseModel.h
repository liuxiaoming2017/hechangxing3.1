//
//  OrganDiseaseModel.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/7.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrganDiseaseModel : NSObject

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *MICD;
@property (nonatomic,copy) NSString *MTJI;
@property (nonatomic,assign) int SEX;

@property (nonatomic,assign) BOOL isSelected;//是否已经选中
@property (nonatomic,assign) NSInteger currentIndex;//被选中时的次序

@end
