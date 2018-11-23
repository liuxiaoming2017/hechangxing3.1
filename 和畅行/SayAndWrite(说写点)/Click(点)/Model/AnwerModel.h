//
//  AnwerModel.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/13.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnwerModel : NSObject


@property (nonatomic,assign) NSInteger order;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,assign) NSInteger answer_id;
@property (nonatomic,assign) NSInteger type_id;
@property (nonatomic,copy) NSString *name;

@end
