//
//  SongListModel.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/27.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongListModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *source;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,assign) float price;

@property (nonatomic,copy) NSString *status;

@property (nonatomic,copy) NSString *subjectSn;

@end
