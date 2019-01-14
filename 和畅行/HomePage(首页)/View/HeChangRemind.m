//
//  HeChangRemind.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/9.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HeChangRemind.h"
#import "RemindCell.h"
#import "RemindModel.h"
#import "HeChangPackgeController.h"
#import "SayAndWriteController.h"
#import "MeridianIdentifierViewController.h"
#import "TipSpeakController.h"
#import "WriteListController.h"
#import "TipWriteController.h"
#import "QuestionListController.h"
#import "TipClickController.h"



@interface HeChangRemind()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) CALayer *subLayer;

@end

@implementation HeChangRemind

@synthesize subLayer;

- (id)initWithFrame:(CGRect)frame withDataArr:(NSArray *)arr
{
    self = [super initWithFrame:frame];
    self.dataArr = arr;
    if(self){
        [self createupUI];
    }
    return self;
}

- (void)createupUI
{
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    imageV.tag = 200;
    imageV.layer.cornerRadius = 8.0;
    imageV.layer.masksToBounds = YES;
    imageV.backgroundColor = [UIColor whiteColor];
    //[self addSubview:imageV];
    
  //  [self insertSublayerWithImageView:imageV];
    
    //self.backgroundColor = [UIColor whiteColor];
    
    NSString *titleStr = [self getCurrentTime];
    CGSize strSize = [titleStr boundingRectWithSize:CGSizeMake(1190, 2500) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:[[UIFont systemFontOfSize:1] fontName] size:18]} context:nil].size;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 15, strSize.width, strSize.height)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = titleStr;
    [self addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.right+6, titleLabel.top, 200, strSize.height)];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.textColor = UIColorFromHex(0X8E8E93);
    timeLabel.text = @"和畅提醒";
    [self addSubview:timeLabel];
    
//    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(80, 51, ScreenWidth-14*2-80-5, 1)];
//    lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
//    [self addSubview:lineImageV];
    
    //添加tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52, self.frame.size.width, (45+14)*self.dataArr.count) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor=[UIColor clearColor];
    self.tableView.backgroundView=nil;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.scrollEnabled = NO;
    
    [self addSubview:self.tableView];
    
}


#pragma mark - tableview代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45+14;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.dataArr.count>0){
        return self.dataArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RemindCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RemindCell"];
    if(cell == nil){
        cell = [[RemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RemindCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if(self.dataArr.count>indexPath.row){
        RemindModel *model = [self.dataArr objectAtIndex:indexPath.row];
        cell.typeLabel.text = model.type;
        if([model.type isEqualToString:@"一说"]){
            cell.lineImageV.backgroundColor = UIColorFromHex(0X66A8E9);
        }else if ([model.type isEqualToString:@"一写"]){
             cell.lineImageV.backgroundColor = UIColorFromHex(0XF0B764);
        }else{
             cell.lineImageV.backgroundColor = UIColorFromHex(0X8992F0);
        }
        cell.contentLabel.text = model.advice;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SayAndWriteController *vc = nil;
    RemindCell *cell = (RemindCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString *type = @"";
    NSString *fangtype = @"";
    NSString *titleStr = @"";
    NSString *urlStr = @"";
    
    if([cell.typeLabel.text isEqualToString:@"一说"]){
        
        if([self isFirestClickThePageWithString:@"speak"]){
            vc = [[MeridianIdentifierViewController alloc] init];
        }else{
            vc = [[TipSpeakController alloc] init];
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.typeLabel.text isEqualToString:@"一写"]){
        
        if([self isFirestClickThePageWithString:@"write"]){
            vc = [[WriteListController alloc] init];
        }else{
            vc = [[TipWriteController alloc] init];
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
    }else if ([cell.typeLabel.text isEqualToString:@"一点"]){
        
        if([self isFirestClickThePageWithString:@"click"]){
            vc = [[QuestionListController alloc] init];
        }else{
            vc = [[TipClickController alloc] init];
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:vc animated:YES];
        
    }else {
        if ([cell.typeLabel.text isEqualToString:@"一听"]){
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yiting";
            titleStr = @"音乐处方";
        }else if ([cell.typeLabel.text isEqualToString:@"一站"]){
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yizhan";
            titleStr = @"运动处方";
        }else if ([cell.typeLabel.text isEqualToString:@"一推"]){
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yitui";
            titleStr = @"推拿处方";
        }
        
        urlStr = [NSString stringWithFormat:@"%@%@%@.jhtml?type=%@",URL_PRE,type,[MemberUserShance shareOnce].idNum,fangtype];
        HeChangPackgeController *hechangVc = [[HeChangPackgeController alloc] init];
        hechangVc.progressType = progress2;
        hechangVc.urlStr = urlStr;
        hechangVc.titleStr = titleStr;
        hechangVc.hidesBottomBarWhenPushed = YES;
        [self.viewController.navigationController pushViewController:hechangVc animated:YES];
    }
}

- (void)updateViewWithData:(NSArray *)arr withHeight:(CGFloat)height
{
    UIImageView *imgV = [self viewWithTag:200];
    self.dataArr = arr;
    self.tableView.height = height;
    imgV.height = height;
    [self insertSublayerWithImageView:imgV];
    self.height = height;
    [self.tableView reloadData];
    
}

# pragma mark - 获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

-(void)insertSublayerWithImageView:(UIImageView *)imageV
{
    if(!subLayer){
        subLayer=[CALayer layer];
        CGRect fixframe = imageV.frame;
        subLayer.frame= fixframe;
        subLayer.cornerRadius=8;
        subLayer.backgroundColor=[UIColorFromHex(0xffffff) colorWithAlphaComponent:1.0].CGColor;
        
        subLayer.masksToBounds=NO;
        subLayer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        subLayer.shadowOffset = CGSizeMake(0,1);//shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOpacity = 0.4;//阴影透明度，默认0
        subLayer.shadowRadius = 4;//阴影半径，默认3
        [self.layer insertSublayer:subLayer below:imageV.layer];
    }else{
        subLayer.frame = imageV.frame;
    }
    
}

- (BOOL)isFirestClickThePageWithString:(NSString *)string
{
    NSString *userName = [UserShareOnce shareOnce].username;
    NSString *writeKey = [NSString stringWithFormat:@"%@_%@",userName,string];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([[userDefaults objectForKey:writeKey] isEqualToString:@"1"]){
        return YES;
    }else{
        [userDefaults setObject:@"1" forKey:writeKey];
        [userDefaults synchronize];
        return NO;
    }
    return NO;
}

@end
