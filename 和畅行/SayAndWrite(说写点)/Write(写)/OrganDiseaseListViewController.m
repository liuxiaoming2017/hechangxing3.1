//
//  OrganDiseaseListViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/4.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "OrganDiseaseListViewController.h"
#import "DBManager.h"
#import "OrganDiseaseModel.h"
#import "SymptomModel.h"
#import "ResultWriteController.h"

#import "AdvisoryTableViewCell.h"
#import "HpiViewController.h"

#define kCOMMIT @"member/service/fxpgReport.jhtml"                   /*********** 提交接口  ************/
#define kGET_CHILDMEMBER @"member/memberModifi/list.jhtml"   /*********** 获取子账户 ************/

@interface OrganDiseaseListViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    
    NSInteger _selectedCount;//已选择的病症个数
    NSMutableArray *_selectedArr;//存放已经选择的病症的model
    //弹出视图
    
    NSMutableArray *_symptomDataArr;//病症数据
}

@property (nonatomic,strong) UITextField *searchTF;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger selectedCount;
@property (nonatomic,retain) NSMutableArray *selectedArr;
@property (nonatomic,retain) NSMutableArray *symptomDataArr;
@property (nonatomic,assign)BOOL isPush;
//子账户弹出视图
@property (nonatomic ,strong) UIView *backView;

@end

@implementation OrganDiseaseListViewController


#pragma mark- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = ModuleZW(@"现病史");
    [self customsearchBar];
    [self createTableView];
    
    [self initData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    _selectedCount = _selectedArr.count;
    _isPush = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if(_isPush) return;
    self.endTimeStr = [GlobalCommon getCurrentTimes];
    [GlobalCommon pageDurationWithpageId:@"7" withstartTime:self.startTimeStr withendTime:self.endTimeStr];
}

#pragma mark- 初始化数据
-(void)initData{


    _selectedArr = [[NSMutableArray alloc] init];
    _selectedCount = 0;
    
    
    UIButton *selectedSymDisBtn = [Tools creatButtonWithFrame:CGRectMake(Adapter(30), ScreenHeight - Adapter(50), ScreenWidth - Adapter(60), Adapter(40)) target:self sel:@selector(selectedSymDisBtnClick:) tag:22 image:nil title:ModuleZW(@"下一步")];
    selectedSymDisBtn.backgroundColor = RGB_ButtonBlue;
    selectedSymDisBtn.layer.cornerRadius = selectedSymDisBtn.height/2;
    selectedSymDisBtn.layer.masksToBounds = YES;
    [selectedSymDisBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:selectedSymDisBtn];
    
    
 
    
    NSArray *section = @[@"背部",@"病因",@"腹部",@"全身",@"四肢部",@"头面部",@"胸部",@"腰股部"];
    _symptomDataArr = [[NSMutableArray alloc] initWithArray:section];
}
- (void)goBack:(UIButton *)btn{
    if(_refreshTableView){
        self.refreshTableView();
    }
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark ------ searchBar相关
-(void)customsearchBar{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(Adapter(10), kNavBarHeight, ScreenWidth-Adapter(20), Adapter(56))];
    view.layer.cornerRadius = Adapter(10);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.shadowColor = RGB(200, 200, 200).CGColor;
    view.layer.shadowOffset = CGSizeMake(0,0);
    view.layer.shadowOpacity = 0.5;
    view.layer.shadowRadius = Adapter(5);
    self.backView = view;
    [self.view addSubview:view];
    
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(Adapter(10), Adapter(10), ScreenWidth-Adapter(40), Adapter(36))];
    _searchTF.layer.cornerRadius = _searchTF.height/2;
    _searchTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _searchTF.backgroundColor = RGB_ButtonBlue;
    _searchTF.textColor = [UIColor whiteColor];
    _searchTF.tintColor = [UIColor whiteColor];
    _searchTF.delegate = self;
    _searchTF.tag = 100;
    _searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ModuleZW(@"搜索疾病名称") attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Adapter(10), Adapter(10), Adapter(30), Adapter(16))];
    leftImageView.image = [UIImage imageNamed:@"搜索 (1)"];
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    _searchTF.leftView = leftImageView;
    _searchTF.leftViewMode = UITextFieldViewModeAlways;
    [view addSubview:_searchTF];
}

-(UIImage*)createImageWithColor: (UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [self.searchTF resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //关闭键盘的方法
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSArray *arr = [[DBManager sharedManager] readModelsWith:string];
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:arr];
    _dataArr = [marr mutableCopy];
    if(arr.count > 0){
        self.backView.frame = CGRectMake(Adapter(10), kNavBarHeight, ScreenWidth-Adapter(20), ScreenHeight - kNavBarHeight  );
    }else{
        self.backView.frame = CGRectMake(Adapter(10), kNavBarHeight, ScreenWidth-Adapter(20), Adapter(56));
    }
    [_tableView reloadData];
    return YES;
}

#pragma mark- tableView相关
-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+Adapter(76), ScreenWidth, ScreenHeight-kNavBarHeight - kTabBarHeight - Adapter(76) ) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    _dataArr = [[NSMutableArray alloc] init];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark-tableView Delegate相关
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adapter(44);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        cell.backgroundColor = [UIColor clearColor];
        if (_dataArr.count) {
            OrganDiseaseModel *model = _dataArr[indexPath.row];
            NSMutableString *contentStr = [[NSMutableString alloc] initWithString:model.content];
            NSArray *contentArr = [contentStr componentsSeparatedByString:@"_"];
            UILabel *title = [Tools labelWith:contentArr[0] frame:CGRectMake(Adapter(48), 0, Adapter(260), Adapter(44)) textSize:14 textColor:[Tools colorWithHexString:@"#666"] lines:0 aligment:NSTextAlignmentLeft];
            [cell.contentView addSubview:title];
            UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(Adapter(40), Adapter(43), ScreenWidth-Adapter(80), 1) imageName:@"ICD10_leftGrayLine"];
            [cell.contentView addSubview:lineView];
            if (_selectedArr.count) {
                for (OrganDiseaseModel *diseaseModel in _selectedArr) {
                    if ([diseaseModel.content isEqualToString:model.content]) {
                        [self addCheckWith:cell];
                    }
                }
            }
            //选中cell回调
            __weak typeof(self) weakSelf = self;
            [self refreshCellWith:^(NSInteger row) {
                for (int i=0; i<self->_dataArr.count; i++) {
                    if (i == row) {
                        NSLog(@"选中第%ld个cell",(long)row);
                        OrganDiseaseModel *tapModel = self->_dataArr[row];
                        /**
                         *  先判断是否有已经选择的数据，如果有则去判断当前点击的cell是否是已经被点击过，据此去添加或者去除勾,相应的从_selectedArr中增加或者删除model
                         *                         如果没有，则直接打钩，并添加到_selectedArr中
                         */
                        if (self->_selectedCount) {
                            BOOL alreadySelected = NO;
                            OrganDiseaseModel *selectedModel = nil;
                            for (int k=0; k<self->_selectedArr.count; k++) {
                                selectedModel = self->_selectedArr[k];
                                if ([selectedModel.MICD isEqualToString:tapModel.MICD]) {
                                    alreadySelected = YES;
                                    break;
                                }
                            }
                            if (alreadySelected) {
                                if (self->_selectedCount>0) {
                                    self->                                   _selectedCount--;
                                }
                                NSLog(@"删除第%ld个cell",(long)selectedModel.currentIndex);
                                [self->_selectedArr removeObjectAtIndex:selectedModel.currentIndex];
                                //更新已选择model的次序
                                for (int j=(int)selectedModel.currentIndex; j<self->_selectedArr.count; j++) {
                                    OrganDiseaseModel *model3 = self->_selectedArr[j];
                                    model3.currentIndex--;
                                    [self->_selectedArr replaceObjectAtIndex:j withObject:model3];
                                }
                                [weakSelf removeCheckWith:cell];
                            }else if(self->_selectedCount < 5){
                                tapModel.isSelected = YES;
                                if (self->_selectedArr.count) {
                                    tapModel.currentIndex = self->_selectedCount;
                                }else{
                                    tapModel.currentIndex = 0;
                                }
                                [self->_selectedArr addObject:tapModel];
                                self->_selectedCount++;
                                [weakSelf addCheckWith:cell];
                            }else{
                                NSLog(@"最多只能选择五个病症");
                                [self showAlertWarmMessage:ModuleZW(@"您最多只能选择五种症状")];
                                return ;
                            }
                        }else{
                            tapModel.isSelected = YES;
                            if (self->_selectedArr.count) {
                                tapModel.currentIndex = self->_selectedCount;
                            }else{
                                tapModel.currentIndex = 0;
                            }
                            [self->_selectedArr addObject:tapModel];
                            self->_selectedCount++;
                            [weakSelf addCheckWith:cell];
                        }
                        break;
                    }
                }
                [self->_tableView reloadData];
            }];
            
        }
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        self.refreshBlock(indexPath.row);
}

#pragma mark-添加、去除“对勾”
-(void)addCheckWith:(UITableViewCell *)cell{
    //UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-14-20.5, 9.75, 20.5, 20.5)];
    UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-Adapter(62), Adapter(9.75), Adapter(20.5), Adapter(20.5))];

    check.image = [UIImage imageNamed:@"ICD10_selected"];
    
    [cell.contentView addSubview:check];
    
}
-(void)removeCheckWith:(UITableViewCell *)cell{
    for (UIImageView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
}
#pragma mark- 点击已选症状及疾病
-(void)selectedSymDisBtnClick:(UIButton *)button{
    self.isPush = YES;
    HpiViewController *hpiVC = [[HpiViewController alloc]init];
    hpiVC.topArray = self.upData;
    hpiVC.bottomArray =  _selectedArr;
    hpiVC.rightDataArr = _rightDataArr;
    hpiVC.sex = _sex;
    NSLog(@"%@",self.startTimeStr);
    hpiVC.startTimeStr = self.startTimeStr;
    [self.navigationController pushViewController:hpiVC animated:YES];
   
}





#pragma mark- block相关
-(void)refreshCellWith:(refreshCellBlock)block{
    if (!self.refreshBlock) {
        self.refreshBlock = [block copy];
    }
    
}



@end
