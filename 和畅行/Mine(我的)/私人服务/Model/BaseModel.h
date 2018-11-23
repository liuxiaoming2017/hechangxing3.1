//
//  BaseModel.h
//  Voicediagno
//
//  Created by Mymac on 15/10/15.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

//@property (nonatomic,retain) NSNumber *id;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
