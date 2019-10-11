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
#import "BlockViewController.h"

@interface HCY_CarDetailController ()<UITableViewDelegate,UITableViewDataSource,ServiceBlockCellDelegate>

@property (nonatomic,strong)UILabel *hLabel;
@property (nonatomic,strong)UILabel *mLabel;
@property (nonatomic,strong)UILabel *yLabel;
@property (nonatomic,strong)UILabel *contentLabel;
@property (nonatomic,strong)UITableView *listTableView;
@property (nonatomic,strong)UITableView *serviceTableView;
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,strong) NSArray *serviceArr;
@property (nonatomic,strong) UIView *listBackView;
@end

@implementation HCY_CarDetailController

- (void)viewDidLoad {
    [super viewDidLoad];

    if(self.dateDic){
        [self layoutCarDetailView];
    }else{
        [self requestPurchaseHistory];
    }
   
}

-(void)layoutCarDetailView {
    self.navTitleLabel.text = ModuleZW(@"卡详情");
    CGFloat height ;
    NSString *contentStr = [NSString string];
    
    if(self.dateDic){
        NSString *dicStr = [NSString stringWithFormat:@"%@",self.dateDic[@"data"][@"lmMdServiceAttr"]];
        if(dicStr.length > 10){
            self.serviceArr = self.dateDic[@"data"][@"lmMdServiceAttr"];
        }else{
            self.serviceArr = @[];
        }
        self.model = [[HYC_CardsModel alloc]init];
        self.model.card_name = _dateDic[@"data"][@"name"];
        NSLog(@"%@",self.model.card_name);
        if(!kDictIsEmpty(self.dateDic[@"data"][@"description"])){
            contentStr = self.dateDic[@"data"][@"description"];
        }else{
            contentStr = @"";
        }
    }else{
        contentStr = _model.cardDescription;
    }


    CGRect textRect = [contentStr boundingRectWithSize:CGSizeMake(ScreenWidth - 60, MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                           context:nil];
    
     NSLog(@"%@",self.model.card_name);
    CGRect labelRect = [self.model.card_name boundingRectWithSize:CGSizeMake(ScreenWidth - 20 - 60, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} context:nil];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, kNavBarHeight + 40,ScreenWidth - 20, 70 + textRect.size.height + _serviceArr.count * 30*[UserShareOnce shareOnce].fontSize+labelRect.size.height + 20)];
    if (imageV.height > ScreenHeight - imageV.top -  kTabBarHeight) {
        imageV.height = ScreenHeight - imageV.top -  kTabBarHeight - 30;
    }
    [imageV.layer addSublayer:[UIColor setGradualChangingColor:imageV fromColor:@"4294E1" toColor:@"D1BDFF"]];
    imageV.layer.cornerRadius = 10;
    imageV.layer.masksToBounds = YES;
    imageV.userInteractionEnabled = YES;
    [self.view addSubview:imageV];
    
    
    
    _hLabel = [[UILabel alloc] init];
    _hLabel.frame = CGRectMake(20, 20, imageV.width - 60, labelRect.size.height);
    _hLabel.textColor = [UIColor whiteColor];
    _hLabel.numberOfLines = 2;
    _hLabel.text = self.model.card_name;
    _hLabel.font = [UIFont systemFontOfSize:20];
    [imageV addSubview:_hLabel];
    
    _mLabel = [[UILabel alloc] init];
    _mLabel.frame = CGRectMake(20,_hLabel.bottom , imageV.width -  40, 35 );
    _mLabel.numberOfLines = 2;
    _mLabel.text = [NSString stringWithFormat:@"%@:%@",ModuleZW(@"卡密"),self.model.card_no];
    _mLabel.font = [UIFont systemFontOfSize:16];
    _mLabel.textColor = [UIColor whiteColor];
//    [imageV addSubview:_mLabel];
    
   
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.frame = CGRectMake(20,_hLabel.bottom + 5 , imageV.width -  40, textRect.size.height );
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = contentStr;
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.textColor = [UIColor whiteColor];
    [imageV addSubview:_contentLabel];
    
    
    
    _yLabel = [[UILabel alloc] init];
    _yLabel.frame = CGRectMake(_mLabel.left , _contentLabel.bottom , 300, 35);
    _yLabel.text = ModuleZW(@"剩余服务");
    _yLabel.font = [UIFont systemFontOfSize:16];
    _yLabel.textColor = [UIColor whiteColor];
    [imageV addSubview:_yLabel];
    

    self.serviceTableView = [[UITableView alloc]initWithFrame:CGRectMake(_yLabel.left+5, _yLabel.bottom+5, imageV.width-_yLabel.left*2 - 10, _serviceArr.count * 30*[UserShareOnce shareOnce].fontSize) style:UITableViewStylePlain];
    self.serviceTableView.backgroundColor = [UIColor clearColor];
    self.serviceTableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.serviceTableView.dataSource = self;
    self.serviceTableView.delegate = self;
    self.serviceTableView.estimatedRowHeight = 100;
    [imageV addSubview:self.serviceTableView];
    
    
    UIButton *listButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    listButton.frame = CGRectMake(imageV.width - 40, 20, 25, 27);
    [listButton setBackgroundImage:[UIImage imageNamed:@"消费记录icon"] forState:(UIControlStateNormal)];
    [[listButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        
        if(self.dataArr.count < 1){
            [self showAlertWarmMessage:ModuleZW(@"暂无消费记录")];
            return ;
        }
        
        if(!self.listBackView) {
            self.listBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            self.listBackView.backgroundColor = RGBA(0, 0, 0, 0.55);
            self.listBackView.hidden = NO;
            [self.view addSubview:self.listBackView];
            
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
        }else{
             self.listBackView.hidden = NO;
        }
    }];
    [imageV addSubview:listButton];
  

    if(self.dateDic){
        listButton.hidden = YES;
//        _mLabel.text = [NSString stringWithFormat:@"%@:%@",ModuleZW(@"卡密"),self.dateDic[@"data"][@"code"]];
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
        if(self.serviceArr.count > 0){
            [_listTableView reloadData];
        }
        
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
    NSLog(@"%@",dic);
    if ([status intValue]== 100) {
        
        if([[[dic valueForKey:@"data"] valueForKey:@"member"] valueForKey:@"bindCard"]){
            [UserShareOnce shareOnce].bindCard = [[[dic valueForKey:@"data"] valueForKey:@"member"] valueForKey:@"bindCard"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cardNameSuccess" object:nil];
//        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:ModuleZW(@"服务卡添加成功") preferredStyle:(UIAlertControllerStyleAlert)];
//        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
//            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:YES];
//
//        }];
//        [alerVC addAction:sureAction];
//        [self presentViewController:alerVC animated:YES completion:nil];
        [GlobalCommon showMessage:ModuleZW(@"服务卡添加成功") duration:1];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:YES];
        
    }
    else if ([status intValue]== 44)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:ModuleZW(@"提示") message:ModuleZW(@"登录超时，请重新登录") delegate:self cancelButtonTitle:ModuleZW(@"确定") otherButtonTitles:nil,nil];
        av.tag  = 100008;
        [av show];
    } else  {
        
        NSString *str = [[dic valueForKey:@"data"] valueForKey:@"data"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cardNameSuccess" object:nil];
        UIAlertController *alerVC = [UIAlertController alertControllerWithTitle:ModuleZW(@"提示") message:str preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:ModuleZW(@"确定") style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]animated:YES];
            
        }];
        [alerVC addAction:sureAction];
        [self presentViewController:alerVC animated:YES completion:nil];
        
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
    

}

- (void)requesstuserinfoError:(ASIHTTPRequest *)request
{
    [self layoutCarDetailView];
    [GlobalCommon hideMBHudWithView:self.view];
    [self showAlertWarmMessage:ModuleZW(@"抱歉，请检查您的网络是否畅通")];
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
//                [self.listTableView reloadData];
            }
        }
        [self layoutCarDetailView];

    }else{
        [self layoutCarDetailView];
        [self showAlertWarmMessage:[dic objectForKey:@"message"]];
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.serviceTableView){
        if(self.serviceArr){
            return self.serviceArr.count;
        }else{
            return 0;
        }
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
            cell.kindLabel.text = [dic objectForKey:@"name"];
            NSString *timeStr =[NSString stringWithFormat:@"%@", [dic objectForKey:@"createDate"]];
            if (![GlobalCommon stringEqualNull:timeStr]) {
                cell.timeLabel.text = [timeStr substringToIndex:10];
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
