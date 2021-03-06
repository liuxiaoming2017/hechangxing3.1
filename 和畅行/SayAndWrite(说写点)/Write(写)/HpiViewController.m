//
//  HpiViewController.m
//  和畅行
//
//  Created by 出神入化 on 2019/4/30.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "HpiViewController.h"
#import "HPITableViewCell.h"
#import "SymptomModel.h"
#import "OrganDiseaseModel.h"
#import "ResultWriteController.h"

#define kCOMMIT @"member/service/fxpgReport.jhtml"                   /*********** 提交接口  ************/
@interface HpiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UIView *top1View;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UITableView *topTableView;
@property (nonatomic,strong)UITableView *bottomTableView;
@end

@implementation HpiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = ModuleZW(@"现病史");
    
    [self layoutView];
}

//布局现病史页面
-(void)layoutView{
    
    NSArray *titleArray = @[ModuleZW(@"症状选择"),ModuleZW(@"现病史")];
    for (int i = 0; i < 2; i++) {
        UIView  *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        [self.view addSubview:view];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, ScreenWidth - 60, 40)];
        label.text = titleArray[i];
        [view addSubview:label];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth - 20, 1)];
        lineView.backgroundColor = RGB(236, 236, 236);
        [view addSubview:lineView];
        
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:(UITableViewStylePlain)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if(i == 0){
            view.frame = CGRectMake(10, kNavBarHeight + 10, ScreenWidth - 20, _topArray.count * 40 + 60);
            tableView.frame = CGRectMake(0, 50, ScreenWidth - 20, _topArray.count * 40 );
            self.top1View = view;
            self.topTableView = tableView;
            
        }else{
            view.frame = CGRectMake(10, self.top1View.bottom + 10, ScreenWidth - 20, _bottomArray.count * 40 + 60);
            tableView.frame = CGRectMake(0, 50, ScreenWidth - 20, _bottomArray.count * 40 );
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            button.frame = CGRectMake(ScreenWidth-60, 10, 30, 30);
            [button setBackgroundImage:[UIImage imageNamed:@"添加icon"] forState:(UIControlStateNormal)];
            [[button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [view addSubview:button];
            self.bottomView = view;
            self.bottomTableView = tableView;
        }
        [view addSubview:tableView];
        [self insertSublayerWithImageView:view with:self.view];
        
        UIButton *submitButton = [UIButton  buttonWithType:(UIButtonTypeCustom)];
        submitButton.frame = CGRectMake(30, ScreenHeight - kTabBarHeight, ScreenWidth - 60, 36);
        [submitButton setTitle:ModuleZW(@"提交") forState:(UIControlStateNormal)];
        submitButton.titleLabel.font = [UIFont systemFontOfSize:18];
        submitButton.layer.cornerRadius = 18;
        submitButton.layer.masksToBounds = YES;
        submitButton.backgroundColor = RGB_ButtonBlue;
        [[submitButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
            NSMutableString *symStr = [[NSMutableString alloc] init];
            NSMutableString *icdStr = [[NSMutableString alloc] init];
            NSMutableString *param = [[NSMutableString alloc] init];
            [param appendFormat:@"cust_id=%@",[MemberUserShance shareOnce].idNum];
            
            for (int i=0; i<self->_topArray.count; i++) {
                SymptomModel *symModel = self->_topArray[i];
                [symStr  appendFormat:@",%@-%.1f",symModel.symptomId,symModel.extent];
            }
            if (symStr.length) {
                [symStr deleteCharactersInRange:NSMakeRange(0, 1)];
                [param appendFormat:@"&symptomStr=%@",symStr];
            }
            
            for (int j=0; j<self->_bottomArray.count; j++) {
                OrganDiseaseModel *diseaseModel = self->_bottomArray[j];
                [icdStr appendFormat:@",%@",diseaseModel.MICD];
            }
            
            if (icdStr.length) {
                [icdStr deleteCharactersInRange:NSMakeRange(0, 1)];
                [param appendFormat:@"&icds=%@",icdStr];
            }
            [param appendFormat:@"&level=%@",@(2)];
            [param appendFormat:@"&zxNum=%@",@(self->_topArray.count)];
            [param appendFormat:@"&disNum=%@",@"5"];
            [param appendFormat:@"&sex=%@",@(self->_sex)];
            [param appendFormat:@"&device=1"];
            
            [UserShareOnce shareOnce].isRefresh = YES;
            
            NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@",URL_PRE,kCOMMIT,param];
            ResultWriteController *vc = [[ResultWriteController alloc] init];
            vc.urlStr = urlStr;
            vc.isReturnTop = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [self.view addSubview:submitButton];

    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _topTableView) {
        return  _topArray.count;
    }else{
        return _bottomArray.count;
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentiferStr = @"HPITableViewCell";
    HPITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentiferStr];
   
    if (cell == nil) {
        cell = [[HPITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentiferStr];
    }
    if (tableView == _topTableView){
        SymptomModel *selectedModel = _topArray[indexPath.row];
        cell.titleLabel.text = ModuleZW(selectedModel.symptom);
        cell.stateLabel.hidden = NO;
        cell.titleLabel.width = (ScreenWidth -20)/2 - 35;
        CGFloat light= 0.7;
        CGFloat moderate = 1.0;
        CGFloat heavy = 1.5;
        cell.deletBlock = ^{
            SymptomModel *model = self->_topArray[indexPath.row];
            for (int i = 0; i < self.rightDataArr.count; i++) {
                SymptomModel *model1 = self.rightDataArr[i];
                if([model.symptom isEqualToString:model1.symptom]){
                    model1.fPrivate = 0;
                }
            }
            [self->_topArray removeObjectAtIndex:indexPath.row];
            [self.topTableView reloadData];
        };
        if (selectedModel.extent == light) {
            cell.stateLabel.text = ModuleZW(@"轻度");
            cell.stateLabel.textColor = [Tools colorWithHexString:@"#00bc00"];
        }else if (selectedModel.extent == moderate){
            cell.stateLabel.text = ModuleZW(@"中度");
            cell.stateLabel.textColor = [Tools colorWithHexString:@"#ff9a24"];
        }else if (selectedModel.extent == heavy){
            cell.stateLabel.text = ModuleZW(@"重度");
            cell.stateLabel.textColor = [Tools colorWithHexString:@"#ff7057"];
        }
    }else{
        cell.stateLabel.hidden = YES;
        OrganDiseaseModel *diseaseModel = _bottomArray[indexPath.row];
        NSMutableString *contentStr = [[NSMutableString alloc] initWithString:diseaseModel.content];
        NSArray *contentArr = [contentStr componentsSeparatedByString:@"_"];
        cell.titleLabel.text = contentArr[0];
        cell.titleLabel.width = ScreenWidth -100;
        cell.deletBlock = ^{
            [self->_bottomArray removeObjectAtIndex:indexPath.row];
            [self.bottomTableView reloadData];
        };
    }
    
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;

}
@end
