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

@interface OrganDiseaseListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *_searchBar;
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    
    NSInteger _selectedCount;//已选择的病症个数
    NSMutableArray *_selectedArr;//存放已经选择的病症的model
    //弹出视图
    
    NSMutableArray *_symptomDataArr;//病症数据
}

@property (nonatomic,retain) UISearchBar *searchBar;
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArr;
@property (nonatomic,assign) NSInteger selectedCount;
@property (nonatomic,retain) NSMutableArray *selectedArr;
@property (nonatomic,retain) NSMutableArray *symptomDataArr;
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
}

#pragma mark- 初始化数据
-(void)initData{


    _selectedArr = [[NSMutableArray alloc] init];
    _selectedCount = 0;
    
    
    UIButton *selectedSymDisBtn = [Tools creatButtonWithFrame:CGRectMake(30, ScreenHeight - 50, ScreenWidth - 60, 40) target:self sel:@selector(selectedSymDisBtnClick:) tag:22 image:nil title:ModuleZW(@"确定")];
    selectedSymDisBtn.backgroundColor = RGB_ButtonBlue;
    selectedSymDisBtn.layer.cornerRadius = 20;
    selectedSymDisBtn.layer.masksToBounds = YES;
    [selectedSymDisBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.view addSubview:selectedSymDisBtn];
    
    
 
    
    NSArray *section = @[@"背部",@"病因",@"腹部",@"全身",@"四肢部",@"头面部",@"胸部",@"腰股部"];
    _symptomDataArr = [[NSMutableArray alloc] initWithArray:section];
}

-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark ------ searchBar相关
-(void)customsearchBar{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, kNavBarHeight, ScreenWidth-20, 56)];
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    self.backView = view;
    [self insertSublayerWithImageView:view with:self.view];
    [self.view addSubview:view];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-40, 36)];
    _searchBar.layer.masksToBounds = YES;
    [_searchBar setBackgroundImage:[UIImage new]];
    _searchBar.layer.cornerRadius = 18;
    _searchBar.tintColor = [UIColor whiteColor];
    _searchBar.delegate = self;
    _searchBar.tag = 100;
    _searchBar.placeholder = ModuleZW(@"搜索疾病名称");
    [_searchBar setImage:[UIImage imageNamed:@"搜索 (1)"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    UITextField *searchTextField =  [[[_searchBar.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor =RGB_ButtonBlue;
    searchTextField.layer.cornerRadius = 18;
    searchTextField.layer.masksToBounds = YES;
    searchTextField.textColor = [UIColor whiteColor];
    NSString *holderText = ModuleZW(@"搜索疾病名称");
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:[UIColor whiteColor]
                        range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont boldSystemFontOfSize:16]
                        range:NSMakeRange(0, holderText.length)];
    searchTextField.attributedPlaceholder = placeholder;
    
    
    for(UIView *searchBarSubview in [_searchBar subviews]){
        for(UIView *subView in [searchBarSubview subviews]){
            if([subView conformsToProtocol:@protocol(UITextInputTraits)]){
                [(UITextField *)subView setReturnKeyType:UIReturnKeyDone];
            }
        }
    }
    
    
    
    [view addSubview:_searchBar];
    
    
    //[_searchBar release];
    
    
   
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSArray *arr = [[DBManager sharedManager] readModelsWith:_searchBar.text];
    NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:arr];
    _dataArr = [marr mutableCopy];
    if(arr.count > 0){
        self.backView.frame = CGRectMake(10, kNavBarHeight, ScreenWidth-20, ScreenHeight - kNavBarHeight  );
         [self insertSublayerWithImageView:_backView with:self.view];
    }else{
        self.backView.frame = CGRectMake(10, kNavBarHeight, ScreenWidth-20, 56);
         [self insertSublayerWithImageView:_backView with:self.view];
    }
    [_tableView reloadData];
}

//开始搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];

}
#pragma mark- tableView相关
-(void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavBarHeight+76, ScreenWidth, ScreenHeight-kNavBarHeight - kTabBarHeight - 76 ) style:UITableViewStylePlain];
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
    return 44.0f;
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
    HpiViewController *hpiVC = [[HpiViewController alloc]init];
    hpiVC.topArray = self.upData;
    hpiVC.bottomArray =  _selectedArr;
    hpiVC.sex = _sex;
    [self.navigationController pushViewController:hpiVC animated:YES];
   
}





#pragma mark- block相关
-(void)refreshCellWith:(refreshCellBlock)block{
    if (!self.refreshBlock) {
        self.refreshBlock = [block copy];
    }
    
}



@end
