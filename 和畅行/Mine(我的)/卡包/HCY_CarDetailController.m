//
//  HCY_CarDetailController.m
//  和畅行
//
//  Created by Wei Zhao on 2018/12/10.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HCY_CarDetailController.h"
#import "HCY_UnderlineButton.h"
#import "HCY_ConsumptionListCell.h"
#import "ServiceBlockCell.h"
#import "HCY_CallController.h"


@interface HCY_CarDetailController ()<UITableViewDelegate,UITableViewDataSource,ServiceBlockCellDelegate>

@property (nonatomic,strong)UILabel *hLabel;
@property (nonatomic,strong)UILabel *mLabel;
@property (nonatomic,strong)UILabel *yLabel;
@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)UITableView *serviceTableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *serviceArr;
@end

@implementation HCY_CarDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutCarDetailView];
    [self requestPurchaseHistory];
}

-(void)layoutCarDetailView {
    
    self.navTitleLabel.text = ModuleZW(@"消费记录");
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, kNavBarHeight + 40,ScreenWidth - 20, 240)];
    [imageV.layer addSublayer:[UIColor setGradualChangingColor:imageV fromColor:@"4294E1" toColor:@"D1BDFF"]];
    imageV.layer.cornerRadius = 10;
    imageV.layer.masksToBounds = YES;
    imageV.userInteractionEnabled = YES;
    [self.view addSubview:imageV];
    
    _hLabel = [[UILabel alloc] init];
    _hLabel.frame = CGRectMake(0, 20, imageV.width, 25);
    _hLabel.textColor = [UIColor whiteColor];
    _hLabel.textAlignment = NSTextAlignmentCenter;
    _hLabel.text = self.model.card_name;
    _hLabel.font = [UIFont systemFontOfSize:21];
    [imageV addSubview:_hLabel];
    
    _mLabel = [[UILabel alloc] init];
    _mLabel.frame = CGRectMake(20,_hLabel.bottom , imageV.width -  40, 30 );
    _mLabel.numberOfLines = 2;
    _mLabel.text = [NSString stringWithFormat:@"%@：%@",ModuleZW(@"卡号"),self.model.card_no];
    _mLabel.font = [UIFont systemFontOfSize:16];
    _mLabel.textColor = [UIColor whiteColor];
    [imageV addSubview:_mLabel];
    
    
    
    _yLabel = [[UILabel alloc] init];
    _yLabel.frame = CGRectMake(_mLabel.left , _mLabel.bottom , 160, 30);
    _yLabel.text = ModuleZW(@"剩余服务");
    _yLabel.font = [UIFont systemFontOfSize:16];
    _yLabel.textColor = [UIColor whiteColor];
    [imageV addSubview:_yLabel];
    
//    if([GlobalCommon stringEqualNull:self.model.cardDescription]){
//        _yLabel.frame = CGRectMake(_mLabel.left , _hLabel.bottom , 160, 30);
//    }
    
    self.serviceTableView = [[UITableView alloc]initWithFrame:CGRectMake(_yLabel.left+5, _yLabel.bottom+5, imageV.width-_yLabel.left*2 - 10, imageV.height-_yLabel.bottom-10) style:UITableViewStylePlain];
    self.serviceTableView.backgroundColor = [UIColor clearColor];
    self.serviceTableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.serviceTableView.dataSource = self;
    self.serviceTableView.delegate = self;
    self.serviceTableView.rowHeight = 30;
    [imageV addSubview:self.serviceTableView];
    
    
    UILabel *listLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, imageV.bottom + 23, 200, 30)];
    listLabel.text = ModuleZW(@"消费记录");
    listLabel.font = [UIFont systemFontOfSize:16];
    listLabel.textColor = RGB_TextDarkGray;
    [self.view addSubview:listLabel];
    
    

    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(30, listLabel.bottom+20, self.view.frame.size.width - 60, self.view.frame.size.height - kNavBarHeight-listLabel.bottom - 20) style:UITableViewStylePlain];
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.rowHeight = 30;
    [self.view addSubview:self.listTableView];
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"HCY_ConsumptionListCell" bundle:nil] forCellReuseIdentifier:@"HCY_ConsumptionListCell"];
    
    
}

- (void)requestPurchaseHistory
{
//    NSString *urlStr   = @"weiq/user_record.jhtml";
//    NSDictionary *dic = @{@"memberId":[UserShareOnce shareOnce].uid,
//                                    @"card_no":self.model.card_no};
    
    [GlobalCommon showMBHudWithView:self.view];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/md/user_record.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    
    [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
    [request setPostValue:self.model.card_no forKey:@"card_no"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requesstuserinfoError:)];
    [request setDidFinishSelector:@selector(requesstuserinfoCompleted:)];
    [request startAsynchronous];
    
//    __weak typeof(self) weakSelf = self;
//    [ZYGASINetworking POST_Path:urlStr params:dic completed:^(id JSON, NSString *stringData) {
//        if([[JSON objectForKey:@"code"] integerValue] == 100){
//            NSArray *arr = [JSON objectForKey:@"data"];
//            if(arr.count>0){
//                    weakSelf.serviceArr = [arr objectAtIndex:0];
//                [weakSelf.serviceTableView reloadData];
//                if(arr.count>1){
//                    weakSelf.dataArr = [arr objectAtIndex:1];
//                    [weakSelf.listTableView reloadData];
//                }
//            }
           // [weakSelf.listTableView reloadData];
//        }else{
//            [weakSelf showAlertWarmMessage:[JSON objectForKey:@"message"]];
//        }
//    } failed:^(NSError *error) {
//        [weakSelf showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
//    }];
}

- (void)requesstuserinfoError:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"抱歉，请检查您的网络是否畅通") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
    [av show];
}
- (void)requesstuserinfoCompleted:(ASIHTTPRequest *)request
{
    [GlobalCommon hideMBHudWithView:self.view];
    NSString* reqstr=[request responseString];
    //NSLog(@"dic==%@",reqstr);
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    //NSLog(@"234214324%@",status);
    if ([status intValue]== 100) {
        
        NSArray *arr = [dic objectForKey:@"data"];
        if(arr.count>0){
            self.serviceArr = [arr objectAtIndex:0];
            [self.serviceTableView reloadData];
            if(arr.count>1){
                self.dataArr = [arr objectAtIndex:1];
                [self.listTableView reloadData];
            }
        }
    }else{
        [self showAlertWarmMessage:[dic objectForKey:@"message"]];

    }
    
}



-(void)consultingAction:(UIButton *)button {
    
    
    switch (button.tag) {
        case 2000:
            NSLog(@"去购物");
            break;
            
        case 2001:
            NSLog(@"去咨询");
            break;
            
        default:
            break;
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.serviceTableView){
        return self.serviceArr.count;
    }else if (tableView == self.listTableView){
        return self.dataArr.count;
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == self.serviceTableView){
        ServiceBlockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceBlockCell"];
        if(cell == nil){
            cell = [[ServiceBlockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ServiceBlockCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.delegate = self;
        }
        if(self.serviceArr.count>indexPath.row){
            NSDictionary *dic = [self.serviceArr objectAtIndex:indexPath.row];
            cell.typeLabel.text = [dic objectForKey:@"serviceName"];
            NSString *str = [NSString stringWithFormat:@"%@%@",[dic objectForKey:@"value"],[dic objectForKey:@"unit"]];
            cell.contentLabel.text = str;
            
            if(![GlobalCommon stringEqualNull:[dic objectForKey:@"serviceCode"]]){
                if([[dic objectForKey:@"serviceCode"] isEqualToString:@"10006"]){
                    [cell.tradeBtn setTitle:ModuleZW(@"去咨询") forState:UIControlStateNormal];
                }else{
                    [cell.tradeBtn setTitle:ModuleZW(@"去预约") forState:UIControlStateNormal];
                }
            }else{
                [cell.tradeBtn setTitle:ModuleZW(@"去咨询") forState:UIControlStateNormal];
            }
            
        }
        return cell;
    }else if (tableView == self.listTableView){
        HCY_ConsumptionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCY_ConsumptionListCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.dataArr.count>indexPath.row){
            NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
            cell.kindLabel.text = [dic objectForKey:@"serviceName"];
            NSString *timeStr =[NSString stringWithFormat:@"%@", [dic objectForKey:@"createTime"]];
            if(timeStr != nil && ![timeStr isEqualToString:@""] && ![timeStr isKindOfClass:[NSNull class]]){
                NSArray *arr = [timeStr componentsSeparatedByString:@" "];
                NSLog(@"arr:%@",arr);
                if(arr.count>1){
                    cell.timeLabel.text = [arr objectAtIndex:0];
                    cell.hourLabel.text = [arr objectAtIndex:1];
                }
            }
        }
        return cell;
    }
    
    return nil;
};

- (void)selectTradeButton:(NSString *)btnStr
{
    
    if([btnStr isEqualToString:ModuleZW(@"去咨询")]){
        HCY_CallController *vc = [[HCY_CallController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:4006776668"]];
    }
}

@end
