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
//#import <HHDoctorSDK/HHDoctorSDK-Swift.h>

@interface TimeLineView()<UITableViewDelegate,UITableViewDataSource,govSectionViewDelegate>



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
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundView=nil;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    [self.tableView registerClass:[HCY_ReportCell class] forCellReuseIdentifier:@"HCY_ReportCell"];
}

-(void)relodTableViewWitDataArray:(NSMutableArray *)dataArray withType:(NSInteger)type {
    self.typeInteger = type;
   
    if (dataArray.count > 0){
        HealthTipsModel *model = dataArray[0];
        if (model.quarter != nil && ![model.quarter isKindOfClass:[NSNull class]]&&model.quarter.length != 0) {
            self.topModel = model;
            [dataArray removeObjectAtIndex:0];
        }
    }
    
    self.dataArr = dataArray;
        
    if (_typeInteger == 0) {
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
    if (self.topModel != nil && ![self.topModel isKindOfClass:[NSNull class]]) {
        return 90;
    }else{
        return 0;
    }
}

#pragma mark -- 每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.typeInteger == 1 || self.typeInteger == 2||self.typeInteger == 0) {
        if (indexPath.row == 0) {
            return 105;
        }else {
            HealthTipsModel *model = _dataArr[indexPath.row];
            HealthTipsModel *onAmodel = _dataArr[indexPath.row - 1];

            if ([model.createTime isEqualToString:onAmodel.createTime]) {
                return 65;
            }else {
                return 105;
            }
        }
    }if (self.typeInteger == 10) {
         return 120;
    }else {
        
        if (indexPath.row == 0) {
            return 130;
        }else {
            HealthTipsModel *model = _dataArr[indexPath.row];
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
        
    if (self.typeInteger == 1|| self.typeInteger == 2||self.typeInteger == 0) {
        
        HealthTipsModel *model = _dataArr[indexPath.row];

        if(indexPath.row == 0 ){
            TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if(cell==nil){
                cell = [[TimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if ([model.subjectCategorySn isEqualToString:@"JLBS"]){
                [[NSUserDefaults standardUserDefaults]setValue: [model.subject valueForKey:@"name"] forKey:@"Physical"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
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
            
            [cell assignmentCellWithModel:model];
            return cell;
        }else{
            
           
            HealthTipsModel *onAmodel = _dataArr[indexPath.row - 1];
            if ([model.createTime isEqualToString:onAmodel.createTime]) {
                
                NoTimeLineCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell2"];
                if(cell==nil){
                    cell = [[NoTimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
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

                [cell assignmentNoCellWithModel:model];
                return cell;
            }else {
                
                TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                if(cell==nil){
                    cell = [[TimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
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
                
                [cell assignmentCellWithModel:model];
                return cell;
            }
        }
        
    }
    if (self.typeInteger == 10) {
        
        HealthTipsModel *model = _dataArr[indexPath.row];
        HCY_ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HCY_ReportCell"];
        
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
            
            if (_dataArr.count > 1) {
                HealthTipsModel *nextmodel = _dataArr[indexPath.row+1];
                if (![model.createTime isEqualToString:nextmodel.createTime]) {
                    cell.lineImageV2.hidden = YES;
                }else{
                    cell.lineImageV2.hidden = NO;
                }
            }else{
                cell.lineImageV2.hidden = NO;
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
    
    HealthTipsModel *model = [[HealthTipsModel alloc]init];
    if(_dataArr.count > 0) {
        model = _dataArr[0];
    }
    
    NSString *idNim = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@/member/service/reports.jhtml?memberChildId=%@&quarter=%@&year=%@",URL_PRE,idNim,model.quarter,model.year];
    ResultSpeakController *vc = [[ResultSpeakController alloc] init];
    vc.urlStr = url;
    [[self viewController].navigationController pushViewController:vc animated:YES];

    
}

#pragma mark -- 选择每个cell执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    HealthTipsModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    ////经络
    if ([model.subjectCategorySn isEqualToString:@"JLBS"]) {
        NSString *aUrlle= [NSString stringWithFormat:@"%@member/service/reshow.jhtml?sn=%@&device=1",URL_PRE,[model.subject valueForKey:@"subject_sn"]];
        
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = aUrlle;
        vc.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:vc animated:YES];
        
    }else  if ([model.subjectCategorySn isEqualToString:@"TZBS"]){
        
        ResultController *resultVC = [[ResultController alloc] init];
        resultVC.TZBSstr = [model.subject valueForKey:@"subject_sn"];
        resultVC.hidesBottomBarWhenPushed = YES;
        [[self viewController].navigationController pushViewController:resultVC animated:YES];
        
    }else {
            
        //// 脏腑
        if (![model.physique_id isKindOfClass:[NSNull class]]&&model.physique_id!=nil&&model.physique_id.length!=0) {
            
            NSString *idNim = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
            //member/service/zf_report.jhtml?cust_id=32&physique_id=181224175130815054&device=1
            NSString *url = [[NSString alloc] initWithFormat:@"%@member/service/zf_report.jhtml?cust_id=%@&physique_id=%@&device=1",URL_PRE,idNim,model.physique_id];
            ResultSpeakController *vc = [[ResultSpeakController alloc] init];
            vc.urlStr = url;
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }
        
        //心电图
        if ([model.subject valueForKey:@"subject_sn"] != nil&&![[model.subject valueForKey:@"subject_sn"] isKindOfClass:[NSNull class]]) {
            
            EEGDetailController *detail = [[EEGDetailController alloc] init];
            detail.dataPath = model.path;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:detail];
            self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            self.hud.label.text = @"加载中...";
            [[self viewController] presentViewController:nav animated:YES completion:nil];
            
        }
        
        //血压
        if (model.highPressure != nil&&![model.highPressure isKindOfClass:[NSNull class]]&&model.highPressure.length != 0) {
            
            NSString *urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,[MemberUserShance shareOnce].idNum,@(30)];
           
            ResultSpeakController *vc = [[ResultSpeakController alloc] init];
            vc.urlStr = urlStr;
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
            
            
        }
        
        //血氧
        
        if (model.density != nil&&![model.density isKindOfClass:[NSNull class]]&&model.density.length != 0) {
            
            NSString *urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,[MemberUserShance shareOnce].idNum,@(20)];

            ResultSpeakController *vc = [[ResultSpeakController alloc] init];
            vc.urlStr = urlStr;
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
            
        }
        
        //体温
        
        if (model.temperature != nil&&![model.temperature isKindOfClass:[NSNull class]]&&model.temperature.length != 0) {
            
            
             NSString *urlStr = [NSString stringWithFormat:@"%@subject_report/getreport.jhtml?mcId=%@&datatype=%@",URL_PRE,[MemberUserShance shareOnce].idNum,@(20)];
           
            ResultSpeakController *vc = [[ResultSpeakController alloc] init];
            vc.urlStr = urlStr;
            vc.hidesBottomBarWhenPushed = YES;
            [[self viewController].navigationController pushViewController:vc animated:YES];
        }
    }
    
    
    //病例列表
    if (model.medicRecordId!=nil&&![model.medicRecordId isKindOfClass:[NSNull class]]&&model.medicRecordId.length!=0){
# pragma mark -  病例列表
//        NSString *resultStr = [[HHMSDK default] getMedicDetailWithUserToken:testToken medicId:testMedicId];
//        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
//        vc.urlStr = resultStr;
//        vc.titleStr = @"病例详情";
//        vc.hidesBottomBarWhenPushed = YES;
//        [[self viewController].navigationController pushViewController:vc animated:YES];
        
    }
    
    
 //季度报告
    if (model.quarter != nil && ![model.quarter isKindOfClass:[NSNull class]]&&model.quarter.length != 0) {
        
        
        NSString *idNim = [NSString stringWithFormat:@"%@",[MemberUserShance shareOnce].idNum];
        
        NSString *url = [[NSString alloc] initWithFormat:@"%@/member/service/reports.jhtml?memberChildId=%@&quarter=%@&year=%@",URL_PRE,idNim,model.quarter,model.year];
        ResultSpeakController *vc = [[ResultSpeakController alloc] init];
        vc.urlStr = url;
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
