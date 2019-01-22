//
//  DownLoadHandlers.h
//  Voicediagno
//
//  Created by 李传铎 on 15/10/12.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ProgressIndicator.h"
@protocol DownloadHandlersDelegate <NSObject>

@required
//代理函数 获取当前下标
- (void)DownloadHandlerSelectAtIndex:(NSInteger)index;

@end

@interface DownLoadHandlers : NSObject<ASIHTTPRequestDelegate, ASIProgressDelegate>
@property (weak, nonatomic) id<DownloadHandlersDelegate> downdelegate;
@property(nonatomic,copy)NSString *url;
//下载资源的名称
@property(nonatomic,copy)NSString *name;
//下载资源的类型，即后缀
@property(nonatomic,copy)UIButton *btnImg;
@property(nonatomic,copy)NSString *fileType;
@property(nonatomic,copy)NSString *savePath;
@property (nonatomic,retain) NSMutableDictionary* downloadingDic;
@property (nonatomic,retain) NSMutableDictionary* progressDic;
@property (nonatomic,retain) NSMutableDictionary* btnDic;
@property(nonatomic,retain)ProgressIndicator *progress;
+(DownLoadHandlers *)sharedInstance;
-(void)start;
-(void)setButton:(UIButton*)btn;
@end
