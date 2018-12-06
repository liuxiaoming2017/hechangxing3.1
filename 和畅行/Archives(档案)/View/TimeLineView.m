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
}

-(void)relodTableViewWitDataArray:(NSMutableArray *)dataArray withType:(NSInteger)type {
    self.typeInteger = type;
    self.dataArr = dataArray;
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
    return 90;
}

#pragma mark -- 每个cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.typeInteger == 0) {
//
//    }else
    if (self.typeInteger == 1 || self.typeInteger == 2) {
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
    
   
    
//    TimeLineModel*model = self.dataArr[indexPath.row];
//
//    return [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[TimeLineCell class] contentViewWidth:self.frame.size.width];
}
#pragma mark -- 每个cell显示的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HealthTipsModel *model = _dataArr[indexPath.row];
    
    
    if (self.typeInteger == 1|| self.typeInteger == 2) {
        
        
        if(indexPath.row == 0 ){
            TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
            if(cell==nil){
                cell = [[TimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                [cell assignmentNoCellWithModel:model];
                return cell;
            }else {
                
                TimeLineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
                if(cell==nil){
                    cell = [[TimeLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell assignmentCellWithModel:model];
                return cell;
            }
        }
        
    }else {
        
        if(indexPath.row == 0 ){
            HCY_DAVisceraCell * cell =[tableView dequeueReusableCellWithIdentifier:@"HCY_DAVisceraCell"];
            if(cell==nil){
                cell = [[HCY_DAVisceraCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCY_DAVisceraCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                [cell assignmentNoVisceraWithModel:model];
                return cell;
            }else {
                
                HCY_DAVisceraCell * cell =[tableView dequeueReusableCellWithIdentifier:@"HCY_DAVisceraCell"];
                if(cell==nil){
                    cell = [[HCY_DAVisceraCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HCY_DAVisceraCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                [cell assignmentVisceraWithModel:model];
                return cell;
                
            }
        }
        
        
       
        
    }
   
    
    
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//    GovSectionView *sectionV = [GovSectionView showWithName:@"" withSection:section];
//    sectionV.tableView = self.tableView;
//    sectionV.section = section;
//    sectionV.delegate=self;
//    return nil;
//}

#pragma mark - 自定义sectionView的代理方法
- (void)sectionGestTap:(NSInteger)section withTapGesture:(UITapGestureRecognizer *)gest
{
    UIView *sectionV = gest.view;
    NSInteger sectionTag = sectionV.tag-100;
    NSInteger sect = 0;
    if(sectionV.superview ==self.tableView){
        sect = sectionTag;
    }else{
        sect = sectionTag;
    }
    
}

#pragma mark -- 选择每个cell执行的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

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
