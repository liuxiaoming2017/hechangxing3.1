//
//  WriteListController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/19.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SayAndWriteController.h"

typedef void (^reloadCellBlock)(NSInteger row);
typedef void(^addCheckBlock)(void);

@interface WriteListController : SayAndWriteController
{
    UIImageView *_leftView;
    UIImageView *_rightView;
    UIButton *_leftButton;
    UIButton *_rightButton;
    UIImageView *_lineView;//蓝线
    int _sex;  //  0男，  1女
    BOOL _isFront;//是否是身体的正面
    BOOL _isBodyTouched;//点击身体的某部位
    NSString *_touchedPart;//点击的部位
    UIButton *_headBtn;
    UIButton *_leftArmBtn;
    UIButton *_rightArmBtn;
    UIButton *_chestBtn;
    UIButton *_hipBtn;
    UIButton *_legsBtn;
    UITableView *_leftTableView;
    NSMutableArray *_leftDataArr;//左边tableView的数据源
    NSMutableArray *_sectionStatus;//存放组的状态
    NSMutableArray *_sectionDataArr;//组的数据
    NSMutableArray *_sectionOpenImageArr;//组的图片
    NSMutableArray *_sectionClosedImageArr;//组的图片
    
    UITableView *_rightTableView;//右边tableView
    NSMutableArray *_rightDataArr;
    NSInteger _selectedCount;//已选择的病症个数
    NSMutableArray *_selectedArr;//存放已经选择的病症的model
    
    //弹出视图
    UIView *_bottomView;
    UIView *_showView;
    UIImageView *_contentView;
    UITableView *_popTableView;
}

@property (nonatomic,copy) reloadCellBlock reloadBlock;
-(void)reloadCellWith:(reloadCellBlock )block;
@property (nonatomic,copy) addCheckBlock checkBlock;
-(void)addCheckWithBlock:(addCheckBlock )block;

@property (nonatomic,strong) UIImageView *leftView;
@property (nonatomic,strong) UIImageView *rightView;
@property (nonatomic,strong) UIButton *leftButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UIImageView *lineView;
@property (nonatomic,assign) int sex;
@property (nonatomic,assign) BOOL isFront;
@property (nonatomic,assign) BOOL isBodyTouched;
@property (nonatomic,copy  ) NSString *touchedPart;
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) NSMutableArray *leftDataArr;
@property (nonatomic,strong) NSMutableArray *sectionDataArr;
@property (nonatomic,strong) NSMutableArray *sectionOpenImageArr;
@property (nonatomic,strong) NSMutableArray *sectionClosedImageArr;

@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) NSMutableArray *rightDataArr;
@property (nonatomic,assign) NSInteger selectedCount;
@property (nonatomic,strong) NSMutableArray *selectedArr;

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *showView;
@property (nonatomic,strong) UIImageView *contentView;
@property (nonatomic,strong) UITableView *popTableView;
@end
