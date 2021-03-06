//
//  GanYuSchemeController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/1.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "GanYuSchemeController.h"
#import "HeChangPackgeController.h"
#import "JingLuoSchemeController.h"
#import "InformationViewController.h"
#import "TestViewController.h"
#import "HCY_CallController.h"
#import "HCY_HelpController.h"


@interface GanYuSchemeController ()

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation GanYuSchemeController
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text =ModuleZW(@"干预方案");
    [self createUI];
}

- (void)createUI
{
    CGFloat imageHeight = 100;
    CGFloat imageWidth = (ScreenWidth-55)/2.0;
    imageHeight = imageWidth/2.16;
   scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight)];
   scrollView.showsVerticalScrollIndicator = NO;
   scrollView.showsHorizontalScrollIndicator = NO;
   scrollView.bounces = NO;
   [self.view addSubview:scrollView];
    
    NSArray *titleArr = @[ModuleZW(@"经络梳理方案"),
                                        ModuleZW(@"脏腑调理方案"),
                                       ModuleZW( @"体质调理方案"),
                                       ModuleZW( @"状态护理方案")];
    for(NSInteger i=0;i<titleArr.count;i++){
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5+(imageHeight+30)*i, 200, 20)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = [titleArr objectAtIndex:i];
        titleLabel.tag = 100+i;
        [scrollView addSubview:titleLabel];
    }
    
    
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allBtn.frame = CGRectMake(ScreenWidth-60, 5, 50, 20);
    NSString *buttonStr = [NSString stringWithFormat:@"%@ >",ModuleZW(@"全部")];
    [allBtn setTitle:buttonStr forState:UIControlStateNormal];
    allBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [allBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(allBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:allBtn];
    
    NSArray *imageArr = @[];
    if(self.notYiChi){
            imageArr = @[ModuleZW(@"一戴Ch"),ModuleZW(@"一站Ch"),
                         ModuleZW(@"一坐2"),ModuleZW(@"一饮Ch"),
                         ModuleZW(@"一测Ch"), ModuleZW(@"一呼Ch"),
                         ModuleZW(@"一助Ch"),ModuleZW(@"一阅Ch")];
      
    }else{
            imageArr = @[ModuleZW(@"一戴Ch"),ModuleZW(@"一站Ch"),
                         ModuleZW(@"一吃Ch"),ModuleZW(@"一坐Ch"),
                         ModuleZW(@"一饮Ch"),ModuleZW(@"一测Ch"),
                         ModuleZW(@"一呼Ch"),ModuleZW(@"一助Ch"),
                         ModuleZW(@"一阅Ch")];
    }
    
    for(NSInteger i = 0;i<imageArr.count;i++){
        
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.tag = 200+i;
        NSInteger xx = 0, yy = 0;
        if(self.notYiChi){ ///
            if(i<2){
                xx = i%2;
                yy = i/2;
                
                imageV.frame = CGRectMake(15+(imageWidth+25)*xx, 30+(imageHeight+30)*yy, imageWidth, imageHeight);
            }else if (i==2){
                imageV.frame = CGRectMake(15, 30+(imageHeight+30), ScreenWidth-30, imageHeight);
                imageV.tag = 201+i;
            }else if (i==3){
                imageV.frame = CGRectMake(15, 30+(imageHeight+30)*2, ScreenWidth-30, imageHeight);
                imageV.tag = 201+i;
            }else{
                xx = (i)%2;
                yy = (i)/2;
                imageV.tag = 201+i;
                if(yy==3){
                    imageV.frame = CGRectMake(15+(imageWidth+25)*xx, 30+(imageHeight+30)*(yy+1)-10, imageWidth, imageHeight);
                }
                else{
                    imageV.frame = CGRectMake(15+(imageWidth+25)*xx, 30+imageHeight*(yy+1)+30*(yy+1), imageWidth, imageHeight);
                }
                
            }
        }else{ ///
            if(i<4){
                xx = i%2;
                yy = i/2;
                
                imageV.frame = CGRectMake(15+(imageWidth+25)*xx, 30+(imageHeight+30)*yy, imageWidth, imageHeight);
            }else if (i==4){
                imageV.frame = CGRectMake(15, 30+(imageHeight+30)*2, ScreenWidth-30, imageHeight);
            }else{
                xx = (i+1)%2;
                yy = (i+1)/2;
                if(yy==3){
                    imageV.frame = CGRectMake(15+(imageWidth+25)*xx, 30+(imageHeight+30)*yy, imageWidth, imageHeight);
                }else{
                    imageV.frame = CGRectMake(15+(imageWidth+25)*xx, 30+imageHeight*yy+30*(yy-1)+15, imageWidth, imageHeight);
                }
                
            }
        }
        
        imageV.contentMode = UIViewContentModeScaleToFill;
        imageV.userInteractionEnabled = YES;
        
        imageV.image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
        [scrollView addSubview:imageV];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        [imageV addGestureRecognizer:tap];
    }
}

- (void)allBtnAction
{
    JingLuoSchemeController *vc = [[JingLuoSchemeController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)imageTapAction:(UITapGestureRecognizer *)gesture
{
    UIImageView *imageV = (UIImageView *)gesture.view;
    NSString *type = @"";
    NSString *fangtype = @"";
    NSString *titleStr = @"";
    NSString *urlStr = @"";
   
    switch (imageV.tag) {
        case 200:
            if([UserShareOnce shareOnce].isOnline){
                type = @"/member/service/view/fang/JLBS/1/";
                fangtype = @"yixuan";
                titleStr = ModuleZW(@"膳食处方");
                urlStr = [NSString stringWithFormat:@"%@%@%@.jhtml?type=%@",URL_PRE,type,[MemberUserShance shareOnce].idNum,fangtype];
            }else{
                type = @"/member/service/view/fang/JLBS/1/";
                fangtype = @"yidai";
                urlStr = [NSString stringWithFormat:@"%@%@%@.jhtml?type=%@",URL_PRE,type,[MemberUserShance shareOnce].idNum,fangtype];
                titleStr =ModuleZW( @"耳穴处方");
            }
            break;
        case 201:
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yizhan";
            urlStr = [NSString stringWithFormat:@"%@%@%@.jhtml?type=%@",URL_PRE,type,[MemberUserShance shareOnce].idNum,fangtype];
            titleStr = ModuleZW(@"运动处方");
            break;
        case 202:
            type = @"/member/service/zf_chufang/";
            urlStr = [NSString stringWithFormat:@"%@%@%@/1.jhtml",URL_PRE,type,[MemberUserShance shareOnce].idNum];
            titleStr = ModuleZW(@"食疗处方");
            break;
            ///member/service/view/fang/sn/2/
        case 203:
            type = @"member/service/view/fang/sn/1/";
            fangtype = @"yizuo";
            urlStr = [NSString stringWithFormat:@"%@%@%@.jhtml?type=%@",URL_PRE,type,[MemberUserShance shareOnce].idNum,fangtype];
            titleStr = ModuleZW(@"脏腑运动处方");
            break;
        case 204:
            type = @"/member/service/view/fang/TZBS/1/";
            fangtype = @"yiyin";
            urlStr = [NSString stringWithFormat:@"%@%@%@.jhtml?type=%@",URL_PRE,type,[MemberUserShance shareOnce].idNum,fangtype];
            titleStr = ModuleZW(@"体质处方");
            break;
        case 205:
        {
            //一测
            TestViewController *vc = [[TestViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
          
            return;
        }
            break;
            
        case 206:
        {
                HCY_CallController *callVC = [[HCY_CallController alloc]init];
                [self.navigationController pushViewController:callVC animated:YES];
          
            return;
           
        }
           
        case 207:
        {
                HCY_HelpController *helpVC = [[HCY_HelpController alloc]init];
                [self.navigationController pushViewController:helpVC animated:YES];           
            return;
        }
            break;

        case 208:
        {
            InformationViewController *vc = [[InformationViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
            
            break;
        default:
            break;
    }
    
    
    HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
    vc.progressType = progress2;
    vc.urlStr = urlStr;
    vc.titleStr = titleStr;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)rightBtnAction:(UIButton *)btn
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
