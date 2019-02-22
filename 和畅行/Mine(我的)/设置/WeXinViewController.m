//
//  WeXinViewController.m
//  Voicediagno
//
//  Created by ZhangYunguang on 16/1/13.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "WeXinViewController.h"

@interface WeXinViewController ()

@end

@implementation WeXinViewController

- (void)dealloc{
   
}
-(void)backClick:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    self.navTitleLabel.text = ModuleZW(@"官方微信");
    UIScrollView*  WeiXinScrollView=[[UIScrollView alloc] init];
    WeiXinScrollView.frame=CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight);
    WeiXinScrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:WeiXinScrollView];
   
    UILabel* Lb_weixin=[[UILabel alloc] init];
    Lb_weixin.frame=CGRectMake(15, 15, ScreenWidth-30, 21);
    Lb_weixin.font=[UIFont systemFontOfSize:13];
    Lb_weixin.textAlignment=1;
    Lb_weixin.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    Lb_weixin.text=ModuleZW(@"炎黄东方微信号：ky3h_yh");
    [WeiXinScrollView addSubview:Lb_weixin];
    
    
    UIImage* weixinImg=[UIImage imageNamed:@"newweixin_erweima.jpg"];
//    UIImageView* weixinImgView=[[UIImageView alloc] init];
//    weixinImgView.frame=CGRectMake((ScreenWidth-weixinImg.size.width/2)/2, Lb_weixin.frame.origin.y+Lb_weixin.frame.size.height, weixinImg.size.width/2, weixinImg.size.height/2);
//    weixinImgView.image=weixinImg;
//    [WeiXinScrollView addSubview:weixinImgView];
//    [weixinImgView release];
    
    UIButton *yhBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yhBtn setImage:weixinImg forState:UIControlStateNormal];
    yhBtn.frame=CGRectMake((ScreenWidth-weixinImg.size.width/2)/2, Lb_weixin.frame.origin.y+Lb_weixin.frame.size.height+5, weixinImg.size.width/2, weixinImg.size.height/2);
    [yhBtn addTarget:self action:@selector(yhBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [WeiXinScrollView addSubview:yhBtn];
    
    
    UILabel* Lb_weixin1=[[UILabel alloc] init];
    Lb_weixin1.frame=CGRectMake(15, yhBtn.frame.origin.y+yhBtn.frame.size.height+15, ScreenWidth-30, 21);
    Lb_weixin1.font=[UIFont systemFontOfSize:13];
    Lb_weixin1.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    Lb_weixin1.text=ModuleZW(@"知己KY3H服务微信号：ky3h_zjfw");
    Lb_weixin1.textAlignment=1;
    [WeiXinScrollView addSubview:Lb_weixin1];
    
    
    UIImage* weixinImg1=[UIImage imageNamed:@"newzhiji_erweima.jpg"];
//    UIImageView* weixinImgView1=[[UIImageView alloc] init];
//    weixinImgView1.frame=CGRectMake((ScreenWidth-weixinImg1.size.width/2)/2, Lb_weixin1.frame.origin.y+Lb_weixin1.frame.size.height, weixinImg1.size.width/2, weixinImg1.size.height/2);
//    weixinImgView1.image=weixinImg1;
//    [WeiXinScrollView addSubview:weixinImgView1];
//    [weixinImgView1 release];
    
    UIButton *zjBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [zjBtn setImage:weixinImg forState:UIControlStateNormal];
    zjBtn.frame=CGRectMake((ScreenWidth-weixinImg1.size.width/2)/2, Lb_weixin1.frame.origin.y+Lb_weixin1.frame.size.height+5, weixinImg1.size.width/2, weixinImg1.size.height/2);
    [zjBtn addTarget:self action:@selector(yhBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [WeiXinScrollView addSubview:zjBtn];
    
    CGSize weixinHeight;
    weixinHeight.width=ScreenWidth;
    weixinHeight.height=Lb_weixin.frame.size.height+yhBtn.frame.size.height+Lb_weixin1.frame.size.height+zjBtn.frame.size.height+100;
    [WeiXinScrollView setContentSize:weixinHeight];
}

- (void)yhBtnClick:(UIButton *)btn{
    NSLog(@"btn");
    [self saveImageToPhotos:btn.currentImage];
}

//实现该方法
- (void)saveImageToPhotos:(UIImage*)savedImage
{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //因为需要知道该操作的完成情况，即保存成功与否，所以此处需要一个回调方法image:didFinishSavingWithError:contextInfo:
}

//回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = ModuleZW(@"保存图片失败");
    }else{
        msg = ModuleZW(@"已收藏到手机相册请进入微信扫描！" );
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
//    [self showViewController:alert sender:nil];
    [alert addAction:[UIAlertAction actionWithTitle:ModuleZW(@"确定") style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
