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


#define kCOMMIT @"member/service/fxpgReport.jhtml"                   /*********** 提交接口  ************/
#define kGET_CHILDMEMBER @"member/memberModifi/list.jhtml"   /*********** 获取子账户 ************/

@interface OrganDiseaseListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *_searchBar;
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    
    NSInteger _selectedCount;//已选择的病症个数
    NSMutableArray *_selectedArr;//存放已经选择的病症的model
    //弹出视图
    UIView *_bottomView;
    UIView *_showView;
    UIImageView *_contentView;
    UITableView *_popUpTableView;
    UITableView *_popDownTableView;
    
    NSMutableArray *_symptomImageArr;//病症图片
    NSMutableArray *_symptomDataArr;//病症数据
}

@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger selectedCount;
@property (nonatomic,retain) NSMutableArray *selectedArr;
@property (nonatomic,retain) UIView *bottomView;
@property (nonatomic,retain) UIView *showView;
@property (nonatomic,retain) UIImageView *contentView;
@property (nonatomic,retain) UITableView *popUpTableView;
@property (nonatomic,retain) UITableView *popDownTableView;
@property (nonatomic,retain) NSMutableArray *symptomImageArr;
@property (nonatomic,retain) NSMutableArray *symptomDataArr;
//子账户弹出视图
@property (nonatomic ,retain) UIView *childPersonView;
@property (nonatomic ,retain) UIView *childShowView;
@property (nonatomic ,retain) UITableView *childTableView;
@property (nonatomic ,retain) NSMutableArray *childDataArr;
@property (nonatomic ,copy) NSString *memberChildId;

@end

@implementation OrganDiseaseListViewController

- (void)dealloc
{
   
}
#pragma mark- viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"疾病列表";
    [self customsearchBar];
    [self createTableView];
    
    [self initData];
    
}

#pragma mark- 初始化数据
-(void)initData{
    //弹出视图
    _bottomView = [[UIView alloc] initWithFrame:self.view.frame];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.5;
    [self.view addSubview:_bottomView];
    _showView = [[UIView alloc] initWithFrame:self.view.frame];
    _showView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_showView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePopView)];
    [_showView addGestureRecognizer:tap];
    
    _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-40, 180)];
    _contentView.image = [UIImage imageNamed:@"popback"];
    //_contentView.backgroundColor = [UIColor redColor];
    _contentView.layer.cornerRadius = 6;
    _contentView.clipsToBounds = YES;
    _contentView.center = self.view.center;
    _contentView.userInteractionEnabled = YES;
    [_showView addSubview:_contentView];
    _bottomView.hidden = YES;
    _showView.hidden = YES;
    //弹出的tableView
    _popUpTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, _contentView.frame.size.width, _contentView.frame.size.height/2) style:UITableViewStylePlain];
    _popUpTableView.delegate = self;
    _popUpTableView.dataSource = self;
    _popUpTableView.showsVerticalScrollIndicator = NO;
    _popUpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _popDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _contentView.frame.size.height/2, _contentView.frame.size.width, _contentView.frame.size.height/2) style:UITableViewStylePlain];
    _popDownTableView.delegate = self;
    _popDownTableView.dataSource = self;
    _popDownTableView.showsVerticalScrollIndicator = NO;
    _popDownTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _selectedArr = [[NSMutableArray alloc] init];
    _selectedCount = 0;
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-61, ScreenWidth, 61)];
    view2.backgroundColor = [Tools colorWithHexString:@"#f2f1ef"];
    [self.view addSubview:view2];
    UIButton *selectedSymDisBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-80, 10.5, 160, 40) target:self sel:@selector(selectedSymDisBtnClick:) tag:22 image:@"selectedSymDisease" title:nil];
    [view2 addSubview:selectedSymDisBtn];
    
    
    NSArray *openImages = @[@"ICD10_back_open",@"ICD10_reason_open",@"ICD10_stomach_open",@"ICD10_body_open",@"ICD10_limps_open",@"ICD10_head_open",@"ICD10_chest_open",@"ICD10_waist_open"];
    _symptomImageArr = [[NSMutableArray alloc] initWithArray:openImages];
    
    NSArray *section = @[@"背部",@"病因",@"腹部",@"全身",@"四肢部",@"头面部",@"胸部",@"腰股部"];
    _symptomDataArr = [[NSMutableArray alloc] initWithArray:section];
    [self createChildMemberView];
}
#pragma mark- 子成员弹出视图
-(void)createChildMemberView{
    //子成员弹出视图
    _childDataArr = [[NSMutableArray alloc]init];
    _memberChildId = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
    _childPersonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _childPersonView.backgroundColor = [UIColor blackColor];
    _childPersonView.alpha = 0.3;
    [self.view addSubview:_childPersonView];
    _childShowView = [[UIView alloc]initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 60, self.view.frame.size.height - 190)];
    _childShowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_childShowView];
    _childTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _childShowView.frame.size.width, _childShowView.frame.size.height - 80) style:UITableViewStylePlain];
    _childTableView.delegate = self;
    _childTableView.dataSource = self;
    _childTableView.bounces = NO;
    [_childShowView addSubview:_childTableView];
    [_childTableView registerClass:[AdvisoryTableViewCell class] forCellReuseIdentifier:@"CELL"];
    _childTableView.backgroundColor = [UIColor whiteColor];
    //_childTableView.hidden = YES;
    
    _childTableView.tableFooterView = [[UIView alloc]init];
    
    _childPersonView.hidden = YES;
    _childShowView.hidden = YES;
    
    //_showView添加点击手势
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [_childPersonView addGestureRecognizer:tap2];
    
}
-(void)tapScreen:(UITapGestureRecognizer *)tap{
    [_childPersonView setHidden:YES];
    [_childShowView setHidden:YES];
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)hidePopView{
    _bottomView.hidden = YES;
    _showView.hidden = YES;
    for (UIView *view in _contentView.subviews) {
        [view removeFromSuperview];
    }
}
-(void)showPopView{
    _bottomView.hidden = NO;
    _showView.hidden = NO;
}
#pragma mark ------ searchBar相关
-(void)customsearchBar{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, 50)];
    view.backgroundColor = [Tools colorWithHexString:@"#d5d7d8"];
    [self.view addSubview:view];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 30)];
    _searchBar.layer.masksToBounds = YES;
    _searchBar.layer.cornerRadius = 4;
    [_searchBar setBackgroundImage:[UIImage new]];
    _searchBar.delegate = self;
    _searchBar.tag = 100;
    _searchBar.placeholder = @"搜索疾病名称";
    //searchBar.showsCancelButton = YES;
    [view addSubview:_searchBar];
    //[_searchBar release];
    
    
    UIImageView *view2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.bottom, ScreenWidth, 46)];
    view2.tag = 1024;
    view2.backgroundColor = [Tools colorWithHexString:@"#f2f1ef"];
    UIImageView *diseaseIcon = [Tools creatImageViewWithFrame:CGRectMake(20, 14, 17.5, 18) imageName:@"ICD10_病"];
    [view2 addSubview:diseaseIcon];
    UILabel *symptomLabel = [Tools labelWith:@"可能的疾病" frame:CGRectMake(48, 14, 120, 18) textSize:13 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45.5, ScreenWidth, 0.5)];
    line.image = [UIImage imageNamed:@"ICD10_leftGrayLine"];
    [view2 addSubview:line];
    
    [view2 addSubview:symptomLabel];
    [self.view addSubview:view2];
   
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //关闭键盘的方法
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


//将要进入编辑模式
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //[searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
//将要推出编辑模式
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    return YES;
}
//点击取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}
//开始搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    NSArray *arr = [[DBManager sharedManager] readModelsWith:_searchBar.text];
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:arr];
    _dataArr = [marr mutableCopy];
    
    [_tableView reloadData];
}
#pragma mark- tableView相关
-(void)createTableView{
    
    UIView *view2 = [self.view viewWithTag:1024];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, view2.bottom, ScreenWidth, ScreenHeight-view2.bottom-61) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
    if (tableView == _tableView) {
        if (_dataArr.count) {
            return _dataArr.count;
        }
    }else if (tableView == _popUpTableView){
        if (self.upData) {
            return self.upData.count;
        }
    }else if (tableView == _popDownTableView){
        if (_selectedArr.count) {
            return _selectedArr.count;
        }
    }else if (tableView == _childTableView){
        if (_childDataArr.count) {
            return _childDataArr.count;
        }
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView || tableView == _childTableView) {
        return 44.0f;
    }
    return 40.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        if (_dataArr.count) {
            OrganDiseaseModel *model = _dataArr[indexPath.row];
            NSMutableString *contentStr = [[NSMutableString alloc] initWithString:model.content];
            NSArray *contentArr = [contentStr componentsSeparatedByString:@"_"];
            UILabel *title = [Tools labelWith:contentArr[0] frame:CGRectMake(48, 0, 260, 44) textSize:14 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
            [cell.contentView addSubview:title];
            UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(40, 43, ScreenWidth-80, 1) imageName:@"ICD10_leftGrayLine"];
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
                                if ([selectedModel.content isEqualToString:tapModel.content]) {
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
                                [self showPopView];
                                NSArray *alert = @[@"您最多只能选择五种症状",@"请酌情选择"];
                                for (int k=0; k<alert.count; k++) {
                                    UILabel *label = [Tools labelWith:alert[k] frame:CGRectMake(0, 75+k*15, self->_contentView.frame.size.width, 15) textSize:14 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentCenter];
                                    [self->_contentView addSubview:label];
                                }
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
    }else if (tableView == _popUpTableView){
        return [self showUpTableViewWith:tableView index:indexPath];
    }else if (tableView == _popDownTableView){
        return [self showDownTableViewWith:tableView index:indexPath];
    }else if (tableView == _childTableView){
        return [self showChildTableViewWith:tableView index:indexPath];
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        self.refreshBlock(indexPath.row);
    }else if (tableView == _childTableView){
        _childPersonView.hidden = YES;
        _childShowView.hidden = YES;

        NSLog(@"%ld",(long)indexPath.row);
        NSDictionary *memberDic = self.childDataArr[indexPath.row];
        NSNumber *memberId = @(0);
        memberId = memberDic[@"id"];
        NSMutableString *symStr = [[NSMutableString alloc] init];
        NSMutableString *icdStr = [[NSMutableString alloc] init];
        NSMutableString *param = [[NSMutableString alloc] init];
        [param appendFormat:@"cust_id=%@",memberId];
        
        for (int i=0; i<_upData.count; i++) {
            SymptomModel *symModel = _upData[i];
            [symStr  appendFormat:@",%@-%.1f",symModel.symptomId,symModel.extent];
        }
        if (symStr.length) {
            [symStr deleteCharactersInRange:NSMakeRange(0, 1)];
            [param appendFormat:@"&symptomStr=%@",symStr];
        }
        
        for (int j=0; j<_selectedArr.count; j++) {
            OrganDiseaseModel *diseaseModel = _selectedArr[j];
            [icdStr appendFormat:@",%@",diseaseModel.MICD];
        }
        if (icdStr.length) {
            [icdStr deleteCharactersInRange:NSMakeRange(0, 1)];
            [param appendFormat:@"&icds=%@",icdStr];
        }
        [param appendFormat:@"&level=%@",@(2)];
        [param appendFormat:@"&zxNum=%@",@(_upData.count)];
        [param appendFormat:@"&disNum=%@",@(_selectedArr.count)];
        [param appendFormat:@"&sex=%@",@(_sex)];
        [param appendFormat:@"&device=1"];
        
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@",URL_PRE,kCOMMIT,param];
 
       
    }
}
#pragma mark- 展示popUptableView
-(UITableViewCell *)showUpTableViewWith:(UITableView *)tableView index:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"upCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    SymptomModel *selectedModel = _upData[indexPath.row];
    NSString *iconImage = [[NSString alloc] init];
    for (int i=0;i<_symptomImageArr.count;i++) {
        NSString *str = _symptomDataArr[i];
        if ([str isEqualToString:selectedModel.personPart]) {
            iconImage = _symptomImageArr[i];
            break;
        }
    }
//    UIImageView *icon = [Tools creatImageViewWithFrame:CGRectMake(25, 3, 34.5, 34) imageName:iconImage];
//    [cell.contentView addSubview:icon];
    UILabel *symptomName = [Tools labelWith:selectedModel.symptom frame:CGRectMake(25, 3, _contentView.frame.size.width-70-25-11-20-30, 34) textSize:14 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
    [cell.contentView addSubview:symptomName];
    UILabel *extentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-25-11-20-30, 3, 30, 34)];
    extentLabel.font = [UIFont systemFontOfSize:14];
    NSLog(@"%@ --- %f",selectedModel.symptom,selectedModel.extent);

    
    CGFloat light= 0.7;
    CGFloat moderate = 1.0;
    CGFloat heavy = 1.2;
    if (selectedModel.extent == light) {
        extentLabel.text = @"轻度";
        extentLabel.textColor = [Tools colorWithHexString:@"#00bc00"];
    }else if (selectedModel.extent == moderate){
        extentLabel.text = @"中度";
        extentLabel.textColor = [Tools colorWithHexString:@"#ff9a24"];
    }else if (selectedModel.extent == heavy){
        extentLabel.text = @"重度";
        extentLabel.textColor = [Tools colorWithHexString:@"#ff7057"];
    }

    
    [cell.contentView addSubview:extentLabel];
    
    cell.contentView.userInteractionEnabled = YES;
    UIImageView *deleteImage = [Tools creatImageViewWithFrame:CGRectMake(_contentView.frame.size.width-25-11-5, 9.5, 16, 21) imageName:@"ICD10_delete"];
    [cell.contentView addSubview:deleteImage];
    UIButton *deleteBtn = [Tools creatButtonWithFrame:CGRectMake(_contentView.frame.size.width-5-40, 0, 40, 40) target:self sel:@selector(upDeleteBtnClick:) tag:50+indexPath.row image:@"" title:nil];
    deleteBtn.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:deleteBtn];
    UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(25, 39, _contentView.frame.size.width-25-25, 1) imageName:@"ICD10_leftGrayLine"];
    [cell.contentView addSubview:lineView];
    return cell;
}
#pragma mark- 展示popDowntableView
-(UITableViewCell *)showDownTableViewWith:(UITableView *)tableView index:(NSIndexPath *)indexPath {
    static NSString *cellDownIdentifier = @"downCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellDownIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDownIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    OrganDiseaseModel *diseaseModel = _selectedArr[indexPath.row];
    NSMutableString *contentStr = [[NSMutableString alloc] initWithString:diseaseModel.content];
    NSArray *contentArr = [contentStr componentsSeparatedByString:@"_"];
    UILabel *diseaseName = [Tools labelWith:contentArr[0] frame:CGRectMake(25, 3, _contentView.frame.size.width-20-30, 34) textSize:14 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
    [cell.contentView addSubview:diseaseName];
    
    cell.contentView.userInteractionEnabled = YES;
    UIImageView *deleteImage = [Tools creatImageViewWithFrame:CGRectMake(_contentView.frame.size.width-25-11-5, 9.5, 16, 21) imageName:@"ICD10_delete"];
    [cell.contentView addSubview:deleteImage];
    UIButton *deleteBtn = [Tools creatButtonWithFrame:CGRectMake(_contentView.frame.size.width-5-40, 0, 40, 40) target:self sel:@selector(downDeleteBtnClick:) tag:150+indexPath.row image:@"" title:nil];
    deleteBtn.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:deleteBtn];
    UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(25, 39, _contentView.frame.size.width-25-25, 1) imageName:@"ICD10_leftGrayLine"];
    [cell.contentView addSubview:lineView];
    return cell;
}
#pragma mark- 展示childTableView
-(UITableViewCell *)showChildTableViewWith:(UITableView *)tableView index:(NSIndexPath *)indexPath {
    AdvisoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        UIImageView *aimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 13.5, 53 / 2, 53 / 2)];
        aimage.image = [UIImage imageNamed:@"4111_11.png"];
        [cell addSubview:aimage];
    }else{
        UIImageView *aimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 13.5, 53 / 2, 53 / 2)];
        aimage.image = [UIImage imageNamed:@"4123_15.png"];
        [cell addSubview:aimage];
    }
    if ([[self.childDataArr[indexPath.row] objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
        cell.nameLabel.text = @"未知";
    }else{
        if ([[self.childDataArr[indexPath.row] objectForKey:@"name"]isEqualToString:[UserShareOnce shareOnce].name]) {
            cell.nameLabel.text = [[MemberUserShance shareOnce].name isKindOfClass:[NSNull class]]? [UserShareOnce shareOnce].name:[MemberUserShance shareOnce].name;
        }else{
            cell.nameLabel.text = [self.childDataArr[indexPath.row] objectForKey:@"name"];
        }
    }
    int sesss ;
    int age ;
    
    if ([[self.childDataArr[indexPath.row] objectForKey:@"birthday"]isEqual:[NSNull null]] ) {
        NSString *sex = @"";
        if ([[UserShareOnce shareOnce].gender isEqual:[NSNull null]]||[[UserShareOnce shareOnce].gender isEqualToString:@"male"]) {
            sex =@"男" ;
        }else{
            sex = @"女";
        }
        
        cell.sexLabel.text = [NSString stringWithFormat:@"%@",sex];
        cell.phoneLabel.text = [NSString stringWithFormat:@"%@岁",@"0"];
        
    }else{
        NSString *sex = @"";
        if ([[self.childDataArr[indexPath.row] objectForKey:@"gender"] isKindOfClass:[NSNull class]]) {
            sex = @"未知";
        }else if ([[self.childDataArr[indexPath.row] objectForKey:@"gender"] isEqualToString:@"male"]) {
            sex =@"男" ;
        }else{
            sex = @"女";
        }
        
        NSString *str = [[self.childDataArr[indexPath.row] objectForKey:@"birthday"] substringToIndex:4];
        sesss = [str intValue];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *now;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
        NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        now=[NSDate date];
        comps = [calendar components:unitFlags fromDate:now];
        age = (int)[comps year] - sesss;
        
        cell.sexLabel.text = [NSString stringWithFormat:@"%@",sex];
        cell.phoneLabel.text = [NSString stringWithFormat:@"%d岁",age];
    }
    return cell;
}
#pragma mark-点击病症删除按钮
-(void)upDeleteBtnClick:(UIButton *)button{
    if (_upData.count) {
        SymptomModel *model = _upData[button.tag-50];
        [_upData removeObjectAtIndex:button.tag-50];
        [_popUpTableView reloadData];
        //同时相应的改变_rightTableView状态
        model.fPrivate = @NO;
        model.extent = 0;
//        if (_selectedCount>0) {
//            _selectedCount--;
//        }
        //将改变同步到plist

        
        //读plist数据
        NSString *home = NSHomeDirectory();
        NSString *docPath2 = [home stringByAppendingPathComponent:@"Documents"];
        NSString *filepath = [docPath2 stringByAppendingPathComponent:@"symptom.plist"];
        NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filepath];
        for (int i=0;i<data.count;i++) {
            NSDictionary *dic = data[i];
            if ([dic[@"symptom"] isEqualToString:model.symptom]) {
                //改变plist中的fPrivate的状态
                NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
                [mdic setValue:model.fPrivate forKey:@"fPrivate"];
                [data replaceObjectAtIndex:i withObject:mdic];
                [data writeToFile:filepath atomically:YES];
            }
        }
        
    }
    
}
#pragma mark-点击疾病删除按钮
-(void)downDeleteBtnClick:(UIButton *)button{
    if (_selectedArr.count) {
        //OrganDiseaseModel *model = _selectedArr[button.tag - 150];
        [_selectedArr removeObjectAtIndex:button.tag-150];
        [_popDownTableView reloadData];
        [_tableView reloadData];
        
    }
}
#pragma mark-添加、去除“对勾”
-(void)addCheckWith:(UITableViewCell *)cell{
    //UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-14-20.5, 9.75, 20.5, 20.5)];
    UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-40-22, 9.75, 20.5, 20.5)];

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
    NSLog(@"点击已选症状及疾病");
    [_contentView setFrame:CGRectMake(0, 0, ScreenWidth-40, (_selectedArr.count*40+30)+(_upData.count*40+30)+60)];
    _contentView.center = self.view.center;
    [self showPopView];
    [_popUpTableView setFrame:CGRectMake(0, 30, _contentView.frame.size.width, _upData.count*40)];
    [_contentView addSubview:_popUpTableView];
    [_popUpTableView reloadData];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, 30)];
    view.backgroundColor = [Tools colorWithHexString:@"#f2f1ef"];
    UIImageView *symIcon = [Tools creatImageViewWithFrame:CGRectMake(20, 5, 17.5, 18) imageName:@"ICD10_07_症"];
    [view addSubview:symIcon];
    UILabel *symptomLabel = [Tools labelWith:@"已选症状" frame:CGRectMake(48, 5, 120, 18) textSize:13 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [view addSubview:symptomLabel];
    [_contentView addSubview:view];
    
    
    UIImageView *view2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30+_popUpTableView.frame.size.height, _contentView.frame.size.width, 30)];
    view2.backgroundColor = [Tools colorWithHexString:@"#f2f1ef"];
    UIImageView *diseaseIcon = [Tools creatImageViewWithFrame:CGRectMake(20, 5, 17.5, 18) imageName:@"ICD10_病"];
    [view2 addSubview:diseaseIcon];
    UILabel *diseaseLabel = [Tools labelWith:@"已选疾病" frame:CGRectMake(48, 5, 120, 18) textSize:13 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [view2 addSubview:diseaseLabel];
    [_contentView addSubview:view2];
    
    
    [_popDownTableView setFrame:CGRectMake(0, 30*2+_popUpTableView.frame.size.height, _contentView.frame.size.width, _selectedArr.count*40)];
    [_contentView addSubview:_popDownTableView];
    [_popDownTableView reloadData];
    
    UIButton *backBtn = [Tools creatButtonWithFrame:CGRectMake(_contentView.frame.size.width/4-43.25, _contentView.frame.size.height-46, 86.5, 32) target:self sel:@selector(backBtnClick:) tag:60 image:@"ICD10_back" title:nil];
    [_contentView addSubview:backBtn];
    
    UIButton *commitBtn = [Tools creatButtonWithFrame:CGRectMake(_contentView.frame.size.width/4*3-43.25, _contentView.frame.size.height-46, 86.5, 32) target:self sel:@selector(commitBtnClick:) tag:61 image:@"ICD10_commit" title:nil];
    [_contentView addSubview:commitBtn];
}

#pragma mark-点击返回按钮
-(void)backBtnClick:(UIButton *)button{
    [self hidePopView];
}
#pragma mark-点击提交按钮
-(void)commitBtnClick:(UIButton *)button{
    
    [self hidePopView];
    if([GlobalCommon isManyMember]){
        SubMemberView *subMember = [[SubMemberView alloc] initWithFrame:CGRectZero];
        __weak typeof(self) weakSelf = self;
        [subMember receiveSubIdWith:^(NSString *subId) {
            NSLog(@"%@",subId);
            if ([subId isEqualToString:@"user is out of date"]) {
                //登录超时
                
            }else{
                [weakSelf handleMessageWithMemberId:subId];
                NSLog(@"选中的子账户id为：%@",subId);
            }
            [subMember hideHintView];
        }];
    }else{
        [self handleMessageWithMemberId:[NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum]];
    }
    
}

- (void)handleMessageWithMemberId:(NSString *)memberId
{
    
    NSMutableString *symStr = [[NSMutableString alloc] init];
    NSMutableString *icdStr = [[NSMutableString alloc] init];
    NSMutableString *param = [[NSMutableString alloc] init];
    [param appendFormat:@"cust_id=%@",memberId];
    
    for (int i=0; i<_upData.count; i++) {
        SymptomModel *symModel = _upData[i];
        [symStr  appendFormat:@",%@-%.1f",symModel.symptomId,symModel.extent];
    }
    if (symStr.length) {
        [symStr deleteCharactersInRange:NSMakeRange(0, 1)];
        [param appendFormat:@"&symptomStr=%@",symStr];
    }
    
    for (int j=0; j<_selectedArr.count; j++) {
        OrganDiseaseModel *diseaseModel = _selectedArr[j];
        [icdStr appendFormat:@",%@",diseaseModel.MICD];
    }
    if (icdStr.length) {
        [icdStr deleteCharactersInRange:NSMakeRange(0, 1)];
        [param appendFormat:@"&icds=%@",icdStr];
    }
    [param appendFormat:@"&level=%@",@(2)];
    [param appendFormat:@"&zxNum=%@",@(_upData.count)];
    [param appendFormat:@"&disNum=%@",@(_selectedArr.count)];
    [param appendFormat:@"&sex=%@",@(_sex)];
    [param appendFormat:@"&device=1"];
    
    [UserShareOnce shareOnce].isRefresh = YES;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@",URL_PRE,kCOMMIT,param];
    ResultWriteController *vc = [[ResultWriteController alloc] init];
    vc.urlStr = urlStr;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- block相关
-(void)refreshCellWith:(refreshCellBlock)block{
    if (!self.refreshBlock) {
        self.refreshBlock = [block copy];
    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
