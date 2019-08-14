//
//  HealthLectureOrderViewController.m
//  Voicediagno
//
//  Created by Mymac on 15/10/30.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "HealthLectureOrderViewController.h"
#import "LoginViewController.h"
#import "HealthOrderedModel.h"
#import "HealthOrderedInfoModel.h"
#import "HealthLectureModel.h"
#import "OrderNumModel.h"
//#import "HealthOrderCell.h"
#import "UIImageView+WebCache.h"
//#import "PaymentInfoViewController.h"
#import "NoMessageView.h"
#import "DateManager.h"


#define kCELLID @"HealthOrderCell"

@interface HealthLectureOrderViewController ()<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate>

{
    UITableView    *_tableView;
    NSMutableArray *_dataArr;//每个订单的信息头
    NSMutableArray *_lecturesArr;//讲座信息
    NSMutableArray *_ordersArr;//订单信息
    NSMutableArray *_orderNumArr;//预约码
    ASIHTTPRequest *_request;
    MBProgressHUD  *_progress;
    
    UIView         *_bottomView;//弹出视图背景
    UIView         *_topView;
    UIView         *noView;
    NSInteger      _requstCat;//  1-- 讲座列表 ， 2-- 取消预约
}

@end

@implementation HealthLectureOrderViewController
- (void)dealloc
{
    [_tableView release];
    [_dataArr release];
    [_lecturesArr release];
    [_ordersArr release];
    [_orderNumArr release];
    [_request release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = ModuleZW(@"健康讲座");
    [self downloadData];
}

- (void)goBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ----- 请求健康讲座数据
-(void)downloadData{
    _requstCat = 1;
    NSString *str = [[NSString alloc] initWithFormat:@"%@/member/lecture/list/%@.jhtml",URL_PRE,[UserShareOnce shareOnce].uid];
    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str]];
    _request.timeOutSeconds = 20;
    _request.requestMethod = @"GET";
    _request.delegate = self;
    [_request startAsynchronous];
    [str release];
    
    _progress = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_progress];
    [self.view bringSubviewToFront:_progress];
    _progress.delegate = self;
    _progress.label.text = ModuleZW(@"加载中...");
    [_progress showAnimated:YES];
}

-(void)hudWasHidden{
    [_progress removeFromSuperview];
    [_progress release];
    _progress = nil;
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    if (_requstCat == 1) {
        [self hudWasHidden];
        NSString *requestStr = [request responseString];
        NSDictionary *dic = [requestStr JSONValue];
        if ([dic[@"status"] integerValue] == 44) {
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.label.text = ModuleZW(@"未登录或登录超时，请重新登录");
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hideAnimated:YES afterDelay:2];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            [login release];
        }else if ([dic[@"status"] integerValue] == 100){
            NSArray *data = dic[@"data"];
            if (data.count == 0) {
                noView = [NoMessageView createImageWith:100.0f];
                [self.view addSubview:noView];
                return ;
            }
            if (noView) {
                [noView removeFromSuperview];
            }
            _dataArr = [[NSMutableArray alloc] init];
            _lecturesArr = [[NSMutableArray alloc] init];
            _ordersArr = [[NSMutableArray alloc] init];
            _orderNumArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dataDic in data) {
                HealthOrderedModel *model = [[HealthOrderedModel alloc] init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_dataArr addObject:model];
                [model release];
                
                NSDictionary *lectureDic = dataDic[@"lecture"];//讲座信息
                HealthLectureModel *lecModel = [[HealthLectureModel alloc] init];
                [lecModel setValuesForKeysWithDictionary:lectureDic];
                [_lecturesArr addObject:lecModel];
                [lecModel release];
                
                NSDictionary *orderItemDic = dataDic[@"orderItem"];//订单信息
                HealthOrderedInfoModel *orderModel = [[HealthOrderedInfoModel alloc] init];
                if (![orderItemDic isKindOfClass:[NSNull class]]) {
                    
                    [orderModel setValuesForKeysWithDictionary:orderItemDic];
                    [_ordersArr addObject:orderModel];
                    [orderModel release];
                }else{
                    [_ordersArr addObject:orderModel];
                }
                
                NSDictionary *reserveSnsDic = [dataDic[@"reserveSns"] lastObject];
                OrderNumModel *orderNumModel = [[OrderNumModel alloc] init];
                //orderNumModel.id = reserveSnsDic[@"id"];
                //            orderNumModel.createDate = reserveSnsDic[@"createDate"];
                //            orderNumModel.modifyDate = reserveSnsDic[@"modifyDate"];
                //            orderNumModel.reserveSn = reserveSnsDic[@"reserveSn"];//预约码
                [orderNumModel setValuesForKeysWithDictionary:reserveSnsDic];
                [_orderNumArr addObject:orderNumModel];
                [orderNumModel release];
                
            }
            [self initWithController];//初始化界面
        }
    }else if (_requstCat == 2){
        NSString *requestStr = [request responseString];
        NSDictionary *dic = [requestStr JSONValue];
        if ([dic[@"status"] integerValue] == 44) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.label.text = ModuleZW(@"未登录或登录超时，请重新登录");
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hideAnimated:YES afterDelay:2];
            LoginViewController *login = [[LoginViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
            [login release];
        }else if ([dic[@"status"] integerValue] == 1){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.label.text = dic[@"data"];
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hideAnimated:YES afterDelay:2];
        }else if ([dic[@"status"] integerValue] == 100){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.label.text = dic[@"data"];
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hideAnimated:YES afterDelay:2];
            //取消  取消预约按钮
            
        }
    }
    

}
-(void)requestFailed:(ASIHTTPRequest *)request{
    if (_requstCat == 1) {
        [self hudWasHidden];
        NSLog(@"%@",request.error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = requestErrorMessage;
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.removeFromSuperViewOnHide =YES;
        hud.mode = MBProgressHUDModeText;
        hud.label.text = ModuleZW(@"取消预约失败");
        hud.minSize = CGSizeMake(132.f, 108.0f);
        [hud hideAnimated:YES afterDelay:2];
    }
    
}
#pragma mark ------ tableView相关
-(void)initWithController{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+5, kScreenSize.width, kScreenSize.height-kNavBarHeight-5) style:UITableViewStylePlain];
    //_tableView.backgroundColor = [UIColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //[_tableView registerNib:[UINib nibWithNibName:@"HealthOrderCell" bundle:nil] forCellReuseIdentifier:kCELLID];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCELLID];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELLID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    HealthOrderedModel *orderModel = [_dataArr objectAtIndex:indexPath.row];
    HealthLectureModel *lectureModel = [_lecturesArr objectAtIndex:indexPath.row];
    HealthOrderedInfoModel *orderInfoModel = [_ordersArr objectAtIndex:indexPath.row];
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 8)];
    topLine.image = [UIImage imageNamed:@"thickLine"];
    [cell addSubview:topLine];
    UIImageView *orderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 11, 15, 18)];
    orderIcon.image = [UIImage imageNamed:@"orderMenuImage"];
    [cell addSubview:orderIcon];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 32, kScreenSize.width, 0.5)];
    line.image = [UIImage imageNamed:@"orderLine"];
    [cell addSubview:line];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 37, 55, 65)];
    icon.image = [UIImage imageNamed:@"医生预加载图片"];
    if (tableView.dragging == NO && tableView.decelerating == NO) {
        [icon sd_setImageWithURL:[NSURL URLWithString:lectureModel.picture] placeholderImage:[UIImage imageNamed:@"医生预加载图片"]];
    }
    [cell addSubview:icon];
    UILabel *lecture = [Tools labelWith:@"健康讲座：" frame:CGRectMake(68, 37, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:lecture];
    UILabel *lectureContent = [Tools labelWith:lectureModel.title frame:CGRectMake(123, 37, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
    
    
    [cell addSubview:lectureContent];
    UILabel *talker = [Tools labelWith:@"主  讲 人：" frame:CGRectMake(68, 50, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:talker];
    UILabel *talkerContent = [Tools labelWith:lectureModel.talker frame:CGRectMake(123, 50, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:talkerContent];
    
    UILabel *time = [Tools labelWith:@"讲座时间：" frame:CGRectMake(68, 63, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:time];
    NSString *lecBeginTime = [[NSString alloc] initWithString:[Tools timeYMDStringFrom:lectureModel.beginDate.doubleValue]];
    NSString *lecEndTime = [[NSString alloc] initWithString:[Tools timeYMDStringFrom:lectureModel.endDate.doubleValue]];
    NSString *lecHourTime = [[NSString alloc] initWithString:[Tools timeHMStringFrom:lectureModel.lectureDate.doubleValue]];
    NSString *timeStr = [[NSString alloc] initWithFormat:@"%@-%@日 %@",lecBeginTime,lecEndTime,lecHourTime];
    UILabel *timeContent = [Tools labelWith:timeStr frame:CGRectMake(123, 63, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:timeContent];
    
    UILabel *area = [Tools labelWith:@"讲座地点：" frame:CGRectMake(68, 76, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:area];
    UILabel *areaContent = [Tools labelWith:lectureModel.area frame:CGRectMake(123, 76, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:areaContent];
    UILabel *count = [Tools labelWith:@"数       量：" frame:CGRectMake(68, 89, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:count];
    UILabel *countContent = [Tools labelWith:[NSString stringWithFormat:@"%@",orderModel.reserveNums] frame:CGRectMake(123, 89, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:countContent];
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 107, kScreenSize.width, 0.5)];
    lineView.image = [UIImage imageNamed:@"orderLine"];
    //lineView.backgroundColor = [Tools colorWithHexString:@"#666666"];
    [cell addSubview:lineView];
    
    UILabel *paiedLabel = [Tools labelWith:@"实际付款：" frame:CGRectMake(8, 127, 60, 15) textSize:12 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:paiedLabel];
    UILabel *paiedContent = [Tools labelWith:[NSString stringWithFormat:@"￥%.2f",orderModel.actualPayment.floatValue] frame:CGRectMake(68, 127, 220, 15) textSize:12 textColor:[Tools colorWithHexString:@"333"] lines:1 aligment:NSTextAlignmentLeft];
    [cell addSubview:paiedContent];
    //   订单状态：orderModel.status      支付状态：orderInfoModel.paymentStatus  预约截止日期：lectureModel.endDate
    NSString *orderStatus = orderModel.status;
    NSString *payStatus   = orderInfoModel.paymentStatus;
    //当前日期的年月日和预约日期的年月日
    NSInteger currentYear = [[DateManager currentYear] integerValue];
    NSInteger currentMonth = [[DateManager currentMonth] integerValue];
    NSInteger currentDay = [[DateManager currentDay] integerValue];
    NSInteger orderYear = [[DateManager getYearFrom:lectureModel.endDate] integerValue];
    NSInteger orderMonth = [[DateManager getMonthFrom:lectureModel.endDate] integerValue];
    NSInteger orderDay = [[DateManager getDayFrom:lectureModel.endDate] integerValue];
    if ([orderInfoModel.sn isKindOfClass:[NSNull class]] || orderInfoModel.sn == nil) {
        //免费讲座
        UILabel *freeLabel = [Tools labelWith:@"免费讲座" frame:CGRectMake(27, 11, 80, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
        [cell addSubview:freeLabel];
        UIButton *checkBtn = [Tools buttonWithFrame:CGRectMake(kScreenSize.width-60, 127, 50, 20) title:nil nomalImage:@"查看预约码" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:indexPath.row target:self sel:@selector(checkNumClick:)];
        [cell addSubview:checkBtn];
        if (orderYear > currentYear || (orderYear == currentYear && orderMonth > currentMonth) || (orderYear == currentYear && orderMonth == currentMonth && orderDay > currentDay)) {
            //未过期
        }else{
            UILabel *payState = [Tools labelWith:@"已取消" frame:CGRectMake(kScreenSize.width-50, 11, 40, 20) textSize:12 textColor:[Tools colorWithHexString:@"#ff6f5e"] lines:1 aligment:NSTextAlignmentLeft];
            [cell addSubview:payState];
        }
    }else{
        //收费讲座
        UILabel *freeLabel = [Tools labelWith:@"订单信息：" frame:CGRectMake(27, 11, 80, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
        [cell addSubview:freeLabel];
        UILabel *freeContent = [Tools labelWith:orderInfoModel.sn frame:CGRectMake(107, 11, 100, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
        [cell addSubview:freeContent];
        UILabel *payState = [Tools labelWith:@"" frame:CGRectMake(kScreenSize.width-80, 11, 70, 20) textSize:12 textColor:[Tools colorWithHexString:@"#5db4fb"] lines:1 aligment:NSTextAlignmentRight];
        [cell addSubview:payState];
        if ([payStatus isEqualToString:@"unpaid"]) {
            payState.text = @"未付款";
            payState.textColor = [Tools colorWithHexString:@"#ff6f5e"];
            if ([orderStatus isEqualToString:@"cancelled"]) {
                payState.text = @"已取消";
            }else{
                UIButton *continuePay = [Tools buttonWithFrame:CGRectMake(kScreenSize.width-60, 127, 50, 20) title:nil nomalImage:@"继续支付" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:indexPath.row target:self sel:@selector(continuePayClick:)];
                [cell addSubview:continuePay];
            }
        }else if ([payStatus isEqualToString:@"partialPayment"]) {
            payState.text = @"已部分付款";
            paiedLabel.text = @"已付款:";
            paiedContent.text = [NSString stringWithFormat:@"￥%.2f    剩余付款: ￥%.2f",orderInfoModel.amountPaid.floatValue,orderInfoModel.amountPayable.floatValue];
            if ([orderStatus isEqualToString:@"cancelled"]) {
                payState.text = @"退款中";
                payState.textColor = [Tools colorWithHexString:@"#69ca00"];
                paiedLabel.text = @"退款金额";
                paiedContent.text = @"￥ 0";
            }else{
                UIButton *continuePay = [Tools buttonWithFrame:CGRectMake(kScreenSize.width-60, 127, 50, 20) title:nil nomalImage:@"继续支付" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:indexPath.row target:self sel:@selector(continuePayClick:)];
                [cell addSubview:continuePay];
                if (orderYear > currentYear || (orderYear == currentYear && orderMonth > currentMonth) || (orderYear == currentYear && orderMonth == currentMonth && orderDay > currentDay)) {
                    //未过期
                    UIButton *cancelBtn = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width-120, 127, 50, 20) target:self sel:@selector(cancelBtnClick:) tag:indexPath.row image:@"取消预约" title:nil];
                    [cell addSubview:cancelBtn];
                }
            }
            
        }else if ([payStatus isEqualToString:@"paid"]) {
            payState.text = @"已全额付款";
            payState.textColor = [Tools colorWithHexString:@"#5db4fb"];
            if ([orderStatus isEqualToString:@"cancelled"]) {
                payState.text = @"退款中";
                payState.textColor = [Tools colorWithHexString:@"#69ca00"];
                paiedLabel.text = @"退款金额";
                paiedContent.text = @"￥ 0";
            }else{
                UIButton *checkBtn = [Tools buttonWithFrame:CGRectMake(kScreenSize.width-60, 127, 50, 20) title:nil nomalImage:@"查看预约码" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:indexPath.row target:self sel:@selector(checkNumClick:)];
                [cell addSubview:checkBtn];
                if (orderYear > currentYear || (orderYear == currentYear && orderMonth > currentMonth) || (orderYear == currentYear && orderMonth == currentMonth && orderDay > currentDay)) {
                    //未过期
                    UIButton *cancelBtn = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width-120, 127, 50, 20) target:self sel:@selector(cancelBtnClick:) tag:indexPath.row image:@"取消预约" title:nil];
                    [cell addSubview:cancelBtn];
                }
            }
        }else if ([payStatus isEqualToString:@"partialRefunds"]) {
            payState.text = @"已部分退款";
            payState.textColor = [Tools colorWithHexString:@"#999999"];
            paiedLabel.text = @"退款金额";
            paiedContent.text = [NSString stringWithFormat:@"￥ %.2f",orderInfoModel.refundPay.floatValue];
        }else if ([payStatus isEqualToString:@"refunded"]) {
            payState.text = @"已退款";
            payState.textColor = [Tools colorWithHexString:@"#999999"];
            paiedLabel.text = @"退款金额";
            paiedContent.text = [NSString stringWithFormat:@"￥ %.2f",orderInfoModel.refundPay.floatValue];
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    if (orderModel.actualPayment.floatValue == 0) {
//        //免费
//        for (UIView *view in cell.subviews) {
//            [view removeFromSuperview];
//        }
//        UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 8)];
//        topLine.image = [UIImage imageNamed:@"订单线"];
//        [cell addSubview:topLine];
//        [topLine release];
//        UIImageView *orderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 11, 15, 18)];
//        orderIcon.image = [UIImage imageNamed:@"订单图标"];
//        [cell addSubview:orderIcon];
//        [orderIcon release];
//        UILabel *freeLabel = [Tools labelWith:@"免费讲座" frame:CGRectMake(27, 11, 80, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:freeLabel];
//        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 32, kScreenSize.width, 0.5)];
//        line.image = [UIImage imageNamed:@"orderLine"];
//        //line.backgroundColor = [Tools colorWithHexString:@"#666666"];
//        [cell addSubview:line];
//        [line release];
//        
//        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 37, 55, 65)];
//        [icon sd_setImageWithURL:[NSURL URLWithString:lectureModel.picture] placeholderImage:[UIImage imageNamed:@"医生预加载图片"]];
//        [cell addSubview:icon];
//        [icon release];
//        UILabel *lecture = [Tools labelWith:@"健康讲座：" frame:CGRectMake(68, 37, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:lecture];
//        UILabel *lectureContent = [Tools labelWith:lectureModel.title frame:CGRectMake(123, 37, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
////    lecture.backgroundColor = [UIColor grayColor];
////    lectureContent.backgroundColor = [UIColor blackColor];
//    
//    
//    
//        [cell addSubview:lectureContent];
//        UILabel *talker = [Tools labelWith:@"主  讲 人：" frame:CGRectMake(68, 50, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:talker];
//        UILabel *talkerContent = [Tools labelWith:lectureModel.talker frame:CGRectMake(123, 50, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:talkerContent];
//        
//        UILabel *time = [Tools labelWith:@"讲座时间：" frame:CGRectMake(68, 63, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:time];
//        NSString *lecBeginTime = [[NSString alloc] initWithString:[Tools timeYMDStringFrom:lectureModel.beginDate.doubleValue]];
//        NSString *lecEndTime = [[NSString alloc] initWithString:[Tools timeYMDStringFrom:lectureModel.endDate.doubleValue]];
//        NSString *lecHourTime = [[NSString alloc] initWithString:[Tools timeHMStringFrom:lectureModel.lectureDate.doubleValue]];
//        NSString *timeStr = [[NSString alloc] initWithFormat:@"%@-%@日 %@",lecBeginTime,lecEndTime,lecHourTime];
//        UILabel *timeContent = [Tools labelWith:timeStr frame:CGRectMake(123, 63, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:timeContent];
//        
//        UILabel *area = [Tools labelWith:@"讲座地点：" frame:CGRectMake(68, 76, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:area];
//        UILabel *areaContent = [Tools labelWith:lectureModel.area frame:CGRectMake(123, 76, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:areaContent];
//        UILabel *count = [Tools labelWith:@"数       量：" frame:CGRectMake(68, 89, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:count];
//        UILabel *countContent = [Tools labelWith:[NSString stringWithFormat:@"%@",orderModel.reserveNums] frame:CGRectMake(123, 89, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:countContent];
//        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 107, kScreenSize.width, 0.5)];
//        lineView.image = [UIImage imageNamed:@"orderLine"];
//        //lineView.backgroundColor = [Tools colorWithHexString:@"#666666"];
//        [cell addSubview:lineView];
//        [lineView release];
//        
//        UILabel *paiedLabel = [Tools labelWith:@"实际付款：" frame:CGRectMake(8, 127, 60, 15) textSize:12 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:paiedLabel];
//        UILabel *paiedContent = [Tools labelWith:[NSString stringWithFormat:@"￥%.2f",orderModel.actualPayment.floatValue] frame:CGRectMake(68, 127, 80, 15) textSize:12 textColor:[Tools colorWithHexString:@"333"] lines:1 aligment:NSTextAlignmentLeft];
//        [cell addSubview:paiedContent];
//        
//        UIButton *checkBtn = [Tools buttonWithFrame:CGRectMake(kScreenSize.width-60, 127, 50, 20) title:nil nomalImage:@"查看预约码" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:indexPath.row target:self sel:@selector(checkNumClick:)];
//        [cell addSubview:checkBtn];
//    }else{
//        
//        if ([orderModel.status isEqualToString:@"cancelled"]) {
//            //取消预约
//            for (UIView *view in cell.subviews) {
//                [view removeFromSuperview];
//            }
//            UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 8)];
//            topLine.image = [UIImage imageNamed:@"订单线"];
//            [cell addSubview:topLine];
//            [topLine release];
//            UIImageView *orderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 11, 15, 18)];
//            orderIcon.image = [UIImage imageNamed:@"订单图标"];
//            [cell addSubview:orderIcon];
//            [orderIcon release];
//            UILabel *freeLabel = [Tools labelWith:@"订单信息：" frame:CGRectMake(27, 11, 80, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:freeLabel];
//            UILabel *freeContent = [Tools labelWith:orderInfoModel.sn frame:CGRectMake(107, 11, 100, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:freeContent];
//            
//            
//            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 32, kScreenSize.width, 0.5)];
//            line.backgroundColor = [Tools colorWithHexString:@"#666666"];
//            [cell addSubview:line];
//            [line release];
//            
//            UILabel *payState = [Tools labelWith:@"未付款" frame:CGRectMake(kScreenSize.width-50, 11, 40, 20) textSize:12 textColor:[Tools colorWithHexString:@"#5db4fb"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:payState];
//            
//            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 37, 55, 65)];
//            [icon sd_setImageWithURL:[NSURL URLWithString:lectureModel.picture] placeholderImage:[UIImage imageNamed:@"医生预加载图片"]];
//            [cell addSubview:icon];
//            [icon release];
//            UILabel *lecture = [Tools labelWith:@"健康讲座：" frame:CGRectMake(68, 37, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:lecture];
//            UILabel *lectureContent = [Tools labelWith:lectureModel.title frame:CGRectMake(123, 37, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            //    lecture.backgroundColor = [UIColor grayColor];
//            //    lectureContent.backgroundColor = [UIColor blackColor];
//            
//            
//            
//            [cell addSubview:lectureContent];
//            UILabel *talker = [Tools labelWith:@"主  讲 人：" frame:CGRectMake(68, 50, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:talker];
//            UILabel *talkerContent = [Tools labelWith:lectureModel.talker frame:CGRectMake(123, 50, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:talkerContent];
//            
//            UILabel *time = [Tools labelWith:@"讲座时间：" frame:CGRectMake(68, 63, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:time];
//            NSString *lecBeginTime = [[NSString alloc] initWithString:[Tools timeYMDStringFrom:lectureModel.beginDate.doubleValue]];
//            NSString *lecEndTime = [[NSString alloc] initWithString:[Tools timeYMDStringFrom:lectureModel.endDate.doubleValue]];
//            NSString *lecHourTime = [[NSString alloc] initWithString:[Tools timeHMStringFrom:lectureModel.lectureDate.doubleValue]];
//            NSString *timeStr = [[NSString alloc] initWithFormat:@"%@-%@日 %@",lecBeginTime,lecEndTime,lecHourTime];
//            UILabel *timeContent = [Tools labelWith:timeStr frame:CGRectMake(123, 63, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:timeContent];
//            
//            UILabel *area = [Tools labelWith:@"讲座地点：" frame:CGRectMake(68, 76, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:area];
//            UILabel *areaContent = [Tools labelWith:lectureModel.area frame:CGRectMake(123, 76, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:areaContent];
//            UILabel *count = [Tools labelWith:@"数       量：" frame:CGRectMake(68, 89, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:count];
//            UILabel *countContent = [Tools labelWith:[NSString stringWithFormat:@"%@",orderModel.reserveNums] frame:CGRectMake(123, 89, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:countContent];
//            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 107, kScreenSize.width, 0.5)];
//            lineView.backgroundColor = [Tools colorWithHexString:@"#666666"];
//            [cell addSubview:lineView];
//            [lineView release];
//            
//            UILabel *paiedLabel = [Tools labelWith:@"实际付款：" frame:CGRectMake(8, 127, 60, 15) textSize:12 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:paiedLabel];
//            UILabel *paiedContent = [Tools labelWith:[NSString stringWithFormat:@"￥%.2f",orderModel.actualPayment.floatValue] frame:CGRectMake(68, 127, 80, 15) textSize:12 textColor:[Tools colorWithHexString:@"333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:paiedContent];
//            
//            UIButton *continuePay = [Tools buttonWithFrame:CGRectMake(kScreenSize.width-60, 127, 50, 20) title:nil nomalImage:@"继续支付" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:indexPath.row target:self sel:@selector(continuePayClick:)];
//            [cell addSubview:continuePay];
//            
//        }else if ([orderModel.status isEqualToString:@"sucess"]){
//            //预约并支付成功
//            for (UIView *view in cell.subviews) {
//                [view removeFromSuperview];
//            }
//            UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 8)];
//            topLine.image = [UIImage imageNamed:@"订单线"];
//            [cell addSubview:topLine];
//            [topLine release];
//            UIImageView *orderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 11, 15, 18)];
//            orderIcon.image = [UIImage imageNamed:@"订单图标"];
//            [cell addSubview:orderIcon];
//            [orderIcon release];
//            UILabel *freeLabel = [Tools labelWith:@"订单信息：" frame:CGRectMake(27, 11, 80, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:freeLabel];
//            UILabel *freeContent = [Tools labelWith:orderInfoModel.sn frame:CGRectMake(107, 11, 100, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:freeContent];
//            
//            UILabel *payState = [Tools labelWith:@"已付款" frame:CGRectMake(kScreenSize.width-50, 11, 40, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:payState];
//            
//            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 32, kScreenSize.width, 0.5)];
//            line.backgroundColor = [Tools colorWithHexString:@"#666666"];
//            [cell addSubview:line];
//            [line release];
//            
//            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 37, 55, 65)];
//            [icon sd_setImageWithURL:[NSURL URLWithString:lectureModel.picture] placeholderImage:[UIImage imageNamed:@"医生预加载图片"]];
//            [cell addSubview:icon];
//            [icon release];
//            UILabel *lecture = [Tools labelWith:@"健康讲座：" frame:CGRectMake(68, 37, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:lecture];
//            UILabel *lectureContent = [Tools labelWith:lectureModel.title frame:CGRectMake(123, 37, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            //    lecture.backgroundColor = [UIColor grayColor];
//            //    lectureContent.backgroundColor = [UIColor blackColor];
//            
//            
//            
//            [cell addSubview:lectureContent];
//            UILabel *talker = [Tools labelWith:@"主  讲 人：" frame:CGRectMake(68, 50, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:talker];
//            UILabel *talkerContent = [Tools labelWith:lectureModel.talker frame:CGRectMake(123, 50, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:talkerContent];
//            
//            UILabel *time = [Tools labelWith:@"讲座时间：" frame:CGRectMake(68, 63, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:time];
//            NSString *lecBeginTime = [[NSString alloc] initWithString:[Tools timeYMDStringFrom:lectureModel.beginDate.doubleValue]];
//            NSString *lecEndTime = [[NSString alloc] initWithString:[Tools timeYMDStringFrom:lectureModel.endDate.doubleValue]];
//            NSString *lecHourTime = [[NSString alloc] initWithString:[Tools timeHMStringFrom:lectureModel.lectureDate.doubleValue]];
//            NSString *timeStr = [[NSString alloc] initWithFormat:@"%@-%@日 %@",lecBeginTime,lecEndTime,lecHourTime];
//            UILabel *timeContent = [Tools labelWith:timeStr frame:CGRectMake(123, 63, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:timeContent];
//            
//            UILabel *area = [Tools labelWith:@"讲座地点：" frame:CGRectMake(68, 76, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:area];
//            UILabel *areaContent = [Tools labelWith:lectureModel.area frame:CGRectMake(123, 76, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:areaContent];
//            UILabel *count = [Tools labelWith:@"数       量：" frame:CGRectMake(68, 89, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:count];
//            UILabel *countContent = [Tools labelWith:[NSString stringWithFormat:@"%@",orderModel.reserveNums] frame:CGRectMake(123, 89, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:countContent];
//            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 107, kScreenSize.width, 0.5)];
//            lineView.backgroundColor = [Tools colorWithHexString:@"#666666"];
//            [cell addSubview:lineView];
//            [lineView release];
//            
//            UILabel *paiedLabel = [Tools labelWith:@"实际付款：" frame:CGRectMake(8, 127, 60, 15) textSize:12 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:paiedLabel];
//            UILabel *paiedContent = [Tools labelWith:[NSString stringWithFormat:@"￥%.2f",orderModel.actualPayment.floatValue] frame:CGRectMake(68, 127, 80, 15) textSize:12 textColor:[Tools colorWithHexString:@"333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:paiedContent];
//            
//            UIButton *cancelBtn = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width-120, 127, 50, 20) target:self sel:@selector(cancelBtnClick:) tag:indexPath.row image:@"取消预约" title:nil];
//            [cell addSubview:cancelBtn];
//            
//            UIButton *checkBtn = [Tools buttonWithFrame:CGRectMake(kScreenSize.width-60, 127, 50, 20) title:nil nomalImage:@"查看预约码" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:indexPath.row target:self sel:@selector(checkNumClick:)];
//            [cell addSubview:checkBtn];
//            
//        }else{
//            //未支付
//            for (UIView *view in cell.subviews) {
//                [view removeFromSuperview];
//            }
//            UIImageView *topLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenSize.width, 8)];
//            topLine.image = [UIImage imageNamed:@"订单线"];
//            [cell addSubview:topLine];
//            [topLine release];
//            UIImageView *orderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 11, 15, 18)];
//            orderIcon.image = [UIImage imageNamed:@"订单图标"];
//            [cell addSubview:orderIcon];
//            [orderIcon release];
//            UILabel *freeLabel = [Tools labelWith:@"订单信息：" frame:CGRectMake(27, 11, 80, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:freeLabel];
//            
//            UILabel *payState = [Tools labelWith:@"未付款" frame:CGRectMake(kScreenSize.width-50, 11, 40, 20) textSize:12 textColor:[Tools colorWithHexString:@"#5db4fb"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:payState];
//            UILabel *freeContent = [Tools labelWith:orderInfoModel.sn frame:CGRectMake(107, 11, 100, 20) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:freeContent];
//            
//            
//            
//            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 32, kScreenSize.width, 0.5)];
//            line.backgroundColor = [Tools colorWithHexString:@"#666666"];
//            [cell addSubview:line];
//            [line release];
//            
//            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 37, 55, 65)];
//            [icon sd_setImageWithURL:[NSURL URLWithString:lectureModel.picture] placeholderImage:[UIImage imageNamed:@"医生预加载图片"]];
//            [cell addSubview:icon];
//            [icon release];
//            UILabel *lecture = [Tools labelWith:@"健康讲座：" frame:CGRectMake(68, 37, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:lecture];
//            UILabel *lectureContent = [Tools labelWith:lectureModel.title frame:CGRectMake(123, 37, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            //    lecture.backgroundColor = [UIColor grayColor];
//            //    lectureContent.backgroundColor = [UIColor blackColor];
//            
//            
//            
//            [cell addSubview:lectureContent];
//            UILabel *talker = [Tools labelWith:@"主  讲 人：" frame:CGRectMake(68, 50, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:talker];
//            UILabel *talkerContent = [Tools labelWith:lectureModel.talker frame:CGRectMake(123, 50, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:talkerContent];
//            
//            UILabel *time = [Tools labelWith:@"讲座时间：" frame:CGRectMake(68, 63, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:time];
//            NSString *lecBeginTime = [[NSString alloc] initWithString:[Tools timeYMDStringFrom:lectureModel.beginDate.doubleValue]];
//            NSString *lecEndTime = [[NSString alloc] initWithString:[Tools timeYMDStringFrom:lectureModel.endDate.doubleValue]];
//            NSString *lecHourTime = [[NSString alloc] initWithString:[Tools timeHMStringFrom:lectureModel.lectureDate.doubleValue]];
//            NSString *timeStr = [[NSString alloc] initWithFormat:@"%@-%@日 %@",lecBeginTime,lecEndTime,lecHourTime];
//            UILabel *timeContent = [Tools labelWith:timeStr frame:CGRectMake(123, 63, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:timeContent];
//            
//            UILabel *area = [Tools labelWith:@"讲座地点：" frame:CGRectMake(68, 76, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:area];
//            UILabel *areaContent = [Tools labelWith:lectureModel.area frame:CGRectMake(123, 76, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:areaContent];
//            UILabel *count = [Tools labelWith:@"数       量：" frame:CGRectMake(68, 89, 70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:count];
//            UILabel *countContent = [Tools labelWith:[NSString stringWithFormat:@"%@",orderModel.reserveNums] frame:CGRectMake(123, 89, kScreenSize.width-68-70, 13) textSize:11 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:countContent];
//            UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 107, kScreenSize.width, 0.5)];
//            lineView.backgroundColor = [Tools colorWithHexString:@"#666666"];
//            [cell addSubview:lineView];
//            [lineView release];
//            
//            UILabel *paiedLabel = [Tools labelWith:@"实际付款：" frame:CGRectMake(8, 127, 60, 15) textSize:12 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:paiedLabel];
//            UILabel *paiedContent = [Tools labelWith:[NSString stringWithFormat:@"￥%.2f",orderModel.actualPayment.floatValue] frame:CGRectMake(68, 127, 80, 15) textSize:12 textColor:[Tools colorWithHexString:@"333"] lines:1 aligment:NSTextAlignmentLeft];
//            [cell addSubview:paiedContent];
//            
//            UIButton *cancelBtn = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width-120, 127, 50, 20) target:self sel:@selector(cancelBtnClick:) tag:indexPath.row image:@"取消预约" title:nil];
//            [cell addSubview:cancelBtn];
//            
//            UIButton *continuePay = [Tools buttonWithFrame:CGRectMake(kScreenSize.width-60, 127, 50, 20) title:nil nomalImage:@"继续支付" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:indexPath.row target:self sel:@selector(continuePayClick:)];
//            [cell addSubview:continuePay];
//            
//        }
////        cell.paiedMoneyLabel.text = [NSString stringWithFormat:@"￥%.2f",orderModel.actualPayment.floatValue];
////        cell.orderCountLabel.text = orderInfoModel.sn;
//    }
    
    return cell;
}

//查看预约码
-(void)checkNumClick:(UIButton *)button{
    OrderNumModel *model = [_orderNumArr objectAtIndex:button.tag];
    _bottomView = [[UIView alloc] initWithFrame:self.view.frame];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.5;
    [self.view addSubview:_bottomView];
    _topView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_topView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen)];
    [_topView addGestureRecognizer:tap];
    [tap release];
    
    UIImageView *hintView = [[UIImageView alloc] initWithFrame:CGRectMake(10, kScreenSize.height/2-35, kScreenSize.width-20, 100)];
    hintView.image = [UIImage imageNamed:@"预约码背景"];
    [_topView addSubview:hintView];
    
    UILabel *title = [Tools labelWith:@"预约码：" frame:CGRectMake(10, 12, 80, 10) textSize:13 textColor:[Tools colorWithHexString:@"#5c5c5c"] lines:1 aligment:NSTextAlignmentLeft];
    [hintView addSubview:title];
    UILabel *num = [Tools labelWith:model.reserveSn frame:CGRectMake(0, 45, hintView.frame.size.width, 10) textSize:13 textColor:[Tools colorWithHexString:@"5c5c5c"] lines:1 aligment:NSTextAlignmentCenter];
    [hintView addSubview:num];
    
    UILabel *time = [Tools labelWith:[Tools timeYMDStringFrom:model.modifyDate.doubleValue] frame:CGRectMake(hintView.frame.size.width-120, 78, 100, 10) textSize:11 textColor:[Tools colorWithHexString:@"#5c5c5c"] lines:1 aligment:NSTextAlignmentRight];
    [hintView addSubview:time];
    
    [hintView release];
    [_bottomView release];
    [_topView release];
}
//取消预约
-(void)cancelBtnClick:(UIButton *)button{
    [button removeFromSuperview];
    _requstCat = 2;
    HealthOrderedModel *orderModel = [_dataArr objectAtIndex:button.tag];
    NSString *str = [[NSString alloc] initWithFormat:@"%@/member/doctorSubscribe/cancel/%@.jhtml?type=10",URL_PRE,orderModel.id];
    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:str]];
    _request.timeOutSeconds = 20;
    _request.requestMethod = @"GET";
    _request.delegate = self;
    [_request startAsynchronous];
    [str release];
}
//继续支付
-(void)continuePayClick:(UIButton *)button{
    
    //跳转到支付界面
    /*
    HealthLectureModel *lecModel = [_lecturesArr objectAtIndex:button.tag];
    HealthOrderedModel *healthModel = [_dataArr objectAtIndex:button.tag];
    HealthOrderedInfoModel *orderModel = [_ordersArr objectAtIndex:button.tag];
    
    
    PaymentInfoViewController *payment = [[PaymentInfoViewController alloc] init];
    payment.model = lecModel;
    payment.count = healthModel.reserveNums.integerValue;
    payment.price = healthModel.actualPayment.floatValue;
    payment.orderId = orderModel.id.integerValue;
    payment.sn = orderModel.sn;
    [self.navigationController pushViewController:payment animated:YES];
    [payment release];
     */
}

-(void)tapScreen{
    [_bottomView removeFromSuperview];
    [_topView removeFromSuperview];
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
