//
//  JingLuoSchemeController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/8/1.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "JingLuoSchemeController.h"
#import "HeChangPackgeController.h"
#import "i9_MoxaMainViewController.h"

@interface JingLuoSchemeController ()

@end

@implementation JingLuoSchemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"经络梳理";
    [self createUI];
}

- (void)createUI
{
    NSArray *imageArr = @[ModuleZW(@"一戴Ch") ,ModuleZW(@"一站Ch"),
                                            ModuleZW( @"一听Ch"),ModuleZW(@"一贴Ch"),
                                            ModuleZW( @"一选Ch"),ModuleZW(@"一砭Ch"),
                                            ModuleZW( @"一灸Ch"),ModuleZW(@"一推Ch"),
                                            ModuleZW( @"一刮Ch")];
    if([UserShareOnce shareOnce].isOnline){
        imageArr = @[ModuleZW(@"一站Ch"),ModuleZW(@"一贴Ch"),
                               ModuleZW(@"一选Ch"),ModuleZW(@"一砭Ch"),
                               ModuleZW(@"一灸Ch"),ModuleZW(@"一推Ch"),
                               ModuleZW(@"一刮Ch")];
    }
    CGFloat imageWidth = (ScreenWidth-50)/2.0;
    CGFloat imageHeight = imageWidth/2.16;
    for(NSInteger i = 0;i<imageArr.count;i++){
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        NSInteger xx = 0, yy = 0;
        
        xx = i%2;
        yy = i/2;
            
        imageV.frame = CGRectMake(15+(imageWidth+20)*xx, kNavBarHeight+20+(imageHeight+20)*yy, imageWidth, imageHeight);
        
        imageV.contentMode = UIViewContentModeScaleToFill;
        imageV.userInteractionEnabled = YES;
        imageV.tag = 200+i;
        imageV.image = [UIImage imageNamed:[imageArr objectAtIndex:i]];
        [self.view addSubview:imageV];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
        [imageV addGestureRecognizer:tap];
    }
}

- (void)imageTapAction:(UITapGestureRecognizer *)gesture
{
    UIImageView *imageV = (UIImageView *)gesture.view;
    
    NSString *type = @"";
    NSString *fangtype = @"";
    NSString *titleStr = @"";
    NSString *urlStr = @"";
    
    NSInteger viewTag = imageV.tag;
    
    if([UserShareOnce shareOnce].isOnline){
        if(viewTag == 200){
            viewTag = 200+1;
        }else {
            viewTag += 2;
        }
    }
    
    switch (viewTag) {
        case 200:
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yidai";
            titleStr = ModuleZW(@"耳穴处方");
            break;
        case 201:
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yizhan";
            
            titleStr = ModuleZW(@"运动处方");
            break;
        case 202:
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yiting";
            
            titleStr = ModuleZW(@"音乐处方");
            break;
            ///member/service/view/fang/sn/2/
        case 203:
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yitei";
            
            titleStr = ModuleZW(@"磁贴处方");
            break;
        case 204:
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yixuan";
            titleStr = ModuleZW(@"膳食处方");
            break;
        case 205:
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yishan";
            titleStr =ModuleZW( @"砭石处方");
            break;
        case 206:
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yijiu";
            titleStr = @"灸法处方";
//        {
//            i9_MoxaMainViewController *vc = [[i9_MoxaMainViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//            return;
//        }
            break;
        case 207:
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yitui";
            titleStr = ModuleZW(@"推拿处方");
            break;
        case 208:
            type = @"/member/service/view/fang/JLBS/1/";
            fangtype = @"yigua";
            titleStr =ModuleZW( @"刮痧处方");
            break;
        default:
            break;
    }
    
    urlStr = [NSString stringWithFormat:@"%@%@%@.jhtml?type=%@",URL_PRE,type,[MemberUserShance shareOnce].idNum,fangtype];
    HeChangPackgeController *vc = [[HeChangPackgeController alloc] init];
    vc.progressType = progress2;
    vc.urlStr = urlStr;
    vc.titleStr = titleStr;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
