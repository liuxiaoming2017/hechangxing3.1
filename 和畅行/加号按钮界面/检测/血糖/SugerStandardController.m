//
//  SugerStandardController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/21.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SugerStandardController.h"

@interface SugerStandardController ()

@end

@implementation SugerStandardController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"血糖检测";
    [self createUI];
}

- (void)createUI
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(20, kNavBarHeight+20, ScreenWidth-40, ScreenHeight-kNavBarHeight-40)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 15, 15)];
    image1.image = [UIImage imageNamed:@"检测_感叹号"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(image1.right+5, 2, 200, 40)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    //titleLabel.textColor = UIColorFromHex(0X1E82D2);
    titleLabel.text = @"注意事项";
    [topView addSubview:image1];
    [topView addSubview:titleLabel];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(image1.left, image1.bottom+40, 15, 15)];
    image2.image = [UIImage imageNamed:@"检测_01"];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(image2.right+10, image2.top-15, topView.width-image2.right-20, 40)];
    label2.numberOfLines = 0;
    label2.font = [UIFont systemFontOfSize:15];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.textColor = UIColorFromHex(0X8E8E93);
    label2.text = @"空腹12-14小时，抽血。前一次进餐要正常饮食，不暴饮暴食。";
    [topView addSubview:label2];
    
    
    
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(image2.left, image2.bottom+40, image2.width, image2.height)];
    image3.image = [UIImage imageNamed:@"检测_02"];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(image3.right+10, image3.top-2, topView.width-image2.right-20, 20)];
    label3.font = [UIFont systemFontOfSize:15];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.textColor = UIColorFromHex(0X8E8E93);
    label3.text = @"既餐后两小时的时候抽血，随后进行测试。";
    [topView addSubview:label3];
    
    UIImageView *image4 = [[UIImageView alloc] initWithFrame:CGRectMake(image3.left, image3.bottom+40, image2.width, image2.height)];
    image4.image = [UIImage imageNamed:@"检测_03"];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(image3.right+10, image4.top-2, topView.width-image2.right-20, 20)];
    label4.font = [UIFont systemFontOfSize:15];
    label4.textAlignment = NSTextAlignmentLeft;
    label4.textColor = UIColorFromHex(0X8E8E93);
    label4.text = @"既餐后两小时的时候抽血，正常11.1以下。";
    [topView addSubview:label4];
    
    [topView addSubview:image2];
    [topView addSubview:image3];
    [topView addSubview:image4];
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
