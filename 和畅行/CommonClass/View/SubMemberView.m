//
//  SubMemberView.m
//  Voicediagno
//
//  Created by ZhangYunguang on 15/12/25.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "SubMemberView.h"
#import "ChildMemberModel.h"
#import "UIView+ViewController.h"

#define kSubMemberPort @"/member/memberModifi/list.jhtml"

@interface SubMemberView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation SubMemberView

#pragma mark - 重写初始化方法
-(instancetype)init{
    if (self = [super init]) {
        [self initHintView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initHintView];
    }
    return self;
}
#pragma mark - 初始化view
-(void)initHintView{
    
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"memberChirldArr"];
    
    _bottomView = [[UIView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    [[UIApplication sharedApplication].keyWindow addSubview:_bottomView];
    
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    
    
    for(NSData *data in arr){
        ChildMemberModel *model = (ChildMemberModel *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([[UserShareOnce shareOnce].username isEqualToString:model.name]){
            model.gender = [UserShareOnce shareOnce].gender;
        }
        [self.dataArr addObject:model];
    }
    
    
    CGFloat width = ScreenWidth-50*2;
    CGFloat height = self.dataArr.count*44+35>width ? 400 : width;
    _showView = [[UIView alloc] initWithFrame:CGRectMake(50, (ScreenHeight-height)/2.0, width, height)];
    _showView.layer.cornerRadius = 8.0;
    _showView.layer.masksToBounds = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:_showView];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, _showView.width, 25)];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = UIColorFromHex(0x009ef3);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    if ([MemberUserShance shareOnce].name.length < 26){
        _titleLabel.text =[NSString stringWithFormat:@"欢迎：%@", [MemberUserShance shareOnce].name];
    }else{
        _titleLabel.text =[NSString stringWithFormat:@"欢迎：%@", [UserShareOnce shareOnce].wxName];
    }

    [_showView addSubview:_titleLabel];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _titleLabel.bottom+5, _showView.frame.size.width, _showView.frame.size.height-_titleLabel.bottom-5) style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_showView addSubview:_tableView];
    _bottomView.backgroundColor = [UIColor blackColor];
    _bottomView.alpha = 0.5;
    _showView.backgroundColor = [UIColor whiteColor];
    
    
//    _bottomView.hidden = YES;
//    _showView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [_bottomView addGestureRecognizer:tap];
    
    [self.tableView reloadData];
    
    
    //先判断有没有已经选择过的子账号
//    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSInteger selectedMemberId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedMemberId"] integerValue];
//        ChildMemberModel *model = obj;
//        if (selectedMemberId == model.idNum.integerValue) {
//            *stop = YES;
//            if (idx != 0) {
//                [self.dataArr exchangeObjectAtIndex:0 withObjectAtIndex:idx];
//            }
//
//        }
//    }];
    
    
    
}
#pragma mark - 点击屏幕
-(void)tapScreen:(UITapGestureRecognizer *)tap{
    [self hideHintView];
}
#pragma mark-tableView Delegate相关
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count ? self.dataArr.count: 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight ? self.cellHeight: 44.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    
    ChildMemberModel *model = self.dataArr[indexPath.row];
    if (model.idNum == [MemberUserShance shareOnce].idNum) {
        UIImageView *aimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 52 / 2, 52 / 2)];
        aimage.image = [UIImage imageNamed:@"childMemberSelect"];
        [cell addSubview:aimage];
    }else{
        UIImageView *aimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9, 52 / 2, 52 / 2)];
        aimage.image = [UIImage imageNamed:@"childMemberUnSelect"];
        [cell addSubview:aimage];
    }

    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 24)];
    nameLabel.font = [UIFont systemFontOfSize:13];
    if ( model.name.length > 27) {
        nameLabel.text =  [UserShareOnce shareOnce].wxName;
    }else {
        nameLabel.text = model.name;
    }
        
    [cell addSubview:nameLabel];
    
    int sesss ;
    int age ;
    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLabel.right + 10, 10, 40, 24)];
    sexLabel.font = [UIFont systemFontOfSize:13];
    UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(sexLabel.right+10, 10, 70, 24)];
    ageLabel.font = [UIFont systemFontOfSize:13];
    [cell addSubview:sexLabel];
    [cell addSubview:ageLabel];
    
    NSString *sex = @"";
    ;

    if([GlobalCommon stringEqualNull:model.gender]){
        sex =@"—" ;
    }else if ([model.gender isEqualToString:@"male"]){
        sex = @"男";
    }else{
        sex = @"女";
    }
    sexLabel.text = sex;

    if ([model.birthday isKindOfClass:[NSNull class]] ||model.birthday == nil|| model.birthday.length ==0) {
        ageLabel.text =@"未知";
    }else if ([model.birthday isEqualToString:@"请选择您的出生日期"]){
        ageLabel.text =@"未知";
    } else{
        NSString *str = [model.birthday substringToIndex:4];
        sesss = [str intValue];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *now;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
        NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        now=[NSDate date];
        comps = [calendar components:unitFlags fromDate:now];
        age = (int)[comps year] - sesss;
        ageLabel.text = [NSString stringWithFormat:@"%d岁",age];
    }
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 43, tableView.frame.size
                                                                          .width-40, 1)];
    lineView.image = [UIImage imageNamed:@"ICD10_leftGrayLine"];
    lineView.backgroundColor = UIColorFromHex(0xDADADA);
    [cell addSubview:lineView];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ChildMemberModel *model = self.dataArr[indexPath.row];
    MemberUserShance *memberShance = [MemberUserShance shareOnce];
//    if(model.idNum == memberShance.idNum){
//        return;
//    }
    memberShance = [MemberUserShance mj_objectWithKeyValues:model];
//    if(indexPath.row == 2){
//        memberShance.idNum = [NSNumber numberWithInt:4017];
//    }
    NSString *memberId = [NSString stringWithFormat:@"%@",model.idNum];
    self.myBlock(memberId);
    if(self.mynameBlock){
        self.mynameBlock(model.name);
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",@(indexPath.row)] forKey:@"selectedMemberIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:memberId forKey:@"selectedMemberId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 隐藏view
-(void)hideHintView{
    
    [_showView removeFromSuperview];
    [_bottomView removeFromSuperview];

}

#pragma mark - block
-(void)receiveSubIdWith:(SelectCellBlock)block{
    if (!self.myBlock) {
        self.myBlock = [block copy];
    }
}

-(void)receiveNameWith:(SelectNameCellBlock)block{
    if(!self.mynameBlock) {
        self.mynameBlock = [block copy];
    }
}


@end
