//
//  MyAdvisoryDetailsViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/12.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "MyAdvisoryDetailsViewController.h"
#import "UIImageView+WebCache.h"

@interface MyAdvisoryDetailsViewController ()

@end

@implementation MyAdvisoryDetailsViewController
- (void)dealloc{
   
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"咨询详情";
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height )];
    [self.view addSubview:scrollView];
    UIImageView *bottomView = [[UIImageView alloc]init];
    bottomView.image = [UIImage imageNamed:@"我的121咨询_04.png"];
    bottomView.frame = CGRectMake(self.view.frame.size.width / 2 - 50, 0, 125, 20);
    [scrollView addSubview:bottomView];
    
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 0, 125, 20)];
    timeLab.font = [UIFont systemFontOfSize:11];
    timeLab.textColor = [UIColor whiteColor];
    NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:[[self.dataDic  objectForKey:@"modifyDate"] doubleValue]/1000.00];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    
    NSString *confromTimespStr = [formatter stringFromDate:data];
    timeLab.text = confromTimespStr;
    timeLab.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:timeLab];
   
    UIImageView *personImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 38, 21, 14.5)];
    //qwewqewqe
    personImage.image = [UIImage imageNamed:@"qq11个人信息_03.png"];
    [scrollView addSubview:personImage];
   
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.frame = CGRectMake(46, 38, 60, 15);
    nameLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
    nameLabel.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:nameLabel];
   
    
    UILabel *sexLabel = [[UILabel alloc]init];
    sexLabel.frame = CGRectMake(110, 38, 100, 15);
    sexLabel.textAlignment = NSTextAlignmentCenter;
    sexLabel.textColor = [UtilityFunc colorWithHexString:@"#333333"];
    sexLabel.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:sexLabel];
    
    UILabel *answerLabel = [[UILabel alloc]init];
    //answerLabel.textColor = [UtilityFunc colorWithHexString:@"#fe6f5f"];
    answerLabel.font = [UIFont systemFontOfSize:12];
    [scrollView addSubview:answerLabel];
    
    UILabel *contentlabel = [[UILabel alloc]init];
    
    contentlabel.textColor = [UtilityFunc colorWithHexString:@"#adadb0"];
    contentlabel.font = [UIFont systemFontOfSize:12];
    contentlabel.numberOfLines = 0;
    contentlabel.text = [self.dataDic objectForKey:@"content"];
    [scrollView addSubview:contentlabel];

    CGRect rect = [contentlabel.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    float heiget = rect.size.height;
    
    contentlabel.frame = CGRectMake(15, 66, self.view.frame.size.width - 30, heiget +10);
    if ([[UserShareOnce shareOnce].name isEqual:[NSNull null]]) {
        nameLabel.text = [UserShareOnce shareOnce].username;
    }else{
        nameLabel.text = [UserShareOnce shareOnce].name;
    }
    
    NSString *sexStr = @"";
    int age = 0;
    if ([[[self.dataDic objectForKey:@"memberChild"]objectForKey:@"gender"]isEqual:[NSNull null]]||[[[self.dataDic objectForKey:@"memberChild"]objectForKey:@"gender"] isEqualToString:@"male"]) {
        sexStr = @"男";
    }else{
        sexStr = @"女";
    }
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    now=[NSDate date];
    comps = [calendar components:unitFlags fromDate:now];
    
    if ([[[self.dataDic objectForKey:@"memberChild"]objectForKey:@"birthday"]isEqual:[NSNull null]]) {
        age = 0;
    }else{
        
        age = (int)[comps year] - [[[[self.dataDic objectForKey:@"memberChild"]objectForKey:@"birthday"] substringToIndex:4] intValue];
        
        
    }
    sexLabel.text = [NSString stringWithFormat:@"(%@%d岁)",sexStr,age];
    
    UIScrollView *scrollViews = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 101+heiget, self.view.frame.size.width, 80)];
    [scrollView addSubview:scrollViews];
    
    NSArray *array = [self.dataDic objectForKey:@"userConsultationImages"];
    if (array.count == 0) {
        
    }else{
        for (int i = 0; i <array.count; i++) {
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(82*i + 5, 0, 80, 80)];
            NSString *string = [NSString stringWithFormat:@"%@",array[i]];
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:string]];
            [scrollViews addSubview:imageV];
            // image.backgroundColor = [UIColor redColor];
            
        }
    }
    scrollViews.contentSize = CGSizeMake(82*array.count+10, 0) ;
    heiget+=100;
    if ([[self.dataDic objectForKey:@"replyUserConsultations"] isEqual:[NSNull null]]) {
        
    }else{
        UIImageView *bottomViews = [[UIImageView alloc]init];
        bottomViews.image = [UIImage imageNamed:@"我的121咨询_04.png"];
        bottomViews.frame = CGRectMake(self.view.frame.size.width / 2 - 50, 165 + heiget, 125, 20);
        [scrollView addSubview:bottomViews];
       
        UILabel *timeLabs = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 165 + heiget, 125, 20)];
        timeLabs.font = [UIFont systemFontOfSize:11];
        timeLabs.textColor = [UIColor whiteColor];
        NSDate *datas = [[NSDate alloc]initWithTimeIntervalSince1970:[[[[self.dataDic objectForKey:@"replyUserConsultations"]objectForKey:@"memberChild"] objectForKey:@"modifyDate"] doubleValue]/1000.00];
        NSDateFormatter *formatters = [[NSDateFormatter alloc] init];
        [formatters setDateStyle:NSDateFormatterMediumStyle];
        [formatters setTimeStyle:NSDateFormatterShortStyle];
        [formatters setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatters setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
        
        NSString *confromTimespStrs = [formatters stringFromDate:datas];
        timeLabs.text = confromTimespStrs;
        //timeLabs.textColor= [UIColor redColor];
        timeLabs.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:timeLabs];
        
        UIImageView *personImages = [[UIImageView alloc]initWithFrame:CGRectMake(15, 195 +heiget, 21, 14.5)];
        personImages.image = [UIImage imageNamed:@"zixunxiangqinghuifu.png"];
        [scrollView addSubview:personImages];
        
        
        
        UILabel *nameLabels = [[UILabel alloc]init];
        nameLabels.frame = CGRectMake(46, 195 + heiget, 60, 15);
        nameLabels.textColor = [UtilityFunc colorWithHexString:@"#333333"];
        nameLabels.text = @"医生解答";
        nameLabels.font = [UIFont systemFontOfSize:12];
        [scrollView addSubview:nameLabels];
        
        CGRect rect = [[[self.dataDic objectForKey:@"replyUserConsultations"]objectForKey:@"content"] boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
        float labelHeight = rect.size.height;
        UILabel *replyUserConsultations = [[UILabel alloc]initWithFrame:CGRectMake(15, 215 + heiget, self.view.frame.size.width - 30, labelHeight + 30)];
        replyUserConsultations.numberOfLines = 0;
        replyUserConsultations.text = [NSString stringWithFormat:@"%@",[[self.dataDic objectForKey:@"replyUserConsultations"]objectForKey:@"content"]];
        replyUserConsultations.font = [UIFont systemFontOfSize:12];
        replyUserConsultations.textColor = [UtilityFunc colorWithHexString:@"#7d7d7d"];
        [scrollView addSubview:replyUserConsultations];
  
        scrollView.contentSize = CGSizeMake(0, 250 +heiget +labelHeight);
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
