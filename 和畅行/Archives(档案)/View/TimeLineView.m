//
//  TimeLineView.m
//  和畅行
//
//  Created by 刘晓明 on 2018/11/7.
//  Copyright © 2018 刘晓明. All rights reserved.
//

#import "TimeLineView.h"
#import "TimeLineCell.h"
#import "NoTimeLineCell.h"
#import "GovSectionView.h"
#import "HCY_DAVisceraCell.h"
#import "HCY_DAVisceraNoTimeCell.h"
#import "ResultSpeakController.h"
#import "ArchivesController.h"
#import "ResultController.h"
#import "EEGDetailController.h"
#import "HCY_ReportCell.h"
#import "UploadReportDetailsViewController.h"
//#import <HHDoctorSDK/HHDoctorSDK-Swift.h>

@interface TimeLineView()<UITableViewDelegate,UITableViewDataSource,govSectionViewDelegate>

@property (nonatomic,strong)NSString *memberIDStr;

@end

@implementation TimeLineView

- (id)initWithFrame:(CGRect)frame withData:(NSArray *)dataArr
{
    self = [super initWithFrame:frame];
    if(self){
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = [UIColor whiteColor];
    
    
    self.dataArr = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
         self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    }

    
    [self.tableView registerClass:[HCY_ReportCell class] forCellReuseIdentifier:@"HCY_ReportCell"];
}

-(void)relodTableViewWitDataArray:(NSMutableArray *)dataArray withType:(NSInteger)type withMemberID:(NSString *)memberID {
    self.typeInteger = type;
    self.dataArr = dataArray;
    self.memberIDStr = memberID;
    
    //档案最新
        if (self.typeInteger == 1){
            if (dataArray.count > 0){
                HealthTipsModel *model = dataArray[0];
                if (model.quarter != nil && ![model.quarter isKindOfClass:[NSNull class]]&&model.quarter.length != 0) {
                    self.topModel = model;
                    [dataArray removeObjectAtIndex:0];
                }
            }
        }
    
        self.dataArr = dataArray;
    
        if (_typeInteger == 1) {
             self.dataArr = [self.dataArr  sortedArrayUsingComparator:^(HealthTipsModel *model1, HealthTipsModel *model2) {
    
                NSTimeInterval time1=[model1.createDate doubleValue]/1000;
                NSTimeInterval time2=[model2.createDate doubleValue]/1000;
                NSDate *detailDate1=[NSDate dateWithTimeIntervalSince1970:time1];
                NSDate *detailDate2=[NSDate dateWithTimeIntervalSince1970:time2];
    
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat: @"yyyy/MM/dd HH:mm"];
    
                if (detailDate1 == [detailDate1 earlierDate: detailDate2]) {
                    return NSOrderedDescending;
                }else if (detailDate1 == [detailDate1 laterDate: detailDate2]) {
                    return NSOrderedAscending;//升序
                }else{
                    return NSOrderedSame;//相等
                }
            }];
        }
        [self.tableView reloadData];
}

#pragma mark -- tableView的代理方法
#pragma mark -- 返回多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark -- 每组返回多少个
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (self.typeInteger == 1) {
        if (self.topModel != nil && ![self.topModel isKindOfClass:[NSNull class]]) {
            return 90;
        }else{
            return 0;
        }
    }else{
        return 0;
    }

}

#pragma mark -- 每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthTipsModel *model = _dataArr[indexPath.row];
    
    if (self.typeInteger < 15&&self.typeInteger!=2&&self.typeInteger!=3) {
        
        if ([model.type isEqualToString:@"MedicRecord"]) {
            if(indexPath.row == 0){
                return 130;
            }else{
                HealthTipsModel *onAmodel = _dataArr[indexPath.row - 1];
                NSString *notimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",model.createTime]];
                NSString *nexttimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",onAmodel.createTime]];
                if ([notimeStr isEqualToString:nexttimeStr]) {
                    return 95;
                }else {
                    return 130;
                }
            }
        }else{
            if (![model.type isEqualToString:@"REPORT"]){
                return UITableViewAutomaticDimension;
            }else{
                return 120;
            }
        }
       
        
    }if (self.typeInteger == 2) {
        return 120;
    }else {
        
        if (indexPath.row == 0) {
            return 130;
        }else {
            HealthTipsModel *onAmodel = _dataArr[indexPath.row - 1];
            if ([model.createTime isEqualToString:onAmodel.createTime]) {
                return 95;
            }else {
                return 130;
            }
        }
    }
    
}
#pragma mark -- 每个cell显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.typeInteger < 15 &&self.typeInteger !=2 &&self.typeInteger!=3) {
        HealthTipsModel *model = _dataArr[indexPath.row];
        if(![model.type isEqualToString:@"REPORT"]) {
            NSString *timeStr = [NSString string];
            if (self.typeInteger == 0||self.typeInteger == 5) {
                timeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",model.createTime]];
            }else if (self.typeInteger == 1||self.typeInteger == 14){
                timeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",model.createDate]];
            }else{
                timeStr = model.createTime;
            }
            
            if(indexPath.row == 0 ){
                if ([model.type isEqualToString:@"MedicRecord"]) {
                    
                    HCY_DAVisceraCell * cell =[tableView dequeueReusableCellWithIdentifier:@"HCY_DAVisceraCell"];
                    if(cell==nil){
                        cell = [[HCY_DAVisceraCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCY_DAVisceraCell"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    cell.doctorNameLabel.font = [UIFont systemFontOfSize:15];
                    cell.departmentNameLabel.font = [UIFont systemFontOfSize:15];
                    cell.CCLabel.font = [UIFont systemFontOfSize:15];
                    cell.timeLabel.font=[UIFont systemFontOfSize:16.0];
                    cell.createDateLabel.font=[UIFont systemFontOfSize:13.0];

                    if (indexPath.row < _dataArr.count -1) {
                        HealthTipsModel *nextAmodel = _dataArr[indexPath.row + 1];
                        NSString *notimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",model.createTime]];
                        NSString *nexttimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",nextAmodel.createTime]];
                        if (![notimeStr isEqualToString:nexttimeStr]) {
                            cell.lineImageV2.hidden = YES;
                        }else{
                            cell.lineImageV2.hidden = NO;
                        }
                    }else if (indexPath.row == _dataArr.count -1){
                        cell.lineImageV2.hidden = YES;
                    }
//
                    [model yy_modelSetWithJSON:model.medicRecord];
                    [cell assignmentVisceraWithModel:model];
                    return cell;

                }else{
                    TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                    if(cell==nil){
                        cell = [[TimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    cell.timeLabel.font=[UIFont systemFontOfSize:16.0];
                    cell.createDateLabel.font=[UIFont systemFontOfSize:13.0];
                    cell.contentLabel.font=[UIFont systemFontOfSize:16];
                    if ([model.subjectCategorySn isEqualToString:@"JLBS"]){
                        [[NSUserDefaults standardUserDefaults]setValue: [model.subject valueForKey:@"name"] forKey:@"Physical"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    
                    if (_dataArr.count > 1) {
                        HealthTipsModel *nextmodel = _dataArr[indexPath.row+1];
                        NSString *nextTimeStr = [NSString string];
                        if (self.typeInteger == 0||self.typeInteger == 5) {
                            nextTimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",nextmodel.createTime]];
                        }else if (self.typeInteger == 1||self.typeInteger == 14){
                            nextTimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",nextmodel.createDate]];
                        }else{
                            nextTimeStr = nextmodel.createTime;
                        }
                        if (![timeStr isEqualToString:nextTimeStr]) {
                            cell.lineImageV2.hidden = YES;
                        }else{
                            cell.lineImageV2.hidden = NO;
                        }
                    }else{
                        cell.lineImageV2.hidden = YES;
                    }
                    
                    [cell assignmentCellWithModel:model withType:self.typeInteger];
                    return cell;
                }
               
            }else{
                
                HealthTipsModel *onAmodel = _dataArr[indexPath.row - 1];
                NSString *onTimeStr = [NSString string];
                if (self.typeInteger == 0||self.typeInteger == 5) {
                    onTimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",onAmodel.createTime]];
                }else if (self.typeInteger == 1||self.typeInteger == 14){
                    onTimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",onAmodel.createDate]];
                }else{
                    onTimeStr = onAmodel.createTime;
                }
                NSLog(@"==========%@",model.createTime);
                if ([timeStr isEqualToString:onTimeStr]) {
                    
                    if ([model.type isEqualToString:@"MedicRecord"]) {
                        HCY_DAVisceraNoTimeCell * cell =[tableView dequeueReusableCellWithIdentifier:@"HCY_DAVisceraNoTimeCell"];
                        if(cell==nil){
                            cell = [[HCY_DAVisceraNoTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCY_DAVisceraNoTimeCell"];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        if (indexPath.row < _dataArr.count -1) {
                            HealthTipsModel *nextAmodel = _dataArr[indexPath.row + 1];
                          NSString *notimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",model.createTime]];
                           NSString *nexttimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",nextAmodel.createTime]];
                            if (![notimeStr isEqualToString:nexttimeStr]) {
                                cell.lineImageV2.hidden = YES;
                            }else{
                                cell.lineImageV2.hidden = NO;
                            }
                        }else if (indexPath.row == _dataArr.count -1){
                            cell.lineImageV2.hidden = YES;
                        }
                        cell.doctorNameLabel.font = [UIFont systemFontOfSize:15];
                        cell.departmentNameLabel.font = [UIFont systemFontOfSize:15];
                        cell.CCLabel.font = [UIFont systemFontOfSize:15];
                        cell.createDateLabel.font=[UIFont systemFontOfSize:13.0];
                        NSLog(@"%@",model.medicRecord);
                        [model yy_modelSetWithJSON:model.medicRecord];
                        [cell assignmentNoVisceraWithModel:model];
                        return cell;
                    }else{
                        NoTimeLineCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell2"];
                        if(cell==nil){
                            cell = [[NoTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        
                        cell.createDateLabel.font=[UIFont systemFontOfSize:13.0];
                        cell.kindLabel.font = [UIFont systemFontOfSize:12];
                        cell.contentLabel.font=[UIFont systemFontOfSize:16];
                        if (indexPath.row < _dataArr.count -1) {
                            HealthTipsModel *nextAmodel = _dataArr[indexPath.row + 1];
                            NSString *nextTimeStr = [NSString string];
                            if (self.typeInteger == 0||self.typeInteger == 5) {
                                nextTimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",nextAmodel.createTime]];
                            }else if (self.typeInteger == 1||self.typeInteger == 14){
                                nextTimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",nextAmodel.createDate]];
                            }else{
                                nextTimeStr = nextAmodel.createTime;
                            }
                            if (![timeStr isEqualToString:nextTimeStr]) {
                                cell.lineImageV2.hidden = YES;
                            }else{
                                cell.lineImageV2.hidden = NO;
                            }
                        }else if (indexPath.row == _dataArr.count -1){
                            cell.lineImageV2.hidden = YES;
                        }
                        
                        
                        [cell assignmentNoCellWithModel:model withType:self.typeInteger];
                        return cell;
                    }
                  
                }else {
                    
                    if ([model.type isEqualToString:@"MedicRecord"]) {
                        HCY_DAVisceraCell * cell =[tableView dequeueReusableCellWithIdentifier:@"HCY_DAVisceraCell"];
                        if(cell==nil){
                            cell = [[HCY_DAVisceraCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCY_DAVisceraCell"];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        cell.doctorNameLabel.font = [UIFont systemFontOfSize:15];
                        cell.departmentNameLabel.font = [UIFont systemFontOfSize:15];
                        cell.CCLabel.font = [UIFont systemFontOfSize:15];
                        cell.timeLabel.font=[UIFont systemFontOfSize:16.0];
                        cell.createDateLabel.font=[UIFont systemFontOfSize:13.0];
                        
                        if (_dataArr.count > 1) {
                            HealthTipsModel *nextmodel = _dataArr[indexPath.row+1];
                            NSString *notimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",model.createTime]];
                            NSString *nexttimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",nextmodel.createTime]];
                            if (![notimeStr isEqualToString:nexttimeStr]) {
                                cell.lineImageV2.hidden = YES;
                            }else{
                                cell.lineImageV2.hidden = NO;
                            }
                        }else{
                            cell.lineImageV2.hidden = NO;
                        }
                        
                        [model yy_modelSetWithJSON:model.medicRecord];
                        [cell assignmentVisceraWithModel:model];
                        return cell;
                    }else{
                        TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                        if(cell==nil){
                            cell = [[TimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        cell.timeLabel.font=[UIFont systemFontOfSize:16.0];
                        cell.createDateLabel.font=[UIFont systemFontOfSize:13.0];
                        cell.contentLabel.font=[UIFont systemFontOfSize:16];
                        
                        if (indexPath.row < _dataArr.count -1) {
                            HealthTipsModel *nextAmodel = _dataArr[indexPath.row + 1];
                            NSString *nextTimeStr = [NSString string];
                            if (self.typeInteger == 0||self.typeInteger == 5) {
                                nextTimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",nextAmodel.createTime]];
                            }else if (self.typeInteger == 1||self.typeInteger == 14){
                                nextTimeStr = [self getDateStringWithOtherTimeStr:[NSString stringWithFormat:@"%@",nextAmodel.createDate]];
                            }else{
                                nextTimeStr = nextAmodel.createTime;
                            }
                            if (![timeStr isEqualToString:nextTimeStr]) {
                                cell.lineImageV2.hidden = YES;
                            }else{
                                cell.lineImageV2.hidden = NO;
                            }
                        }else if (indexPath.row == _dataArr.count -1){
                            cell.lineImageV2.hidden = YES;
                        }
                        
                        [cell assignmentCellWithModel:model withType:self.typeInteger];
                        return cell;
                    }
                    
                 
                }
            }
        }else{
            HealthTipsModel *model = _dataArr[indexPath.row];
            HCY_ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCY_ReportCell"];
            cell.quarterLabel.font = [UIFont systemFontOfSize:24];
            cell.timeLabel.font = [UIFont systemFontOfSize:14];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setReportModel:model withIndex:indexPath];
            return cell;
        }
    
    }else if (self.typeInteger ==2) {
        
        HealthTipsModel *model = _dataArr[indexPath.row];
        HCY_ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCY_ReportCell"];
        cell.quarterLabel.font = [UIFont systemFontOfSize:24];
        cell.timeLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setReportModel:model withIndex:indexPath];
        
        return cell;
        
        
    }else {
        
        HealthTipsModel *model = _dataArr[indexPath.row];;
        
        if(indexPath.row == 0 ){
            HCY_DAVisceraCell * cell =[tableView dequeueReusableCellWithIdentifier:@"HCY_DAVisceraCell"];
            if(cell==nil){
                cell = [[HCY_DAVisceraCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCY_DAVisceraCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.doctorNameLabel.font = [UIFont systemFontOfSize:15];
            cell.departmentNameLabel.font = [UIFont systemFontOfSize:15];
            cell.CCLabel.font = [UIFont systemFontOfSize:15];
            cell.timeLabel.font=[UIFont systemFontOfSize:16.0];
            cell.createDateLabel.font=[UIFont systemFontOfSize:13.0];
            
            if (_dataArr.count > 1) {
                HealthTipsModel *nextmodel = _dataArr[indexPath.row+1];
                if (![model.createTime isEqualToString:nextmodel.createTime]) {
                    cell.lineImageV2.hidden = YES;
                }else{
                    cell.lineImageV2.hidden = NO;
                }
            }else{
                cell.lineImageV2.hidden = YES;
            }
            
            
            [cell assignmentVisceraWithModel:model];
            return cell;
        }else{
            
            HealthTipsModel *onAmodel = _dataArr[indexPath.row - 1];
            if ([model.createTime isEqualToString:onAmodel.createTime]) {
                
                HCY_DAVisceraNoTimeCell * cell =[tableView dequeueReusableCellWithIdentifier:@"HCY_DAVisceraNoTimeCell"];
                if(cell==nil){
                    cell = [[HCY_DAVisceraNoTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCY_DAVisceraNoTimeCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                if (indexPath.row < _dataArr.count -1) {
                    HealthTipsModel *nextAmodel = _dataArr[indexPath.row + 1];
                    if (![model.createTime isEqualToString:nextAmodel.createTime]) {
                        cell.lineImageV2.hidden = YES;
                    }else{
                        cell.lineImageV2.hidden = NO;
                    }
                }else if (indexPath.row == _dataArr.count -1){
                    cell.lineImageV2.hidden = YES;
                }
                [cell assignmentNoVisceraWithModel:model];
                return cell;
            }else {
                
                HCY_DAVisceraCell * cell =[tableView dequeueReusableCellWithIdentifier:@"HCY_DAVisceraCell"];
                if(cell==nil){
                    cell = [[HCY_DAVisceraCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCY_DAVisceraCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.doctorNameLabel.font = [UIFont systemFontOfSize:15];
                cell.departmentNameLabel.font = [UIFont systemFontOfSize:15];
                cell.CCLabel.font = [UIFont systemFontOfSize:15];
                cell.timeLabel.font=[UIFont systemFontOfSize:16.0];
                cell.createDateLabel.font=[UIFont systemFontOfSize:13.0];
                
                if (indexPath.row < _dataArr.count -1) {
                    HealthTipsModel *nextAmodel = _dataArr[indexPath.row + 1];
                    if (![model.createTime isEqualToString:nextAmodel.createTime]) {
                        cell.lineImageV2.hidden = YES;
                    }else{
                        cell.lineImageV2.hidden = NO;
                    }
                }else if (indexPath.row == _dataArr.count -1){
                    cell.lineImageV2.hidden = YES;
                }
                [cell assignmentVisceraWithModel:model];
                return cell;
                
            }
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (self.topModel != nil && ![self.topModel isKindOfClass:[NSNull class]]) {
        NSLog(@"%@",self.topModel);
        GovSectionView *sectionV = [GovSectionView showWithModel:self.topModel];
        sectionV.tableView = self.tableView;
        sectionV.section = section;
        sectionV.delegate=self;
        return sectionV;
    }else{
        return nil;
    }
}

#pragma mark - 自定义sectionView的代理方法
- (void)sectionGestTap:(NSInteger)section withTapGesture:(UITapGestureRecognizer *)gest
{
    
    if(![UserShareOnce shareOnce].languageType&&![[UserShareOnce shareOnce].bindCard isEqualToString:@"1"]){
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还不是会员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        [av show];
        return;
    }
    
    HealthTipsModel *model = [[HealthTipsModel alloc]init];
    if(_dataArr.count > 0) {
        model = _dataArr[0];
    }
    
    NSString *idNim = [NSString stringWithFormat:@"%@",self.memberIDStr];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/member/service/reports.jhtml?memberChildId=%@&quarter=%@&year=%@",URL_PRE,idNim,self.topModel.quarter,self.topModel.year];
    ResultSpeakController *vc = [[ResultSpeakController alloc] init];
    vc.urlStr = url;
    vc.titleStr = ModuleZW(@"季度报告详情");
    vc.hidesBottomBarWhenPushed = YES;
    [[self viewController].navigationController pushViewController:vc animated:YES];
    
    
}

#pragma mark -- 选择每个cell执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HealthTipsModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    ////经络
    if ([model.subjectCategorySn isEqualToString:@"JLBS"] ||[model.type isEqualToString:@"JLBS"]) {
        NSString *aUrlle =  [NSString string];
        if ([model.type isEqualToString:@"JLBS"]){
            if([GlobalCommon stringEqualNull:model.link]) return;
            aUrlle= [NSString stringWithFormat:@"%@%@",URL_PRE,model.link];
        }else{
            aUrlle= [NSString stringWithFormat:@"%@member/service/reshow.jhtml?sn=%@&device=1",URL_PRE,[model.subject valueForKey:@"subject_sn"]];
        }
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = aUrlle;
        vc.titleStr = ModuleZW(@"经络详情");
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
    
    //体质
    if ([model.subjectCategorySn isEqualToString:@"TZBS"] ||[model.type isEqualToString:@"TZBS"]){
        
        NSString *tzUrlle = [NSString string];
        if ([model.type isEqualToString:@"TZBS"]){
            if([GlobalCommon stringEqualNull:model.link]) return;
            tzUrlle= [NSString stringWithFormat:@"%@%@",URL_PRE,model.link];
            ResultSpeakController *vc = [[ResultSpeakController alloc] init];
            vc.urlStr = tzUrlle;
            vc.titleStr = ModuleZW(@"体质详情");
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }else{
            ResultController *resultVC = [[ResultController alloc] init];
            resultVC.TZBSstr = [model.subject valueForKey:@"subject_sn"];
            //resultVC.titleStr = @"健康档案";
            resultVC.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:resultVC animated:YES];
        }
    }
    
    //// 脏腑
    if (![GlobalCommon stringEqualNull:model.physique_id] ||[model.type isEqualToString:@"ZFBS"] ) {
        NSString *zfStr = [NSString string];
        if ([model.type isEqualToString:@"ZFBS"]){
            
            if([GlobalCommon stringEqualNull:model.link]) return;
            zfStr = [NSString stringWithFormat:@"%@%@",URL_PRE,model.link] ;
        }else{
            NSString *idNim = [NSString stringWithFormat:@"%@",self.memberIDStr];
            zfStr = [[NSString alloc] initWithFormat:@"%@member/service/zf_report.jhtml?cust_id=%@&physique_id=%@&device=1",URL_PRE,idNim,model.physique_id];
        }
        //member/service/zf_report.jhtml?cust_id=32&physique_id=181224175130815054&device=1
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = zfStr;
        vc.titleStr = ModuleZW(@"脏腑详情");
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
    
    //心电图
    if ( ![GlobalCommon stringEqualNull:model.path] ||[model.type isEqualToString:@"ECG"]  ) {
        EEGDetailController *detail = [[EEGDetailController alloc] init];
        detail.hidesBottomBarWhenPushed = YES;
        if ([model.type isEqualToString:@"ECG"]){
            if([GlobalCommon stringEqualNull:model.link]) return;
            detail.dataPath = model.link;
        }else{
            detail.dataPath = model.path;
        }
       // UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detail];
//        self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//        self.hud.label.text = ModuleZW(@"加载中...");
        [[self viewController].navigationController pushViewController:detail animated:YES];
       // [[self viewController] presentViewController:nav animated:YES completion:nil];
    }
    
    //血压
    if (![GlobalCommon stringEqualNull:model.highPressure ] ||[model.type isEqualToString:@"BLOOD"] ) {
        
        NSString *xyurlStr = [NSString string];
        //            if ([model.type isEqualToString:@"BLOOD"]){
        //                if([GlobalCommon stringEqualNull:model.link]) return;
        //                urlStr= [NSString stringWithFormat:@"%@%@",URL_PRE,model.link];
        //            }else{
        xyurlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,self.memberIDStr,@(30)];
        //            }
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = xyurlStr;
        vc.titleStr =ModuleZW( @"血压详情");
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
        
    }
    
    //血氧
    if (![GlobalCommon stringEqualNull:model.density] ||[model.type isEqualToString:@"OXYGEN"]  ) {
        
        NSString *xyurlStr = [NSString string];
        //            if ([model.type isEqualToString:@"OXYGEN"]){
        //                if([GlobalCommon stringEqualNull:model.link]) return;
        //                urlStr= [NSString stringWithFormat:@"%@%@",URL_PRE,model.link];
        //            }else{
        xyurlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,self.memberIDStr,@(20)];
        //            }
        
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = xyurlStr;
        vc.titleStr = ModuleZW(@"血氧详情");
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
        
    }
    
    //体温
    
    if (![GlobalCommon stringEqualNull:model.temperature] ||[model.type isEqualToString:@"BODY"] ) {
        
        NSString *twurlStr = [NSString string];
        //            if ([model.type isEqualToString:@"BODY"]){
        //                if([GlobalCommon stringEqualNull:model.link]) return;
        //                urlStr= [NSString stringWithFormat:@"%@%@",URL_PRE,model.link];
        //            }else{
        twurlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,self.memberIDStr,@(40)];
        //            }
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = twurlStr;
        vc.titleStr = ModuleZW(@"体温详情");
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
    
    //血糖
    if ([model.type isEqualToString:@"SUGAR"] ) {
        
        NSString *xturlStr = [NSString string];
        //            if ([model.type isEqualToString:@"BODY"]){
        //                if([GlobalCommon stringEqualNull:model.link]) return;
        //                urlStr= [NSString stringWithFormat:@"%@%@",URL_PRE,model.link];
        //            }else{
        xturlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@&version=2",URL_PRE,self.memberIDStr,@(60)];

        //            }
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = xturlStr;
        vc.titleStr = ModuleZW(@"血糖详情");
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
    
    //呼吸
    if ([model.type isEqualToString:@"BREATH"] ) {
        
        NSString *hxurlStr = [NSString string];
        //            if ([model.type isEqualToString:@"BODY"]){
        //                if([GlobalCommon stringEqualNull:model.link]) return;
        //                urlStr= [NSString stringWithFormat:@"%@%@",URL_PRE,model.link];
        //            }else{
        hxurlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,self.memberIDStr,@(50)];
        
        //            }
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = hxurlStr;
        vc.titleStr = ModuleZW(@"呼吸详情");
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
    
    
    
    if ([model.type isEqualToString:@"REPORT"] ) {
        
        if(![UserShareOnce shareOnce].languageType&&![[UserShareOnce shareOnce].bindCard isEqualToString:@"1"]){
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还不是会员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
            return;
        }
        
        NSString *idNim = [NSString stringWithFormat:@"%@",self.memberIDStr];
        if([GlobalCommon stringEqualNull:model.link]) return;
        NSString *url = [[NSString alloc] initWithFormat:@"%@%@",URL_PRE,model.link];
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = url;
        vc.titleStr = ModuleZW(@"季度报告详情");
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
    
    
    //病历列表
    if (![GlobalCommon stringEqualNull:model.medicRecordId]||[model.type isEqualToString:@"MedicRecord"]){
# pragma mark -  病历列表

        #if TARGET_IPHONE_SIMULATOR

        #else
         if (![GlobalCommon stringEqualNull:model.medicRecordId]){
             NSString *resultStr = [NSString string];
             if([model.type isEqualToString:@"MedicRecord"]){
                 NSString *userTokenStr = [model.medicRecord valueForKey:@"userToken"];
                 NSString *medicRecordIdStr = [model.medicRecord valueForKey:@"medicRecordId"];
                 if (![GlobalCommon stringEqualNull:userTokenStr]&&![GlobalCommon stringEqualNull:medicRecordIdStr]) {
                       resultStr = [[HHMSDK default] getMedicDetailWithUserToken:userTokenStr medicId:medicRecordIdStr];
                 }else{
                     return;
                 }
             }else{
                 resultStr = [[HHMSDK default] getMedicDetailWithUserToken:model.userToken medicId:model.medicRecordId];
             }
             //NSString *resultStr = [[HHMSDK default] getMedicDetailWithUserToken:[UserShareOnce shareOnce].userToken medicId:model.medicRecordId];
            //测试环境
            //NSString *resultStr = [[HHMSDK default] getMedicDetailWithUserToken:@"E97C4CD92C12E6C935CDAA39C1380DC7CCCB578FFE9820E7F43A1807648A85D9" medicId:@"1566359270792"];
            //NSLog(@"token:%@,iddddd:%@",[UserShareOnce shareOnce].userToken,model.medicRecordId);
            ResultSpeakController *vc = [[ResultSpeakController alloc] init];
            vc.urlStr = resultStr;
            vc.titleStr = @"病历详情";
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
         }
        #endif
        
                
    }
    
    
    //季度报告
    if (model.quarter != nil && ![model.quarter isKindOfClass:[NSNull class]]&&model.quarter.length != 0) {
        
        if(![UserShareOnce shareOnce].languageType&&![[UserShareOnce shareOnce].bindCard isEqualToString:@"1"]){
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还不是会员" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [av show];
            return;
        }
        
        NSString *idNim = [NSString stringWithFormat:@"%@",self.memberIDStr];
        
        NSString *resulturl = [[NSString alloc] initWithFormat:@"%@/member/service/reports.jhtml?memberChildId=%@&quarter=%@&year=%@",URL_PRE,idNim,model.quarter,model.year];
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = resulturl;
        vc.titleStr = ModuleZW(@"季度报告详情");
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
        
    }
    
    if (model.pictures||[model.type isEqualToString:@"memberHealthr"]) {
        UploadReportDetailsViewController *vc = [[UploadReportDetailsViewController alloc]init];
        if ([model.type isEqualToString:@"memberHealthr"]) {
            HealthTipsModel *model1 = _dataArr[indexPath.row];
            vc.model = [[HealthTipsModel alloc]init];
            [vc.model yy_modelSetWithJSON:model1.memberHealthr];
        }else{
            vc.model = _dataArr[indexPath.row];
        }
        
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (ArchivesController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[ArchivesController class]]) {
            return (ArchivesController *)nextResponder;
        }
    }
    return nil;
}

-(NSString *)getDateStringWithOtherTimeStr:(NSString *)str{
    NSTimeInterval time=[str doubleValue]/1000;//传入的时间戳str如果是精确到毫秒的记得要/1000
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
    //设定时间格式,这里可以设置成自己需要的格式
    NSString *dateStr = [NSString stringWithFormat:@"yyyy-MM-dd"];
    [dateFormatter setDateFormat:dateStr];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}


//排序
// 将数组按照时间戳排序
//- (NSMutableArray *)sortWithdataArray:(NSMutableArray *)array {
//
//
//    return sortArray;
//
//}

//cell的点击事件


//# pragma mark - 让section头视图和cell一起滚动
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = 40;
//    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//            }
//
//        //禁止下拉
//                CGPoint offset = self.tableView.contentOffset;
//                if (offset.y <= 0) {
//                    offset.y = 0;
//                }
//                self.tableView.contentOffset = offset;
//    }
//
//}

@end

