//
//  QuestionListController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/12.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "QuestionListController.h"
#import "QuestionView.h"
#import "QuestionModel.h"
#import "CacheManager.h"
#import "QuestionCell.h"
#import "AnwerModel.h"
#import "ResultController.h"

@interface QuestionListController ()<UICollectionViewDelegate,UICollectionViewDataSource,QuestionCellDelegate>
{
    NSInteger _pages;
    NSInteger _currentIndex;
    NSInteger _selectNum;
    
    BOOL _firstQuestionSelect;
    BOOL _secondQuestionSelect;
}
@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,strong) NSArray *anwerArr;
@property (nonatomic,strong) NSArray *repeatQuestionArr;
@property (nonatomic,strong) NSArray *questionArr;
@property (nonatomic,strong) UILabel *allPage;
@property (nonatomic,strong) UIButton *lastPage;
@property (nonatomic,strong) UIButton *nextPage;
@property (nonatomic,copy)NSString *str;

@end

@implementation QuestionListController
@synthesize collectionV;

- (void)dealloc{
    self.questionArr = nil;
    collectionV = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navTitleLabel.text = @"体质辨识";
    [self getQuestionData];
    self.anwerArr = [NSArray arrayWithObjects:@"没有（根本不)",@"很少（有一点)",@"有时（有些)",@"经常（相当)",@"总是（非常)", nil];
    
}

- (void)goBack:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)createUI
{
    
    _currentIndex = 0;
    _selectNum = 0;
    _firstQuestionSelect = NO;
    _secondQuestionSelect = NO;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(15, kNavBarHeight+15, ScreenWidth-30, ScreenHeight-kNavBarHeight-30)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(ScreenWidth-30, ScreenHeight-kNavBarHeight-30-50);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-30, layout.itemSize.height) collectionViewLayout:layout];
    collectionV.delegate = self;
    collectionV.dataSource = self;
    collectionV.showsHorizontalScrollIndicator = NO;
    collectionV.backgroundColor = [UIColor clearColor];
    collectionV.pagingEnabled = YES;
    collectionV.scrollEnabled = NO;
    [collectionV registerClass:[QuestionCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [backView addSubview:collectionV];
    
    
    self.lastPage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lastPage.frame = CGRectMake(15, backView.height-40, 60, 30);
    [self.lastPage setTitle:@"上一页" forState:UIControlStateNormal];
    self.lastPage.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.lastPage setTitleColor:[Tools colorWithHexString:@"#0282bf"] forState:UIControlStateNormal];
    self.lastPage.hidden = YES;
    [self.lastPage addTarget:self action:@selector(lastPageAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.lastPage];
    
    self.allPage = [[UILabel alloc] initWithFrame:CGRectMake((backView.width-100)/2.0, self.lastPage.top, 100, 30)];
    self.allPage.font = [UIFont systemFontOfSize:15];
    self.allPage.textAlignment = NSTextAlignmentCenter;
    self.allPage.textColor = [Tools colorWithHexString:@"#0282bf"];
    self.allPage.text = [NSString stringWithFormat:@"1/%ld页",(long)_pages];
    [backView addSubview:self.allPage];
    
    self.nextPage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextPage.frame = CGRectMake(backView.width-60-15, self.lastPage.top, 60, 30);
    [self.nextPage setTitle:@"下一页" forState:UIControlStateNormal];
    self.nextPage.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.nextPage setTitleColor:[Tools colorWithHexString:@"#0282bf"] forState:UIControlStateNormal];
    [self.nextPage addTarget:self action:@selector(nextPageAction) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.nextPage];
    
    [collectionV reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getQuestionData
{
    NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath = [docuPath stringByAppendingPathComponent:@"question.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:dbPath];
    if(isExist){
        CacheManager *cacheManager = [[CacheManager alloc] initManage];

        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
        tempArr = [cacheManager getQuestionModels];

        [self handleQuestionDataWithArr:tempArr];

    }else{
        [self requestQuestionListData];
    }
    
}

- (void)handleQuestionDataWithArr:(NSMutableArray *)tempArr
{
    NSMutableArray *repeatArr1 = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *tempArr1 = [NSMutableArray arrayWithCapacity:0];
    NSInteger arrCount = [tempArr count];
    for(NSInteger i=0;i<arrCount;i++){
        BOOL isRepeat = NO;
        QuestionModel *model1 = [tempArr objectAtIndex:i];
        for(NSInteger j=i+1;j<arrCount;j++){
            QuestionModel *model2 = [tempArr objectAtIndex:j];
            if(model2.order == model1.order){
                isRepeat = YES;
            }
        }
        if(isRepeat){
            [repeatArr1 addObject:model1];
        }else{
            [tempArr1 addObject:model1];
        }
    }
    self.questionArr = [tempArr1 copy];
    self.repeatQuestionArr = [repeatArr1 copy];
    _pages = (NSInteger)ceil(self.questionArr.count/2.0);
    [self createUI];
}

- (void)requestQuestionListData
{

    NSString *str = @"questionnaire/lists.jhtml";
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"TZBS" forKey:@"sn"];
    __weak typeof(self) weakSelf = self;
    [GlobalCommon showMBHudWithView:self.view];
    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:str parameters:dic successBlock:^(id response) {
         [GlobalCommon hideMBHudWithView:weakSelf.view];
        if([[response objectForKey:@"status"] integerValue] == 100){
            
            NSArray *arr1 = [response objectForKey:@"data"];
            NSMutableArray *mutabDataArr = [NSMutableArray arrayWithCapacity:0];
            
            for(NSDictionary *dic in arr1){
                NSArray *arr2 = [dic objectForKey:@"question"];
                
                NSArray *answerArr = [dic objectForKey:@"answer"];
                
                //对答案数组按照order字段排序
                answerArr = [answerArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *dic1, NSDictionary *dic2) {
                    return [[dic1 objectForKey:@"order"] compare:[dic2 objectForKey:@"order"]];
                }];
                
                NSString *answerIDStr = @"";
                //将所有的答案id拼接
                for(NSDictionary *answerDic in answerArr){
                    answerIDStr =[answerIDStr stringByAppendingString:[NSString stringWithFormat:@",%@",[answerDic objectForKey:@"id"]]];
                }
                
                answerIDStr = [answerIDStr substringFromIndex:1];
                
                //获取问题将其转化为QuestionModel
                NSString *typeStr = [dic objectForKey:@"name"];
                for(NSDictionary *dic2 in arr2){
                    QuestionModel *model = [[QuestionModel alloc] init];
                    model = [QuestionModel mj_objectWithKeyValues:dic2];
                    model.type = typeStr;
                    model.order = [[dic2 objectForKey:@"order"] integerValue];
                    model.allIDStr = answerIDStr;
                    [mutabDataArr addObject:model];
                }
            }
            CacheManager *cacheManager = [[CacheManager alloc] init];
            BOOL result = [cacheManager createDataBase];
            if(result){
                [cacheManager insertQuestionModels:mutabDataArr];
            }else{
                [weakSelf showAlertWarmMessage:@"数据库创建失败"];
            }
            [weakSelf handleQuestionDataWithArr:mutabDataArr];
        }else{
            [weakSelf showAlertWarmMessage:[response objectForKey:@"data"]];
        }
    } failureBlock:^(NSError *error) {
        [GlobalCommon hideMBHudWithView:weakSelf.view];
        [weakSelf showAlertWarmMessage:requestErrorMessage];
    }];
}

# pragma mark - 选则选项代理方法
- (void)selectAnswerWithNumber:(NSInteger )num
{
    
    QuestionModel *model = nil;
    NSInteger indexNum = 0;
    
    if(num>100 && num<200){ //第一个题目
        indexNum = num - 100;
        model = [self.questionArr objectAtIndex:_currentIndex*2];
        if(!model.isSelected){
            if(!_firstQuestionSelect){
                _selectNum += 1;
            }
            model.isSelected = YES;
            _firstQuestionSelect = YES;
        }
        
    }else{
        indexNum = num - 200;
        model = [self.questionArr objectAtIndex:_currentIndex*2+1];
        if(!model.isSelected){
            if(!_secondQuestionSelect){
                _selectNum += 1;
            }
            model.isSelected = YES;
            _secondQuestionSelect = YES;
        }
        
    }

    model.selectNum = indexNum;
    if(model.reverse){
        model.grade = 5 - indexNum;
    }else{
        model.grade = indexNum;
    }
    
    NSArray *idArr = [model.allIDStr componentsSeparatedByString:@","];
    model.answerID = [[idArr objectAtIndex:model.selectNum-1] integerValue];
    
    /*自动答题*/
//    for(NSInteger i=0;i<self.questionArr.count;i++){
//        QuestionModel *model = [self.questionArr objectAtIndex:i];
//        _selectNum+=1;
//        NSInteger indexNum = (arc4random() % 5) + 1;
//        model.selectNum = indexNum;
//        if(model.reverse){
//            model.grade = 5 - indexNum;
//        }else{
//            model.grade = indexNum;
//        }
//        NSArray *idArr = [model.allIDStr componentsSeparatedByString:@","];
//        model.answerID = [[idArr objectAtIndex:model.selectNum-1] integerValue];
//    }
    /*自动答题*/
    
    if(_selectNum == self.questionArr.count){ //所有题目已经答完
        [self generateTZBS];
    }else{
        if(_firstQuestionSelect&&_secondQuestionSelect){
            [self nextPageAction];
        }
    }
}

# pragma mark - collectionView的代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _pages;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionCell *cell = (QuestionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.delegate = self;
    QuestionModel *model1 = [self.questionArr objectAtIndex:indexPath.row*2];
    cell.title1.text = [NSString stringWithFormat:@"%ld.  %@",indexPath.row*2+1,model1.name];
    
    [cell updateButtonStateWithGrade1:model1.selectNum withTag:100];
    
    //NSLog(@"count1:%ld,count2:%ld",self.questionArr.count,indexPath.row);
    if(self.questionArr.count>indexPath.row*2+1){
        QuestionModel *model2 = [self.questionArr objectAtIndex:indexPath.row*2+1];
        cell.title2.text = [NSString stringWithFormat:@"%ld.  %@",indexPath.row*2+2,model2.name];
        
        [cell updateButtonStateWithGrade1:model2.selectNum withTag:200];
        
    }else{
        [cell hideBottomQuestion];
    }
        return cell;
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint targetOffset = [self nearestTargetOffsetForOffset:*targetContentOffset];
    targetContentOffset->x = targetOffset.x;
    targetContentOffset->y = targetOffset.y;
    //NSLog(@"####x:%f,width:%f",targetContentOffset->x,ScreenWidth);
    CGFloat offetX = targetContentOffset->x;
    _currentIndex = offetX/(ScreenWidth - 30);
    [self updatePageView];
}

- (CGPoint)nearestTargetOffsetForOffset:(CGPoint)offset
{
    CGFloat pageSize = 0 + ScreenWidth-30;
    //四舍五入
    NSInteger page = roundf(offset.x / pageSize);
    CGFloat targetX = pageSize * page;
    return CGPointMake(targetX, offset.y);
}

- (void)updatePageView
{
    if(_currentIndex==0){
        self.lastPage.hidden = YES;
    }
    if(_currentIndex>0){
        self.lastPage.hidden = NO;
    }
    if(_currentIndex+1 == _pages){
        //self.nextPage.hidden = YES;
        [self.nextPage setTitle:@"提交" forState:UIControlStateNormal];
    }else{
        //self.nextPage.hidden = NO;
        [self.nextPage setTitle:@"下一页" forState:UIControlStateNormal];
    }
    self.allPage.text = [NSString stringWithFormat:@"%ld/%ld页",_currentIndex+1,(long)_pages];
}

- (void)lastPageAction
{
    _firstQuestionSelect = NO;
    _secondQuestionSelect = NO;
    [collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    _currentIndex = _currentIndex - 1;
    
    [self updatePageView];
    
}

- (void)nextPageAction
{
    if([self.nextPage.titleLabel.text isEqualToString:@"提交"]){
        if(_selectNum == self.questionArr.count){
            [self generateTZBS];
        }else{
            [self showAlertWarmMessage:@"题目还未答完,不能提交!"];
        }
        return;
    }
    
    _firstQuestionSelect = NO;
    _secondQuestionSelect = NO;
    [collectionV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
    _currentIndex = _currentIndex + 1;
    
    [self updatePageView];
    //[self networkTZBS];
}

# pragma mark - 生成体质辨识
- (void)generateTZBS
{
    for(QuestionModel *model in self.questionArr){
        for(QuestionModel *repeatModel in self.repeatQuestionArr){
            if(repeatModel.order == model.order){
                if(repeatModel.reverse){
                    repeatModel.grade = 5 - model.selectNum;
                }else{
                    repeatModel.grade = model.selectNum;
                }
                NSArray *idArr = [repeatModel.allIDStr componentsSeparatedByString:@","];
                repeatModel.answerID = [[idArr objectAtIndex:model.selectNum-1] integerValue];
            }
        }
    }
    
    //每种体质个数
    NSInteger TZ00Count=0,TZ01Count=0,TZ02Count=0,TZ03Count=0,TZ04Count=0,TZ05Count=0,TZ06Count=0,TZ07Count=0,TZ08Count = 0;
    //每种体质分数
    NSInteger TZ00Fraction=0,TZ01Fraction=0,TZ02Fraction=0,TZ03Fraction=0,TZ04Fraction=0,TZ05Fraction=0,TZ06Fraction=0,TZ07Fraction=0,TZ08Fraction = 0;
    
    NSString *mstr0 = @"", *mstr1=@"",*mstr2 = @"", *mstr3=@"",*mstr4 = @"", *mstr5=@"",*mstr6 = @"", *mstr7=@"",*mstr8 = @"";
    
    NSMutableArray *examCatIdArr = [[NSMutableArray alloc] initWithArray:@[@"",@"",@"",@"",@"",@"",@"",@"",@""]];
    
    NSArray *totalArr = [self.questionArr arrayByAddingObjectsFromArray:self.repeatQuestionArr];
    for(QuestionModel *model in totalArr){
        
        NSInteger key = model.uid;
        NSInteger value = model.answerID;
        
        if([model.type isEqualToString:@"平和质问卷"]){
            TZ00Count+=1;
            TZ00Fraction = TZ00Fraction+model.grade;
            mstr0 =[mstr0 stringByAppendingString:[NSString stringWithFormat:@",%ld,%ld",(long)key,(long)value]];
            [examCatIdArr replaceObjectAtIndex:0 withObject:@(model.uid)];
        }else if ([model.type isEqualToString:@"气虚质问卷"]){
            TZ01Count+=1;
            TZ01Fraction+=model.grade;
            mstr1 =[mstr1 stringByAppendingString:[NSString stringWithFormat:@",%ld,%ld",(long)key,(long)value]];
            [examCatIdArr replaceObjectAtIndex:1 withObject:@(model.uid)];
        }else if ([model.type isEqualToString:@"阳虚质问卷"]){
            TZ02Count+=1;
            TZ02Fraction+=model.grade;
            mstr2 =[mstr2 stringByAppendingString:[NSString stringWithFormat:@",%ld,%ld",(long)key,(long)value]];
            [examCatIdArr replaceObjectAtIndex:2 withObject:@(model.uid)];
        }else if ([model.type isEqualToString:@"阴虚质问卷"]){
            TZ03Count+=1;
            TZ03Fraction+=model.grade;
            mstr3 =[mstr3 stringByAppendingString:[NSString stringWithFormat:@",%ld,%ld",(long)key,(long)value]];
            [examCatIdArr replaceObjectAtIndex:3 withObject:@(model.uid)];
        }else if ([model.type isEqualToString:@"痰湿质问卷"]){
            TZ04Count+=1;
            TZ04Fraction+=model.grade;
            mstr4 =[mstr4 stringByAppendingString:[NSString stringWithFormat:@",%ld,%ld",(long)key,(long)value]];
            [examCatIdArr replaceObjectAtIndex:4 withObject:@(model.uid)];
        }else if ([model.type isEqualToString:@"湿热质问卷"]){
            TZ05Count+=1;
            TZ05Fraction+=model.grade;
            mstr5 =[mstr5 stringByAppendingString:[NSString stringWithFormat:@",%ld,%ld",(long)key,(long)value]];
            [examCatIdArr replaceObjectAtIndex:5 withObject:@(model.uid)];
        }else if ([model.type isEqualToString:@"血瘀质问卷"]){
            TZ06Count+=1;
            TZ06Fraction+=model.grade;
            mstr6 =[mstr6 stringByAppendingString:[NSString stringWithFormat:@",%ld,%ld",(long)key,(long)value]];
            [examCatIdArr replaceObjectAtIndex:6 withObject:@(model.uid)];
        }else if ([model.type isEqualToString:@"气郁质问卷"]){
            TZ07Count+=1;
            TZ07Fraction+=model.grade;
            mstr7 =[mstr7 stringByAppendingString:[NSString stringWithFormat:@",%ld,%ld",(long)key,(long)value]];
            [examCatIdArr replaceObjectAtIndex:7 withObject:@(model.uid)];
        }else if ([model.type isEqualToString:@"特禀质问卷"]){
            TZ08Count+=1;
            TZ08Fraction+=model.grade;
            mstr8 =[mstr8 stringByAppendingString:[NSString stringWithFormat:@",%ld,%ld",(long)key,(long)value]];
            [examCatIdArr replaceObjectAtIndex:8 withObject:@(model.uid)];
        }
            
    }
    
    mstr0 = [mstr0 substringFromIndex:1];
    mstr1 = [mstr1 substringFromIndex:1];
    mstr2 = [mstr2 substringFromIndex:1];
    mstr3 = [mstr3 substringFromIndex:1];
    mstr4 = [mstr4 substringFromIndex:1];
    mstr5 = [mstr5 substringFromIndex:1];
    mstr6 = [mstr6 substringFromIndex:1];
    mstr7 = [mstr7 substringFromIndex:1];
    mstr8 = [mstr8 substringFromIndex:1];
    
    /*
    NSString *v0 = [[NSString alloc] initWithFormat:@"{%@}",mstr0];
    NSString *v1 = [[NSString alloc] initWithFormat:@"{%@}",mstr1];
    NSString *v2 = [[NSString alloc] initWithFormat:@"{%@}",mstr2];
    NSString *v3 = [[NSString alloc] initWithFormat:@"{%@}",mstr3];
    NSString *v4 = [[NSString alloc] initWithFormat:@"{%@}",mstr4];
    NSString *v5 = [[NSString alloc] initWithFormat:@"{%@}",mstr5];
    NSString *v6 = [[NSString alloc] initWithFormat:@"{%@}",mstr6];
    NSString *v7 = [[NSString alloc] initWithFormat:@"{%@}",mstr7];
    NSString *v8 = [[NSString alloc] initWithFormat:@"{%@}",mstr8];
    */
     
    //NSArray *resultArr = [NSArray arrayWithObjects:v0,v1,v2,v3,v4,v5,v6,v7,v8, nil];
    //转化分数
    TZ00Fraction = (TZ00Fraction - TZ00Count)/(TZ00Count*4.0)*100;
    TZ01Fraction = (TZ01Fraction - TZ01Count)/(TZ01Count*4.0)*100;
    TZ02Fraction = (TZ02Fraction - TZ02Count)/(TZ02Count*4.0)*100;
    TZ03Fraction = (TZ03Fraction - TZ03Count)/(TZ03Count*4.0)*100;
    TZ04Fraction = (TZ04Fraction - TZ04Count)/(TZ04Count*4.0)*100;
    TZ05Fraction = (TZ05Fraction - TZ05Count)/(TZ05Count*4.0)*100;
    TZ06Fraction = (TZ06Fraction - TZ06Count)/(TZ06Count*4.0)*100;
    TZ07Fraction = (TZ07Fraction - TZ07Count)/(TZ07Count*4.0)*100;
    TZ08Fraction = (TZ08Fraction - TZ08Count)/(TZ08Count*4.0)*100;
    
    
    NSArray *arr = [[NSArray alloc] initWithObjects:@(TZ01Fraction),@(TZ02Fraction),@(TZ03Fraction),@(TZ04Fraction),@(TZ05Fraction),@(TZ06Fraction),@(TZ07Fraction),@(TZ08Fraction), nil];
    
    self.str = @"TZBS-01";//赋初值
    if ((TZ01Fraction <30)&&(TZ02Fraction <30)&&(TZ03Fraction <30)&&(TZ04Fraction <30)&&(TZ05Fraction <30)&&(TZ06Fraction <30)&&(TZ07Fraction <30)&&(TZ08Fraction <30)) {
       self.str = @"TZBS-01";
    }
    if ((TZ01Fraction >40)||(TZ02Fraction >40)||(TZ02Fraction >40)||(TZ02Fraction >40)||(TZ02Fraction >40)||(TZ02Fraction >40)||(TZ02Fraction >40)||(TZ02Fraction >40)) {
        self.str = [self maxIndexWithArr:arr];
    }if (TZ00Fraction >=60) {
        if (((TZ01Fraction <40)&&(TZ01Fraction >=30))&&((TZ02Fraction <40)&&(TZ02Fraction >=30))&&((TZ03Fraction <40)&&(TZ03Fraction >=30))&&((TZ04Fraction <40)&&(TZ04Fraction >=30))&&((TZ05Fraction <40)&&(TZ05Fraction >=30))&&((TZ06Fraction <40)&&(TZ06Fraction >=30))&&((TZ07Fraction <40)&&(TZ07Fraction >=30))&&((TZ08Fraction <40)&&(TZ08Fraction >=30))) {
            self.str = @"TZBS-01";
        }
    }else{
        if (((TZ01Fraction <40)&&(TZ01Fraction >=30))&&((TZ02Fraction <40)&&(TZ02Fraction >=30))&&((TZ03Fraction <40)&&(TZ03Fraction >=30))&&((TZ04Fraction <40)&&(TZ04Fraction >=30))&&((TZ05Fraction <40)&&(TZ05Fraction >=30))&&((TZ06Fraction <40)&&(TZ06Fraction >=30))&&((TZ07Fraction <40)&&(TZ07Fraction >=30))&&((TZ08Fraction <40)&&(TZ08Fraction >=30))) {
            //取分数高者为该偏颇体质
            
            self.str= [self maxIndexWithArr:arr];
            
        }
    }
    
    NSArray *arr2 = [[NSArray alloc] initWithObjects:@(TZ00Fraction),@(TZ01Fraction),@(TZ02Fraction),@(TZ03Fraction),@(TZ04Fraction),@(TZ05Fraction),@(TZ06Fraction),@(TZ07Fraction),@(TZ08Fraction), nil];
    NSArray *TZBS_arr = @[@"TZBS-01",@"TZBS-02",@"TZBS-03",@"TZBS-04",@"TZBS-07",@"TZBS-06",@"TZBS-09",@"TZBS-05",@"TZBS-08"];
    NSString *tzscore = @"";
    NSString *tempStr = @"";
    for(NSInteger i=0;i<TZBS_arr.count;i++){
        tempStr = [[TZBS_arr objectAtIndex:i] stringByAppendingString:[NSString stringWithFormat:@":%@;",[arr2 objectAtIndex:i]]];
        if(i == 0){
            tzscore = tempStr;
        }else{
            tzscore = [tzscore stringByAppendingString:tempStr];
        }
    }
    NSLog(@"tzscore:%@",tzscore);
    
    NSMutableString *questionIdsString = [[NSMutableString alloc] initWithCapacity:10];
    for (id object in examCatIdArr) {
        NSString *string = [object stringValue];
        [questionIdsString appendFormat:@",%@",string];
    }
    if (questionIdsString) {
        [questionIdsString deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    //NSLog(@"questionIdsString************%@",questionIdsString);
    
    
    
    
    NSDictionary *paramDic = @{@"subjectSn":self.str,
                                             @"memberChildId":[MemberUserShance shareOnce].idNum,
                                             @"jsonResults":@"",
                                             @"questionnaireIds":questionIdsString,
                                             @"tzscore":tzscore};
    
    __weak typeof(self) weakSelf = self;
    //NSString *urlStr = @"subject_category/list.jhtml?sn=TZBS";
//    NSString *urlStr = @"/member/myreport/save_report.jhtml";
    
    
    [GlobalCommon showMBHudWithView:self.view];
    
    
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/myreport/save_report.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"token" value:[UserShareOnce shareOnce].token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",[UserShareOnce shareOnce].token,[UserShareOnce shareOnce].JSESSIONID]];
    
    [request setPostValue:[MemberUserShance shareOnce].idNum forKey:@"memberChildId"];
    [request setPostValue:self.str forKey:@"subjectSn"];
    [request setPostValue:@"" forKey:@"jsonResults"];
    [request setPostValue:questionIdsString forKey:@"questionnaireIds"];
    [request setPostValue:tzscore forKey:@"tzscore"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requesstuserinfoError:)];
    [request setDidFinishSelector:@selector(requesstuserinfoCompleted:)];
    [request startAsynchronous];
    
 //
//    [ZYGASINetworking POST_Path:urlStr params:paramDic completed:^(id JSON, NSString *stringData) {
//        [GlobalCommon hideMBHudWithView:weakSelf.view];
//        if([[JSON objectForKey:@"status"] integerValue] == 100){
//            ResultController *resultVC = [[ResultController alloc] init];
//            resultVC.TZBSstr = str;
//            [weakSelf.navigationController pushViewController:resultVC animated:YES];
//        }else{
//        }
//    } failed:^(NSError *error) {
//        [GlobalCommon hideMBHudWithView:weakSelf.view];
//        [weakSelf showAlertWarmMessage:@"请求网络失败"];
//    }];
    
    
    
//    [[NetworkManager sharedNetworkManager] requestWithType:1 urlString:urlStr headParameters:headers parameters:paramDic successBlock:^(id response) {
//        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
//        id jsonData = [NSJSONSerialization JSONObjectWithData:response options:0 error:&errorForJSON];
//        NSLog(@"data:%@",jsonData);
//    } failureBlock:^(NSError *error) {
//        
//    }];
    
//    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
//        NSArray *dataArr = [response objectForKey:@"data"];
//        NSDictionary *dataDic = [dataArr objectAtIndex:0];
//        NSInteger dataID = [[dataDic objectForKey:@"id"] integerValue];
//        ResultController *resultVC = [[ResultController alloc] init];
//        resultVC.TZBSstr = str;
//        resultVC.subCatId = dataID;
//        [weakSelf.navigationController pushViewController:resultVC animated:YES];
//    } failureBlock:^(NSError *error) {
//        [weakSelf showAlertWarmMessage:@"请求网络失败!"];
//    }];
    
}


- (void)requesstuserinfoError:(ASIHTTPRequest *)request
{
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    [GlobalCommon hideMBHudWithView:self.view];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
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
        
        [UserShareOnce shareOnce].isRefresh = YES;
        ResultController *resultVC = [[ResultController alloc] init];
        resultVC.TZBSstr = self.str;
        [self.navigationController pushViewController:resultVC animated:YES];
        
    }
    
}

//- (void)networkTZBS
//{
//    __weak typeof(self) weakSelf = self;
//    NSString *urlStr = @"subject_category/list.jhtml?sn=TZBS";
//    [[NetworkManager sharedNetworkManager] requestWithType:0 urlString:urlStr parameters:nil successBlock:^(id response) {
//        NSArray *dataArr = [response objectForKey:@"data"];
//        NSDictionary *dataDic = [dataArr objectAtIndex:0];
//        NSInteger dataID = [[dataDic objectForKey:@"id"] integerValue];
//
//    } failureBlock:^(NSError *error) {
//        [weakSelf showAlertWarmMessage:@"请求网络失败!"];
//    }];
//
//}

//求出最大值对应的体质类型
-(NSString *) maxIndexWithArr:(NSArray *)arr{
    NSInteger maxIndex = 0;
    NSInteger max = 0;
    for (int i=0; i<arr.count; i++) {
        for (int j=i+1; j<arr.count; j++) {
            if (arr[i]>arr[j]) {
                max = [arr[i] integerValue];
            }else if (arr[i]<arr[j]){
                max = [arr[j] integerValue];
            }else if (arr[i]==arr[j]){
                max = [arr[i] integerValue];
            }
        }
    }
    for (int i=0; i<arr.count; i++) {
        if ([arr[i] integerValue] == max) {
            maxIndex = i+1;
            break;
        }
    }
    switch (maxIndex) {
        case 1:
        {
            return @"TZBS-02";
        }
            break;
        case 2:
        {
            return @"TZBS-03";
        }
            break;
        case 3:
        {
            return @"TZBS-04";
        }
            break;
        case 4:
        {
            return @"TZBS-07";
        }
            break;
        case 5:
        {
            return @"TZBS-06";
        }
            break;
        case 6:
        {
            return @"TZBS-09";
        }
            break;
        case 7:
        {
            return @"TZBS-05";
        }
            break;
        case 8:
        {
            return @"TZBS-08";
        }
            break;
            
        default:
            break;
    }
    return @"";
}


@end
