//
//  ArchiveModel.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/23.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ArchiveModel : NSObject

@property (nonatomic,assign) NSInteger cellType;
@property (nonatomic,copy) NSString *iconImage;
@property (nonatomic,copy) NSString *result;
@property (nonatomic,copy) NSString *symptom;
@property (nonatomic,assign) NSString *time;
@property (nonatomic,copy) NSString *category;

@property (nonatomic,copy) NSString *subject_sn;
@end
