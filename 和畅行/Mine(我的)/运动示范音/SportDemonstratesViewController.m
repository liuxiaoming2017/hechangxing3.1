//
//  SportDemonstratesViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/12.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "SportDemonstratesViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "LoginViewController.h"


@interface SportDemonstratesViewController ()<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate,AVAudioPlayerDelegate,MBProgressHUDDelegate,DownloadHandlersDelegate>
{
    UIButton* btnbfzt;
    int counts;
}
@property (nonatomic,strong)NSMutableSet *buttonSet;
@property (nonatomic,strong)NSArray *buttonArray;
@property (nonatomic,assign)BOOL isReload;
@end

@implementation SportDemonstratesViewController

@synthesize LeMdicinaTab;
- (void)dealloc{

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
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
        
        self.fileurl=@"";
        [[UserShareOnce shareOnce].mp3 stop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Do any additional setup after loading the view.
    counts = 0;
    self.isReload = YES;
    _buttonSet = [NSMutableSet set];
    _buttonArray = [NSArray array];
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"#ffffff"];
    self.navTitleLabel.text = ModuleZW(@"运动示范音");
    
    UITableView *tableview=[[UITableView alloc]init];
    tableview.frame=CGRectMake(0,kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight-56);
    tableview.delegate=self;
    tableview.dataSource=self;
    tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    // tableview.separatorColor =[UIColor clearColor];//
    tableview.backgroundColor=[UIColor clearColor];
    self.LeMdicinaTab=tableview;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:tableview];
    tableview.tableFooterView = [UIView new];
    
    self.LeMedicArray= [NSMutableArray array];
    
   
    [self GetResourceslist];
    
    UIView *diView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 56, self.view.frame.size.width, 56)];
    diView.backgroundColor = [UtilityFunc colorWithHexString:@"#f2f1ef"];
    [self.view addSubview:diView];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 60, 12, 120, 32)];
    imageV.image = [UIImage imageNamed:@"quanbuxiazai.png"];
    [diView addSubview:imageV];
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(self.view.frame.size.width / 2 - 60, 12, 120, 32);
    [imageButton addTarget:self action:@selector(imageButton) forControlEvents:UIControlEventTouchUpInside];
    [diView addSubview:imageButton];
    
    
    UIButton *removAllButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    removAllButton.frame = CGRectMake(ScreenWidth  - 120, 12, 100, 32);
    [removAllButton setTitle:@"删除全部" forState:(UIControlStateNormal)];
    [removAllButton addTarget:self action:@selector(removeAll) forControlEvents:(UIControlEventTouchUpInside)];
//    [diView addSubview:removAllButton];
    
}
- (void)imageButton{
    NSString* filepath=[self Createfilepath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
   for (int i = 0; i < self.LeMedicArray.count; i++) {
    NSString* NewFileNames=[[[[self.LeMedicArray objectAtIndex:i] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"];
    //    NSArray*Urlarray=[NewFileName componentsSeparatedByString:@"/"];
    //    NSString* urlpathname= [Urlarray objectAtIndex:Urlarray.count-1];
    NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", NewFileNames]];
    //urlpath = [urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
    if (fileExists) {
        NSLog(@"已存在");
        counts ++;
    }
       
    }
    if (counts == self.LeMedicArray.count ) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"你已经全部下载。") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        
        [av show];
        
        return;
    }
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"你确定要全部下载运动示范音吗？") delegate:self cancelButtonTitle:ModuleZW(@"取消") otherButtonTitles:ModuleZW(@"确定"),nil];
    av.tag = 34567;
    [av show];
   
}
-(void)GetResourceslist
{
    [GlobalCommon showMBHudWithView:self.view];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/resources/list.jhtml?sn=%@",UrlPre,@"ZY-YDSFY"];
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
    [GlobalCommon hideMBHudWithView:self.view];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    [self showAlertWarmMessage:requestErrorMessage];
}
- (void)requestResourceslistCompleted:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",dic);
    NSLog(@"%d",[status intValue]);
    if ([status intValue]==100)
    {
        self.LeMedicArray=[[dic objectForKey:@"data"]objectForKey:@"content"];
       
        [self.LeMdicinaTab reloadData];
    }
    else if ([status intValue]==44)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"登录超时，请重新登录") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        av.tag = 100008;
        [av show];
        
    }else {
        NSString *strStr = [dic objectForKey:@"data"];
        [self showAlertWarmMessage:strStr];
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==100008)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
    if (alertView.tag == 34567 &&buttonIndex == 1) {
        
        
        for (NSInteger i = self.buttonArray.count; i < self.LeMedicArray.count; i ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
            [self tableView: LeMdicinaTab cellForRowAtIndexPath: indexPath];
        }
        
        int xiazaiCount = 0;
        
        self.buttonArray = [_buttonSet allObjects];
        

        for (int i = 0; i < self.LeMedicArray.count; i ++) {
            
            NSString* filepath=[self Createfilepath];
            NSString* NewFileNames=[[[[self.LeMedicArray objectAtIndex:i] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"];
            
            NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",NewFileNames]];
            
            urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            // NSURL *url = [NSURL URLWithString:urlpath];
            
            NSString* NewFileNamess=[[[[self.LeMedicArray objectAtIndex:i] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
          
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
            
            if (!fileExists) {
                _downloadHanlder = [DownLoadHandlers sharedInstance];
                [_downloadHanlder.downloadingDic setValue:@"downloading" forKey:[NSString stringWithFormat:@"%@",[[[[self.LeMedicArray objectAtIndex:i] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"]]];
                NSLog(@"不存在");
                NSString* aurl=[NSString stringWithFormat:@"%@",NewFileNamess];
                aurl = [aurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                _downloadHanlder.name = [NSString stringWithFormat:@"%@",[[[[self.LeMedicArray objectAtIndex:i] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"]];
                
                _downloadHanlder.url = aurl;
                _downloadHanlder.fileType =@"mp3";
                _downloadHanlder.downdelegate = self;
                _downloadHanlder.savePath = [self Createfilepath];
            
               
                UIButton *button = self.buttonArray[i];
                ProgressIndicator *progressBar = [[ProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 30, 33)];
                progressBar.frame=button.bounds;
                [button addSubview:progressBar];
                [_downloadHanlder setButton:button];
                [_downloadHanlder setProgress:progressBar] ;
                [_downloadHanlder start];
                
                if (i == 0) {
                    [LeMdicinaTab reloadData];
                }
                
                xiazaiCount ++;
            }
            }
    
           

        
    }
    if (alertView.tag == 200008) {
        _downloadHanlder.downdelegate = nil;
        _downloadHanlder = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag == 1999 &&buttonIndex == 1) {
        btnbfzt.selected = YES;
        NSString* filepath=[self Createfilepath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //判断temp文件夹是否存在
        NSString* NewFileNames=[[[[self.LeMedicArray objectAtIndex:(long)btnbfzt.tag-10000] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"];
        NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",NewFileNames]];
        NSLog(@"111%@",urlpath);
        NSLog(@"12121212-------%@",self.fileurl);
        if (self.fileurl.length!=0)
        {
            
        }
        else{
            urlpath = [urlpath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
            if (fileExists)
            {
            }
            else
            {
                NSString* NewFileNamess=[[[[self.LeMedicArray objectAtIndex:(long)btnbfzt.tag-10000] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"source"];
                
                _downloadHanlder = [DownLoadHandlers sharedInstance];
                [_downloadHanlder.downloadingDic setValue:@"downloading" forKey:[NSString stringWithFormat:@"%@",[[[[self.LeMedicArray objectAtIndex:(long)btnbfzt.tag-10000] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"]]];
                NSLog(@"不存在");
                NSString* aurl=[NSString stringWithFormat:@"%@",NewFileNamess];
                aurl = [aurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                for (int i=0; i<btnbfzt.subviews.count; i++)
                {
                    UIView* view=[btnbfzt.subviews objectAtIndex:i];
                    if ([view isKindOfClass:[UIImageView class]] )
                    {
                        [view removeFromSuperview];
                    }
                }
                
                self.bfztbutton=btnbfzt;
                _progress = [[ProgressIndicator alloc] initWithFrame:CGRectMake(0, 0, 30, 33)];
                _downloadHanlder.name = [NSString stringWithFormat:@"%@",[[[[self.LeMedicArray objectAtIndex:(long)btnbfzt.tag-10000] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"]];
                _progress.frame=self.bfztbutton.bounds;
                [self.bfztbutton addSubview:_progress];
                
                _downloadHanlder.url = aurl;
                [_downloadHanlder setButton:self.bfztbutton];
                
                
                
                _downloadHanlder.fileType =@"mp3";
                _downloadHanlder.savePath = [self Createfilepath];
                
                [_downloadHanlder setProgress:_progress] ;
                [_downloadHanlder start];
            }
        }
        
        
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
    if (cell == nil)  {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }  else  {
        while ([cell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    UILabel* lbname=[[UILabel alloc] init];
    lbname.frame=CGRectMake(14.5, (cell.frame.size.height-23)/2, 80, 23);
    lbname.backgroundColor=[UIColor clearColor];
    lbname.textColor=[UtilityFunc colorWithHexString:@"#666666"];
    lbname.font=[UIFont systemFontOfSize:11];
    lbname.text=[[self.LeMedicArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    [cell addSubview:lbname];
   
    
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[[[self.LeMedicArray objectAtIndex:indexPath.row] objectForKey:@"createDate"] doubleValue]/1000.00];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    NSString *confromTimespStr = [formatter stringFromDate:d];
    
    //lbname.frame.origin.x+lbname.frame.size.width+5+30
    UILabel* lbBuy_Date=[[UILabel alloc] init];
    lbBuy_Date.frame=CGRectMake((ScreenWidth-130)/2.0, (cell.frame.size.height-23)/2, 130, 23);
    lbBuy_Date.backgroundColor=[UIColor clearColor];
    lbBuy_Date.textColor=[UtilityFunc colorWithHexString:@"#666666"];
    lbBuy_Date.font=[UIFont systemFontOfSize:11];
    lbBuy_Date.text=confromTimespStr;
    [cell addSubview:lbBuy_Date];
   
    
    
    UIImage* statusviewImg = nil;
    NSString* filepath=[self Createfilepath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* NewFileNames=[[[[self.LeMedicArray objectAtIndex:indexPath.row] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"];
    NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", NewFileNames]];
    BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
    
    if (fileExists) {
        NSLog(@"已存在");
        if (self.bfztbutton!=nil)   {
            if (self.bfztbutton.tag==indexPath.row+10000&&self.fileurl.length>0) {
                statusviewImg=[UIImage imageNamed:@"运动示范音_03.png"];
            } else  {
                statusviewImg=[UIImage imageNamed:@"运动示范音_03.png"];
            }
        }  else  {
            statusviewImg=[UIImage imageNamed:@"运动示范音_03.png"];
        }
        
    } else {
        statusviewImg=[UIImage imageNamed:@"New_yy_zt_xz.png"];
        NSLog(@"不存在");
        
    }
    if ([[_downloadHanlder.downloadingDic objectForKey:[NSString stringWithFormat:@"%@",[[[[self.LeMedicArray objectAtIndex:indexPath.row] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"]]] length]>0)
    {
        UIButton* statusbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        statusbtn.frame=CGRectMake(ScreenWidth-statusviewImg.size.height/2-24.5, (cell.frame.size.height-statusviewImg.size.height/2)/2, statusviewImg.size.width/2  , statusviewImg.size.height/2);
        [statusbtn addTarget:self action:@selector(DownloadButton:) forControlEvents:UIControlEventTouchUpInside];
        statusbtn.tag=indexPath.row+10000;//[[[self.segmendatatarray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        [_downloadHanlder setButton:statusbtn];
        
        [statusbtn addSubview:[_downloadHanlder.progressDic objectForKey:[NSString stringWithFormat:@"%@",[[[[self.LeMedicArray objectAtIndex:indexPath.row] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"]]]];
        [cell addSubview:statusbtn];
    } else  {
        UIImageView* statusviewImgview=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusviewImg.size.width/2  , statusviewImg.size.height/2)];
        statusviewImgview.image=statusviewImg;
        UIButton* statusbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        statusbtn.tag=indexPath.row+10000;//[[[self.segmendatatarray objectAtIndex:indexPath.row] objectForKey:@"id"] intValue];
        statusbtn.frame=CGRectMake(ScreenWidth-statusviewImg.size.height/2-24.5, (cell.frame.size.height-statusviewImg.size.height/2)/2, statusviewImg.size.width/2+10  , statusviewImg.size.height/2+10);
        [statusbtn addTarget:self action:@selector(DownloadButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [statusbtn addSubview:statusviewImgview];
        if (!fileExists) {
            [_buttonSet addObject:statusbtn];
        }
        [cell addSubview:statusbtn];
    }
    UILabel* Linebg=[[UILabel alloc] init];
    Linebg.frame=CGRectMake(5, cell.frame.size.height-0.5, ScreenWidth-10, 0.5);
    Linebg.backgroundColor=[UtilityFunc colorWithHexString:@"#d8d8d8"];
    [cell addSubview:Linebg];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
    if (btnbfzt.selected) {
        return;
    }else{
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"确定下载该曲目吗？") delegate:self cancelButtonTitle:ModuleZW(@"取消") otherButtonTitles:ModuleZW(@"确定"),nil];
        av.tag = 1999;
        [av show];
       
        
    }
}
-(NSString *)getPathOfDocuments{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    return path;
}

# pragma mark - 下载成功的代理回调
- (void)DownloadHandlerSelectAtIndex:(NSInteger)inde
{
    
    [LeMdicinaTab reloadData];

    NSLog(@"下载完成了");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//删除全部
-(void)removeAll {
    
    for (int i =  0;  i < _LeMedicArray.count ; i++) {
        UIImage* statusviewImg = nil;
        NSString* filepath=[self Createfilepath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString* NewFileNames=[[[[self.LeMedicArray objectAtIndex:i] objectForKey:@"resourcesWarehouses"] objectAtIndex:0] objectForKey:@"title"];
        NSString* urlpath= [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", NewFileNames]];
        BOOL fileExists = [fileManager fileExistsAtPath:urlpath];
        
        //删除全部
        NSError * error = nil ;
        if ([[NSFileManager defaultManager ] fileExistsAtPath :urlpath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :urlpath error :&error];
        }
    }
    [self.LeMdicinaTab reloadData];
  
}


@end
