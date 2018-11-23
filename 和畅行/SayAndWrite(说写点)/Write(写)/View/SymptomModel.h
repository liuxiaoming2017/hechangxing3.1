//
//  SymptomModel.h
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/2.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//
/***************** 症状模型 *******************/
#import <Foundation/Foundation.h>

@interface SymptomModel : NSObject

@property (nonatomic,retain) NSNumber *symptomId;//症状id
@property (nonatomic,copy) NSString *symptom;   //症状
@property (nonatomic,copy) NSString *personPart;//区域
@property (nonatomic,copy) NSString *part;      //部位
@property (nonatomic,retain) NSNumber *sexType;//使用性别
@property (nonatomic,copy) NSString *inputCode;//症状表示代码
@property (nonatomic,copy) NSString *symDescription;//症状描述
@property (nonatomic,retain) NSNumber *fPrivate;//用于表示cell是否选中

@property (nonatomic,assign) NSInteger currentIndex;//病症cell（右）被选中时的次序
@property (nonatomic,assign) CGFloat extent;  //程度：  0.7 -->轻度   1.0 -->中度  1.2 -->重度

@end
