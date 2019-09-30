//
//  SidebarViewController.m
//  LLBlurSidebar
//
//  Created by Lugede on 14/11/20.
//  Copyright (c) 2014年 lugede.cn. All rights reserved.
//

#import "SidebarViewController.h"
#import "SlideLeftCell.h"


@interface SidebarViewController ()

@property (nonatomic, retain) UITableView* menuTableView;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic,assign) NSInteger selectTag;
//@property (nonatomic, copy) NSString *imageStr;
@end

@implementation SidebarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWithView];
    
    // Do any additional setup after loading the view from its nib.
    
 
}

- (void)initWithView
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kSidebarWidth-72*2-26)/2.0 -15, kNavBarHeight, 100, 25)];
    titleLabel.font = [UIFont systemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = UIColorFromHex(0X000000);
    titleLabel.text = ModuleZW(@"筛选");
    [self.contentView addSubview:titleLabel];
    
    self.selectTag = -1;
    //档案最新
    if ([UserShareOnce shareOnce].languageType){
        self.titleArr = [NSArray arrayWithObjects:
                         ModuleZW(@"全部"),
                         ModuleZW(@"最新"),
                         ModuleZW(@"阶段报告"),
                         ModuleZW(@"经络"),
                         ModuleZW(@"脏腑"),
                         ModuleZW(@"体质"),
                         ModuleZW(@"血压"),
                         ModuleZW(@"血氧"),
                         ModuleZW(@"血糖"),
                         ModuleZW(@"心率"),
                         ModuleZW(@"呼吸"),
                         ModuleZW(@"体温"),
                         ModuleZW(@"体检报告"), nil];
    }else{
        self.titleArr = [NSArray arrayWithObjects:
                         ModuleZW(@"全部"),
                         ModuleZW(@"最新"),
                         ModuleZW(@"阶段报告"),
                         ModuleZW(@"病历"),
                         ModuleZW(@"经络"),
                         ModuleZW(@"脏腑"),
                         ModuleZW(@"体质"),
                         ModuleZW(@"血压"),
                         ModuleZW(@"血氧"),
                         ModuleZW(@"血糖"),
                         ModuleZW(@"心率"),
                         ModuleZW(@"呼吸"),
                         ModuleZW(@"体温"),
                         @"体检报告",
                         nil];
    }
   

    for(NSInteger i=0;i<self.titleArr.count;i++){
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(titleLabel.left+(90+17)*(i%2), titleLabel.bottom+26+(42+23)*(i/2), 95, 45);
        selectBtn.tag = i+100;
        selectBtn.layer.cornerRadius = 15;
        selectBtn.titleLabel.numberOfLines = 2;
        selectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        selectBtn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        selectBtn.layer.masksToBounds = YES;
        [selectBtn.layer setBorderColor:UIColorFromHex(0XEEEEEE).CGColor];
        [selectBtn.layer setBorderWidth:1.0];
        [selectBtn setTitle:[self.titleArr objectAtIndex:i] forState:UIControlStateNormal];
        [selectBtn setBackgroundColor:UIColorFromHex(0XEEEEEE)];
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:16/[UserShareOnce shareOnce].fontSize];
        [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [selectBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:selectBtn];
        
    }
    
    UIButton *selButton = (UIButton *)[self.contentView viewWithTag:100+self.titleArr.count-1];
    NSLog(@"frame:%@",NSStringFromCGRect(selButton.frame));
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake((kSidebarWidth-150)/2.0, selButton.bottom+40, 150, 42);
    sureBtn.layer.cornerRadius = sureBtn.height/2.0;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:ModuleZW(@"确定") forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor redColor]];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [sureBtn addTarget:self action:@selector(sureBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:sureBtn];
    
}

- (void)selectBtnAction:(UIButton *)button {
    
    self.selectTag = button.tag-100;
    if(self.selectTag == -1){
        return;
    }else{
        if([self.delegate respondsToSelector:@selector(selectIndexWithString:withButton:)]){
            NSString *str = [self.titleArr objectAtIndex:self.selectTag];
            [self.delegate selectIndexWithString:str withButton:button];
            [self autoShowHideSidebar];
        }
    }
    
}

- (void)sureBtnAction:(UIButton *)button
{
    [self autoShowHideSidebar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableViewData
{
    [self.menuTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}



#pragma mark - TableView
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 5;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if(indexPath.row == 0){
//        return 100;
//    }
//    return 60;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *sidebarMenuCellIdentifier = @"CellIdentifier";
//    
//    SlideLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:sidebarMenuCellIdentifier];
//    if(!leftCell){
//        leftCell = [[SlideLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sidebarMenuCellIdentifier];
//        leftCell.backgroundColor = [UIColor clearColor];
//    }
//    if(indexPath.row == 0){
//        if (g_userInfo.Name == nil || [g_userInfo.Name isKindOfClass:[NSNull class]]) {
//            if(g_userInfo.memberImage != nil && ![g_userInfo.memberImage isKindOfClass:[NSNull class]]){
//                [leftCell initCellWithTitleStr:g_userInfo.UserName imageUrl:g_userInfo.memberImage];
//            }else{
//                [leftCell initCellWithTitleStr:g_userInfo.UserName imageUrl:@"我的"];
//            }
//        }
//        else
//        {
//            if(g_userInfo.memberImage != nil && ![g_userInfo.memberImage isKindOfClass:[NSNull class]]){
//                [leftCell initCellWithTitleStr:g_userInfo.Name imageUrl:g_userInfo.memberImage];
//            }else{
//                [leftCell initCellWithTitleStr:g_userInfo.Name imageUrl:@"我的"];
//            }
//        }
//        
//    }else{
//        [leftCell initCellWithTitleStr:[self.titleArr objectAtIndex:indexPath.row-1] imageUrl:[self.imageArr objectAtIndex:indexPath.row-1]];
//    }
//    
//    return leftCell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    //UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//   
//    [self showHideSidebar];
//}

@end
