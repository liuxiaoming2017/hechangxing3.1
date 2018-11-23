//
//  WriteListController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/19.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "WriteListController.h"
#import "WriteDefine.h"
#import "SymptomModel.h"
#import "Mybutton.h"
#import "MyView.h"
#import "OrganDiseaseListViewController.h"

#define popCellHeight 40

@interface WriteListController ()<UITableViewDelegate,UITableViewDataSource>
{
    
}

@end

@implementation WriteListController

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)goBack:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"脏腑辨识";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithController];
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
    
    _contentView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, ScreenWidth-100, 180)];
    _contentView.image = [UIImage imageNamed:@"popback"];
    _contentView.layer.cornerRadius = 6.0;
    _contentView.clipsToBounds = YES;
    
    _contentView.center = self.view.center;
    _contentView.userInteractionEnabled = YES;
    [_showView addSubview:_contentView];
    
    _bottomView.hidden = YES;
    _showView.hidden = YES;
}

#pragma mark-构建界面
-(void)initWithController{
    _touchedPart = [[NSString alloc] init];
    _leftButton = [Tools creatButtonWithFrame:CGRectMake(0, kNavBarHeight+5, ScreenWidth/2-0.5, 40) target:self sel:@selector(leftBtnClick:) tag:11 image:nil title:@"人 体 图 解"];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_leftButton setTitleColor:[Tools colorWithHexString:@"#319ffe"] forState:UIControlStateSelected];
    [_leftButton setTintColor:[UIColor whiteColor]];
    _leftButton.selected = YES;
    [self.view addSubview:_leftButton];
    _rightButton = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2+0.5, kNavBarHeight+5, ScreenWidth/2-0.5, 40) target:self sel:@selector(rightBtnClick:) tag:12 image:nil title:@"症 状 列 表"];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[Tools colorWithHexString:@"#319ffe"] forState:UIControlStateSelected];
    [_rightButton setTintColor:[UIColor whiteColor]];
    [self.view addSubview:_rightButton];
    
    UIImageView *vLine = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-0.25, kNavBarHeight+16, 0.5, 18)];
    vLine.image = [UIImage imageNamed:@"预约挂号专题页_03"];
    [self.view addSubview:vLine];
    //    [vLine release];
    UIImageView *hLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, _leftButton.bottom, ScreenWidth, 0.3)];
    hLine.image = [UIImage imageNamed:@"预约挂号专题页_04"];
    [self.view addSubview:hLine];
    //    [hLine release];
    
    _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _leftButton.bottom, ScreenWidth/2, 1)];
    _lineView.backgroundColor = [Tools colorWithHexString:@"#319ffe"];
    [self.view addSubview:_lineView];
    
    _leftView = [Tools creatImageViewWithFrame:CGRectMake(0, _leftButton.bottom, ScreenWidth, ScreenHeight-_leftButton.bottom) imageName:@"ICD10_02"];
    [self.view addSubview:_leftView];
    _rightView = [Tools creatImageViewWithFrame:CGRectMake(0, _leftButton.bottom, ScreenWidth, ScreenHeight-_leftButton.bottom) imageName:@""];
    _rightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rightView];
    [self.view sendSubviewToBack:_leftView];
    [self.view sendSubviewToBack:_rightView];
    _leftView.userInteractionEnabled = YES;
    _rightView.userInteractionEnabled = YES;
    _rightView.hidden = YES;
    [self createBodyView];
    [self createSymptom];
    
}

#pragma mark-人体图解界面
-(void)createBodyView{
    UIButton *sexButton = [Tools creatButtonWithFrame:CGRectMake(25, 28, 74, 35) target:self sel:@selector(sexBtnClick:) tag:13 image:@"ICD10_man" title:nil];
    _sex = 0;
    [_leftView addSubview:sexButton];
    UIButton *sideButton = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth-33.5-56.5, ScreenHeight-30-53-109, 56.5, 53) target:self sel:@selector(sideBtnClick:) tag:14 image:@"" title:nil];
    [_leftView addSubview:sideButton];
    _isFront = YES;
    if (_isFront) {
        [sideButton setImage:[UIImage imageNamed:@"ICD10_19_front"] forState:UIControlStateNormal];
    }
    
    //人体图
    _headBtn = [Tools buttonWithFrame:CGRectMake(ScreenWidth/2-30.5, 30, 61, 94) title:nil nomalImage:@"" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:15 target:self sel:@selector(bodyClick:)];
    [_leftView addSubview:_headBtn];
    _chestBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-41, 124, 82, 96) target:self sel:@selector(bodyClick:) tag:16 image:@"" title:nil];
    [_leftView addSubview:_chestBtn];
    _leftArmBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-41-59.5, 124, 59.5, 187.5) target:self sel:@selector(bodyClick:) tag:17 image:@"" title:nil];
    [_leftView addSubview:_leftArmBtn];
    _rightArmBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2+41, 124, 59.5, 187.5) target:self sel:@selector(bodyClick:) tag:18 image:@"" title:nil];
    [_leftView addSubview:_rightArmBtn];
    _hipBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-41, 220, 82, 60.5) target:self sel:@selector(bodyClick:) tag:19 image:@"" title:nil];
    [_leftView addSubview:_hipBtn];
    _legsBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-41, 280.5, 82, ScreenHeight == 568? 180: 201.5) target:self sel:@selector(bodyClick:) tag:20 image:@"" title:nil];
    [_leftView addSubview:_legsBtn];
    
    [_headBtn setImage:[UIImage imageNamed:kMAN_FRONT_HEAD_NOMAL] forState:UIControlStateNormal];
    [_leftArmBtn setImage:[UIImage imageNamed:kMAN_FRONT_LEFTARM_NOMAL] forState:UIControlStateNormal];
    [_rightArmBtn setImage:[UIImage imageNamed: kMAN_FRONT_RIGHTARM_NOMAL] forState:UIControlStateNormal];
    [_chestBtn setImage:[UIImage imageNamed: kMAN_FRONT_CHEST_NOMAL] forState:UIControlStateNormal];
    [_hipBtn setImage:[UIImage imageNamed:kMAN_FRONT_HIP_NOMAL] forState:UIControlStateNormal];
    [_legsBtn setImage:[UIImage imageNamed:kMAN_FRONT_LEGS_NOMAL] forState:UIControlStateNormal];
    
}

#pragma mark-症状列表界面以及左tableView
-(void)createSymptom{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 46)];
    view.backgroundColor = [Tools colorWithHexString:@"#f2f1ef"];
    UIImageView *diseaseIcon = [Tools creatImageViewWithFrame:CGRectMake(20, 14, 17.5, 18) imageName:@"ICD10_07_症"];
    [view addSubview:diseaseIcon];
    UILabel *symptomLabel = [Tools labelWith:@"选择症状" frame:CGRectMake(48, 14, 120, 18) textSize:13 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45.5, ScreenWidth, 0.5)];
    line.image = [UIImage imageNamed:@"ICD10_leftGrayLine"];
    [view addSubview:line];
    
    [view addSubview:symptomLabel];
    [_rightView addSubview:view];
    
    
    [self createDataSource];
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, ScreenWidth/2-20, _leftView.bounds.size.height-61-41) style:UITableViewStylePlain];
    _leftTableView.backgroundColor = [Tools colorWithHexString:@"#ecf0f1"];
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.tableFooterView = [[UIView alloc] init];
    [_rightView addSubview:_leftTableView];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, _rightView.frame.size.height-61, _rightView.frame.size.width, 61)];
    view2.backgroundColor = [Tools colorWithHexString:@"#f2f1ef"];
    [_rightView addSubview:view2];
    UIButton *selectedBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-80, 10.5, 160, 40) target:self sel:@selector(selectedBtnClick:) tag:22 image:@"ICD10_selectedSymptom" title:nil];
    [view2 addSubview:selectedBtn];
    
}

#pragma mark-左tableView的数据以及右tableView、popTableView的初始化
-(void)createDataSource{
    NSArray *section = @[@"背部",@"病因",@"腹部",@"全身",@"四肢部",@"头面部",@"胸部",@"腰股部"];
    _sectionDataArr = [[NSMutableArray alloc] initWithArray:section];
    NSArray *openImages = @[@"ICD10_back_open",@"ICD10_reason_open",@"ICD10_stomach_open",@"ICD10_body_open",@"ICD10_limps_open",@"ICD10_head_open",@"ICD10_chest_open",@"ICD10_waist_open"];
    _sectionOpenImageArr = [[NSMutableArray alloc] initWithArray:openImages];
    NSArray *closedImages = @[@"ICD10_back_closed",@"ICD10_reason_closed",@"ICD10_stomach_closed",@"ICD10_body_closed",@"ICD10_limps_closed",@"ICD10_head_closed",@"ICD10_chest_closed",@"ICD10_waist_closed"];
    _sectionClosedImageArr = [[NSMutableArray alloc] initWithArray:closedImages];
    _sectionStatus = [[NSMutableArray alloc] init];
    for (int i=0; i<section.count; i++) {
        [_sectionStatus addObject:@NO];
    }
    
    NSArray *arr1 = @[@"背部"];
    NSArray *arr2 = @[@"病因"];
    NSArray *arr3 = @[@"腹部",@"生殖部",@"生殖器",@"小便"];
    NSArray *arr4 = @[@"出汗",@"出血",@"精神状态",@"皮肤",@"身体",@"食欲",@"睡眠",@"体温",@"形态",@"肿块"];
    NSArray *arr5 = @[@"关节",@"脉",@"四肢",@"指/趾/掌"];
    NSArray *arr6 = @[@"鼻",@"耳",@"呼吸",@"颈",@"咳嗽",@"口腔",@"面部",@"面色",@"呕吐",@"舌",@"痰",@"头",@"头发",@"牙",@"咽喉",@"眼",@"声音"];
    NSArray *arr7 = @[@"乳房",@"胁肋",@"心脏",@"胸部"];
    NSArray *arr8 = @[@"大便",@"肛门",@"腰"];
    _leftDataArr = [[NSMutableArray alloc] initWithObjects:arr1,arr2,arr3,arr4,arr5,arr6,arr7,arr8, nil];
    
    NSString *symptomPath = [[NSBundle mainBundle] pathForResource:@"symptom" ofType:@"txt"];
    NSString *symptomContent = [[NSString alloc] initWithContentsOfFile:symptomPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *totalSymptomArray = [symptomContent componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistPath = [docPath stringByAppendingPathComponent:@"symptom.plist"];
    NSMutableArray *resultsArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger j = 0; j < totalSymptomArray.count; j++){
        NSString *symptomStr = [totalSymptomArray objectAtIndex:j];
        NSArray *symptomArr = [symptomStr componentsSeparatedByString:@"\t"];
        [resultsArr addObject:@{@"personPart":[symptomArr objectAtIndex:0],@"part":[symptomArr objectAtIndex:1],@"symptomId":[symptomArr objectAtIndex:2],@"symptom":[symptomArr objectAtIndex:3],@"sexType":[symptomArr objectAtIndex:4],@"inputCode":[symptomArr objectAtIndex:5],@"symDescription":[symptomArr objectAtIndex:6],@"fPrivate":[symptomArr objectAtIndex:7],@"currentIndex":[symptomArr objectAtIndex:8]}];
    }
    [resultsArr writeToFile:plistPath atomically:YES];
    
    [_leftTableView reloadData];
    
    //初始化右tableView
    _rightDataArr = [[NSMutableArray alloc] init];
    _selectedArr = [[NSMutableArray alloc] init];
    _selectedCount = 0;
    
    [self createRightTableView];
    
    //弹出的tableView
    _popTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, _contentView.frame.size.width, _contentView.frame.size.height-60-20) style:UITableViewStylePlain];
    _popTableView.delegate = self;
    _popTableView.dataSource = self;
    _popTableView.showsVerticalScrollIndicator = NO;
    _popTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark-创建rightTableView
-(void)createRightTableView{
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth/2-20, 46, ScreenWidth/2+20, _leftView.bounds.size.height-61-41) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.backgroundColor = [UIColor whiteColor];
    _rightTableView.showsVerticalScrollIndicator = NO;
    _rightTableView.tableFooterView = [[UIView alloc] init];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_rightView addSubview:_rightTableView];
    
}

#pragma mark-点击人体图解按钮
-(void)leftBtnClick:(UIButton *)button{
    _leftView.hidden = NO;
    _rightView.hidden = YES;
    [_leftButton setSelected:YES];
    [_rightButton setSelected:NO];
    _leftButton.userInteractionEnabled = NO;
    _rightButton.userInteractionEnabled = YES;
    [_lineView setFrame:CGRectMake(0, _leftButton.bottom-1, ScreenWidth/2, 1)];
    [self reloadLeftView];
    //将症状列表里面的section状态还原
    for (int i=0; i<_sectionStatus.count; i++) {
        [_sectionStatus replaceObjectAtIndex:i withObject:@NO];
    }
}
#pragma mark-点击症状列表按钮
-(void)rightBtnClick:(UIButton *)button{
    _leftView.hidden = YES;
    _rightView.hidden = NO;
    [_rightButton setSelected:YES];
    [_leftButton setSelected:NO];
    _rightButton.userInteractionEnabled = NO;
    _leftButton.userInteractionEnabled = YES;
    
    [_lineView setFrame:CGRectMake(ScreenWidth/2, _leftButton.bottom-1, ScreenWidth/2, 1)];
    //判断是不是点击身体的某部位而跳转过来的
    if (_isBodyTouched) {
        _isBodyTouched = NO;
        for (int i=0; i<_sectionDataArr.count; i++) {
            if ([_sectionDataArr[i] isEqualToString:_touchedPart]) {
                [_sectionStatus replaceObjectAtIndex:i withObject:@YES];
                _touchedPart = nil;
                _leftTableView.contentOffset = CGPointMake(0, 60*i);
                [_leftTableView reloadData];
                //                MyView *view = (MyView *)[_rightView viewWithTag:1000+i];
                //                [self sectionClick:view];
                break;
            }
        }
        
    }
}

#pragma mark-点击性别按钮
-(void)sexBtnClick:(UIButton *)button{
    if (_sex == 0) {
        _sex = 1;
        [button setImage:[UIImage imageNamed:@"ICD10_woman"] forState:UIControlStateNormal];
    }else{
        _sex = 0;
        [button setImage:[UIImage imageNamed:@"ICD10_man"] forState:UIControlStateNormal];
    }
    [self reloadLeftView];
    [self cancelledSelected];
}
#pragma mark- 点击正反面
-(void)sideBtnClick:(UIButton *)button{
    if (_isFront) {
        _isFront = NO;
        [button setImage:[UIImage imageNamed:@"2_19_back"] forState:UIControlStateNormal];
    }else{
        _isFront = YES;
        [button setImage:[UIImage imageNamed:@"ICD10_19_front"] forState:UIControlStateNormal];
    }
    [self reloadLeftView];
    [self cancelledSelected];
}

#pragma mark-刷新人体图
-(void)reloadLeftView{
    if (_isFront) {
        //正面
        [_headBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_HEAD_NOMAL: kWOMAN_FRONT_HEAD_NOMAL] forState:UIControlStateNormal];
        [_leftArmBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_LEFTARM_NOMAL: kWOMAN_FRONT_LEFTARM_NOMAL] forState:UIControlStateNormal];
        [_rightArmBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_RIGHTARM_NOMAL: kWOMAN_FRONT_RIGHTARM_NOMAL] forState:UIControlStateNormal];
        [_chestBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_CHEST_NOMAL: kWOMAN_FRONT_CHEST_NOMAL] forState:UIControlStateNormal];
        [_hipBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_HIP_NOMAL: kWOMAN_FRONT_HIP_NOMAL] forState:UIControlStateNormal];
        [_legsBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_LEGS_NOMAL: kWOMAN_FRONT_LEGS_NOMAL] forState:UIControlStateNormal];
        
        [_headBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_HEAD_SELECTED: kWOMAN_FRONT_HEAD_SELECTED] forState:UIControlStateSelected];
        [_leftArmBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_LEFTARM_SELECTED: kWOMAN_FRONT_LEFTARM_SELECTED] forState:UIControlStateSelected];
        [_rightArmBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_RIGHTARM_SELECTED: kWOMAN_FRONT_RIGHTARM_SELECTED] forState:UIControlStateSelected];
        [_chestBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_CHEST_SELECTED: kWOMAN_FRONT_CHEST_SELECTED] forState:UIControlStateSelected];
        [_hipBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_HIP_SELECTED: kWOMAN_FRONT_HIP_SELECTED] forState:UIControlStateSelected];
        [_legsBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_FRONT_LEGS_SELECTED: kWOMAN_FRONT_LEGS_SELECTED] forState:UIControlStateSelected];
    }else{
        //反面
        [_headBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_HEAD_NOMAL: kWOMAN_BACK_HEAD_NOMAL] forState:UIControlStateNormal];
        [_leftArmBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_LEFTARM_NOMAL: kWOMAN_BACK_LEFTARM_NOMAL] forState:UIControlStateNormal];
        [_rightArmBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_RIGHTARM_NOMAL: kWOMAN_BACK_RIGHTARM_NOMAL] forState:UIControlStateNormal];
        [_chestBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_CHEST_NOMAL: kWOMAN_BACK_CHEST_NOMAL] forState:UIControlStateNormal];
        [_hipBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_HIP_NOMAL: kWOMAN_BACK_HIP_NOMAL] forState:UIControlStateNormal];
        [_legsBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_LEGS_NOMAL: kWOMAN_BACK_LEGS_NOMAL] forState:UIControlStateNormal];
        
        [_headBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_HEAD_SELECTED: kWOMAN_BACK_HEAD_SELECTED] forState:UIControlStateSelected];
        [_leftArmBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_LEFTARM_SELECTED: kWOMAN_BACK_LEFTARM_SELECTED] forState:UIControlStateSelected];
        [_rightArmBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_RIGHTARM_SELECTED: kWOMAN_BACK_RIGHTARM_SELECTED] forState:UIControlStateSelected];
        [_chestBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_CHEST_SELECTED: kWOMAN_BACK_CHEST_SELECTED] forState:UIControlStateSelected];
        [_hipBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_HIP_SELECTED: kWOMAN_BACK_HIP_SELECTED] forState:UIControlStateSelected];
        [_legsBtn setImage:[UIImage imageNamed:_sex == 0?kMAN_BACK_LEGS_SELECTED: kWOMAN_BACK_LEGS_SELECTED] forState:UIControlStateSelected];
    }
}
#pragma mark-点击身体的各个部位
-(void)bodyClick:(UIButton *)button{//tag值:15~20
    [button setSelected:YES];
    button.userInteractionEnabled = NO;
    for (int i=0; i<6; i++) {
        UIButton *btn = (UIButton *)[_leftView viewWithTag:i+15];
        if (btn.tag == button.tag) {
            continue;
        }
        [btn setSelected:NO];
        btn.userInteractionEnabled = YES;
    }
    [self reloadLeftView];
    //跳到症状列表界面，同时展现点击部位的那部分列表
    _isBodyTouched = YES;
    //判断点击的是哪个部位：背部，病因，腹部，全身，四肢部，头面部，胸部，腰股部
    switch (button.tag) {
        case 15://头
        {
            _touchedPart =  @"头面部";
        }
            break;
        case 16://胸/背
        {
            _touchedPart = _isFront == YES ? @"胸部": @"背部";
        }
            break;
        case 17: case 18: case 20://左手
        {
            _touchedPart = @"四肢部";
        }
            break;
        case 19://臀
        {
            _touchedPart = _isFront == YES ? @"腹部": @"腰股部";
        }
            break;
            
        default:
            break;
    }
    
    [self rightBtnClick:nil];
    
}
//取消所有的身体部位的选中状态
-(void)cancelledSelected{
    [_headBtn setSelected:NO];
    [_leftArmBtn setSelected:NO];
    [_rightArmBtn setSelected:NO];
    [_chestBtn setSelected:NO];
    [_hipBtn setSelected:NO];
    [_legsBtn setSelected:NO];
}

# pragma mark - 隐藏弹出视图
-(void)hidePopView{
    _bottomView.hidden = YES;
    _showView.hidden = YES;
    for (UIView *view in _contentView.subviews) {
        [view removeFromSuperview];
    }
}

# pragma mark - 显示弹出视图
-(void)showPopView{
    _bottomView.hidden = NO;
    _showView.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-tableView Delegate相关
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _leftTableView) {
        return _leftDataArr.count;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        //判断是否是打开状态
        if ([[_sectionStatus objectAtIndex:section] boolValue] == YES) {
            return [[_leftDataArr objectAtIndex:section] count];
        }
    }else if (tableView == _rightTableView){
        if (_rightDataArr.count) {
            return _rightDataArr.count;
        }
        return 0;
    }else if (tableView == _popTableView){
        return _selectedArr.count;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
            return 45;
    }else if (tableView == _rightTableView){
        return 50;
    }else{
        return popCellHeight;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return 60.0f;
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        MyView *view = [[MyView alloc] initWithFrame:CGRectMake(0, 0, _leftTableView.bounds.size.width, 60)];
        view.backgroundColor = [Tools colorWithHexString:@"#ecf0f1"];
        [view addTarget:self action:@selector(sectionClick:)];
        view.tag = 1000+section;
        BOOL ret = [_sectionStatus[section] boolValue];
        UIImageView *image = [Tools creatImageViewWithFrame:CGRectMake(18, 13, 34.5, 34) imageName:ret == YES ?_sectionOpenImageArr[section]: _sectionClosedImageArr[section]];
        [view addSubview:image];
        UILabel *title = [Tools labelWith:_sectionDataArr[section] frame:CGRectMake(68, 13, 80, 34) textSize:16 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
        [view addSubview:title];
        UIImageView *line = [Tools creatImageViewWithFrame:CGRectMake(0, 59.5, _leftTableView.frame.size.width, 0.5) imageName:@"ICD10_leftGrayLine"];
        [view addSubview:line];
        
        return view ;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        static NSString *cellReusered = @"cell";
        NSArray *cellData = [_leftDataArr objectAtIndex:indexPath.section];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusered];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReusered];
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        cell.backgroundColor = [UIColor clearColor];
        UIView *back = [[UIView alloc] init];
        back.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = back;
        //        [back release];
        UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(48, 44, _leftTableView.frame.size.width-33.5, 1) imageName:@"ICD10_leftGrayLine"];
        [cell.contentView addSubview:lineView];
        UILabel *title = [Tools labelWith:[cellData objectAtIndex:indexPath.row] frame:CGRectMake(48, 0, 100, 45) textSize:15 textColor:[Tools colorWithHexString:@"#8f9292"] lines:1 aligment:NSTextAlignmentLeft];
        [cell.contentView addSubview:title];
        
        return cell;
    }else if (tableView == _rightTableView){
        static NSString *rightCellReusered = @"rightCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCellReusered];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCellReusered];
        }
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        cell.tag = 200+indexPath.row;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(0, 49, ScreenWidth/2+20, 1) imageName:@"ICD10_leftGrayLine"];
        [cell.contentView addSubview:lineView];
        SymptomModel *model = _rightDataArr[indexPath.row];
        UILabel *title = [Tools labelWith:model.symptom frame:CGRectMake(20, 0, ScreenWidth/2-20, 50) textSize:15 textColor:[Tools colorWithHexString:@"#8f9292"] lines:1 aligment:NSTextAlignmentLeft];
        [cell.contentView addSubview:title];
        if (model.fPrivate.boolValue == YES) {
            //显示 “对勾”
            [self addCheckWith:cell];
        }
        //回调，当点击cell时重新刷新cell
        __weak typeof(self) weakSelf = self;
        [self reloadCellWith:^(NSInteger row) {
            NSLog(@"row:------ > %ld",row);
            if (self->_rightDataArr.count) {
                for (int i=0; i<self->_rightDataArr.count; i++) {
                    if (row == i) {
                        SymptomModel *model2 = self->_rightDataArr[row];
                        if (self->_selectedCount <= 5) {
                            if (model2.fPrivate.boolValue == YES) {
                                //去除 “对勾”
                                model2.fPrivate = @NO;
                                if (self->_selectedCount>0) {
                                    self->_selectedCount--;
                                }
                                //在已经选择的症状中删除相应的model，并更新数据
                                NSLog(@"删除第%ld个",model2.currentIndex);
                                [self->_selectedArr removeObjectAtIndex:model2.currentIndex];
                                for (int j=(int)model2.currentIndex; j<self->_selectedArr.count; j++) {
                                    SymptomModel *model3 = self->_selectedArr[j];
                                    model3.currentIndex--;
                                    [self->_selectedArr replaceObjectAtIndex:j withObject:model3];
                                }
                                
                                [self removeCheckWith:cell];
                            }else{
                                //弹出提示框，去选择病症的轻重或者提示最多选择5个症状
                                for (UIView *view in self->_contentView.subviews) {
                                    [view removeFromSuperview];
                                }
                                [self->_contentView setFrame:CGRectMake(50, 0, ScreenWidth-100, 180)];
                                self->_contentView.center = self.view.center;
                                [self showPopView];
                                //显示 “对勾”
                                if (self->_selectedCount <5) {
                                    NSArray *arr = @[@"轻度",@"中度",@"重度"];
                                    for (int k=0; k<3; k++) {
                                        Mybutton *btn = [[Mybutton alloc] initWithFrame:CGRectMake(0, 60*k, self->_contentView.bounds.size.width, 60) row:row tag:500+k+row];
                                        [btn setTitle:arr[k] forState:UIControlStateNormal];
                                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                        btn.titleLabel.font = [UIFont systemFontOfSize:14];
                                        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                                        [self->_contentView addSubview:btn];
                                        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60*(k+1), self->_contentView.frame.size.width, 0.5)];
                                        line.image = [UIImage imageNamed:@"ICD10_leftGrayLine"];
                                        [self->_contentView addSubview:line];
                                        //                                        [line release];
                                    }
                                    
                                    [self addCheckWithBlock:^{
                                        [weakSelf addCheckWith:cell];
                                    }];
                                    
                                }else if (self->_selectedCount ==5){
                                    //弹出警告框  最多只能选择5个病症
                                    NSLog(@"最多选择5个   %@",self->_selectedArr);
                                    for (UIView *view in self->_contentView.subviews) {
                                        [view removeFromSuperview];
                                    }
                                    NSArray *alert = @[@"您最多只能选择五种症状",@"请酌情选择"];
                                    for (int k=0; k<alert.count; k++) {
                                        UILabel *label = [Tools labelWith:alert[k] frame:CGRectMake(0, 75+k*15, self->_contentView.frame.size.width, 15) textSize:14 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentCenter];
                                        [self->_contentView addSubview:label];
                                    }
                                    
                                }
                                
                            }
                            //将改变同步到数据源_rightDataArr和plist
                            [self->_rightDataArr replaceObjectAtIndex:row withObject:model2];
                            //读plist数据
                            NSString *home = NSHomeDirectory();
                            NSString *docPath2 = [home stringByAppendingPathComponent:@"Documents"];
                            NSString *filepath = [docPath2 stringByAppendingPathComponent:@"symptom.plist"];
                            NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filepath];
                            for (int i=0;i<data.count;i++) {
                                NSDictionary *dic = data[i];
                                if ([dic[@"symptom"] isEqualToString:model2.symptom]) {
                                    //改变plist中的fPrivate的状态
                                    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
                                    [mdic setValue:model2.fPrivate forKey:@"fPrivate"];
                                    [data replaceObjectAtIndex:i withObject:mdic];
                                    [data writeToFile:filepath atomically:YES];
                                }
                            }
                            [self->_rightTableView reloadData];
                            //NSLog(@"%ld",_selectedArr.count);
                        }else{
                            
                            
                        }
                        
                        
                        
                        
                        //SymptomModel *model = _rightDataArr[indexPath.row];
                    }
                }
            }
            
            
        }];
        
        return cell;
    }else if (tableView == _popTableView){
        static NSString *cellIdentifier = @"popCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        SymptomModel *selectedModel = _selectedArr[indexPath.row];
        NSString *iconImage = [[NSString alloc] init];
        for (int i=0;i<_sectionDataArr.count;i++) {
            NSString *str = _sectionDataArr[i];
            if ([str isEqualToString:selectedModel.personPart]) {
                iconImage = _sectionOpenImageArr[i];
                break;
            }
        }
//        UIImageView *icon = [Tools creatImageViewWithFrame:CGRectMake(25, (popCellHeight-26)/2.0, 26, 26) imageName:iconImage];
//        [cell.contentView addSubview:icon];
        UILabel *symptomName = [Tools labelWith:selectedModel.symptom frame:CGRectMake(25, (popCellHeight-40)/2.0, _contentView.frame.size.width-70-25-11-20-30, 40) textSize:14 textColor:[Tools colorWithHexString:@"#666666"] lines:1 aligment:NSTextAlignmentLeft];
        [cell.contentView addSubview:symptomName];
        UILabel *extentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_contentView.frame.size.width-25-11-20-30, (popCellHeight-30)/2.0, 30, 30)];
        extentLabel.font = [UIFont systemFontOfSize:14];
        NSLog(@"%@ --- %f",selectedModel.symptom,selectedModel.extent);

        CGFloat light= 0.70;
        CGFloat moderate = 1.0;
        CGFloat heavy = 1.20;
        if (selectedModel.extent == light) {
            extentLabel.text = @"轻度";
            extentLabel.textColor = [Tools colorWithHexString:@"#00bc00"];
            //extentLabel.textColor = [UIColor blackColor];
        }else if (selectedModel.extent == moderate){
            extentLabel.text = @"中度";
            extentLabel.textColor = [Tools colorWithHexString:@"#ff9a24"];
            //extentLabel.textColor = [UIColor blackColor];
        }else if (selectedModel.extent == heavy){
            extentLabel.text = @"重度";
            extentLabel.textColor = [Tools colorWithHexString:@"#ff7057"];
            //extentLabel.textColor = [UIColor blackColor];
        }
        
        
        [cell.contentView addSubview:extentLabel];
        //        [extentLabel release];
        cell.contentView.userInteractionEnabled = YES;
        UIImageView *deleteImage = [Tools creatImageViewWithFrame:CGRectMake(_contentView.frame.size.width-25-11-5, 9.5, 16, 21) imageName:@"ICD10_delete"];
        [cell.contentView addSubview:deleteImage];
        UIButton *deleteBtn = [Tools creatButtonWithFrame:CGRectMake(_contentView.frame.size.width-5-40, (popCellHeight-40)/2.0, 40, 40) target:self sel:@selector(deleteBtnClick:) tag:50+indexPath.row image:@"" title:nil];
        deleteBtn.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:deleteBtn];
        UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(25, popCellHeight-1, _contentView.frame.size.width-25-25, 1) imageName:@"ICD10_leftGrayLine"];
        [cell.contentView addSubview:lineView];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        NSArray *cellData = [_leftDataArr objectAtIndex:indexPath.section];
        NSString *currentTitle = cellData[indexPath.row];
        //读plist数据
        NSString *home = NSHomeDirectory();
        NSString *docPath2 = [home stringByAppendingPathComponent:@"Documents"];
        NSString *filepath = [docPath2 stringByAppendingPathComponent:@"symptom.plist"];
        NSArray *data = [NSArray arrayWithContentsOfFile:filepath];
        //        NSLog(@"plist数据:\n%@", data);
        if (_rightDataArr.count) {
            [_rightDataArr removeAllObjects];
        }
        for (NSDictionary *dic in data) {
            if ([dic[@"part"] isEqualToString:currentTitle]) {
                SymptomModel *model = [[SymptomModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                //model.fPrivate = @NO;
                [self.rightDataArr addObject:model];
                //[model release];
            }
        }
        [self.rightTableView reloadData];
    }else if (tableView == _rightTableView){
        //利用block回调
        NSLog(@"点击第%ld个cell",indexPath.row);
        self.reloadBlock(indexPath.row);
        
    }
}

#pragma mark - 点击轻度、中度、重度
-(void)btnClick:(Mybutton *)button{
    NSInteger row = button.row;
    SymptomModel *model2 = _rightDataArr[row];
    model2.fPrivate = @YES;
    if (_selectedArr.count) {
        model2.currentIndex = _selectedCount;
    }else{
        model2.currentIndex = 0;
    }
    switch (button.tag-500-button.row) {
        case 0:
        {
            model2.extent = 0.70;
        }
            break;
        case 1:
        {
            model2.extent = 1.0;
        }
            break;
        case 2:
        {
            model2.extent = 1.20;
        }
            break;
            
        default:
            break;
    }
    [_selectedArr addObject:model2];
    NSLog(@"共选择了%ld个病症",_selectedArr.count);
    _selectedCount++;
    
    
    //将改变同步到数据源_rightDataArr和plist
    [_rightDataArr replaceObjectAtIndex:row withObject:model2];
    //读plist数据
    NSString *home = NSHomeDirectory();
    NSString *docPath2 = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filepath = [docPath2 stringByAppendingPathComponent:@"symptom.plist"];
    NSMutableArray *data = [NSMutableArray arrayWithContentsOfFile:filepath];
    for (int i=0;i<data.count;i++) {
        NSDictionary *dic = data[i];
        if ([dic[@"symptom"] isEqualToString:model2.symptom]) {
            //改变plist中的fPrivate的状态
            NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:dic];
            [mdic setValue:model2.fPrivate forKey:@"fPrivate"];
            [data replaceObjectAtIndex:i withObject:mdic];
            [data writeToFile:filepath atomically:YES];
        }
    }
    [_rightTableView reloadData];
    
    
    
    //block回调
    self.checkBlock();
    for (UIView *view in _contentView.subviews) {
        [view removeFromSuperview];
    }
    [self hidePopView];
}
#pragma mark-添加、去除“对勾”
-(void)addCheckWith:(UITableViewCell *)cell{
    UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-14-20.5, 14.75, 20.5, 20.5)];
    check.image = [UIImage imageNamed:@"ICD10_selected"];
    [cell.contentView addSubview:check];
    //   [check release];
}
-(void)removeCheckWith:(UITableViewCell *)cell{
    for (UIImageView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark-点击组
-(void)sectionClick:(MyView *)view{
    BOOL ret = [[_sectionStatus objectAtIndex:view.tag-1000] boolValue];
    if (ret == YES) {
        [_sectionStatus replaceObjectAtIndex:view.tag-1000 withObject:@NO];
    }else{
        [_sectionStatus replaceObjectAtIndex:view.tag-1000 withObject:@YES];
    }
    [_leftTableView reloadData];
}
#pragma mark-点击已选症状
-(void)selectedBtnClick:(UIButton *)button{
    NSLog(@"点击已选症状按钮");
    [_contentView setFrame:CGRectMake(0, 0, ScreenWidth-80, _selectedArr.count*popCellHeight+30+60)];
    _contentView.center = self.view.center;
    for (UIView *view in _contentView.subviews) {
        [view removeFromSuperview];
    }
    //_contentView.image = [UIImage imageNamed:@"ICD10_popSelectedBack"];
    [self showPopView];
    [_popTableView setFrame:CGRectMake(0, 30, _contentView.frame.size.width, _contentView.frame.size.height-60-30)];
    [_contentView addSubview:_popTableView];
    [_popTableView reloadData];
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _contentView.frame.size.width, 30)];
    view.backgroundColor = [Tools colorWithHexString:@"#f2f1ef"];
    UIImageView *diseaseIcon = [Tools creatImageViewWithFrame:CGRectMake(20, 5, 17.5, 18) imageName:@"ICD10_07_症"];
    [view addSubview:diseaseIcon];
    UILabel *symptomLabel = [Tools labelWith:@"已选症状" frame:CGRectMake(48, 5, 120, 18) textSize:13 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [view addSubview:symptomLabel];
    [_contentView addSubview:view];
    //    [view release];
    
    UIButton *backBtn = [Tools creatButtonWithFrame:CGRectMake(_contentView.frame.size.width/4-43.25, _contentView.frame.size.height-46, 86.5, 32) target:self sel:@selector(backBtnClick:) tag:60 image:@"ICD10_back" title:nil];
    [_contentView addSubview:backBtn];
    if(_selectedArr.count==0){
        backBtn.frame = CGRectMake((_contentView.width-86.5)/2.0, _contentView.height-46, 86.5, 32);
    }else{
        UIButton *commitBtn = [Tools creatButtonWithFrame:CGRectMake(_contentView.frame.size.width/4*3-43.25, _contentView.frame.size.height-46, 86.5, 32) target:self sel:@selector(commitBtnClick:) tag:61 image:@"ICD10_commit" title:nil];
        [_contentView addSubview:commitBtn];
    }
    
}

#pragma mark-点击删除按钮
-(void)deleteBtnClick:(UIButton *)button{
    if (_selectedArr.count) {
        SymptomModel *model = _selectedArr[button.tag-50];
        [_selectedArr removeObjectAtIndex:button.tag-50];
        [_popTableView reloadData];
        //同时相应的改变_rightTableView状态
        model.fPrivate = @NO;
        model.extent = 0;
        if (_selectedCount>0) {
            _selectedCount--;
        }
        //将改变同步到数据源_rightDataArr和plist
        for (NSInteger i=0; i<_rightDataArr.count; i++) {
            SymptomModel *rightModel = _rightDataArr[i];
            if ([rightModel.symptom isEqualToString:model.symptom]) {
                [_rightDataArr replaceObjectAtIndex:i withObject:model];
            }
            break;
        }
        
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
        [_rightTableView reloadData];
    }
    
}
#pragma mark-点击返回按钮
-(void)backBtnClick:(UIButton *)button{
    [self hidePopView];
}
#pragma mark-点击提交按钮
-(void)commitBtnClick:(UIButton *)button{
    [self hidePopView];
    OrganDiseaseListViewController *diseaseList = [[OrganDiseaseListViewController alloc] init];
    diseaseList.upData = _selectedArr;
    diseaseList.sex = _sex;
    [self.navigationController pushViewController:diseaseList animated:YES];
}

#pragma mark- block方法的实现
-(void)reloadCellWith:(reloadCellBlock)block{
    self.reloadBlock = [block copy];
}
-(void)addCheckWithBlock:(addCheckBlock)block{
    self.checkBlock = [block copy];
}

@end
