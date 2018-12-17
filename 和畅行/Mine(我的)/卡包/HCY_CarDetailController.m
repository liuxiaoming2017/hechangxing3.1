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
@interface HCY_CarDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UILabel *hLabel;
@property (nonatomic,strong)UILabel *mLabel;
@property (nonatomic,strong)UILabel *yLabel;
@property (nonatomic,strong)UITableView *listTableView;

@end

@implementation HCY_CarDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutCarDetailView];
}

-(void)layoutCarDetailView {
    
    
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
    _hLabel.text = @"视频问诊半年卡";
    _hLabel.font = [UIFont systemFontOfSize:21];
    [imageV addSubview:_hLabel];
    
    _mLabel = [[UILabel alloc] init];
    _mLabel.frame = CGRectMake(20,_hLabel.bottom , imageV.width -  40, 60 );
    _mLabel.numberOfLines = 2;
    _mLabel.text = @"阿道夫沙发沙发沙发上发送到发的是飞洒发士大夫撒按时发生";
    _mLabel.font = [UIFont systemFontOfSize:14];
    _mLabel.textColor = [UIColor whiteColor];
    [imageV addSubview:_mLabel];
    
    
    
    _yLabel = [[UILabel alloc] init];
    _yLabel.frame = CGRectMake(_mLabel.left , _mLabel.bottom , 160, 30);
    _yLabel.text = @"剩余服务";
    _yLabel.font = [UIFont systemFontOfSize:16];
    _yLabel.textColor = [UIColor whiteColor];
    [imageV addSubview:_yLabel];
    
    
    NSArray *titleArray = @[@"余        额",@"视频咨询"];
    NSArray *contentArray = @[@"300元",@"3次"];
    NSArray *buttonArray = @[@"去购物",@"去咨询"];
    
    for (int i = 0 ; i < 2; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_mLabel.left , _yLabel.bottom + 30*i, imageV.width/3, 30)];
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        [imageV addSubview:label];
        
        
        UILabel *contentlabel = [[UILabel alloc]initWithFrame:CGRectMake(_mLabel.left + _mLabel.width/3 , _yLabel.bottom + 30*i, imageV.width/3, 30)];
        contentlabel.text = contentArray[i];
        contentlabel.textAlignment = NSTextAlignmentCenter;
        contentlabel.textColor = [UIColor whiteColor];
        [imageV addSubview:contentlabel];
        
        
        HCY_UnderlineButton *actionButton = [HCY_UnderlineButton buttonWithType:(UIButtonTypeCustom)];
        actionButton.frame =CGRectMake( _mLabel.width*2/3, _yLabel.bottom + 30*i, imageV.width/3, 30);
        [actionButton setTitle:buttonArray[i] forState:(UIControlStateNormal)];
        [actionButton addTarget:self action:@selector(consultingAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [actionButton setTag:2000 + i];
        [actionButton setColor:[UIColor whiteColor]];
        [imageV addSubview:actionButton];
        
    }
    
    
    UILabel *listLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, imageV.bottom + 23, 200, 30)];
    listLabel.text = @"消费记录";
    listLabel.font = [UIFont systemFontOfSize:16];
    listLabel.textColor = RGB_TextDarkGray;
    [self.view addSubview:listLabel];
    
    
//    self.dataArray = [NSMutableArray array];
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(40, listLabel.bottom+20, self.view.frame.size.width - 80, self.view.frame.size.height - kNavBarHeight-listLabel.bottom - 20) style:UITableViewStylePlain];
    self.listTableView.backgroundColor = [UIColor clearColor];
    self.listTableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.rowHeight = 30;
    [self.view addSubview:self.listTableView];
    
    [self.listTableView registerNib:[UINib nibWithNibName:@"HCY_ConsumptionListCell" bundle:nil] forCellReuseIdentifier:@"HCY_ConsumptionListCell"];
    
    
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
    
    return 10;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCY_ConsumptionListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCY_ConsumptionListCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
};

@end
