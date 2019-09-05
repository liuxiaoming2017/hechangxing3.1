//
//  CardModel.h
//  Voicediagno
//
//  Created by Mymac on 15/10/27.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "BaseModel.h"

@interface CardModel : BaseModel

@property (nonatomic,retain) NSNumber *id;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,retain) NSNumber *balance;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *prefix;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,assign) BOOL isEnabled;

@end

