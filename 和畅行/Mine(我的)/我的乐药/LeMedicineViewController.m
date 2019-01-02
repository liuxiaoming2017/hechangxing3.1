//
//  LeMedicineViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/12.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "LeMedicineViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "LoginViewController.h"
#import "NoMessageView.h"

@interface LeMedicineViewController ()<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate,AVAudioPlayerDelegate,MBProgressHUDDelegate>

{
    UIButton* btnbfzt;
    UIView  *noView;
}
@property (nonatomic ,retain) NSString *leyaoPath;
@property (nonatomic ,retain) NSString *otherPaths;

@end

@implementation LeMedicineViewController
@synthesize LeMdicinaTab;

-(void)dealloc{
    [super dealloc];
   // [_leyaoPath release];
   // [_otherPaths release];
    //[_fileurl release];
    [_LeMedicArray release];
    [_LeMedicArrayId release];
    [_bfztbutton release];
    [LeMdicinaTab release];
    [playmp3 release];
    [playTime release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.label.text = @"加载中...";
    [progress_ showAnimated:YES];
}

- (void)hudWasHidden
{
    
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    [progress_ release];
    progress_ = nil;
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    if ([UserShareOnce shareOnce].mp3.playing) {
        
        if (self.bfztbutton!=nil)
        {
            for (int m=0; m<self.bfztbutton.subviews.count;m++) {
                UIImageView* imageImg=[self.bfztbutton.subviews objectAtIndex:m];
                [imageImg removeFromSuperview];
            }
        }
        UIImage* statusviewImg=[UIImage imageNamed:@"New_yy_zt_zt.png"];
        UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
        statusviewImgview.image=statusviewImg;
        [self.bfztbutton addSubview:statusviewImgview];
        [statusviewImgview release];
        self.fileurl=@"";
        [[UserShareOnce shareOnce].mp3 stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"#f2f1ef"];
    self.navTitleLabel.text = @"我的乐药";
    
    UIImage* LeMedicineTypeImg=[UIImage imageNamed:@"LeMedicineType_img.png"];
    UIImageView* LeMedicineImgView=[[UIImageView alloc] init];
    LeMedicineImgView.frame=CGRectMake(0, kNavBarHeight, ScreenWidth, 40);
    LeMedicineImgView.image=LeMedicineTypeImg;
    [self.view addSubview:LeMedicineImgView];
    [LeMedicineImgView release];
    
    UILabel* TYPE_Name=[[UILabel alloc] init];
    TYPE_Name.frame=CGRectMake(0, (LeMedicineImgView.frame.size.height-21)/2+kNavBarHeight, 120, 21);
    TYPE_Name.text=@"名称";
    
    TYPE_Name.font=[UIFont systemFontOfSize:13];
    TYPE_Name.textAlignment = NSTextAlignmentCenter;
    TYPE_Name.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    [self.view addSubview:TYPE_Name];
    [TYPE_Name release];
    
    UILabel* TYPE_Buy_Date=[[UILabel alloc] init];
    TYPE_Buy_Date.frame=CGRectMake(TYPE_Name.frame.origin.x+TYPE_Name.frame.size.width+5+22.5, (LeMedicineImgView.frame.size.height-21)/2+kNavBarHeight, 70, 21);
    TYPE_Buy_Date.text=@"下载时间";
    
    TYPE_Buy_Date.font=[UIFont systemFontOfSize:13];
    TYPE_Buy_Date.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    [self.view addSubview:TYPE_Buy_Date];
    [TYPE_Buy_Date release];
    
    UILabel* TYPE_Consumption_amount=[[UILabel alloc] init];
    TYPE_Consumption_amount.frame=CGRectMake(TYPE_Buy_Date.frame.origin.x+TYPE_Buy_Date.frame.size.width+30, (LeMedicineImgView.frame.size.height-21)/2+kNavBarHeight, 54, 21);
    TYPE_Consumption_amount.text=@"消费金额";
    //TYPE_Consumption_amount.hidden=YES;
    TYPE_Consumption_amount.font=[UIFont systemFontOfSize:13];
    TYPE_Consumption_amount.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    [self.view addSubview:TYPE_Consumption_amount];
    [TYPE_Consumption_amount release];
    
    UILabel* TYPE_Operation=[[UILabel alloc] init];
    TYPE_Operation.frame=CGRectMake(ScreenWidth-22.5-28, (LeMedicineImgView.frame.size.height-21)/2+kNavBarHeight, 28, 21);
    TYPE_Operation.text=@"操作";
    
    TYPE_Operation.font=[UIFont systemFontOfSize:13];
    TYPE_Operation.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    [self.view addSubview:TYPE_Operation];
    [TYPE_Operation release];
    
    
    UITableView *tableview=[[UITableView alloc]init];
    tableview.frame=CGRectMake(0,LeMedicineImgView.bottom, ScreenWidth, ScreenHeight-LeMedicineImgView.bottom);
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // tableview.separatorColor =[UIColor clearColor];//
    tableview.backgroundColor=[UIColor clearColor];
    self.LeMdicinaTab=tableview;
    
    [self.view addSubview:tableview];
    [tableview release];
    NSMutableArray*  datatarray=[NSMutableArray new];
    self.LeMedicArray=datatarray;
    [datatarray release];
    [self GetResourceslist];
}
-(void)GetResourceslist
{
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/resources/list/%@.jhtml",UrlPre,[UserShareOnce shareOnce].uid];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"version" value:@"ios_jlsl-yh-3"];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestResourceslistError:)];
    [request setDidFinishSelector:@selector(requestResourceslistCompleted:)];
    [request startAsynchronous];
}

- (void)requestResourceslistError:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    [av release];
}
- (void)requestResourceslistCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        self.LeMedicArray=[dic objectForKey:@"data"];
        NSLog(@"我的乐药：%@",dic);
        if (self.LeMedicArray.count == 0) {
            noView = [NoMessageView createImageWith:100.0f];
            [self.view addSubview:noView];
            return ;
        }
        if (noView) {
            [noView removeFromSuperview];
        }
        [self.LeMdicinaTab reloadData];
    }
    else if ([status intValue]==44)
    {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        av.tag = 100008;
        [av show];
        [av release];
    }else{
        NSString *str = [dic objectForKey:@"data"];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        //av.tag = 100008;
        [av show];
        [av release];
    }
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==100008)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        [loginVC release];
    }
    if (alertView.tag == 50002&&buttonIndex == 1) {
        
        _downloadHanlder = [DownloadHandler sharedInstance];
        
        [_downloadHanlder.downloadingDic setValue:@"downloading" forKey:[NSString stringWithFormat:@"%@",[[self.otherPaths componentsSeparatedByString:@"."] objectAtIndex:0]]];
        
        NSString* aurl=[NSString stringWithFormat:@"%@",self.leyaoPath];
        aurl = [aurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        for (int i=0; i<btnbfzt.subviews.count; i++)
        {
            UIView* view=[btnbfzt.subviews objectAtIndex:i];
            if ([view isKindOfClass:[UIImageView class]] )
            {
                [view removeFromSuperview];
            }
        }
        
        _progress = [[ProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 30, 33)];
        _downloadHanlder.name = [NSString stringWithFormat:@"%@",[[self.otherPaths componentsSeparatedByString:@"."] objectAtIndex:0]];
        _progress.frame=self.bfztbutton.bounds;
        [self.bfztbutton addSubview:_progress];
        
        _downloadHanlder.url = aurl;
        [_downloadHanlder setButton:self.bfztbutton];
        [_progress release];
        
        
        _downloadHanlder.fileType =@"mp3";
        _downloadHanlder.savePath = [self Createfilepath];
        
        [_downloadHanlder setProgress:_progress] ;
        [_downloadHanlder start];
        
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float height=47;
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.LeMedicArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LeMedicineCell";
    // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellStyleDefault];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier]autorelease];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    else
    {
        while ([cell.contentView.subviews lastObject] != nil)
        {
            
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    UILabel* lbname=[[UILabel alloc] init];
    lbname.frame=CGRectMake(14.5, (cell.frame.size.height-23)/2, 120, 23);
    lbname.backgroundColor=[UIColor clearColor];
    lbname.textColor=[UtilityFunc colorWithHexString:@"#666666"];
    lbname.font=[UIFont systemFontOfSize:11];
    lbname.text=[[self.LeMedicArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell addSubview:lbname];
    [lbname release];
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[[[self.LeMedicArray objectAtIndex:indexPath.row] objectForKey:@"createDate"] doubleValue]/1000.00];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    NSString *confromTimespStr = [formatter stringFromDate:d];
    
    UILabel* lbBuy_Date=[[UILabel alloc] init];
//    lbBuy_Date.backgroundColor = [UIColor blackColor];
    lbBuy_Date.frame=CGRectMake(lbname.frame.origin.x+lbname.frame.size.width+5, (cell.frame.size.height-40)/2, 70, 40);
    lbBuy_Date.backgroundColor=[UIColor clearColor];
    lbBuy_Date.textColor=[UtilityFunc colorWithHexString:@"#666666"];
    lbBuy_Date.font=[UIFont systemFontOfSize:11];
    lbBuy_Date.text=confromTimespStr;
    lbBuy_Date.textAlignment = NSTextAlignmentCenter;
    lbBuy_Date.numberOfLines = 0;
    [cell addSubview:lbBuy_Date];
    [lbBuy_Date release];
    
    UILabel* lbBuy_aCount=[[UILabel alloc] init];
    lbBuy_aCount.frame=CGRectMake(lbBuy_Date.frame.origin.x+lbBuy_Date.frame.size.width+30, (cell.frame.size.height-23)/2, 54, 23);
    lbBuy_aCount.backgroundColor=[UIColor clearColor];
    lbBuy_aCount.textColor=[UtilityFunc colorWithHexString:@"#ff9933"];
    lbBuy_aCount.font=[UIFont systemFontOfSize:11];
//    if ([[[self.LeMedicArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]>0) {
//        lbBuy_aCount.hidden=NO;
//    }
//    else{
//        lbBuy_aCount.hidden=YES;
//    }
    lbBuy_aCount.text=[NSString stringWithFormat:@"¥%.2f",[[[self.LeMedicArray objectAtIndex:indexPath.row] objectForKey:@"price"]floatValue]];//@"¥1.00";
    lbBuy_aCount.textAlignment=1;
    [cell addSubview:lbBuy_aCount];
    [lbBuy_aCount release];
    
    UIImage* statusviewImg = nil;
    NSString* filepath=[self Createfilepath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    //    if (self.bfztbutton!=nil)
    //    {
    //        for (int m=0; m<self.bfztbutton.subviews.count;m++) {
    //            UIImageView* imageImg=[self.bfztbutton.subviews objectAtIndex:m];
    //            [imageImg removeFromSuperview];
    //        }
    //    }
    NSString* NewFileName=[[[[self.LeMedicArray objectAtIndex:indexPath.row] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
    NSArray*Urlarray=[NewFileName componentsSeparatedByString:@"/"];
    NSString* urlpathname= [Urlarray objectAtIndex:Urlarray.count-1];
    NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", urlpathname]];
    //urlpath = [urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
    if (fileExists) {
        NSLog(@"已存在");
        if (self.bfztbutton!=nil)
        {
            if (self.bfztbutton.tag==indexPath.row+10000&&self.fileurl.length>0&&[UserShareOnce shareOnce].mp3.playing) {
                statusviewImg=[UIImage imageNamed:@"New_yy_zt_bf.png"];
            }
            else
            {
                statusviewImg=[UIImage imageNamed:@"New_yy_zt_zt.png"];
            }
        }
        else
        {
            statusviewImg=[UIImage imageNamed:@"New_yy_zt_zt.png"];
        }
        
    }
    else
    {
        statusviewImg=[UIImage imageNamed:@"New_yy_zt_xz.png"];
        NSLog(@"不存在");
    }
    if ([[_downloadHanlder.downloadingDic objectForKey:[NSString stringWithFormat:@"%@",[[urlpathname componentsSeparatedByString:@"."] objectAtIndex:0]]] length]>0)
    {
        UIButton* statusbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        statusbtn.frame=CGRectMake(ScreenWidth-statusviewImg.size.height/2-24.5, (cell.frame.size.height-statusviewImg.size.height/2)/2, statusviewImg.size.width/2  , statusviewImg.size.height/2);
        [statusbtn addTarget:self action:@selector(DownloadButton:) forControlEvents:UIControlEventTouchUpInside];
        statusbtn.tag=indexPath.row+10000;//[[[self.segmendatatarray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        [_downloadHanlder setButton:statusbtn];
        
        [statusbtn addSubview:[_downloadHanlder.progressDic objectForKey:[NSString stringWithFormat:@"%@",[[urlpathname componentsSeparatedByString:@"."] objectAtIndex:0]]]];
        [cell addSubview:statusbtn];
    }
    else
    {
        UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
        statusviewImgview.image=statusviewImg;
        UIButton* statusbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        statusbtn.tag=indexPath.row+10000;//[[[self.segmendatatarray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        statusbtn.frame=CGRectMake(ScreenWidth-statusviewImg.size.height/2-24.5, (cell.frame.size.height-statusviewImg.size.height/2)/2, statusviewImg.size.width/2+10  , statusviewImg.size.height/2+10);
        [statusbtn addTarget:self action:@selector(DownloadButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [statusbtn addSubview:statusviewImgview];
        
        [statusviewImgview release];
        [cell addSubview:statusbtn];
    }
    UILabel* Linebg=[[UILabel alloc] init];
    Linebg.frame=CGRectMake(5, cell.frame.size.height-0.5, ScreenWidth-10, 0.5);
    Linebg.backgroundColor=[UtilityFunc colorWithHexString:@"#d8d8d8"];
    [cell addSubview:Linebg];
    [Linebg release];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSString*) Createfilepath
{
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *folderPath = [path stringByAppendingPathComponent:@"temp"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    if(!fileExists)
    {
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return folderPath;
}
-(void)DownloadButton:(id)sender
{
    btnbfzt=(UIButton*)sender;
    
    NSString* filepath=[self Createfilepath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    NSString* NewFileName=[[[[self.LeMedicArray objectAtIndex:(long)btnbfzt.tag-10000] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
    NSArray*Urlarray=[NewFileName componentsSeparatedByString:@"/"];
    NSString* urlpathname= [Urlarray objectAtIndex:Urlarray.count-1];
    NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",urlpathname]];
    if (self.fileurl.length!=0)
    {
        if ([self.fileurl isEqualToString:urlpath]) {
            if ([UserShareOnce shareOnce].mp3.playing) {
                
                if (self.bfztbutton!=nil)
                {
                    for (int m=0; m<self.bfztbutton.subviews.count;m++) {
                        UIImageView* imageImg=[self.bfztbutton.subviews objectAtIndex:m];
                        [imageImg removeFromSuperview];
                    }
                    
                }
                for (int i=0; i<btnbfzt.subviews.count; i++)
                {
                    UIView* view=[btnbfzt.subviews objectAtIndex:i];
                    if ([view isKindOfClass:[UIImageView class]] )
                    {
                        [view removeFromSuperview];
                    }
                }
                self.bfztbutton=(UIButton*)sender;
                UIImage* statusviewImg=[UIImage imageNamed:@"New_yy_zt_zt.png"];
                UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
                statusviewImgview.image=statusviewImg;
                [self.bfztbutton addSubview:statusviewImgview];
                [statusviewImgview release];
                self.fileurl=@"";
                [[UserShareOnce shareOnce].mp3 stop];
            }
            else
            {
                if (self.bfztbutton!=nil)
                {
                    for (int m=0; m<self.bfztbutton.subviews.count;m++) {
                        UIImageView* imageImg=[self.bfztbutton.subviews objectAtIndex:m];
                        [imageImg removeFromSuperview];
                    }
                    UIImage* statusviewImg=[UIImage imageNamed:@"New_yy_zt_zt.png"];
                    UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
                    statusviewImgview.image=statusviewImg;
                    [self.bfztbutton addSubview:statusviewImgview];
                    [statusviewImgview release];
                }
                self.bfztbutton=(UIButton*)sender;
                
                if (self.bfztbutton!=nil)
                {
                    for (int m=0; m<self.bfztbutton.subviews.count;m++) {
                        UIImageView* imageImg=[self.bfztbutton.subviews objectAtIndex:m];
                        [imageImg removeFromSuperview];
                    }
                }
                UIImage* statusviewImg=[UIImage imageNamed:@"New_yy_zt_bf.png"];
                UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
                statusviewImgview.image=statusviewImg;
                [self.bfztbutton addSubview:statusviewImgview];
                [statusviewImgview release];
                [[UserShareOnce shareOnce].mp3 prepareToPlay];
                [[UserShareOnce shareOnce].mp3 play];
                [LeMdicinaTab reloadData];
                //  playmp3= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(paly) userInfo:nil repeats:NO];
                self.fileurl=urlpath;
            }
            return;
        }
        else{
            
            
            urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *url = [NSURL URLWithString:urlpath];
            BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
            if (fileExists)
            {
                
                if (self.bfztbutton!=nil)
                {
                    for (int m=0; m<self.bfztbutton.subviews.count;m++) {
                        
                        UIImageView* imageImg=[self.bfztbutton.subviews objectAtIndex:m];
                        [imageImg removeFromSuperview];
                        
                    }
                    UIImage* statusviewImg=[UIImage imageNamed:@"New_yy_zt_zt.png"];
                    UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
                    statusviewImgview.image=statusviewImg;
                    [self.bfztbutton addSubview:statusviewImgview];
                    [statusviewImgview release];
                }
                self.bfztbutton=(UIButton*)sender;
                if (self.bfztbutton!=nil)
                {
                    for (int m=0; m<self.bfztbutton.subviews.count;m++) {
                        
                        UIImageView* imageImg=[self.bfztbutton.subviews objectAtIndex:m];
                        [imageImg removeFromSuperview];
                    }
                }
                UIImage* statusviewImg=[UIImage imageNamed:@"New_yy_zt_bf.png"];
                UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
                statusviewImgview.image=statusviewImg;
                [self.bfztbutton addSubview:statusviewImgview];
                [statusviewImgview release];
                self.fileurl=urlpath;
                if ([UserShareOnce shareOnce].mp3)
                {
                    if ([UserShareOnce shareOnce].mp3.playing) {
                        [[UserShareOnce shareOnce].mp3 pause];
                    }
                    
                    [[UserShareOnce shareOnce].mp3 release];
                    [UserShareOnce shareOnce].mp3 =nil;
                }
                [UserShareOnce shareOnce].mp3 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
                [[UserShareOnce shareOnce].mp3 setDelegate:self];//设置代理
                [UserShareOnce shareOnce].mp3.volume = 0.5;//播放音量
                [[UserShareOnce shareOnce].mp3 prepareToPlay];
                [[UserShareOnce shareOnce].mp3 play];
                [LeMdicinaTab reloadData];
                //playmp3= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(paly) userInfo:nil repeats:NO];
                NSLog(@"已存在");
            }
            else
            {
                _downloadHanlder = [DownloadHandler sharedInstance];
                [_downloadHanlder.downloadingDic setValue:@"downloading" forKey:[NSString stringWithFormat:@"%@",[[urlpathname componentsSeparatedByString:@"."] objectAtIndex:0]]];
                NSLog(@"不存在");
                
                NSString* aurl=[NSString stringWithFormat:@"%@",NewFileName];
                aurl = [aurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                for (int i=0; i<btnbfzt.subviews.count; i++)
                {
                    UIView* view=[btnbfzt.subviews objectAtIndex:i];
                    if ([view isKindOfClass:[UIImageView class]] )
                    {
                        [view removeFromSuperview];
                    }
                }
                _progress = [[ProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 30, 33)];
                _downloadHanlder.name = [NSString stringWithFormat:@"%@",[[urlpathname componentsSeparatedByString:@"."] objectAtIndex:0]];
                _progress.frame=btnbfzt.bounds;
                [btnbfzt addSubview:_progress];
                
                _downloadHanlder.url = aurl;
                [_downloadHanlder setButton:btnbfzt];
                [_progress release];
                // _downloadHanlder.name = [NSString stringWithFormat:@"%ld",(long)btnbfzt.tag];
                _downloadHanlder.fileType =@"mp3";
                _downloadHanlder.savePath = [self Createfilepath];
                
                [_downloadHanlder setProgress:_progress] ;
                [_downloadHanlder start];
            }
        }
        
    }
    else{
        
        urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:urlpath];
        BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
        if (fileExists)
        {
            if (btnbfzt!=nil)
            {
                for (int m=0; m<btnbfzt.subviews.count;m++) {
                    
                    UIImageView* imageImg=[btnbfzt.subviews objectAtIndex:m];
                    [imageImg removeFromSuperview];
                }
            }
            self.bfztbutton=(UIButton*)sender;
            UIImage* statusviewImg=[UIImage imageNamed:@"New_yy_zt_bf.png"];
            UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
            statusviewImgview.image=statusviewImg;
            [self.bfztbutton addSubview:statusviewImgview];
            [statusviewImgview release];
            self.fileurl=urlpath;
            if ([UserShareOnce shareOnce].mp3)
            {
                if ([UserShareOnce shareOnce].mp3.playing) {
                    [[UserShareOnce shareOnce].mp3 pause];
                }
                
                [[UserShareOnce shareOnce].mp3 release];
                [UserShareOnce shareOnce].mp3 =nil;
            }
            [UserShareOnce shareOnce].mp3 = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
            [[UserShareOnce shareOnce].mp3 setDelegate:self];//设置代理
            [UserShareOnce shareOnce].mp3.volume = 0.5;//播放音量
            [[UserShareOnce shareOnce].mp3 prepareToPlay];
            [[UserShareOnce shareOnce].mp3 play];
            [LeMdicinaTab reloadData];
            //playmp3= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(paly) userInfo:nil repeats:NO];
            NSLog(@"已存在");
        }
        else
        {
            
            self.bfztbutton=(UIButton*)sender;
            self.otherPaths = urlpathname;
            self.leyaoPath = NewFileName;
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定下载该曲目吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            av.tag = 50002;
            [av show];
            [av release];
        }
    }
    
}

-(void) paly
{
    [[UserShareOnce shareOnce].mp3 play];//播放音乐
    
    [playmp3 invalidate];
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"finish");//设置代理的AVAudioPlayer对象每次播放结束都会触发这个函数
    [[UserShareOnce shareOnce].mp3 pause];
    [UserShareOnce shareOnce].mp3 = nil;
    [LeMdicinaTab reloadData];
    
}
-(NSString *)getPathOfDocuments{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    return path;
}


@end
