//
//  PayMentViewController.m
//  hechangyi
//
//  Created by ZhangYunguang on 16/5/4.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "PayMentViewController.h"
#import "BlockTableViewCell.h"
#import "MBProgressHUD.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "PaySuccessViewController.h"
#import "PayAbnormalViewController.h"
#import "PayViewController.h"
#import "LoginViewController.h"
#import "SongListModel.h"
@interface PayMentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *scrollView;
    UILabel      *xianjinkaLabel;
    UILabel      *zongjiLabel;
    float         xianjika;
}
@property (nonatomic ,strong) UIImageView    *imageV;
@property (nonatomic ,strong) UILabel        *mLabel;
@property (nonatomic ,strong) UILabel        *hLabel;
@property (nonatomic ,strong) UILabel        *yLabel;
@property (nonatomic ,strong) UILabel        *wLabel;
@property (nonatomic ,strong) UILabel        *tLabel;
@property (nonatomic ,strong) UIImageView    *backImage;
@property (nonatomic ,copy) NSString       *idString;
@property (nonatomic ,strong) UITableView    *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UILabel        *jinerLabel;
@property (nonatomic ,assign) float          priceYuer;
@property (nonatomic ,assign) float          priceCountt;

@property (nonatomic,strong) UIView *cashcardView;

@end

@implementation PayMentViewController
@synthesize cashcardView;


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    xianjika = 0.0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navTitleLabel.text =  @"结算信息";
    
    self.dataArray = [[NSMutableArray alloc]init];
    
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kNavBarHeight, self.view.frame.size.width, self.view.frame.size.height - kNavBarHeight - kTabBarHeight-65)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [UserShareOnce shareOnce].yueYaoBuyArr.count*55) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.scrollEnabled = NO;
    //_tableView.rowHeight = 55;
    //self.automaticallyAdjustsScrollViewInsets = NO;
    [scrollView addSubview:_tableView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.bottom, ScreenWidth, 10)];
    lineView.backgroundColor = [UIColor colorWithRed:242/255.0 green:241/255.0 blue:239/255.0 alpha:1.0];
    [scrollView addSubview:lineView];
    
    //现金卡视图
    cashcardView = [[UIView alloc] initWithFrame:CGRectMake(0, _tableView.bottom+15, ScreenWidth, 245)];
    cashcardView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:cashcardView];
    
    UILabel *cardTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 25)];
    cardTitleLabel.font = [UIFont systemFontOfSize:18];
    cardTitleLabel.textAlignment = NSTextAlignmentLeft;
    cardTitleLabel.textColor = [UIColor grayColor];
    cardTitleLabel.text = @"现金卡支付";
    [cashcardView addSubview:cardTitleLabel];
    
    UIImageView *cardBackImg = [[UIImageView alloc]initWithFrame:CGRectMake(22, cardTitleLabel.bottom+5, self.view.frame.size.width - 44, 200)];
    cardBackImg.image = [UIImage imageNamed:@"cashcardBack.png"];
    [cashcardView addSubview:cardBackImg];
    
    
    UIImageView *no_CardImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth/2.0-50, cardBackImg.top+(cardBackImg.height-65)/2.0, 100, 40)];
    no_CardImage.image = [UIImage imageNamed:@"no_card.png"];
    [cashcardView addSubview:no_CardImage];
    
    UILabel *nocardLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth/2.0-100, no_CardImage.bottom+5, 200, 25)];
    nocardLabel.font = [UIFont systemFontOfSize:17];
    nocardLabel.textAlignment = NSTextAlignmentCenter;
    nocardLabel.textColor = [UIColor grayColor];
    nocardLabel.text = @"您当前还没有现金卡哦";
    [cashcardView addSubview:nocardLabel];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, cashcardView.bottom, ScreenWidth, 10)];
    lineView2.backgroundColor = [UIColor colorWithRed:242/255.0 green:241/255.0 blue:239/255.0 alpha:1.0];
    [scrollView addSubview:lineView2];
    
    
    
    
    scrollView.contentSize = CGSizeMake(1, lineView2.bottom);
    
    
  //  [self payMentWithBlock];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, scrollView.bottom, ScreenWidth, 65)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 25)];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"消费金额： ";
    [bottomView addSubview:titleLabel];
    
    UILabel *ciaofeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right, 10, 200, 25)];
    ciaofeiLabel.font = [UIFont systemFontOfSize:16];
    ciaofeiLabel.textAlignment = NSTextAlignmentLeft;
    ciaofeiLabel.textColor = [UtilityFunc colorWithHexString:@"#ff9933"];
    ciaofeiLabel.text = [NSString stringWithFormat:@"¥%.2f",[UserShareOnce shareOnce].allYueYaoPrice];
    [bottomView addSubview:ciaofeiLabel];
    
    UILabel *cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, 120, 25)];
    cardLabel.font = [UIFont systemFontOfSize:16];
    cardLabel.textAlignment = NSTextAlignmentRight;
    cardLabel.textColor = [UIColor blackColor];
    cardLabel.text = @"现金卡支付： ";
    [bottomView addSubview:cardLabel];
    
    UILabel *cardxiaofeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(cardLabel.right, cardLabel.top, 200, 25)];
    cardxiaofeiLabel.font = [UIFont systemFontOfSize:16];
    cardxiaofeiLabel.textAlignment = NSTextAlignmentLeft;
    cardxiaofeiLabel.textColor = [UtilityFunc colorWithHexString:@"#ff9933"];
    cardxiaofeiLabel.text = [NSString stringWithFormat:@"¥%.2f",0.00];
    [bottomView addSubview:cardxiaofeiLabel];
    
    
    UIView *zhifuView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-kTabBarHeight, ScreenWidth, 44)];
    zhifuView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:zhifuView];
    
    UIImageView *xiaofeijinerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 105, zhifuView.height)];
    xiaofeijinerImage.image = [UIImage imageNamed:@"leyaoxiaofeijiner.png"];
    [zhifuView addSubview:xiaofeijinerImage];
    
    UIImageView *jiesuanImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width -  105, 0, 105, 44)];
    jiesuanImage.image = [UIImage imageNamed:@"zhifudetu.png"];
    [zhifuView addSubview:jiesuanImage];
    
    UIImageView *gouwucheImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 12, 20, 20)];
    gouwucheImage.image = [UIImage imageNamed:@"qianbao.png"];
    [zhifuView addSubview:gouwucheImage];
    
    UILabel *zongjinerLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, 90, 20)];
    zongjinerLabel.text = @"还需支付：";
    zongjinerLabel.textAlignment = NSTextAlignmentRight;
    zongjinerLabel.textColor = [UIColor whiteColor];
    zongjinerLabel.font = [UIFont systemFontOfSize:16];
    [zhifuView addSubview:zongjinerLabel];
    
    _jinerLabel = [[UILabel alloc]initWithFrame:CGRectMake(zongjinerLabel.right, 12, 60, 20)];
   
    
    _jinerLabel.text = [NSString stringWithFormat:@"¥%.2f",[UserShareOnce shareOnce].allYueYaoPrice];
    _jinerLabel.textColor = [UIColor whiteColor];
    _jinerLabel.font = [UIFont boldSystemFontOfSize:16];
    [zhifuView addSubview:_jinerLabel];
    
    UIButton *jiesuanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    jiesuanButton.frame = CGRectMake(self.view.frame.size.width - 105, 0, 105, 44);
    [jiesuanButton addTarget:self action:@selector(zhifuqujiesuanButton) forControlEvents:UIControlEventTouchUpInside];
    [zhifuView addSubview:jiesuanButton];
    
    self.priceCountt = [UserShareOnce shareOnce].allYueYaoPrice;
    /*
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 104, self.view.frame.size.width, 60)];
    [self.view addSubview:view];
    UILabel *xiaofeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 10, 200, 20)];
    xiaofeiLabel.text = @"消费金额    －    现金卡支付    ＝    总计";
    xiaofeiLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    xiaofeiLabel.font = [UIFont systemFontOfSize:10];
    [view addSubview:xiaofeiLabel];
    UILabel *jineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, 70, 20)];
    jineLabel.text = [NSString stringWithFormat:@"%.2f",[UserShareOnce shareOnce].allYueYaoPrice];
    jineLabel.font = [UIFont systemFontOfSize:10];
    jineLabel.textAlignment = NSTextAlignmentCenter;
    jineLabel.textColor = [UtilityFunc colorWithHexString:@"#ff9933"];
    [view addSubview:jineLabel];
    xianjinkaLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 35, 80, 20)];
    xianjinkaLabel.text = [NSString stringWithFormat:@"%.1f",0.0];
    xianjinkaLabel.font = [UIFont systemFontOfSize:10];
    xianjinkaLabel.textAlignment = NSTextAlignmentCenter;
    xianjinkaLabel.textColor = [UtilityFunc colorWithHexString:@"#ff9933"];
    [view addSubview:xianjinkaLabel];
    zongjiLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 35, 80, 20)];
    zongjiLabel.text = [NSString stringWithFormat:@"%.2f",[UserShareOnce shareOnce].allYueYaoPrice];
    zongjiLabel.font = [UIFont systemFontOfSize:10];
    zongjiLabel.textAlignment = NSTextAlignmentCenter;
    zongjiLabel.textColor = [UtilityFunc colorWithHexString:@"#ff9933"];
    [view addSubview:zongjiLabel];
     */
}
- (void)zhifuqujiesuanButton{
    float price = [UserShareOnce shareOnce].allYueYaoPrice;
    
    if (price == 0) {
        [self showAlertWarmMessage:@"你还没有添加产品"];
        
        return;
    }
    [GlobalCommon showMBHudWithView:self.view];
    NSString *UrlPre=URL_PRE;
    NSString *idStr = @"";
    
    NSMutableArray *idArr = [NSMutableArray arrayWithCapacity:0];
    self.namesArr = [NSMutableArray arrayWithCapacity:0];
    for(SongListModel *model in [UserShareOnce shareOnce].yueYaoBuyArr){
        [idArr addObject:model.idStr];
        [self.namesArr addObject:model.title];
    }
    
    for (int i = 0; i < idArr.count; i ++) {
        if (idArr.count == 1) {
            idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%@",idArr[0]]];
        }else{
            if (i == idArr.count - 1) {
                idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%@",idArr[i]]];
            }else{
                if (i == 0) {
                    idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%@,",idArr[i]]];
                }else{
                    idStr = [idStr stringByAppendingString:[NSString stringWithFormat:@"%@,",idArr[i]]];
                }
            }
        }
    }
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/resources/reserve.jhtml?memberId=%@&ids=%@",UrlPre,[UserShareOnce shareOnce].uid,idStr];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestpayfangshiError:)];
    [request setDidFinishSelector:@selector(requestpayfangshiCompleted:)];
    [request startAsynchronous];
    
}
-(void)requestpayfangshiError:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    [self showAlertWarmMessage:requestErrorMessage];
    
}
-(void)requestpayfangshiCompleted:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    
    id status=[dic objectForKey:@"status"];
    NSLog(@"==%@",status);
    if (status!=nil)
    {
        if ([status intValue]==100)
        {
            self.idString = [NSString stringWithFormat:@"%@",[[[dic objectForKey:@"data"] objectForKey:@"order"]objectForKey:@"id"]];
            [self zhifufangshidequeding];
            
        }
        else if ([status intValue]==44) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            av.tag = 100008;
            [av show];
        } else
        {
            NSString *str = [dic objectForKey:@"data"];
            [self showAlertWarmMessage:str];
        }
    }
    
    
}
- (void)zhifufangshidequeding{
    float price = [UserShareOnce shareOnce].allYueYaoPrice;
    //清理z选中的订单
    [UserShareOnce shareOnce].allYueYaoPrice = 0;
    [[UserShareOnce shareOnce].yueYaoBuyArr removeAllObjects];
    
    NSMutableArray *arrayBlock = [[NSMutableArray alloc]init];
    if (price > 0 ) {
        if (self.dataArray.count > 0) {
            
            int count = 0;
            NSInteger tagCount = 0;
            for (int i = 0; i < self.dataArray.count; i ++) {
                
                UIButton *button = (UIButton *)[self.view viewWithTag:i + 2000];
                if (button.selected) {
                    count ++;
                    tagCount =  button.tag - 2000;
                    [arrayBlock addObject:[NSString stringWithFormat:@"%ld",(long)tagCount]];
                }
            }
            if (count > 0) {
                if (count == 1) {
                    if (price < [[self.dataArray[tagCount]objectForKey:@"balance"]floatValue]){
                        [self xianjinkazhifushengchengdingdan:[NSString stringWithFormat:@"%@:%f",[self.dataArray[tagCount]objectForKey:@"id"],price] balance:@"0"];
                    }
                    else{
                        //                        跳转到支付宝页面
                        PayViewController *appPayVC = [[PayViewController alloc]init];
                        appPayVC.idStr = _idString;
                        appPayVC.nameArr = [[NSMutableArray alloc]init];
                        appPayVC.nameArr = self.namesArr;
                        appPayVC.priceStr = [NSString stringWithFormat:@"%@:%@",[self.dataArray[tagCount]objectForKey:@"id"],[self.dataArray[tagCount]objectForKey:@"balance"]];
                        appPayVC.priceAPPStr = [NSString stringWithFormat:@"%f",(price - [[self.dataArray[tagCount]objectForKey:@"balance"] floatValue])];
                        [self.navigationController pushViewController:appPayVC animated:YES];
                        
                        
                    }
                }else{
                    float xianjinkazhifuPrice = 0.0;
                    float xianjinkaqian = 0.0;//前面几张卡的余额总数
                    for (int i = 0; i < arrayBlock.count; i++) {
                        xianjinkazhifuPrice += [[[self.dataArray objectAtIndex:[arrayBlock[i]integerValue]] objectForKey:@"balance"]floatValue];
                    }
                    if (xianjinkazhifuPrice > price) {
                        NSString *priceCounts = @"";
                        for (int i = 0; i < arrayBlock.count; i++) {
                            if (i == arrayBlock.count - 1) {
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@:",[[self.dataArray objectAtIndex:[arrayBlock[i]integerValue]]objectForKey:@"id"]]];
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%f",(xianjinkazhifuPrice - xianjinkaqian)]];
                            }else{
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@:",[[self.dataArray objectAtIndex:[arrayBlock[i]integerValue]]objectForKey:@"id"]]];
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@;",[[self.dataArray objectAtIndex:[arrayBlock[i]integerValue]] objectForKey:@"balance"]]];
                                xianjinkaqian += [[[self.dataArray objectAtIndex:[arrayBlock[i]integerValue]] objectForKey:@"balance"]floatValue];
                            }
                        }
                        [self xianjinkazhifushengchengdingdan:priceCounts balance:0];
                    }else{
                        NSString *priceCounts = @"";
                        for (int i = 0; i < arrayBlock.count; i++) {
                            if (i == arrayBlock.count - 1) {
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@:",[[self.dataArray objectAtIndex:[arrayBlock[i]integerValue]]objectForKey:@"id"]]];
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@",[[self.dataArray objectAtIndex:[arrayBlock[i]integerValue]] objectForKey:@"balance"]]];
                            }else{
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@:",[[self.dataArray objectAtIndex:[arrayBlock[i]integerValue]]objectForKey:@"id"]]];
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@;",[[self.dataArray objectAtIndex:[arrayBlock[i]integerValue]] objectForKey:@"balance"]]];
                                
                            }
                        }
                        //                        跳转到支付宝页面
                        PayViewController *appPayVC = [[PayViewController alloc]init];
                        appPayVC.idStr = _idString;
                        appPayVC.nameArr = [[NSMutableArray alloc]init];
                        appPayVC.nameArr = self.namesArr;
                        appPayVC.priceStr = priceCounts ;
                        appPayVC.priceAPPStr = [NSString stringWithFormat:@"%f",(price - xianjinkazhifuPrice)];
                        [self.navigationController pushViewController:appPayVC animated:YES];
                        
                    }
                    
                }
            }else{
                //跳转页面支付宝页面
                PayViewController *appPayVC = [[PayViewController alloc]init];
                appPayVC.idStr = _idString;
                appPayVC.nameArr = [[NSMutableArray alloc]init];
                appPayVC.nameArr = self.namesArr;
                appPayVC.priceStr = @"0" ;
                appPayVC.priceAPPStr = [NSString stringWithFormat:@"%f",price];
                [self.navigationController pushViewController:appPayVC animated:YES];
               
            }
            
        }else{
            //            跳转到支付宝页面
            PayViewController *appPayVC = [[PayViewController alloc]init];
            appPayVC.idStr = _idString;
            appPayVC.nameArr = [[NSMutableArray alloc]init];
            appPayVC.nameArr = self.namesArr;
            appPayVC.priceStr = @"0" ;
            appPayVC.priceAPPStr = [NSString stringWithFormat:@"%f",price];
            [self.navigationController pushViewController:appPayVC animated:YES];
            
        }
    }else{
        return;
    }
}
- (void)xianjinkazhifushengchengdingdan:(NSString *)cardFees balance:(NSString *)balance{
    [GlobalCommon showMBHudWithView:self.view];
    self.priceYuer = [balance floatValue];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/order/create_pay.jhtml",UrlPre];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    
    [request setPostValue:@"50" forKey:@"reserveType"];
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [request setPostValue:self.idString forKey:@"orderId"];
    [request setPostValue:@"payment" forKey:@"type"];
    [request setPostValue:cardFees forKey:@"cardFees"];
    [request setPostValue:@"0" forKey:@"balance"];
    [request addPostValue:[UserShareOnce shareOnce].token forKey:@"token"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestIsxianjinkaReaderError:)];
    
    [request setDidFinishSelector:@selector(requestIsxianjinkaReaderCompleted:)];
    [request startAsynchronous];
    
}
-(void)requestIsxianjinkaReaderError:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    
    [self showAlertWarmMessage:requestErrorMessage];
}
-(void)requestIsxianjinkaReaderCompleted:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",status);
    if ([status intValue]==100)
    {
        
        //            跳转到支付成功界面
//        NSString* filepath = [GlobalCommon createYueYaoZhiFufilepath];
//        NSString *arrayPath=[filepath stringByAppendingPathComponent:@"arrayText.txt"];
//        NSString *namesPath = [filepath stringByAppendingPathComponent:@"nameText.txt"];
//        NSString *idPath = [filepath stringByAppendingPathComponent:@"idText.txt"];
//        NSMutableArray *arr1 = [[NSMutableArray alloc]init];
//
//        [arr1 writeToFile:arrayPath atomically:YES];
//        [arr1 writeToFile:namesPath atomically:YES];
//        [arr1 writeToFile:idPath atomically:YES];
        PaySuccessViewController *paySuccessVC = [[PaySuccessViewController alloc]init];
        [self.navigationController pushViewController:paySuccessVC animated:YES];
    }
    else if([status intValue]==44)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        av.tag = 100008;
        [av show];
        PayAbnormalViewController *paySuccessVC = [[PayAbnormalViewController alloc]init];
        [self.navigationController pushViewController:paySuccessVC animated:YES];
    }else {
        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
        [self showAlertWarmMessage:str];
        PayAbnormalViewController *paySuccessVC = [[PayAbnormalViewController alloc]init];
        [self.navigationController pushViewController:paySuccessVC animated:YES];
    }
}


- (void)payMentWithBlock{
    
    [GlobalCommon showMBHudWithView:self.view];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/cashcard/list/%@.jhtml",UrlPre,[UserShareOnce shareOnce].uid];
    aUrlle = [aUrlle stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:20];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestpayMentError:)];
    [request setDidFinishSelector:@selector(requestpayMentCompleted:)];
    [request startAsynchronous];
}

-(void)requestpayMentError:(ASIHTTPRequest *)request
{
    
    [GlobalCommon hideMBHudWithView:self.view];
    [self showAlertWarmMessage:requestErrorMessage];
    
}
# pragma mark - 现金卡
-(void)requestpayMentCompleted:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",dic);
    if (status!=nil)
    {
        if ([status intValue]==100)
        {
            self.dataArray = [dic objectForKey:@"data"];
            if (self.dataArray.count == 0) {
                UIImageView *no_CardImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height - 344)];
                no_CardImage.image = [UIImage imageNamed:@"no_card.png"];
                [self.view addSubview:no_CardImage];
                return;
            }
            scrollView.contentSize = CGSizeMake(0, self.dataArray.count*(139 / 2 +10));
            [self payWithBlockDetails];
            //[_blockTableView reloadData];
        }
        else if ([status intValue]==44) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            av.tag = 100008;
            [av show];
        } else
        {
            NSString *str = [dic objectForKey:@"data"];
            [self showAlertWarmMessage:str];
        }
    }
    
    
}
- (void)payWithBlockDetails{
    for (int i = 0; i < self.dataArray.count; i++) {
        UIView *diView = [[UIView alloc]initWithFrame:CGRectMake(0,(139 / 2 +10)*i, self.view.frame.size.width, 139 / 2 +10)];
        [scrollView addSubview:diView];
        
        NSDate *datas = [[NSDate alloc]initWithTimeIntervalSince1970:[[self.dataArray[i] objectForKey:@"bindDate"] doubleValue]/1000.00];
        NSDateFormatter *formatters = [[NSDateFormatter alloc] init];
        [formatters setDateStyle:NSDateFormatterMediumStyle];
        [formatters setTimeStyle:NSDateFormatterShortStyle];
        [formatters setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatters setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        
        NSString *confromTimespStrs = [formatters stringFromDate:datas];
        
        
        
        _imageV = [[UIImageView alloc]init];
        _backImage = [[UIImageView alloc] init];
        _backImage.image = [UIImage imageNamed:@"我的卡包_04.png"];
        [diView addSubview:_backImage];
        _imageV.image = [UIImage imageNamed:@"我的咨询_21.png"];
        [diView addSubview:_imageV];
        _mLabel = [[UILabel alloc] init];
        _mLabel.text = [NSString stringWithFormat:@"%.1f",[[self.dataArray[i]objectForKey:@"balance"]floatValue]];
        _mLabel.textAlignment = NSTextAlignmentCenter;
        _mLabel.font = [UIFont systemFontOfSize:17];
        _mLabel.textColor = [UIColor whiteColor];
        
        [diView addSubview:_mLabel];
        _hLabel = [[UILabel alloc] init];
        _hLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        _hLabel.text = @"会员卡：";
        _hLabel.font = [UIFont systemFontOfSize:10];
        [diView addSubview:_hLabel];
        _yLabel = [[UILabel alloc] init];
        _yLabel.text = @"有效期：";
        _yLabel.font = [UIFont systemFontOfSize:10];
        _yLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        [diView addSubview:_yLabel];
        _wLabel = [[UILabel alloc]init];
        _wLabel.text = [NSString stringWithFormat:@"%@",[[self.dataArray[i]objectForKey:@"cashcard"]objectForKey:@"amount"]];
        _wLabel.textColor = [UtilityFunc colorWithHexString:@"#575e64"];
        _wLabel.font= [UIFont systemFontOfSize:10];
        [diView addSubview:_wLabel];
        _tLabel = [[UILabel alloc]init];
        _tLabel.textColor = [UtilityFunc colorWithHexString:@"#fc5856"];
        _tLabel.text = [NSString stringWithFormat:@"%@",confromTimespStrs];
        _tLabel.font = [UIFont systemFontOfSize:10];
        [diView addSubview:_tLabel];
        _backImage.frame = CGRectMake(10, 0, self.view.frame.size.width-20, 139 / 2);
        _imageV.frame  =CGRectMake(10, 0, 101, 139 / 2);
        _mLabel.frame = CGRectMake(10, 0, 101, 139 /2 );
        _hLabel.frame = CGRectMake(115, 15, 60, 15);
        _yLabel.frame = CGRectMake(115, 40, 60, 15);
        _wLabel.frame = CGRectMake(155, 15, 80, 15);
        _tLabel.frame = CGRectMake(155, 40, 200, 15);
        UIButton *zhifuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        zhifuButton.frame = CGRectMake(self.view.frame.size.width- 50, 25, 20, 20);
        zhifuButton.tag = 2000 +i;
        [zhifuButton setBackgroundImage:[UIImage imageNamed:@"zhifuweishiyong.png"] forState:UIControlStateNormal];
        [zhifuButton setBackgroundImage:[UIImage imageNamed:@"leyaozhifuxianjinka.png"] forState:UIControlStateSelected];
        [zhifuButton addTarget:self action:@selector(zhifuButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [diView addSubview:zhifuButton];
        UIButton *dianjiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dianjiButton.frame = CGRectMake(10, 0, self.view.frame.size.width - 20, 139 / 2);
        [dianjiButton addTarget:self action:@selector(dianjiButton:) forControlEvents:UIControlEventTouchUpInside];
        dianjiButton.tag = 3080 + i;
        [diView addSubview:dianjiButton];
        
    }
}
- (void)dianjiButton:(UIButton *)sender{
    
    if (self.priceCountt == 0) {
        [self showAlertWarmMessage:@"请添加商品再选择现金卡"];
        return;
    }
    UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag - 1080];
    NSInteger tagg = sender.tag - 3080;
    
    if (button.selected) {
        button.selected = NO;
        if (self.priceCountt > 0) {
            xianjika -= [[self.dataArray[tagg]objectForKey:@"balance"]floatValue];
            
        }else{
            xianjika = xianjika - [[self.dataArray[tagg]objectForKey:@"balance"]floatValue] - self.priceCountt;
        }
        if (xianjika>0) {
            
            xianjinkaLabel.text = [NSString stringWithFormat:@"%.1f",xianjika];
        }else{
            xianjika = 0.0;
            xianjinkaLabel.text = [NSString stringWithFormat:@"%.1f",xianjika];
        }
        self.priceCountt += [[self.dataArray[tagg]objectForKey:@"balance"]floatValue];
        zongjiLabel.text = [NSString stringWithFormat:@"%.1f",self.priceCountt];
        _jinerLabel.text = [NSString stringWithFormat:@"¥%.1f",self.priceCountt];
        
    }else{
        if (self.priceCountt>0) {
            self.priceCountt -= [[self.dataArray[tagg]objectForKey:@"balance"]floatValue];
            if (self.priceCountt>0) {
                xianjika += [[self.dataArray[tagg]objectForKey:@"balance"]floatValue];
                zongjiLabel.text = [NSString stringWithFormat:@"%.1f",self.priceCountt];
                _jinerLabel.text = [NSString stringWithFormat:@"¥%.1f",self.priceCountt];
                xianjinkaLabel.text = [NSString stringWithFormat:@"%.1f",xianjika];
                
            }else{
                zongjiLabel.text = [NSString stringWithFormat:@"%.1f",0.0];
                _jinerLabel.text = [NSString stringWithFormat:@"¥%.1f",0.0];
                xianjika += self.priceCountt + [[self.dataArray[tagg]objectForKey:@"balance"]floatValue];
                xianjinkaLabel.text = [NSString stringWithFormat:@"%.1f",xianjika];
            }
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        
    }
    
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100008)
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        return [UserShareOnce shareOnce].yueYaoBuyArr.count;
    }
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"LeMedicineCell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellStyleDefault];
    
    if (tableView == _tableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:CellIdentifier];
            cell.backgroundColor=[UIColor clearColor];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
        }
        UIImageView *nameImage = [[UIImageView alloc]initWithFrame:CGRectMake(18, 9, 35, 36.5)];
        nameImage.image = [UIImage imageNamed:@"乐药购物车1及支付_03.png"];
        [cell addSubview:nameImage];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 20, 85, 15)];
        nameLabel.text = @"乐药名称：";
        nameLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
        nameLabel.font = [UIFont systemFontOfSize:14];
        //[cell addSubview:nameLabel];
        UILabel *leyaoLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth-150)/2.0, 20, 150, 15)];
        leyaoLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        leyaoLabel.font = [UIFont systemFontOfSize:14];
        SongListModel *model = [[UserShareOnce shareOnce].yueYaoBuyArr objectAtIndex:indexPath.row];
        leyaoLabel.text = model.title;
        [cell addSubview:leyaoLabel];
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 96, 20, 60, 15)];
        moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",model.price];
        //    moneyLabel.text = [self.dataArray[0] objectForKey:@"price"];
        moneyLabel.textAlignment = NSTextAlignmentCenter;
        moneyLabel.textColor = [UtilityFunc colorWithHexString:@"#ff9933"];
        moneyLabel.font = [UIFont systemFontOfSize:14];
        [cell addSubview:moneyLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}
- (void)zhifuButton:(UIButton *)sender{
    if (self.priceCountt == 0) {
        [self showAlertWarmMessage:@"请添加商品再选择现金卡"];
        return;
    }
    
    if (sender.selected) {
        sender.selected = NO;
        if (self.priceCountt > 0) {
            xianjika -= [[self.dataArray[sender.tag - 2000]objectForKey:@"balance"]floatValue];
            
        }else{
            xianjika = xianjika - [[self.dataArray[sender.tag - 2000]objectForKey:@"balance"]floatValue] - self.priceCountt;
        }
        if (xianjika>0) {
            
            xianjinkaLabel.text = [NSString stringWithFormat:@"%.1f",xianjika];
        }else{
            xianjika = 0.0;
            xianjinkaLabel.text = [NSString stringWithFormat:@"%.1f",xianjika];
        }
        self.priceCountt += [[self.dataArray[sender.tag - 2000]objectForKey:@"balance"]floatValue];
        zongjiLabel.text = [NSString stringWithFormat:@"%.1f",self.priceCountt];
        _jinerLabel.text = [NSString stringWithFormat:@"%.1f",self.priceCountt];
        
    }else{
        if (self.priceCountt>0) {
            self.priceCountt -= [[self.dataArray[sender.tag - 2000]objectForKey:@"balance"]floatValue];
            if (self.priceCountt>0) {
                xianjika += [[self.dataArray[sender.tag - 2000]objectForKey:@"balance"]floatValue];
                zongjiLabel.text = [NSString stringWithFormat:@"%.1f",self.priceCountt];
                _jinerLabel.text = [NSString stringWithFormat:@"%.1f",self.priceCountt];
                xianjinkaLabel.text = [NSString stringWithFormat:@"%.1f",xianjika];
                
            }else{
                zongjiLabel.text = [NSString stringWithFormat:@"%.1f",0.0];
                _jinerLabel.text = [NSString stringWithFormat:@"%.1f",0.0];
                xianjika += self.priceCountt + [[self.dataArray[sender.tag - 2000]objectForKey:@"balance"]floatValue];
                xianjinkaLabel.text = [NSString stringWithFormat:@"%.1f",xianjika];
            }
            sender.selected = YES;
        }else{
            sender.selected = NO;
        }
        
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _count = 0;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
