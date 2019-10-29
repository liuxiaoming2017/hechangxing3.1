//
//  OGBluetoothListView.m
//  EC628Set
//
//  Created by jerry on 2018/9/26.
//  Copyright © 2018年 HLin. All rights reserved.
//

#import "OGBluetoothListView.h"

@interface OGBluetoothListView()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView    *bgView;           //黑色背景视图
@property (nonatomic, strong) UIView    *mainView;         //主框视图
@property (nonatomic, strong) UILabel   *labTitle;         //标题
@property (nonatomic, strong) UIButton  *btnRefresh;       //刷新
@property (nonatomic, strong) UIButton  *btnCancel;        //取消
@property (nonatomic, strong) UIButton  *btnSure;          //确定
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) CBPeripheral *peripheral;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator; //小菊花

@end

@implementation OGBluetoothListView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self showView];
        
    }
    return self;
}
- (void)showView {
    
    self.backgroundColor = [UIColor clearColor];
    
    [self bgView];
    [self mainView];
}

#pragma mark - property
- (UIView *)bgView {
    
    if (_bgView == nil) {
        self.bgView = [[UIView alloc] initWithFrame:self.frame];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _bgView.alpha = 0.3f;
        [self addSubview:_bgView];
    }
    return _bgView;
}


- (UILabel *)labTitle {
    
    if (_labTitle == nil) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.text = @"选择设备";
        _labTitle.textColor = [UIColor blackColor];
        _labTitle.font = [UIFont systemFontOfSize:16];
        _labTitle.textAlignment = NSTextAlignmentCenter;
        [_mainView addSubview:_labTitle];
    }
    return _labTitle;
}

#pragma mark 刷新按钮
- (UIButton *)btnRefresh {
    
    if (_btnRefresh == nil) {
        
        self.btnRefresh = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btnRefresh setTitle:@"刷新" forState:UIControlStateNormal];
        [_btnRefresh setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnRefresh addTarget:self action:@selector(actionRefresh:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_btnRefresh];
    }
    return _btnRefresh;
}

#pragma mark 取消按钮
- (UIButton *)btnCancel {
    
    if (_btnCancel == nil) {
        
        self.btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnCancel.layer.borderWidth = 0.5f;
        _btnCancel.layer.borderColor = [UIColor whiteColor].CGColor;
        [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [_btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnCancel addTarget:self action:@selector(actionCancel:) forControlEvents:UIControlEventTouchUpInside];
        [_mainView addSubview:_btnCancel];
    }
    return _btnCancel;
}

- (UIActivityIndicatorView *)activityIndicator{
    if (_activityIndicator == nil) {
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        //设置小菊花颜色
        _activityIndicator.color = [UIColor cyanColor];
        //设置背景颜色
        _activityIndicator.backgroundColor = [UIColor clearColor];
        //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
        _activityIndicator.hidesWhenStopped = NO;
        [_mainView addSubview:_activityIndicator];
    }
    return _activityIndicator;
}

#pragma mark 确定按钮
- (UIButton *)btnSure {
    
    if (_btnSure == nil) {
        
        self.btnSure = [UIButton buttonWithType:UIButtonTypeSystem];
        _btnSure.layer.borderWidth = 0.5f;
        _btnSure.layer.borderColor = [UIColor whiteColor].CGColor;
        [_btnSure setTitle:@"确定" forState:UIControlStateNormal];
        [_btnSure setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_btnSure addTarget:self action:@selector(actionSure:) forControlEvents:UIControlEventTouchUpInside];
        //[_mainView addSubview:_btnSure];
    }
    return _btnSure;
}

#pragma mark tableView
- (UITableView *)tableView {
    
    if (_tableView == nil) {
        
        CGFloat viewH = _mainView.frame.size.height - _labTitle.frame.size.height;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.labTitle.frame.size.height, _mainView.frame.size.width, viewH)
                                                      style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 0.1)];
        [_mainView addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark 主框视图
- (UIView *)mainView {
    
    if (_mainView == nil) {
        self.mainView = [[UIView alloc] init];
        _mainView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _mainView.bounds = CGRectMake(0, 0, ScreenWidth-60 , 270);
        _mainView.layer.cornerRadius = 5;
        _mainView.backgroundColor = [UIColor whiteColor];
        
        self.labTitle.frame = CGRectMake(70, 0, _mainView.frame.size.width-140, 50);
        UILabel * line = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, _mainView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [_mainView addSubview:line];
        
        self.btnCancel.frame = CGRectMake(_mainView.frame.size.width - 70, 7, 70, 40);
        
//        [self activityIndicator];
//        self.activityIndicator.frame = CGRectMake(5, 7, 40, 40);
        
//        [self btnCancel];
//        self.btnCancel.frame = CGRectMake(0, _mainView.frame.size.height - 50, _mainView.frame.size.width/2, 50);
        
//        [self btnSure];
//        _btnSure.frame = CGRectMake(_mainView.frame.size.width/2, _btnCancel.frame.origin.y, _mainView.frame.size.width/2, _btnCancel.frame.size.height);
        
        [self tableView];
        [self addSubview:_mainView];
    }
    return _mainView;
}

- (void)setArray:(NSMutableArray *)array {
    _array = array;
    
    [self bgView];
    [self mainView];
    
    if (self.tableView) {
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    CBPeripheral *peripherral  = [self.array objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",peripherral.name];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithWhite:0 alpha:0.65];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBPeripheral *peripherral  = [self.array objectAtIndex:indexPath.row];
    
    if (self.selectedPeripheral) {
        self.selectedPeripheral(peripherral);
    }
}

- (void)reloadBluetoothList {
    
    [self.tableView reloadData];
}

- (void)stopIndicatorAnimating{
    //关闭菊花
    [self.activityIndicator stopAnimating];
}

- (void)removeSuperView {
    
     [self removeFromSuperview];
}

#pragma mark - action
- (void)actionRefresh:(UIButton *)sender {
    
}


- (void)actionCancel:(UIButton *)sender {
    //关闭菊花
//    [self.activityIndicator stopAnimating];
//    [[OGBluetoothHelper sharedBluetoothHelper] cancelScan];
    [self removeFromSuperview];
    if (self.scanPeripheralCancel) {
        self.scanPeripheralCancel();
    }
}



@end
