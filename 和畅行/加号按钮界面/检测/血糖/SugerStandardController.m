//
//  SugerStandardController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/21.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SugerStandardController.h"
#import "SugerViewController.h"

@interface SugerStandardController ()

@end

@implementation SugerStandardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = ModuleZW(@"血糖检测");
    [self createUI];
}

- (void)createUI
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(Adapter(20), kNavBarHeight+Adapter(20), ScreenWidth-Adapter(40), ScreenHeight-kNavBarHeight-Adapter(40))];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(Adapter(15), Adapter(15), Adapter(15), Adapter(15))];
    image1.image = [UIImage imageNamed:@"检测_感叹号"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(image1.right+Adapter(5), Adapter(2), Adapter(200), Adapter(40))];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = ModuleZW(@"注意事项");
    [topView addSubview:image1];
    [topView addSubview:titleLabel];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(image1.left, image1.bottom+Adapter(40), Adapter(15), Adapter(15))];
    image2.image = [UIImage imageNamed:@"检测_01"];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(image2.right+Adapter(10), image2.top-Adapter(2), topView.width-image2.right-Adapter(20), Adapter(50))];
    label2.numberOfLines = 0;
    label2.font = [UIFont systemFontOfSize:15];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.textColor = UIColorFromHex(0X8E8E93);
    label2.text = ModuleZW(@"空腹12-14小时，抽血。前一次进餐要正常饮食，不暴饮暴食。");
    CGRect textRect = [label2.text boundingRectWithSize:CGSizeMake(ScreenWidth - image2.right - Adapter(20), MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    label2.height = textRect.size.height;
    [topView addSubview:label2];
    
    
    
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(image2.left, label2.bottom+Adapter(20), image2.width, image2.height)];
    image3.image = [UIImage imageNamed:@"检测_02"];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(image3.right+Adapter(10), image3.top-Adapter(2), topView.width-image2.right-Adapter(20), Adapter(40))];
    label3.font = [UIFont systemFontOfSize:15];
    label3.numberOfLines = 0;
    label3.textAlignment = NSTextAlignmentLeft;
    label3.textColor = UIColorFromHex(0X8E8E93);
    label3.text = ModuleZW(@"既餐后两小时的时候抽血，随后进行测试。");
    CGRect textRect3 = [label3.text boundingRectWithSize:CGSizeMake(topView.width-image2.right-Adapter(20), MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    label3.height = textRect3.size.height;
    [topView addSubview:label3];
    
    UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(image3.left, label3.bottom+Adapter(20), image2.width, image2.height)];
    image4.image = [UIImage imageNamed:@"检测_03"];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(image3.right+Adapter(10), image4.top-Adapter(2), topView.width-image2.right-Adapter(20), Adapter(40))];
    label4.font = [UIFont systemFontOfSize:15];
    label4.numberOfLines = 0;
    label4.textAlignment = NSTextAlignmentLeft;
    label4.textColor = UIColorFromHex(0X8E8E93);
    label4.text = ModuleZW(@"既餐后两小时的时候抽血，正常11.1以下。");
    CGRect textRect4 = [label4.text boundingRectWithSize:CGSizeMake(topView.width-image2.right-Adapter(20), MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    label4.height = textRect4.size.height;
    [topView addSubview:label4];
    
    [topView addSubview:image2];
    [topView addSubview:image3];
    [topView addSubview:image4];
    [self createBottomView];
}

- (void)createBottomView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-Adapter(110), kScreenSize.width, Adapter(110))];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:ModuleZW(@"流程介绍页_02")];
    [self.view addSubview:imageView];
    
    UIButton *checkInstance = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-Adapter(60), Adapter(18), Adapter(120), Adapter(30)) target:self sel:@selector(chekInstaceClick:) tag:11 image:ModuleZW(@"立即检测") title:nil];
    [imageView addSubview:checkInstance];
    
    UIButton *neverCaution = [Tools creatButtonWithFrame:CGRectMake(kScreenSize.width/2-Adapter(60), Adapter(63), Adapter(120), Adapter(30)) target:self sel:@selector(neverCautionClick:) tag:12 image:ModuleZW(@"不再提醒") title:nil];
    [imageView addSubview:neverCaution];
}

-(void)chekInstaceClick:(UIButton *)button{
    NSLog(@"点击立即检测");
    SugerViewController *pressure = [[SugerViewController alloc] init];
    [self.navigationController pushViewController:pressure animated:YES];
}

-(void)neverCautionClick:(UIButton *)button{
    NSLog(@"点击不再提醒");
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sugerNeverCaution"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    SugerViewController *pressure = [[SugerViewController alloc] init];
    [self.navigationController pushViewController:pressure animated:YES];
    
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
