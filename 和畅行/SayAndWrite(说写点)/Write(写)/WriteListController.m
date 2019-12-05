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
#import "WriteleftTableViewCell.h"

#define popCellHeight Adapter(50)
#define Adapterbody(d) (ISPaid ? Adapter(d)*0.8 : Adapter(d))

@interface WriteListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSIndexPath *myIndexPath;
@property (nonatomic,strong)UIButton *backButton;
@property (nonatomic,strong)UILabel *choseLabel;
@property (nonatomic,assign)BOOL isPush;
@end

@implementation WriteListController

- (void)dealloc
{
    NSLog(@"dealloc");
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isPush = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!self.isPush) {
        self.endTimeStr = [GlobalCommon getCurrentTimes];
        [GlobalCommon pageDurationWithpageId:@"7" withstartTime:self.startTimeStr withendTime:self.endTimeStr];
    }
}
- (void)goBack:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = ModuleZW(@"疾病检测");
    self.startTimeStr = [GlobalCommon getCurrentTimes];
    
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
    
    _contentView = [[UIImageView alloc] init];
    _contentView.image = [UIImage imageNamed:@"popback"];
    _contentView.userInteractionEnabled = YES;
    [_showView addSubview:_contentView];
    
    _bottomView.hidden = YES;
    _showView.hidden = YES;
}

#pragma mark-构建界面
-(void)initWithController{
    _touchedPart = [[NSString alloc] init];
    _leftButton = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2 - ScreenWidth/4, kNavBarHeight+Adapter(10), ScreenWidth/2, Adapter(34)) target:self sel:@selector(leftBtnClick:) tag:11 image:nil title:ModuleZW(@"人体图解")];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _leftButton.backgroundColor = UIColorFromHex(0XFFA200);
    [_leftButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    _leftButton.layer.cornerRadius = Adapter(17);
    _leftButton.layer.masksToBounds = YES;
    [self.view addSubview:_leftButton];
    
    _rightButton = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth - ScreenWidth/6 - Adapter(20), kNavBarHeight+Adapter(10), ScreenWidth/6,Adapter(34)) target:self sel:@selector(rightBtnClick:) tag:12 image:nil title:ModuleZW(@"症状列表")];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _rightButton.backgroundColor = UIColorFromHex(0XC3C3C3);
    [_rightButton.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    _rightButton.layer.cornerRadius = Adapter(17);;
    _rightButton.layer.masksToBounds = YES;
    [self.view addSubview:_rightButton];
    
    
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
    
    UIButton *sexButton = [Tools creatButtonWithFrame:CGRectMake(Adapter(25), Adapter(28), Adapter(74), Adapter(35)) target:self sel:@selector(sexBtnClick:) tag:13 image:ModuleZW(@"ICD10_man") title:nil];
    _sex = 0;
    [_leftView addSubview:sexButton];
    UIButton *sideButton = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth-Adapter(90), _leftView.height-Adapter(83) -kTabBarHeight, Adapter(56.5), Adapter(53)) target:self sel:@selector(sideBtnClick:) tag:14 image:@"" title:nil];
    [_leftView addSubview:sideButton];
    _isFront = YES;
    if (_isFront) {
        [sideButton setImage:[UIImage imageNamed:ModuleZW(@"ICD10_19_front")] forState:UIControlStateNormal];
    }
    
    //人体图
    _headBtn = [Tools buttonWithFrame:CGRectMake(ScreenWidth/2-Adapterbody(30.5), Adapterbody(30), Adapterbody(61), Adapterbody(94)) title:nil nomalImage:@"" selectedImage:nil textSize:0 nomalColor:nil selectedCocor:nil tag:15 target:self sel:@selector(bodyClick:)];
    [_leftView addSubview:_headBtn];
    _chestBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-Adapterbody(41), Adapterbody(124), Adapterbody(82), Adapterbody(96)) target:self sel:@selector(bodyClick:) tag:16 image:@"" title:nil];
    [_leftView addSubview:_chestBtn];
    _leftArmBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-Adapterbody(100.5), Adapterbody(124), Adapterbody(59.5), Adapterbody(187.5)) target:self sel:@selector(bodyClick:) tag:17 image:@"" title:nil];
    [_leftView addSubview:_leftArmBtn];
    _rightArmBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2+Adapterbody(41), Adapterbody(124), Adapterbody(59.5), Adapterbody(187.5)) target:self sel:@selector(bodyClick:) tag:18 image:@"" title:nil];
    [_leftView addSubview:_rightArmBtn];
    _hipBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-Adapterbody(41), Adapterbody(220), Adapterbody(82), Adapterbody(60.5)) target:self sel:@selector(bodyClick:) tag:19 image:@"" title:nil];
    [_leftView addSubview:_hipBtn];
    
    _legsBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth/2-Adapterbody(41), Adapterbody(280.5), Adapterbody(82), ScreenHeight == Adapterbody(568)? Adapterbody(180): Adapterbody(201.5)) target:self sel:@selector(bodyClick:) tag:20 image:@"" title:nil];
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
    
   
    UILabel *symptomLabel = [Tools labelWith:ModuleZW(@"选择症状") frame:CGRectMake(Adapter(20), 0, Adapter(200), Adapter(46)) textSize:16 textColor:RGB_TextGray lines:1 aligment:NSTextAlignmentLeft];
    symptomLabel.backgroundColor = [UIColor clearColor];
    [_rightView addSubview:symptomLabel];
    [self createDataSource];
    _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Adapter(46), Adapter(110), _leftView.bounds.size.height-Adapter(102)) style:UITableViewStylePlain];
    _leftTableView.backgroundColor = RGB_AppWhite;
    _leftTableView.delegate = self;
    _leftTableView.dataSource = self;
    _leftTableView.showsVerticalScrollIndicator = NO;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _leftTableView.estimatedRowHeight = 100;
    _leftTableView.tableFooterView = [[UIView alloc] init];
    [_rightView addSubview:_leftTableView];
    
    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    backButton.backgroundColor = UIColorFromHex(0X737373);
    backButton.frame = CGRectMake(Adapter(20), ScreenHeight-Adapter(kTabBarHeight) - Adapter(6), ScreenWidth - Adapter(40), Adapter(40));
    backButton.layer.cornerRadius = backButton.height/2;
    backButton.layer.masksToBounds = YES;
    backButton.hidden = YES;
    [[backButton rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if(self->_selectedArr.count <1){
            [GlobalCommon showMessage:ModuleZW(@"您还未选择症状") duration:2.0];

        }else{
            x.selected = !x.selected;
            if(x.selected){
                [self haveChoes];

            }else{
                self-> _bottomView.hidden = YES;
                self->_showView.hidden = YES;
                for (UIView *view in  self->_contentView.subviews) {
                    [view removeFromSuperview];
                }
            }

        }
    }];
    [self.view addSubview:backButton];
    _backButton = backButton;
    
    
    UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(Adapter(15), Adapter(5), Adapter(30), Adapter(30))];
    leftImageView.image = [UIImage imageNamed:@"renyuandingwei"];
    [backButton addSubview:leftImageView];
    UILabel *choseLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(50), 0, ScreenWidth - Adapter(140), Adapter(40))];
    choseLabel.text = ModuleZW(@"已选症状0/5");
    choseLabel.textColor = UIColorFromHex(0Xf9a943);
    choseLabel.font = [UIFont systemFontOfSize:14];
    [backButton addSubview:choseLabel];
    _choseLabel = choseLabel;
    
    UIButton *selectedBtn = [Tools creatButtonWithFrame:CGRectMake(backButton.width-Adapter(90), 0, Adapter(90), Adapter(40)) target:self sel:@selector(commitBtnClick:) tag:22 image:nil title:ModuleZW(@"下一步")];
    selectedBtn.backgroundColor = RGB_ButtonBlue;
    [backButton addSubview:selectedBtn];
    
}

-(void)selectedBtnClick{
    
}



-(void)haveChoes {
    NSLog(@"点击已选症状按钮");
    [_contentView setFrame:CGRectMake(0, ScreenHeight - _selectedArr.count*popCellHeight - kTabBarHeight-Adapter(56) , ScreenWidth, _selectedArr.count*popCellHeight+kTabBarHeight + Adapter(56))];
    for (UIView *view in _contentView.subviews) {
        [view removeFromSuperview];
    }
    [self showPopView];
    [_popTableView setFrame:CGRectMake(0, Adapter(30), _contentView.frame.size.width, _contentView.frame.size.height-Adapter(90))];
    [_contentView addSubview:_popTableView];
    [_popTableView reloadData];
    

    UILabel *symptomLabel = [Tools labelWith:ModuleZW(@"已选症状(最多5种)") frame:CGRectMake(Adapter(30), 0, ScreenWidth - Adapter(60), Adapter(30)) textSize:14 textColor:UIColorFromHex(0X909095) lines:1 aligment:NSTextAlignmentLeft];
    [_contentView addSubview:symptomLabel];
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, symptomLabel.height -1, symptomLabel.width, 1)];
    lineview.backgroundColor = RGB(211, 217, 215);
    [symptomLabel addSubview:lineview];
    
    [self.view addSubview:_backButton];
}

#pragma mark-左tableView的数据以及右tableView、popTableView的初始化
-(void)createDataSource{
    
    NSArray *section = @[ModuleZW(@"全身"),ModuleZW(@"头面部"),ModuleZW(@"胸部"),ModuleZW(@"腹部"),ModuleZW(@"四肢部"),ModuleZW(@"背部"),ModuleZW(@"腰股部"),ModuleZW(@"病因")];
    _sectionDataArr = [[NSMutableArray alloc] initWithArray:section];
    NSArray *openImages = @[@"ICD10_body_open",@"ICD10_head_open",@"ICD10_chest_open",@"ICD10_stomach_open",@"ICD10_limps_open",@"ICD10_back_open",@"ICD10_waist_open",@"ICD10_reason_open"];
    _sectionOpenImageArr = [[NSMutableArray alloc] initWithArray:openImages];
  
    _sectionStatus = [[NSMutableArray alloc] init];
    for (int i=0; i<section.count; i++) {
        [_sectionStatus addObject:@NO];
    }
    
    NSArray *arr6 = @[ModuleZW(@"背部")];
    NSArray *arr8 = @[ModuleZW(@"病因")];
    NSArray *arr4 = @[ModuleZW(@"腹部"),ModuleZW(@"生殖部"),ModuleZW(@"生殖器"),ModuleZW(@"小便")];
    NSArray *arr1 = @[ModuleZW(@"出汗"),ModuleZW(@"出血"),ModuleZW(@"精神状态"),ModuleZW(@"皮肤"),ModuleZW(@"身体"),ModuleZW(@"食欲"),ModuleZW(@"睡眠"),ModuleZW(@"体温"),ModuleZW(@"形体"),ModuleZW(@"肿块")];
    NSArray *arr5 = @[ModuleZW(@"关节"),ModuleZW(@"脉"),ModuleZW(@"四肢"),ModuleZW(@"指/趾/掌")];
    NSArray *arr2 = @[ModuleZW(@"鼻"),ModuleZW(@"耳"),ModuleZW(@"呼吸"),ModuleZW(@"颈"),ModuleZW(@"咳嗽"),ModuleZW(@"口腔"),ModuleZW(@"面部"),ModuleZW(@"面色"),ModuleZW(@"呕吐"),ModuleZW(@"舌"),ModuleZW(@"痰"),ModuleZW(@"头"),ModuleZW(@"头发"),ModuleZW(@"牙"),ModuleZW(@"咽喉"),ModuleZW(@"眼"),ModuleZW(@"声音")];
    NSArray *arr3 = @[ModuleZW(@"乳房"),ModuleZW(@"胁肋"),ModuleZW(@"心脏"),ModuleZW(@"胸部")];
    NSArray *arr7 = @[ModuleZW(@"大便"),ModuleZW(@"肛门"),ModuleZW(@"腰")];
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
    _popTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Adapter(30), _contentView.frame.size.width, _contentView.frame.size.height-Adapter(80)) style:UITableViewStylePlain];
    _popTableView.delegate = self;
    _popTableView.dataSource = self;
    _popTableView.showsVerticalScrollIndicator = NO;
    _popTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark-创建rightTableView
-(void)createRightTableView{
    

    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(Adapter(120), Adapter(46), ScreenWidth - Adapter(110) , _leftView.bounds.size.height-Adapter(102)) style:UITableViewStylePlain];
    _rightTableView.delegate = self;
    _rightTableView.dataSource = self;
    _rightTableView.backgroundColor = [UIColor whiteColor];
    _rightTableView.showsVerticalScrollIndicator = NO;
    _rightTableView.tableFooterView = [[UIView alloc] init];
    _rightTableView.estimatedRowHeight = 100;
    [self insertSublayerWithImageView:_rightTableView with:_rightView];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_rightView addSubview:_rightTableView];
    
}

#pragma mark-点击人体图解按钮
-(void)leftBtnClick:(UIButton *)button{
    
  
    if (_leftButton.width == ScreenWidth/6){
        [UIView animateWithDuration:0.3 animations:^{
            self->_leftButton.width = ScreenWidth/2;
            self->_leftButton.left = ScreenWidth/2 - ScreenWidth/4;
            self->_leftButton.backgroundColor = UIColorFromHex(0XFFA200);
            self->_rightButton.left = ScreenWidth - ScreenWidth/6 - Adapter(20);
            self->_rightButton.width =ScreenWidth/6;
            self->_rightButton.backgroundColor = UIColorFromHex(0XC3C3C3);
        }];
    }
    _leftView.hidden = NO;
    _rightView.hidden = YES;
    [_leftButton setSelected:YES];
    [_rightButton setSelected:NO];
    _leftButton.userInteractionEnabled = NO;
    _rightButton.userInteractionEnabled = YES;
    _backButton.hidden = YES;
    [self reloadLeftView];
  
}
#pragma mark-点击症状列表按钮
-(void)rightBtnClick:(UIButton *)button{

    if (_rightButton.width == ScreenWidth/6){
        [UIView animateWithDuration:0.3 animations:^{
            self->_rightButton.left = ScreenWidth/2 - ScreenWidth/4;
            self->_rightButton.width =ScreenWidth/2;
            self->_rightButton.backgroundColor = UIColorFromHex(0XFFA200);
            self->_leftButton.width = ScreenWidth/6;
            self->_leftButton.left = Adapter(20);
            self->_leftButton.backgroundColor = UIColorFromHex(0XC3C3C3);
        }];
    }
    _backButton.hidden = NO;
    _leftView.hidden = YES;
    _rightView.hidden = NO;
    [_rightButton setSelected:YES];
    [_leftButton setSelected:NO];
    _rightButton.userInteractionEnabled = NO;
    _leftButton.userInteractionEnabled = YES;
    
    //判断是不是点击身体的某部位而跳转过来的
    if (_isBodyTouched) {
        for (int i=0; i<_sectionDataArr.count; i++) {
            if ([_sectionDataArr[i] isEqualToString:_touchedPart]) {
                [_sectionStatus replaceObjectAtIndex:i withObject:@YES];
                _myIndexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            }else{
                [_sectionStatus replaceObjectAtIndex:i withObject:@NO];
            }
        }
        [_leftTableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftTableView selectRowAtIndexPath:self->_myIndexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
            [self tableView:self.leftTableView didSelectRowAtIndexPath:self->_myIndexPath];
        });
    }else{
        _myIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_sectionStatus replaceObjectAtIndex:0 withObject:@YES];
        [_leftTableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
            [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        });

    }
}

#pragma mark-点击性别按钮
-(void)sexBtnClick:(UIButton *)button{
    if (_sex == 0) {
        _sex = 1;
        [button setImage:[UIImage imageNamed:ModuleZW(@"ICD10_woman")] forState:UIControlStateNormal];
    }else{
        _sex = 0;
        [button setImage:[UIImage imageNamed:ModuleZW(@"ICD10_man")] forState:UIControlStateNormal];
    }
    [self reloadLeftView];
    
    [self cancelledSelected];
}
#pragma mark- 点击正反面
-(void)sideBtnClick:(UIButton *)button{
    if (_isFront) {
        _isFront = NO;
        [button setImage:[UIImage imageNamed:ModuleZW(@"2_19_back")] forState:UIControlStateNormal];
    }else{
        _isFront = YES;
        [button setImage:[UIImage imageNamed:ModuleZW(@"ICD10_19_front")] forState:UIControlStateNormal];
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
            _touchedPart =  ModuleZW(@"头面部");
        }
            break;
        case 16://胸/背
        {
            _touchedPart = _isFront == YES ? ModuleZW(@"胸部"):ModuleZW( @"背部");
        }
            break;
        case 17: case 18: case 20://左手
        {
            _touchedPart = ModuleZW(@"四肢部");
        }
            break;
        case 19://臀
        {
            _touchedPart = _isFront == YES ? ModuleZW(@"腹部"):ModuleZW(@"腰股部");
        }
            break;
            
        default:
            break;
    }
    
    [self rightBtnClick:nil];
    
}
# pragma mark - 取消所有的身体部位的选中状态
-(void)cancelledSelected{
    [_headBtn setSelected:NO];
    _headBtn.userInteractionEnabled = YES;
    [_leftArmBtn setSelected:NO];
    _leftArmBtn.userInteractionEnabled = YES;
    [_rightArmBtn setSelected:NO];
    _rightArmBtn.userInteractionEnabled = YES;
    [_chestBtn setSelected:NO];
    _chestBtn.userInteractionEnabled = YES;
    [_hipBtn setSelected:NO];
    _hipBtn.userInteractionEnabled = YES;
    [_legsBtn setSelected:NO];
    _legsBtn.userInteractionEnabled = YES;
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
//        NSArray *cellData = [_leftDataArr objectAtIndex:indexPath.section];
//        NSString *str = ModuleZW([cellData objectAtIndex:indexPath.row]);
//        CGRect textRect = [str boundingRectWithSize:CGSizeMake( 70, MAXFLOAT)
//                                                     options:NSStringDrawingUsesLineFragmentOrigin
//                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
//                                                     context:nil];
//        return textRect.size.height + 20;
        return UITableViewAutomaticDimension;
    }else if (tableView == _rightTableView){
        return UITableViewAutomaticDimension;
    }else{
        return popCellHeight;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        return Adapter(65);
    }
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _leftTableView) {
        MyView *view = [[MyView alloc] initWithFrame:CGRectMake(Adapter(2.5), Adapter(2.5), Adapter(105), Adapter(60))];
        view.backgroundColor = [UIColor whiteColor];
        [view addTarget:self action:@selector(sectionClick:)];
        [self insertSublayerWithImageView:view with:view];
        view.tag = 1000+section;
        BOOL ret = [_sectionStatus[section] boolValue];
        UILabel *title = [Tools labelWith:_sectionDataArr[section] frame:CGRectMake(Adapter(5), Adapter(5), Adapter(95), Adapter(50)) textSize:14 textColor:RGB_TextGray lines:2 aligment:NSTextAlignmentCenter];
        
        if(ret == NO){
            title.backgroundColor = [UIColor clearColor];
            title.textColor = RGB_TextGray;
            title.layer.cornerRadius = 0;
            title.layer.masksToBounds = NO;
        }else{
            title.textColor = [UIColor clearColor];
            title.backgroundColor = RGB_TextOrange;
            title.layer.cornerRadius = title.height/2;
            title.layer.masksToBounds = YES;
        }
        if(_myIndexPath.section == section){
            title.textColor = [UIColor whiteColor];
            title.backgroundColor = RGB_TextOrange;
            title.layer.cornerRadius = title.height/2;
            title.layer.masksToBounds = YES;
        }
     
        [view addSubview:title];
        view.isClick = ret;
        return view ;
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        static NSString *cellReusered = @"cell";
        NSArray *cellData = [_leftDataArr objectAtIndex:indexPath.section];
        WriteleftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReusered];
        if (cell == nil) {
            cell = [[WriteleftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReusered];
        }
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
   
       
        int i = 0;
        if(_selectedArr.count > 0){
            for (SymptomModel *model in _selectedArr) {
                if ([ModuleZW([cellData objectAtIndex:indexPath.row])  isEqualToString:ModuleZW(model.part)]) {
                    if([model.fPrivate  isEqual: @1] ){
                        i++;
                    }
                }
            }
        }

        cell.typeLabel.text = ModuleZW([cellData objectAtIndex:indexPath.row]);
        cell.typeLabel.frame = CGRectMake(Adapter(10), Adapter(10),Adapter(70), cell.height - Adapter(20));
        if(i>0){
            cell.numberLabel.hidden = NO;
            cell.numberLabel.text = [NSString stringWithFormat:@"%d",i];

        }else{
            cell.numberLabel.hidden = YES;
        }
        
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
        UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(0, Adapter(49), ScreenWidth - Adapter(100), 1) imageName:@"ICD10_leftGrayLine"];
        [cell.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_bottom).offset(1);
            make.height.mas_equalTo(1);
            make.leading.equalTo(cell.contentView.mas_leading);
            make.trailing.equalTo(cell.contentView.mas_trailing);
        }];
        
        SymptomModel *model = _rightDataArr[indexPath.row];
        UILabel *title = [Tools labelWith:ModuleZW(model.symptom) frame:CGRectMake(Adapter(20), 0, ScreenWidth/2-Adapter(20), Adapter(50)) textSize:15 textColor:[Tools colorWithHexString:@"#8f9292"] lines:0 aligment:NSTextAlignmentLeft];
        [cell.contentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView.mas_top).offset(Adapter(3));
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(Adapter(-3));
            make.leading.equalTo(cell.contentView.mas_leading).offset(Adapter(10));
            make.trailing.equalTo(cell.contentView.mas_trailing).offset(Adapter(-40));
            make.height.greaterThanOrEqualTo(@(Adapter(45)));
        }];
        if (model.fPrivate.boolValue == YES) {
            //显示 “对勾”
            [self addCheckWith:cell];
        }
        //回调，当点击cell时重新刷新cell
        __weak typeof(self) weakSelf = self;
        [self reloadCellWith:^(NSInteger row) {
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
                                
                                self->_choseLabel.text = [NSString stringWithFormat:ModuleZW(@"已选症状%ld/5"),(long)self->_selectedCount];
                                //在已经选择的症状中删除相应的model，并更新数据
                                for (int i = 0; i < self->_selectedArr.count; i++) {
                                    SymptomModel *model =  self->_selectedArr[i];
                                    if ([model.symptom  isEqualToString:model2.symptom]) {
                                        [self->_selectedArr removeObject:model];
                                    }
                                }
                                for (int j=(int)model2.currentIndex; j<self->_selectedArr.count; j++) {
                                    SymptomModel *model3 = self->_selectedArr[j];
//                                    model3.currentIndex--;
                                    [self->_selectedArr replaceObjectAtIndex:j withObject:model3];
                                }
                                
                                [self removeCheckWith:cell];
                                [self->_leftTableView reloadData];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self->_leftTableView selectRowAtIndexPath:self.myIndexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
                                });

                            }else{
                                //弹出提示框，去选择病症的轻重或者提示最多选择5个症状
                                for (UIView *view in self->_contentView.subviews) {
                                    [view removeFromSuperview];
                                }
                                [self->_contentView setFrame:CGRectMake(Adapter(50), 0, ScreenWidth-Adapter(100), Adapter(180))];
                                self->_contentView.center = self.view.center;
                                [self showPopView];
                                //显示 “对勾”
                                if (self->_selectedCount <5) {
                                    NSArray *arr = @[ModuleZW(@"轻度"),ModuleZW(@"中度"),ModuleZW(@"重度")];
                                    for (int k=0; k<3; k++) {
                                        Mybutton *btn = [[Mybutton alloc] initWithFrame:CGRectMake(0, Adapter(60)*k, self->_contentView.bounds.size.width, Adapter(60)) row:row tag:500+k+row];
                                        [btn setTitle:ModuleZW(arr[k]) forState:UIControlStateNormal];
                                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                                        btn.titleLabel.font = [UIFont systemFontOfSize:14];
                                        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                                        [self->_contentView addSubview:btn];
                                        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, Adapter(60)*(k+1), self->_contentView.frame.size.width, 0.5)];
                                        line.image = [UIImage imageNamed:@"ICD10_leftGrayLine"];
                                        [self->_contentView addSubview:line];
                                        //                                        [line release];
                                    }
                                    
                                    [self addCheckWithBlock:^{
                                        [weakSelf addCheckWith:cell];
                                    }];
                                    
                                }else if (self->_selectedCount ==5){
                                    //弹出警告框  最多只能选择5个病症
                                    NSLog(@"%@   %@",ModuleZW(@"最多选择5个"),self->_selectedArr);
                                    for (UIView *view in self->_contentView.subviews) {
                                        [view removeFromSuperview];
                                    }
                                    NSArray *alert = @[ModuleZW(@"您最多只能选择五种症状")];
                                    for (int k=0; k<alert.count; k++) {
                                        UILabel *label = [Tools labelWith:ModuleZW(alert[k]) frame:CGRectMake(0, Adapter(75)+k*15, self->_contentView.frame.size.width, Adapter(15)) textSize:14 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentCenter];
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
                        }
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

        UILabel *symptomName = [Tools labelWith:ModuleZW(selectedModel.symptom) frame:CGRectMake(Adapter(30), 0, (ScreenWidth - Adapter(60))/2, Adapter(50)) textSize:16 textColor:[UIColor blackColor] lines:2 aligment:NSTextAlignmentLeft];
        [cell.contentView addSubview:symptomName];
        UILabel *extentLabel = [[UILabel alloc] initWithFrame:CGRectMake(symptomName.right, 0, (ScreenWidth - Adapter(60))/4, Adapter(50))];
        extentLabel.font = [UIFont systemFontOfSize:14];

        CGFloat light= 0.70;
        CGFloat moderate = 1.0;
        CGFloat heavy = 1.50;
        if (selectedModel.extent == light) {
            extentLabel.text = ModuleZW(@"轻度");
            extentLabel.textColor = [Tools colorWithHexString:@"#75d468"];
            //extentLabel.textColor = [UIColor blackColor];
        }else if (selectedModel.extent == moderate){
            extentLabel.text = ModuleZW(@"中度");
            extentLabel.textColor = RGB_TextOrange;
            //extentLabel.textColor = [UIColor blackColor];
        }else if (selectedModel.extent == heavy){
            extentLabel.text = ModuleZW(@"重度");
            extentLabel.textColor = [Tools colorWithHexString:@"#D81E06"];
            //extentLabel.textColor = [UIColor blackColor];
        }
        
        
        [cell.contentView addSubview:extentLabel];
        //        [extentLabel release];
        cell.contentView.userInteractionEnabled = YES;
        UIImageView *deleteImage = [Tools creatImageViewWithFrame:CGRectMake(_contentView.frame.size.width-Adapter(41), Adapter(14.5), Adapter(20), Adapter(21)) imageName:@"ICD10_delete"];
        [cell.contentView addSubview:deleteImage];
        UIButton *deleteBtn = [Tools creatButtonWithFrame:CGRectMake(_contentView.frame.size.width-Adapter(45), (popCellHeight-Adapter(40))/2.0, Adapter(40), Adapter(40)) target:self sel:@selector(deleteBtnClick:) tag:50+indexPath.row image:@"" title:nil];
        deleteBtn.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:deleteBtn];
        UIImageView *lineView = [Tools creatImageViewWithFrame:CGRectMake(Adapter(25), popCellHeight-1, _contentView.frame.size.width-Adapter(50), 1) imageName:@"ICD10_leftGrayLine"];
        [cell.contentView addSubview:lineView];
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _leftTableView) {
        NSArray *cellData = [_leftDataArr objectAtIndex:indexPath.section];
        NSString *currentTitle = cellData[indexPath.row];
        self.myIndexPath = indexPath;
//        WriteleftTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//         [cell isClick:YES];
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
            if ([ModuleZW(dic[@"part"])  isEqualToString:currentTitle]) {
                SymptomModel *model = [[SymptomModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                //model.fPrivate = @NO;
                if([model.sexType intValue] == 2){
                    [_rightDataArr addObject:model];
                }else{
                    if([model.sexType intValue] == _sex){
                        [_rightDataArr addObject:model];
                    }
                }
            }
        }
        [self.rightTableView reloadData];
    }else if (tableView == _rightTableView){
        //利用block回调
        self.reloadBlock(indexPath.row);
        
    }
}

#pragma mark - 点击轻度、中度、重度
-(void)btnClick:(Mybutton *)button{
    NSInteger row = button.row;
    SymptomModel *model2 = _rightDataArr[row];
    model2.fPrivate = @YES;
    if (_selectedArr.count) {
        model2.currentIndex = button.row;
    }else{
        model2.currentIndex = 0;
    }
    NSLog(@"--------%ld",(long)model2.currentIndex);
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
            model2.extent = 1.50;
        }
            break;
            
        default:
            break;
    }
    [_selectedArr addObject:model2];
    [_leftTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.leftTableView selectRowAtIndexPath:self.myIndexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
    });
    NSLog(@"共选择了%ld个病症",_selectedArr.count);
    _selectedCount++;
    _choseLabel.text = [NSString stringWithFormat:ModuleZW(@"已选症状%ld/5"),(long)_selectedCount];
    
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
    UIImageView *check = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width-Adapter(34.5), Adapter(14.75), Adapter(20.5), Adapter(20.5))];
    check.image = [UIImage imageNamed:@"空心圆icon"];
    [cell.contentView addSubview:check];
    [check mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView.mas_top).offset(Adapter(14.75));
        make.trailing.equalTo(cell.contentView.mas_trailing).offset(Adapter(-30));
        make.size.mas_equalTo(CGSizeMake(Adapter(20.5), Adapter(20.5)));
    }];
}
-(void)removeCheckWith:(UITableViewCell *)cell{
    for (UIImageView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
}

#pragma mark-点击组
-(void)sectionClick:(MyView *)view{
    BOOL ret = [[_sectionStatus objectAtIndex:view.tag-1000] boolValue];
    
    if(_myIndexPath.section !=  view.tag-1000){
        [_sectionStatus replaceObjectAtIndex:_myIndexPath.section  withObject:@NO];
        [_sectionStatus replaceObjectAtIndex:view.tag-1000 withObject:@YES];
    }else{
        if(ret == YES){
            [_sectionStatus replaceObjectAtIndex:view.tag-1000 withObject:@NO];
        }else{
            [_sectionStatus replaceObjectAtIndex:view.tag-1000 withObject:@YES];
        }
    }
    _myIndexPath = [NSIndexPath indexPathForRow:0 inSection:view.tag-1000];
   

    [_leftTableView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:view.tag-1000] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
        [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:view.tag-1000]];
    });

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
        
        _choseLabel.text = [NSString stringWithFormat:ModuleZW(@"已选症状%ld/5"),(long)_selectedCount];
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
        [_leftTableView reloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.leftTableView selectRowAtIndexPath:self.myIndexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
        });

        //没有已选症状不让提交
        if(_selectedArr.count == 0){
            _bottomView.hidden = YES;
            _showView.hidden = YES;
            for (UIView *view in _contentView.subviews) {
                [view removeFromSuperview];
            }
        }
        
    }
    
}

#pragma mark-点击提交按钮
-(void)commitBtnClick:(UIButton *)button{
    [self hidePopView];
    if(self->_selectedArr.count <1){
        [GlobalCommon showMessage:ModuleZW(@"未选择症状") duration:2.0];
        
    }else{
        self.isPush = YES;
        OrganDiseaseListViewController *diseaseList = [[OrganDiseaseListViewController alloc] init];
        diseaseList.upData = _selectedArr;
        diseaseList.sex = _sex;
        diseaseList.rightDataArr = self.rightDataArr;
        diseaseList.startTimeStr = self.startTimeStr;
        diseaseList.refreshTableView = ^{
            [self->_leftTableView reloadData];
            [self->_rightTableView reloadData];
            self->_selectedCount = self->_selectedArr.count;
            self->_choseLabel.text = [NSString stringWithFormat:ModuleZW(@"已选症状%ld/5"),(long)self->_selectedCount];
        };
        [self.navigationController pushViewController:diseaseList animated:YES];
    }
    
}

#pragma mark- block方法的实现
-(void)reloadCellWith:(reloadCellBlock)block{
    self.reloadBlock = [block copy];
}
-(void)addCheckWithBlock:(addCheckBlock)block{
    self.checkBlock = [block copy];
}


- (NSString *)imageStrWithPartName:(NSString *)partName
{
    if([GlobalCommon stringEqualNull:partName]){
        return nil;
    }else{
        if([_sectionDataArr containsObject:ModuleZW(partName)]){
            NSInteger index = [_sectionDataArr indexOfObject:ModuleZW(partName)];
            if(_sectionOpenImageArr.count > index){
                return [_sectionOpenImageArr objectAtIndex:index];
            }
            return nil;
        }
    }
    return nil;
}


@end
