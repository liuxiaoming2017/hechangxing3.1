//
//  ReadOrWriteView.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/3.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ReadOrWriteView.h"
#import "UIView+ViewController.h"
#import "TipWriteController.h"
#import "TipClickController.h"
#import "TipSpeakController.h"

#import "MeridianIdentifierViewController.h"
#import "WriteListController.h"
#import "QuestionListController.h"
#import "HCY_HomeImageModel.h"
@implementation ReadOrWriteView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
    }
    return self;
}

- (void)initWithUI
{
    CGFloat imageWidth = 122;
    CGFloat imageHeight = 96;
    
    imageWidth = (ScreenWidth - 10*4)/3.0;
    imageHeight = imageWidth*76.8/97.7;
    
    
    NSArray *imageArr = @[@"readImage",@"writeImage",@"hitImage"];
    
    for(NSInteger i = 0;i<3;i++){
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(10+(imageWidth+10)*i, 10, imageWidth, imageHeight);
        [rightBtn setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]] forState:UIControlStateNormal];
        rightBtn.tag=100+i;
        [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
    }
   
    
   
}


-(void)setButtonImageWithArray:(NSMutableArray *)array {
    
    
    CGFloat imageWidth = 122;
    CGFloat imageHeight = 96;
    
    imageWidth = (ScreenWidth - 10*4)/3.0;
    imageHeight = imageWidth*76.8/97.7;
    
    NSArray *imageArr = @[@"readImage",@"writeImage",@"hitImage"];
    
    for(NSInteger i = 0;i<3;i++){
        HCY_HomeImageModel *model = array[i+2];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(10+(imageWidth+10)*i, 10, imageWidth, imageHeight);
        
        if (model.picurl == nil ||[model.picurl isKindOfClass:[NSNull class]]||model.picurl.length == 0) {
            [rightBtn setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]] forState:UIControlStateNormal];
        }else {
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URL_PRE,model.picurl];
            NSURL *url = [NSURL URLWithString:imageUrl];
            [rightBtn sd_setImageWithURL:url forState:(UIControlStateNormal)];
        }
       
        rightBtn.tag=100+i;
        [rightBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
    }
    
    
}

- (void)buttonAction:(UIButton *)btn
{
     SayAndWriteController *vc = nil;
    switch (btn.tag) {
        case 100:
        {
            if([self isFirestClickThePageWithString:@"speak"]){
                vc = [[MeridianIdentifierViewController alloc] init];
            }else{
                vc = [[TipSpeakController alloc] init];
            }
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
           case 101:
        {
            if([self isFirestClickThePageWithString:@"write"]){
                vc = [[WriteListController alloc] init];
            }else{
                vc = [[TipWriteController alloc] init];
            }
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 102:
        {
            if([self isFirestClickThePageWithString:@"click"]){
                vc = [[QuestionListController alloc] init];
            }else{
                vc = [[TipClickController alloc] init];
            }
            
            vc.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

# pragma mark - 写按钮点击
- (void)writeBtnBtnAction:(UIButton *)btn
{
    SayAndWriteController *vc = nil;
    
    if([self isFirestClickThePageWithString:@"write"]){
        vc = [[WriteListController alloc] init];

    }else{
        vc = [[TipWriteController alloc] init];
    }
    
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
# pragma mark - 说按钮点击
- (void)readBtnBtnAction:(UIButton *)btn
{
    if([self isFirestClickThePageWithString:@"speak"]){
        
    }
    TipSpeakController *vc = [[TipSpeakController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
# pragma mark - 点按钮点击
- (void)hitBtnBtnAction:(UIButton *)btn
{
    if([self isFirestClickThePageWithString:@"tip"]){
        
    }
    TipClickController *vc = [[TipClickController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:vc animated:YES];
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
