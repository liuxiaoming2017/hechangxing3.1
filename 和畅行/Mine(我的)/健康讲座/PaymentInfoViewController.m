//
//  PaymentInfoViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/10/26.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "PaymentInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "CardModel.h"
//#import "CashCardCell.h"
//#import "MoneyCell.h"
//#import "BlockTableViewCell.h"
#import "PayViewController.h"
#import "PaySuccessViewController.h"
#import "PayAbnormalViewController.h"
#import "MyView.h"

@interface PaymentInfoViewController ()<UIScrollViewDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate>
{
    UIScrollView *_scrollView;
    ASIHTTPRequest *_request;
    MBProgressHUD *_progress;
    MBProgressHUD* progress_;
    NSMutableArray *_dataArr;
    //BOOL ret;
    float xianjika;
    //CGFloat cardTotalPay;//现金卡总共支付的钱
    //CGFloat acturellyPayMoney;//实际支付
}
@property (nonatomic ,retain) UIImageView *imageV;
@property (nonatomic ,retain) UILabel *mLabel;
@property (nonatomic ,retain) UILabel *hLabel;
@property (nonatomic ,retain) UILabel *yLabel;
@property (nonatomic ,retain) UILabel *wLabel;
@property (nonatomic ,retain) UILabel *tLabel;
@property (nonatomic ,retain) UIImageView *backImage;

@property (nonatomic ,assign) float priceCountt;
@property (nonatomic ,retain) NSString *idString;
@property (nonatomic ,assign) float priceYuer;
@property (nonatomic ,assign) float pricePrices;
@end

@implementation PaymentInfoViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     xianjika = 0.0;
    _priceCountt = self.price;
    self.navTitleLabel.text = ModuleZW(@"支付信息");
    [self initWithController];
    
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ 初始化界面
-(void)initWithController{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 69, kScreenSize.width, kScreenSize.height-69-44)];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    self.pricePrices = self.price;
    UIImageView *iconLine = [[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 80, 80)];
    iconLine.image = [UIImage imageNamed:@"健康讲座头像"];
    [_scrollView addSubview:iconLine];
    self.idString = [NSString stringWithFormat:@"%ld",(long)self.orderId];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 76, 76)];
    [iconView sd_setImageWithURL:[NSURL URLWithString:self.model.picture]];
    [_scrollView addSubview:iconView];
    UILabel *titleLabel = [Tools labelWith:self.model.title frame:CGRectMake(100, 11, kScreenSize.width-100-80, 40) textSize:14 textColor:[Tools colorWithHexString:@"#333"] lines:0 aligment:NSTextAlignmentLeft];
    [_scrollView addSubview:titleLabel];
    UILabel *priceLabel = [Tools labelWith:[NSString stringWithFormat:@"￥%.2f",self.price] frame:CGRectMake(kScreenSize.width-170, 31, 140, 10) textSize:14 textColor:[Tools colorWithHexString:@"#ff5844"] lines:1 aligment:NSTextAlignmentRight];
    [_scrollView addSubview:priceLabel];
    UILabel *countLabel = [Tools labelWith:[NSString stringWithFormat:@"数量: x%ld",(long)self.count] frame:CGRectMake(kScreenSize.width-70, 51, 60, 10) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [_scrollView addSubview:countLabel];
    UILabel *talkerLabel = [Tools labelWith:self.model.talker frame:CGRectMake(100, 81, kScreenSize.width-100, 10) textSize:11 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
    [_scrollView addSubview:talkerLabel];
    
    UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 101, kScreenSize.width-20, 25)];
    backView.image = [UIImage imageNamed:@"时间背景图"];
    [_scrollView addSubview:backView];
    UIImageView *timeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 15, 15)];
    timeImageView.image = [UIImage imageNamed:@"时钟"];
    [backView addSubview:timeImageView];
    NSString *beginStr = [Tools timeYMDStringFrom:self.model.beginDate.doubleValue];
    NSString *endStr = [Tools timeYMDStringFrom:self.model.endDate.doubleValue];
    NSString *lectureTime = [Tools timeHMStringFrom:self.model.lectureDate.doubleValue];
    UILabel *timeLabel = [Tools labelWith:[NSString stringWithFormat:@"讲座时间：%@-%@日 %@",beginStr,endStr,lectureTime] frame:CGRectMake(35, 5, backView.frame.size.width-35, 15) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [backView addSubview:timeLabel];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 135, kScreenSize.width, 1)];
    line.backgroundColor = [Tools colorWithHexString:@"#f2f1ef"];
    [_scrollView addSubview:line];
    
    UIImageView *acturellyPay = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-44, kScreenSize.width-80, 44)];
    acturellyPay.image = [UIImage imageNamed:@"数量背景"];
    [self.view addSubview:acturellyPay];
    UIImageView *payImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 14.5, 15, 15)];
    payImage.image = [UIImage imageNamed:@"支付图标"];
    [acturellyPay addSubview:payImage];
    UILabel *payLabel = [Tools labelWith:[NSString stringWithFormat:@"实际支付：￥%.2f",self.price] frame:CGRectMake(45, 14.5, 200, 15) textSize:14 textColor:[UIColor whiteColor] lines:1 aligment:NSTextAlignmentLeft];
    payLabel.tag = 111;
    payLabel.font = [UIFont boldSystemFontOfSize:13];
    [acturellyPay addSubview:payLabel];
    MyView *pay = [[MyView alloc] initWithFrame:CGRectMake(kScreenSize.width-80, kScreenSize.height-44, 80, 44)];
    pay.image = [UIImage imageNamed:@"支付"];
    [pay addTarget:self action:@selector(payClick:)];
    [self.view addSubview:pay];
    [self payWithCard];
}
#pragma mark ------ 现金卡支付
-(void)payWithCard{
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 145, 3, 20)];
    lineView.image = [UIImage imageNamed:@"蓝色竖线"];
    [_scrollView addSubview:lineView];
    UILabel *titleLable = [Tools labelWith:@"现金卡支付" frame:CGRectMake(33, 145, 120, 20) textSize:14 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
    [_scrollView addSubview:titleLable];
    
    NSString *str = [[NSString alloc] initWithFormat:@"%@/member/cashcard/list/%@.jhtml",URL_PRE,[UserShareOnce shareOnce].uid];
    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str]];
    _request.timeOutSeconds = 20;
    _request.requestMethod = @"GET";
    _request.delegate = self;
    [_request startAsynchronous];
    
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    [self.view bringSubviewToFront:_progress];
    _progress.delegate = self;
    _progress.labelText = @"加载中...";
    [_progress show:YES];
}
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [_progress removeFromSuperview];
    _progress = nil;
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    [self hudWasHidden:nil];
    NSString *requestStr = [request responseString];
    NSDictionary *dic = [requestStr JSONValue];
    NSArray *data = dic[@"data"];
    if (data.count == 0) {
        //还没有绑定现金卡
        UIImageView *cardView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 175, kScreenSize.width-50, 150)];
        cardView.image = [UIImage imageNamed:@"无现金卡"];
        [_scrollView addSubview:cardView];
    }else{
        //已经绑定现金卡
        _dataArr = [[NSMutableArray alloc] init];
        _dataArr = [dic objectForKey:@"data"];
        _scrollView.contentSize = CGSizeMake(kScreenSize.width, 175+(_dataArr.count+1)*(139/2+10)+10);
        [self payWithBlockDetails];
    }
    
}
- (void)payWithBlockDetails{
    for (int i = 0; i <_dataArr.count; i++) {
        UIView *diView = [[UIView alloc]initWithFrame:CGRectMake(0,175+(139 / 2 +10)*i, self.view.frame.size.width, 139 / 2 +10)];
        [_scrollView addSubview:diView];
        
        NSDate *datas = [[NSDate alloc]initWithTimeIntervalSince1970:[[_dataArr[i] objectForKey:@"bindDate"] doubleValue]/1000.00];
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
        _mLabel.text = [NSString stringWithFormat:@"%.1f",[[_dataArr[i]objectForKey:@"balance"]floatValue]];
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
        _wLabel.text = [NSString stringWithFormat:@"%@",[[_dataArr[i]objectForKey:@"cashcard"]objectForKey:@"amount"]];
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
        zhifuButton.frame = CGRectMake(self.view.frame.size.width- 50, 30, 20, 20);
        zhifuButton.tag = 3333 +i;
        [zhifuButton setBackgroundImage:[UIImage imageNamed:@"zhifuweishiyong.png"] forState:UIControlStateNormal];
        [zhifuButton setBackgroundImage:[UIImage imageNamed:@"leyaozhifuxianjinka.png"] forState:UIControlStateSelected];
        [zhifuButton addTarget:self action:@selector(zhifuButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [diView addSubview:zhifuButton];
        UIButton *dianjiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dianjiButton.frame = CGRectMake(10, 0, self.view.frame.size.width-20, 139 / 2);
        [dianjiButton addTarget:self action:@selector(dianjiButton:) forControlEvents:UIControlEventTouchUpInside];
        dianjiButton.tag = 3080 + i;
        [diView addSubview:dianjiButton];
        
    }
    UIImageView *thickLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 175+(139 / 2 +10)*_dataArr.count, kScreenSize.width, 8)];
    thickLine.image = [UIImage imageNamed:@"healthLec"];
    [_scrollView addSubview:thickLine];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 175+(139 / 2 +10)*_dataArr.count+10, kScreenSize.width-20, (139 / 2 +10))];
    view.tag = 130;
    NSArray *titles = [[NSArray alloc] initWithArray:@[@"消费金额",@"现金卡支付",@"总计"]];
    NSArray *contents = [[NSArray alloc] initWithArray:@[[NSString stringWithFormat:@"￥ %.2f",self.price],@"-￥ 0.00",[NSString stringWithFormat:@"= ￥%.2f",self.price]]];
    for (int i=0; i<titles.count; i++) {
        UILabel *lable = [Tools labelWith:titles[i] frame:CGRectMake(0, 10+20*i, 100, 10) textSize:12 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
        [view addSubview:lable];
        UILabel *contentLabel = [Tools labelWith:contents[i] frame:CGRectMake(view.frame.size.width-150, 10+20*i, 150, 10) textSize:12 textColor:[Tools colorWithHexString:@"#ff9933"] lines:1 aligment:NSTextAlignmentRight];
        contentLabel.tag = 1210+i;
        [view addSubview:contentLabel];
    }

    [_scrollView addSubview:view];
    
}
- (void)dianjiButton:(UIButton *)sender{
    
    if (self.price == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请添加商品再选择现金卡" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        return;
    }
    UIButton *button = (UIButton *)[self.view viewWithTag:sender.tag +253];
    NSInteger tagg = sender.tag - 3080;
    
    
    UIView *view = [self.view viewWithTag:130];
    UILabel *cardLabel = (UILabel *)[view viewWithTag:1211];//现金卡支付
    UILabel *totleLabel = (UILabel *)[view viewWithTag:1212];
    UILabel *acturePayLabel = (UILabel *)[self.view viewWithTag:111];
    
    if (button.selected) {
        button.selected = NO;
        if (self.priceCountt > 0) {
            xianjika -= [[_dataArr[tagg]objectForKey:@"balance"]floatValue];
            
        }else{
            xianjika = xianjika - [[_dataArr[tagg]objectForKey:@"balance"]floatValue] - self.priceCountt;
        }
        if (xianjika>0) {
            
            cardLabel.text = [NSString stringWithFormat:@"-￥ %.2f",xianjika];
        }else{
            xianjika = 0.0;
            cardLabel.text = [NSString stringWithFormat:@"-￥ %.2f",xianjika];
        }
        self.priceCountt += [[_dataArr[tagg]objectForKey:@"balance"]floatValue];
        acturePayLabel.text = [NSString stringWithFormat:@"实际支付：￥%.2f",self.priceCountt>=0 ? self.priceCountt:self.priceCountt+[[_dataArr[sender.tag - 3080]objectForKey:@"balance"]floatValue]];
        totleLabel.text = [NSString stringWithFormat:@"=￥ %.2f",self.priceCountt>=0 ? self.priceCountt:self.priceCountt+[[_dataArr[sender.tag - 3080]objectForKey:@"balance"]floatValue]];
        
    }else{
        if (self.priceCountt>0) {
            self.priceCountt -= [[_dataArr[tagg]objectForKey:@"balance"]floatValue];
            if (self.priceCountt>0) {
                xianjika += [[_dataArr[tagg]objectForKey:@"balance"]floatValue];
                acturePayLabel.text = [NSString stringWithFormat:@"实际支付：￥%.2f",self.priceCountt>=0 ? self.priceCountt:self.priceCountt+[[_dataArr[sender.tag - 3080]objectForKey:@"balance"]floatValue]];
                totleLabel.text = [NSString stringWithFormat:@"=￥ %.2f",self.priceCountt>=0 ? self.priceCountt:self.priceCountt+[[_dataArr[sender.tag - 3080]objectForKey:@"balance"]floatValue]];
                
                cardLabel.text = [NSString stringWithFormat:@"-￥ %.2f",xianjika];
                
            }else{
                acturePayLabel.text = [NSString stringWithFormat:@"实际支付：￥%.2f",0.0];
                totleLabel.text = [NSString stringWithFormat:@"=￥ %.2f",0.0];
                xianjika += self.priceCountt + [[_dataArr[tagg]objectForKey:@"balance"]floatValue];
                cardLabel.text = [NSString stringWithFormat:@"-￥ %.2f",xianjika];
            }
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        
    }
     
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    [self hudWasHidden:nil];
    NSLog(@"%@",request.error);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.removeFromSuperViewOnHide =YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"数据请求失败";
    hud.minSize = CGSizeMake(132.f, 108.0f);
    [hud hide:YES afterDelay:2];
}

- (void)zhifuButton:(UIButton *)sender{
    UIView *view = [self.view viewWithTag:130];
    UILabel *cardLabel = (UILabel *)[view viewWithTag:1211];//现金卡支付
    UILabel *totleLabel = (UILabel *)[view viewWithTag:1212];
    UILabel *acturePayLabel = (UILabel *)[self.view viewWithTag:111];
    if (sender.selected) {
        sender.selected = NO;
        if (self.priceCountt > 0) {
            xianjika -= [[_dataArr[sender.tag - 3333]objectForKey:@"balance"]floatValue];
            
        }else{
            xianjika = xianjika - [[_dataArr[sender.tag - 3333]objectForKey:@"balance"]floatValue] - self.priceCountt;
        }
        if (xianjika>0) {
            
            cardLabel.text = [NSString stringWithFormat:@"%.2f",xianjika];
        }else{
            xianjika = 0.0;
            cardLabel.text = [NSString stringWithFormat:@"%.2f",xianjika];
        }
        self.priceCountt += [[_dataArr[sender.tag - 3333]objectForKey:@"balance"]floatValue];
        acturePayLabel.text = [NSString stringWithFormat:@"实际支付：￥%.2f",self.priceCountt>=0 ? self.priceCountt:self.priceCountt+[[_dataArr[sender.tag - 3333]objectForKey:@"balance"]floatValue]];
        totleLabel.text = [NSString stringWithFormat:@"-￥ %.2f",self.priceCountt>=0 ? self.priceCountt:self.priceCountt+[[_dataArr[sender.tag - 3333]objectForKey:@"balance"]floatValue]];

    }else{
        if (self.priceCountt>0) {
            self.priceCountt -= [[_dataArr[sender.tag - 3333]objectForKey:@"balance"]floatValue];
            if (self.priceCountt>0) {
                xianjika += [[_dataArr[sender.tag - 3333]objectForKey:@"balance"]floatValue];
                acturePayLabel.text = [NSString stringWithFormat:@"实际支付：￥%.2f",self.priceCountt];
                totleLabel.text = [NSString stringWithFormat:@"-￥ %.2f",self.priceCountt];
                cardLabel.text = [NSString stringWithFormat:@"%.2f",xianjika];
                
            }else{
                totleLabel.text = [NSString stringWithFormat:@"-￥ 0.0"];
                acturePayLabel.text = [NSString stringWithFormat:@"实际支付：￥%.2f",0.0];
                xianjika += self.priceCountt + [[_dataArr[sender.tag - 3333]objectForKey:@"balance"]floatValue];
                cardLabel.text = [NSString stringWithFormat:@"%.2f",xianjika];
            }
            sender.selected = YES;
        }else{
            sender.selected = NO;
        }
        
    }
    
}

-(void)payClick:(MyView *)view{
    NSLog(@"点击支付");
    if (self.price == 0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有添加产品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        
        return;
    }
    [self zhifufangshidequeding];
}
-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.labelText = @"加载中...";
    [progress_ show:YES];
}

- (void)zhifufangshidequeding{
    
    NSMutableArray *arrayBlock = [[NSMutableArray alloc]init];
    if (self.price > 0 ) {
        if (_dataArr.count > 0) {
            
            int count = 0;
            NSInteger tagCount = 0;
            for (int i = 0; i < _dataArr.count; i ++) {
                
                UIButton *button = (UIButton *)[self.view viewWithTag:i + 3333];
                if (button.selected) {
                    count ++;
                    tagCount =  button.tag - 3333;
                    [arrayBlock addObject:[NSString stringWithFormat:@"%ld",(long)tagCount]];
                }
            }
            if (count > 0) {
                if (count == 1) {
                    if (self.price < [[_dataArr[tagCount]objectForKey:@"balance"]floatValue]){
                        [self xianjinkazhifushengchengdingdan:[NSString stringWithFormat:@"%@:%f",[_dataArr[tagCount]objectForKey:@"id"],_price] balance:@"0"];
                    }
                    else{
                        //                        跳转到支付宝页面
                        PayViewController *appPayVC = [[PayViewController alloc]init];
                        appPayVC.idStr = _idString;
//                        appPayVC.sn = self.sn;
                        appPayVC.priceStr = [NSString stringWithFormat:@"%@:%@",[_dataArr[tagCount]objectForKey:@"id"],[_dataArr[tagCount]objectForKey:@"balance"]];
                        appPayVC.priceAPPStr = [NSString stringWithFormat:@"%f",(_price - [[_dataArr[tagCount]objectForKey:@"balance"] floatValue])];
                        [self.navigationController pushViewController:appPayVC animated:YES];
                        
                    }
                }else{
                    float xianjinkazhifuPrice = 0.0;
                    float xianjinkaqian = 0.0;//前面几张卡的余额总数
                    for (int i = 0; i < arrayBlock.count; i++) {
                        xianjinkazhifuPrice += [[[_dataArr objectAtIndex:[arrayBlock[i]integerValue]] objectForKey:@"balance"]floatValue];
                    }
                    if (xianjinkazhifuPrice > self.price) {
                        NSString *priceCounts = @"";
                        for (int i = 0; i < arrayBlock.count; i++) {
                            if (i == arrayBlock.count - 1) {
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@:",[_dataArr[tagCount]objectForKey:@"id"]]];
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%f",(xianjinkazhifuPrice - xianjinkaqian)]];
                            }else{
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@:",[_dataArr[tagCount]objectForKey:@"id"]]];
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@;",[[_dataArr objectAtIndex:[arrayBlock[i]integerValue]] objectForKey:@"balance"]]];
                                xianjinkaqian += [[[_dataArr objectAtIndex:[arrayBlock[i]integerValue]] objectForKey:@"balance"]floatValue];
                            }
                        }
                        [self xianjinkazhifushengchengdingdan:priceCounts balance:@"0"];
                    }else{
                        NSString *priceCounts = @"";
                        for (int i = 0; i < arrayBlock.count; i++) {
                            if (i == arrayBlock.count - 1) {
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@:",[_dataArr[tagCount]objectForKey:@"id"]]];
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@",[[_dataArr objectAtIndex:[arrayBlock[i]integerValue]] objectForKey:@"balance"]]];
                            }else{
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@:",[_dataArr[tagCount]objectForKey:@"id"]]];
                                priceCounts = [priceCounts stringByAppendingString:[NSString stringWithFormat:@"%@;",[[_dataArr objectAtIndex:[arrayBlock[i]integerValue]] objectForKey:@"balance"]]];
                                
                            }
                        }
                        //                        跳转到支付宝页面
                        PayViewController *appPayVC = [[PayViewController alloc]init];
                        appPayVC.idStr = _idString;
//                        appPayVC.sn = self.sn;
                        appPayVC.priceStr = priceCounts ;
                        appPayVC.priceAPPStr = [NSString stringWithFormat:@"%f",(_price - xianjinkazhifuPrice)];
                        [self.navigationController pushViewController:appPayVC animated:YES];
                        //                        [self xianjinkazhifushengchengdingdan:priceCounts balance:[NSString stringWithFormat:@"%f",(price - xianjinkazhifuPrice)]];
                    }
                    
                }
            }else{
                //跳转页面支付宝页面
                PayViewController *appPayVC = [[PayViewController alloc]init];
                appPayVC.idStr = _idString;
//                appPayVC.sn = self.sn;
                appPayVC.priceStr = @"0" ;
                appPayVC.priceAPPStr = [NSString stringWithFormat:@"%f",_price];
                [self.navigationController pushViewController:appPayVC animated:YES];
                /*
                 PayViewController *appPayVC = [[PayViewController alloc]init];
                 appPayVC.idStr = _idString;
                 appPayVC.nameArr = [[NSMutableArray alloc]init];
                 appPayVC.nameArr = self.namesArr;
                 appPayVC.priceStr = [NSString stringWithFormat:@"%@:%@",[self.dataArray[tagCount]objectForKey:@"id"],[self.dataArray[tagCount]objectForKey:@"balance"]];
                 appPayVC.priceAPPStr = [NSString stringWithFormat:@"%f",(price - [[self.dataArray[tagCount]objectForKey:@"balance"] floatValue])];
                 [self.navigationController pushViewController:appPayVC animated:YES];
                 
                 */
            }
            
        }else{
            //            跳转到支付宝页面
            PayViewController *appPayVC = [[PayViewController alloc]init];
            appPayVC.idStr = _idString;
//            appPayVC.sn = self.sn;
            appPayVC.priceStr = @"0" ;
            appPayVC.priceAPPStr = [NSString stringWithFormat:@"%f",_price];
            [self.navigationController pushViewController:appPayVC animated:YES];
        }
    }else{
        return;
    }
}
- (void)xianjinkazhifushengchengdingdan:(NSString *)cardFees balance:(NSString *)balance{
    [self showHUD];
    self.priceYuer = [balance floatValue];
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/order/create_pay.jhtml",UrlPre];
    aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:aUrlle];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    
    [request setPostValue:@"10" forKey:@"reserveType"];
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
    [self hudWasHidden:nil];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
}
-(void)requestIsxianjinkaReaderCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    NSLog(@"%@",status);
    if ([status intValue]==100)
    {
        
        //            跳转到支付成功界面
        
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
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        
        [av show];
        PayAbnormalViewController *paySuccessVC = [[PayAbnormalViewController alloc]init];
        [self.navigationController pushViewController:paySuccessVC animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
