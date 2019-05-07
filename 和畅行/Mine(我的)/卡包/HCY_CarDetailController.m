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
@property (nonatomic,strong) UIView *listBackView;
@end

@implementation HCY_CarDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutCarDetailView];
   
}

-(void)layoutCarDetailView {
    
    self.navTitleLabel.text = ModuleZW(@"卡详情");
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, kNavBarHeight + 40,ScreenWidth - 20, 240)];
    [imageV.layer addSublayer:[UIColor setGradualChangingColor:imageV fromColor:@"4294E1" toColor:@"D1BDFF"]];
    imageV.layer.cornerRadius = 10;
    imageV.layer.masksToBounds = YES;
    imageV.userInteractionEnabled = YES;
    [self.view addSubview:imageV];
    
    _hLabel = [[UILabel alloc] init];
    _hLabel.frame = CGRectMake(20, 20, imageV.width - 30, 25);
    _hLabel.textColor = [UIColor whiteColor];
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
    

    self.serviceTableView = [[UITableView alloc]initWithFrame:CGRectMake(_yLabel.left+5, _yLabel.bottom+5, imageV.width-_yLabel.left*2 - 10, imageV.height-_yLabel.bottom-10) style:UITableViewStylePlain];
    self.serviceTableView.backgroundColor = [UIColor clearColor];
    self.serviceTableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.serviceTableView.dataSource = self;
    self.serviceTableView.delegate = self;
    self.serviceTableView.rowHeight = 30;
    [imageV addSubview:self.serviceTableView];
    
    
  
    
    
    
    
    UIButton *listButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    listButton.frame = CGRectMake(imageV.width - 40, 20, 25, 27);
    [listButton setBackgroundImage:[UIImage imageNamed:@"消费记录icon"] forState:(UIControlStateNormal)];
    [[listButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if(!self.listBackView) {
            self.listBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.listBackView.backgroundColor = RGBA(0, 0, 0, 0.55);
            self.listBackView.hidden = NO;
            [self.view addSubview:self.listBackView];
        }else{
             self.listBackView.hidden = NO;
        }
        
        self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, ScreenHeight/2 - 110 , ScreenWidth - 80 , 210) style:UITableViewStylePlain];
        self.listTableView.backgroundColor = UIColorFromHex(0Xffffff);
        self.listTableView.separatorStyle = UITableViewCellEditingStyleNone;
        self.listTableView.layer.cornerRadius = 8;
        self.listTableView.dataSource = self;
        self.listTableView.delegate = self;
        self.listTableView.rowHeight = 30;
        [self.listBackView addSubview:self.listTableView];
          [self.listTableView registerNib:[UINib nibWithNibName:@"HCY_ConsumptionListCell" bundle:nil] forCellReuseIdentifier:@"HCY_ConsumptionListCell"];
        
     
        
        
        UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        closeButton.frame = CGRectMake(ScreenWidth - 55, ScreenHeight/2 - 145, 28, 28);
        [closeButton setBackgroundImage:[UIImage imageNamed:@"消费记录取消icon"] forState:(UIControlStateNormal)];
        [[closeButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            self.listBackView.hidden = YES;
        }];
        [self.listBackView addSubview:closeButton];
        
    }];
    [imageV addSubview:listButton];
  
    if(self.dateDic){
        listButton.hidden = YES;
        _mLabel.text = [NSString stringWithFormat:@"%@：%@",ModuleZW(@"卡号"),self.dateDic[@"data"][@"code"]];
        _yLabel.text = ModuleZW(@"服务内容");
        _hLabel.text = _dateDic[@"data"][@"name"];
        UIButton *addButton =  [UIButton buttonWithType:(UIButtonTypeCustom)];
        addButton.frame = CGRectMake(40, ScreenHeight - kTabBarHeight - 40, ScreenWidth - 80, 36);
        addButton.layer.cornerRadius = 18;
        addButton.layer.masksToBounds = YES;
        addButton.backgroundColor = RGB_ButtonBlue;
        [addButton setTitle:ModuleZW(@"添加至卡包") forState:(UIControlStateNormal)];
        [[addButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSString *UrlPre=URL_PRE;
            NSString *aUrl = [NSString stringWithFormat:@"%@/member/cashcard/bind.jhtml",UrlPre];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
            [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
            [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
            if([UserShareOnce shareOnce].languageType){
                [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
            }
            [request setPostValue:[UserShareOnce shareOnce].uid forKey:@"memberId"];
            [request setPostValue:self.dateDic[@"data"][@"code"]forKey:@"code"];
            
            [request setTimeOutSeconds:20];
            [request setRequestMethod:@"POST"];
            [request setDelegate:self];
            [request setDidFailSelector:@selector(requesstuserinfoError1:)];
            [request setDidFinishSelector:@selector(requesstuserinfoCompleted1:)];
            [request startAsynchronous];
        }];
        [self.view addSubview:addButton];
        self.serviceArr = self.dateDic[@"data"][@"lmMdServiceAttr"];
        if(self.serviceArr.count > 0){
            [_listTableView reloadData];
        }
        
    }else{
        [self requestPurchaseHistory];
    }
    
}

- (void)requesstuserinfoError1:(ASIHTTPRequest *)request
{
    [self showAlertViewController:ModuleZW(@"抱歉，请检查您的网络是否畅通")];
}
- (void)requesstuserinfoCompleted1:(ASIHTTPRequest *)request
{
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]== 100) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"cardNameSuccess" object:nil];
        [GlobalCommon showMessage:ModuleZW(@"服务卡添加成功") duration:1];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else if ([status intValue]== 44)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"登录超时，请重新登录") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        av.tag  = 100008;
        [av show];
    } else  {
        NSString *str = [dic objectForKey:@"data"];
        [self showAlertViewController:str];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _listTableView){
        return 50;
    }else{
         return 0;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *listLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, tableView.width, 50)];
    listLabel.backgroundColor = UIColorFromHex(0Xffffff);
    listLabel.text = ModuleZW(@"   消费记录");
    listLabel.font = [UIFont systemFontOfSize:16];
    listLabel.textColor = RGB_TextDarkGray;
    [self.listTableView addSubview:listLabel];
    return listLabel;
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
    if([UserShareOnce shareOnce].languageType){
        [request addRequestHeader:@"language" value:[UserShareOnce shareOnce].languageType];
    }
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.serviceTableView){
        return self.serviceArr.count;
    }else if (tableView == self.listTableView){
        return 15;
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
            
            if(self.dateDic){
                cell.tradeBtn.hidden = YES;
                cell.contentLabel.width = ScreenWidth - 130;
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
