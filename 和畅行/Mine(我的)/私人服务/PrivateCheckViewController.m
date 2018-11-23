//
//  PrivateCheckViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 15/11/27.
//  Copyright © 2015年 ZhangYunguang. All rights reserved.
//

#import "PrivateCheckViewController.h"
#import "UIImageView+WebCache.h"
#import "PrivateDoctorListViewController.h"

#define kSET_ADVISOR @"/member/healthAdvisor/setAdvisor.jhtml"

@interface PrivateCheckViewController ()<UIAlertViewDelegate>
{
    NSTimer *_timer;
}
@end

@implementation PrivateCheckViewController

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navTitleLabel.text = @"医生详情";
    
    [self initWithController];
    
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-初始化界面
-(void)initWithController{
    
    
    UIImageView *backImage = [Tools creatImageViewWithFrame:CGRectMake(0, 79, ScreenWidth-0, ScreenHeight-79) imageName:@"私人医生_背景"];
    backImage.userInteractionEnabled = YES;
    [self.view addSubview:backImage];
    UIImageView *iconLine = [Tools creatImageViewWithFrame:CGRectMake(20, 20, 80, 80) imageName:@"私人医生_头像线"];
    [backImage addSubview:iconLine];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(21, 21, 78, 78)];
    icon.image = [UIImage imageNamed:@"私人医生预加载"];
    if (![self.model.image isKindOfClass:[NSNull class]]) {
        [icon sd_setImageWithURL:[NSURL URLWithString:self.model.image] placeholderImage:[UIImage imageNamed:@"私人医生预加载"]];
    }
    [backImage addSubview:icon];
    
    UILabel *name = [Tools labelWith:self.model.name frame:CGRectMake(110, 20, 40, 20) textSize:13 textColor:[Tools colorWithHexString:@"#333333"]  lines:1 aligment:NSTextAlignmentLeft];
    [backImage addSubview:name];
    if (![self.model.rank isKindOfClass:[NSNull class]]) {
        UILabel *rank = [Tools labelWith:self.model.rank frame:CGRectMake(160, 20, 100, 20) textSize:13 textColor:[Tools colorWithHexString:@"#666"] lines:1 aligment:NSTextAlignmentLeft];
        [backImage addSubview:rank];
    }
    if (![self.model.skill isKindOfClass:[NSNull class]]) {
        UILabel *skill = [Tools labelWith:self.model.skill frame:CGRectMake(110, 50, 100, 20) textSize:13 textColor:[Tools colorWithHexString:@"#333333"] lines:1 aligment:NSTextAlignmentLeft];
        [backImage addSubview:skill];
    }
    if ([self.category isEqualToString:@"add"]) {
        UIButton *addBtn = [Tools creatButtonWithFrame:CGRectMake(ScreenWidth-20-48.6, 50, 48.6, 18) target:self sel:@selector(addBtnClick:) tag:55 image:@"私人医生_添加" title:nil];
        [backImage addSubview:addBtn];
    }
    for (int i=0; i<5; i++) {
        UIImageView *darkStar = [Tools creatImageViewWithFrame:CGRectMake(110+20*i, 80, 15, 15) imageName:@"星星_未点亮"];
        [backImage addSubview:darkStar];
    }
    int starLevel = [self.model.serviceOrder intValue];
    for (int j=0; j<starLevel; j++) {
        UIImageView *lightStar = [Tools creatImageViewWithFrame:CGRectMake(110+20*j, 80, 15, 15) imageName:@"星星_点亮"];
        [backImage addSubview:lightStar];
    }
    
    UILabel *introTitle = [Tools labelWith:@"简  介：" frame:CGRectMake(20, 120, 110, 10) textSize:13 textColor:[Tools colorWithHexString:@"#333"] lines:1 aligment:NSTextAlignmentLeft];
    [backImage addSubview:introTitle];
    
    if (![self.model.introduction isKindOfClass:[NSNull class]]) {
        UILabel *content = [Tools labelWith:self.model.introduction frame:CGRectMake(20, 140, backImage.frame.size.width-20, 10) textSize:12 textColor:[Tools colorWithHexString:@"#666"] lines:0 aligment:NSTextAlignmentLeft];
        //动态计算label的高度
        CGRect tempRect = [content.text boundingRectWithSize:CGSizeMake(backImage.frame.size.width-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:content.font,NSAttachmentAttributeName, nil] context:nil];
        CGFloat labelH = tempRect.size.height;
        [content setFrame:CGRectMake(20, 140, backImage.frame.size.width-20, labelH)];
        [backImage addSubview:content];
        
    }
    
}
#pragma mark-添加私人医生
-(void)addBtnClick:(UIButton *)button{
    [ZYGASINetworking GET_Path:kSET_ADVISOR params:@{@"advisorId":self.model.id} completed:^(id JSON, NSString *stringData) {
        NSLog(@"请求私人健康顾问返回的的数据：%@",JSON);
        if ([JSON[@"status"] integerValue] == 100) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.removeFromSuperViewOnHide =YES;
            hud.mode = MBProgressHUDModeText;
            hud.label.text = JSON[@"data"];
           
            //hud.labelText = JSON[@"data"];
            hud.minSize = CGSizeMake(132.f, 108.0f);
            [hud hideAnimated:YES afterDelay:2];
            //[hud hide:YES afterDelay:2];
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(backToDoctorList) userInfo:nil repeats:NO];
            [_timer setFireDate:[NSDate distantPast]];
            
        }else if ([JSON[@"status"] integerValue] == 1 || [JSON[@"status"] integerValue] == 53){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:JSON[@"data"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failed:^(NSError *error) {
        NSLog(@"设置私人健康顾问失败");
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)backToDoctorList{
    for (UIViewController *cntroller in self.navigationController.viewControllers) {
        if ([cntroller isKindOfClass:[PrivateDoctorListViewController class]]) {
            [self.navigationController popToViewController:cntroller animated:YES];
        }
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
