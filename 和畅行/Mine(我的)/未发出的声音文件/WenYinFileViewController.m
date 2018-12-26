//
//  WenYinFileViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/12.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "WenYinFileViewController.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "LPPopup.h"

#import "WenYinFileCell.h"

@interface WenYinFileViewController ()<UITableViewDelegate ,UITableViewDataSource,MBProgressHUDDelegate,WenYinFileCellDelegate>
{
    UIView *noView;
}
@end

@implementation WenYinFileViewController
@synthesize WenYinTabView,WenYinArray;
@synthesize fieldpath,mp3name;
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
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dealloc{
   
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    
    
    
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
    
    progress_ = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"未发出声的文件";
    UILabel* lb1=[[UILabel alloc] init];
    lb1.frame=CGRectMake(0, kNavBarHeight, ScreenWidth, 1);
    lb1.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lb1];
    
    UITableView *tableview= [[UITableView alloc] init];
    tableview.frame=CGRectMake(0,kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight);
    tableview.delegate=self;
    tableview.dataSource=self;
    self.WenYinTabView=tableview;
    [self.view addSubview:self.WenYinTabView];
    
    [self setExtraCellLineHidden:tableview];
    NSFileManager *fileMgr = [NSFileManager defaultManager];    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageDir = [path stringByAppendingPathComponent:@"wybs"];
    imageDir = [NSString stringWithFormat:@"%@/Caches/%@", path, [UserShareOnce shareOnce].username];
    NSArray *files = [fileMgr subpathsAtPath: imageDir];
    NSMutableArray*  datatarray=[[NSMutableArray arrayWithArray:files] init];
    if (datatarray.count == 0) {
        noView = [NoMessageView createImageWith:200];
        [self.view addSubview:noView];
        return ;
    }
    self.WenYinArray=datatarray;
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 47;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return WenYinArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WinYinCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    NSLog(@"ddddd%f",cell.frame.size.height);
    UIImage* CellIcon=nil;
    CellIcon=[UIImage imageNamed:@"YY_GongIcon.png"];
    UIImageView * CellIconView=[[UIImageView alloc] init];
    CellIconView.frame=CGRectMake(20, (cell.frame.size.height-CellIcon.size.height/2)/2, CellIcon.size.width/2, CellIcon.size.height/2);
    CellIconView.image=CellIcon;
    [cell addSubview:CellIconView];
    
    
    UILabel* lbname=[[UILabel alloc] init];
    lbname.frame=CGRectMake(CellIconView.frame.origin.x+CellIconView.frame.size.width+8, (cell.frame.size.height-23)/2, 54, 23);
    lbname.backgroundColor=[UIColor clearColor];
    lbname.textColor=[UtilityFunc colorWithHexString:@"#666666"];
    lbname.font=[UIFont systemFontOfSize:12];
    lbname.text=@"经络辨识";
    [cell addSubview:lbname];
    
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageDir = [path stringByAppendingPathComponent:@"wybs"];
    imageDir = [NSString stringWithFormat:@"%@/Caches/%@", path, [UserShareOnce shareOnce].username];
    NSString* pathfinal= [imageDir stringByAppendingPathComponent:[self.WenYinArray objectAtIndex:indexPath.row]];
    float filesize= [[fileMgr attributesOfItemAtPath:pathfinal error:nil] fileSize];
    NSLog(@"pathfinal===%@",pathfinal);
    //float filesize= [[fileMgr attributesOfItemAtPath:pathfinal error:nil] fileSize];
    NSLog(@"filesize==%f",filesize);
    NSString *string2 = [[self.WenYinArray objectAtIndex:indexPath.row ] substringWithRange:NSMakeRange(2, 4)];
    NSLog(@"string2==%@",string2);
    NSString *string3 = [[self.WenYinArray objectAtIndex:indexPath.row ] substringWithRange:NSMakeRange(6, 2)];
    NSLog(@"string3==%@",string3);
    NSString *string4 = [[self.WenYinArray objectAtIndex:indexPath.row ] substringWithRange:NSMakeRange(8, 2)];
    NSLog(@"string4==%@",string4);
    
    UILabel* lbDate=[[UILabel alloc] init];
    lbDate.frame=CGRectMake(lbname.frame.origin.x+lbname.frame.size.width+22, (cell.frame.size.height-23)/2, 140, 23);
    lbDate.backgroundColor=[UIColor clearColor];
    lbDate.textColor=[UtilityFunc colorWithHexString:@"#666666"];
    lbDate.font=[UIFont systemFontOfSize:10];
    lbDate.text=[NSString stringWithFormat:@"时间:%@年%@月%@日",string2,string3,string4];
    [cell addSubview:lbDate];
    
    
    
    UIImage* CellAccessImg=[UIImage imageNamed:@"My_upIcon.png"];
    UIButton* CellAcessImgView=[UIButton buttonWithType:UIButtonTypeCustom];
    CellAcessImgView.tag=indexPath.row+10000;
    CellAcessImgView.frame=CGRectMake(lbDate.frame.origin.x+lbDate.frame.size.width+20.5, (cell.frame.size.height-CellAccessImg.size.width/2)/2, CellAccessImg.size.width/2, CellAccessImg.size.height/2);
    [CellAcessImgView addTarget:self action:@selector(AcessActive:) forControlEvents:UIControlEventTouchUpInside];
    [CellAcessImgView setImage:CellAccessImg forState:UIControlStateNormal];
    [cell addSubview:CellAcessImgView];
    
    UIImage* CellDeleImg=[UIImage imageNamed:@"My_DeleIcon.png"];
    UIButton* CellDeleImgView=[UIButton buttonWithType:UIButtonTypeCustom];
    CellDeleImgView.tag=indexPath.row+10000;
    CellDeleImgView.frame=CGRectMake(CellAcessImgView.frame.origin.x+CellAcessImgView.frame.size.width+15, (cell.frame.size.height-CellAccessImg.size.width/2)/2, CellDeleImg.size.width/2, CellDeleImg.size.height/2);
    [CellDeleImgView addTarget:self action:@selector(DeleActive:) forControlEvents:UIControlEventTouchUpInside];
    [CellDeleImgView setImage:CellDeleImg forState:UIControlStateNormal];
    [cell addSubview:CellDeleImgView];
   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return;
}
-(void)AcessActive:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageDir = [path stringByAppendingPathComponent:@"wybs"];
    imageDir = [NSString stringWithFormat:@"%@/Caches/%@", path, [UserShareOnce shareOnce].username];
    NSLog(@"self.WenYinArray==%@",self.WenYinArray);
    NSString* styr=[self.WenYinArray objectAtIndex:btn.tag-10000];
    self.mp3name=[NSString stringWithFormat:@"%@",styr];
    self.fieldpath= [imageDir stringByAppendingPathComponent:[self.WenYinArray objectAtIndex:btn.tag-10000]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认重传吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    av.tag=90001;
    [av show];
    
}
-(void)DeleActive:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    //NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageDir = [path stringByAppendingPathComponent:@"wybs"];
    imageDir = [NSString stringWithFormat:@"%@/Caches/%@", path, [UserShareOnce shareOnce].username];
    NSLog(@"self.WenYinArray==%@",self.WenYinArray);
    NSString* styr=[self.WenYinArray objectAtIndex:btn.tag-10000];
    self.mp3name=[NSString stringWithFormat:@"%@",styr];
    self.fieldpath= [imageDir stringByAppendingPathComponent:[self.WenYinArray objectAtIndex:btn.tag-10000]];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    av.tag=90002;
    [av show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==90001)
    {
        if (buttonIndex==1)
        {
            [self testMp3Upload];
        }
        else
        {
            
        }
        
    }else
    {
        if (buttonIndex==1) {
            
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            BOOL bRet = [fileMgr fileExistsAtPath:self.fieldpath];
            if (bRet) {
                [self.WenYinArray removeAllObjects];
                NSError *err;
                [fileMgr removeItemAtPath:self.fieldpath error:&err];
                
                NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                NSString *imageDir = [path stringByAppendingPathComponent:@"wybs"];
                imageDir = [NSString stringWithFormat:@"%@/Caches/%@", path, [UserShareOnce shareOnce].username];
                NSArray *files = [fileMgr subpathsAtPath: imageDir];
                NSLog(@"files==%@",files);
                NSMutableArray*  datatarray=[[NSMutableArray arrayWithArray:files] init];
                self.WenYinArray=datatarray;
                [self.WenYinTabView reloadData];
            }
            else
            {
                
            }
            
        }
    }
}

-(void)testMp3Upload
{
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@member/fileUpload/diagnosis.jhtml?convert=convert&memberChildId=%@",UrlPre,[MemberUserShance shareOnce].idNum];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url1 = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url1];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setFile:self.fieldpath forKey:@"file"];   //可以上传图片
    [request setDidFailSelector:@selector(requestUpLoadError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestUpLoadCompleted:)];
    [request startAsynchronous];
   
}
- (void)requestUpLoadCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        LPPopup *popup = [LPPopup popupWithText:@"您的录音已成功上传，正在进行分析。分析报告审核完成后，会发送至您的手机上，请注意查收。"];
        CGPoint point=self.view.center;
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bRet = [fileMgr fileExistsAtPath:self.fieldpath];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:self.fieldpath error:&err];
            
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *imageDir = [path stringByAppendingPathComponent:@"wybs"];
            imageDir = [NSString stringWithFormat:@"%@/Caches/%@", path, [UserShareOnce shareOnce].username];
            NSArray *files = [fileMgr subpathsAtPath: imageDir];
            
            NSLog(@"files==%@",files);
            NSMutableArray*  datatarray=[[NSMutableArray arrayWithArray:files] init];
            self.WenYinArray=datatarray;
            [self.WenYinTabView reloadData];
        }
    }
    else
    {
        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
        LPPopup *popup = [LPPopup popupWithText:str];
        CGPoint point=self.view.center;
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
    }
}
- (void)requestUpLoadError:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    LPPopup *popup = [LPPopup popupWithText:@"抱歉，由于长时间无法连接到网络，系统将您的录音放在了“我的”的“未发出声的文件”里，您可以选择手工上传或删除。"];
    CGPoint point=self.view.center;
    point.y=point.y+130;
    [popup showInView:self.view
        centerAtPoint:point
             duration:5.0f
           completion:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
}
-(NSString *)getPathOfDocuments{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths lastObject];
    return path;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)GetConverAndParse:(NSString *)armfilestr
{
    
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/diagnosis/convertAndParse.jhtml?amrFile=%@&memberChildId=%@",UrlPre,armfilestr,[MemberUserShance shareOnce].idNum];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url1 = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url1];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request setDidFailSelector:@selector(requestConverAndParseError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestConverAndParseCompleted:)];
    [request startAsynchronous];
   
}
- (void)requestConverAndParseError:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
}
- (void)requestConverAndParseCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bRet = [fileMgr fileExistsAtPath:self.fieldpath];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:self.fieldpath error:&err];
            
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            NSString *imageDir = [path stringByAppendingPathComponent:@"wybs"];
            imageDir = [NSString stringWithFormat:@"%@/Caches/%@", path, [UserShareOnce shareOnce].username];
            NSArray *files = [fileMgr subpathsAtPath: imageDir];
            NSLog(@"files==%@",files);
            NSMutableArray*  datatarray=[[NSMutableArray arrayWithArray:files] init];
            self.WenYinArray=datatarray;
            [self.WenYinTabView reloadData];
        }    }
    else
    {
        LPPopup *popup = [LPPopup popupWithText:@"抱歉，由于长时间无法连接到网络，系统将您的录音放在了“我的”的“未发出声的文件”里，您可以选择手工上传或删除。"];
        CGPoint point=self.view.center;
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
