//
//  DownLoadHandlers.m
//  Voicediagno
//
//  Created by 李传铎 on 15/10/12.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "DownLoadHandlers.h"

static DownLoadHandlers *sharedDownloadhandler = nil;

@implementation DownLoadHandlers{
    ASIHTTPRequest *_request;
    ASINetworkQueue *_queue;
    NSString *_pathOfTmp;
    ProgressIndicator *_progress;
    UILabel *_label;
    unsigned long long _dataSize;
    //    BOOL _downloading;
}
@synthesize downdelegate;
@synthesize url = _url;
@synthesize name = _name;
@synthesize fileType = _fileType;
@synthesize savePath = _savePath;
@synthesize progress = _progress;
@synthesize btnImg=_btnImg;
+(DownLoadHandlers *)sharedInstance{
    if (!sharedDownloadhandler) {
        sharedDownloadhandler = [[DownLoadHandlers alloc] init];
    }
    return sharedDownloadhandler;
}
-(void)setButton:(UIButton*)btn
{
    [btn retain];
    
    _btnImg=btn;
    
    [self.btnDic setObject:_btnImg forKey:[NSString stringWithFormat:@"%@",_name]];
}
-(void)setProgress:(ProgressIndicator *)progress
{
    [progress retain];
    _progress=progress;
    [self.progressDic setObject:_progress forKey:[NSString stringWithFormat:@"%@",_name]];
}
-(id)init{
    if (self = [super init]) {
        if (!_queue) {
            _queue = [[ASINetworkQueue alloc] init];
            _queue.showAccurateProgress = YES;
            _queue.shouldCancelAllRequestsOnFailure = NO;
            [_queue go];
        }
        self.downloadingDic = [NSMutableDictionary dictionaryWithCapacity:10];
        self.progressDic=[NSMutableDictionary dictionaryWithCapacity:10];
        self.btnDic=[NSMutableDictionary dictionaryWithCapacity:10];
        //        _downloading = NO;
    }
    return self;
}
-(void)start{
    for (ASIHTTPRequest *r in [_queue operations]) {
        NSString *fileName = [r.userInfo objectForKey:@"Name"];
        if ([fileName isEqualToString:_name]) {
            return;//队列中已存在特定request时，退出
        }
    }
    //    if (_downloading) {
    //        return;
    //    }
    NSURL *url = [NSURL URLWithString:_url];
    _request = [ASIHTTPRequest requestWithURL:url];
    [_request setTimeOutSeconds:60];
    _request.delegate = self;
    _request.temporaryFileDownloadPath = [self cachesPath];
    _request.downloadDestinationPath = [self actualSavePath];
    _request.downloadProgressDelegate = _progress;
    _request.allowResumeForFileDownloads = YES;
    _request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_name, @"Name", nil];
    [_queue addOperation:_request];
}
-(NSString *)actualSavePath{
    return [_savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _name, _fileType]];
}
-(NSString *)cachesPath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _name, _fileType]];
    return path;
}
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
    NSLog(@"total size: %lld", request.contentLength);
    
    for (ASIHTTPRequest *r in [_queue operations]) {
        NSString *fileName = [r.userInfo objectForKey:@"Name"];
        if ([self.progressDic objectForKey:fileName] !=nil) {
            _progress =[self.progressDic objectForKey:fileName];//=request.contentLength/1024.0/1024.0;
            _progress.totalSize = request.contentLength/1024.0/1024.0;
            //[[self.btnDic objectForKey:fileName] addSubview:_progress];
        }
    }
    
}
-(void)requestStarted:(ASIHTTPRequest *)request{
    //    _downloading = YES;
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    
    NSString *fileName = [request.userInfo objectForKey:@"Name"];
    
    if ([self.btnDic objectForKey:fileName] !=nil) {
        NSLog(@"wwwwwwwwwwwwwww");
        for (int i=0; i<[[self.btnDic objectForKey:fileName] subviews].count; i++)
        {
            UIView* view=[[[self.btnDic objectForKey:fileName] subviews] objectAtIndex:i];
            [view removeFromSuperview];
        }
        UIImage* statusviewImg=[UIImage imageNamed:@"运动示范音_03.png"];
        UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(5, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
        statusviewImgview.image=statusviewImg;
        [[self.btnDic objectForKey:fileName] addSubview:statusviewImgview];
        [statusviewImgview release];
        [self.downloadingDic removeObjectForKey:fileName];
        [self.progressDic removeObjectForKey:fileName];
        [self.btnDic removeObjectForKey:fileName];
        [request clearDelegatesAndCancel];
    }
    
    
    if (self.downdelegate && [self.downdelegate respondsToSelector:@selector(DownloadHandlerSelectAtIndex:)]) {
        [self.downdelegate DownloadHandlerSelectAtIndex:_btnImg.tag - 10000];
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"download failed, error: %@", error);
    
    
    for (int i=0; i<_btnImg.subviews.count; i++)
    {
        UIView* view=[_btnImg.subviews objectAtIndex:i];
        [view removeFromSuperview];
    }
    UIImage* statusviewImg=[UIImage imageNamed:@"New_yy_zt_xz.png"];
    UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
    statusviewImgview.image=statusviewImg;
    [_btnImg addSubview:statusviewImgview];
    [statusviewImgview release];
    [self removeRequestFromQueue];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"下载失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    [av release];
    //    _downloading = NO;
}
-(void)removeRequestFromQueue{
    for (ASIHTTPRequest *r in [_queue operations]) {
        NSString *fileName = [r.userInfo objectForKey:@"Name"];
        if ([fileName isEqualToString:_name]) {
            [r clearDelegatesAndCancel];
        }
    }
}
//-(void)unzipFile{
//    NSString *unzipPath = [_savePath stringByAppendingPathComponent:_name];
//    ZipArchive *unzip = [[ZipArchive alloc] init];
//    if ([unzip UnzipOpenFile:[self actualSavePath]]) {
//        BOOL result = [unzip UnzipFileTo:unzipPath overWrite:YES];
//        if (result) {
//            NSLog(@"unzip successfully");
//        }
//        [unzip UnzipCloseFile];
//    }
//    [unzip release];
//    unzip = nil;
//}
-(void)dealloc{
    [_queue release];
    _queue = nil;
    [_progress release];
    _progress = nil;
    [_label release];
    _label = nil;
    [super dealloc];
}
@end
