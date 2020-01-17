//
//  IjoouSetViewController.m
//  HarmonyYi
//
//  Created by Wei Zhao on 2019/12/13.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "IjoouSetViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <BCBluetoothSDK/BCBluetoothSDK.h>
#import "IjoouSetCollectionViewCell.h"
@interface IjoouSetViewController ()<CAAnimationDelegate,CBCentralManagerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,BCBluetoothManagerDelegate>
@property (nonatomic,strong) UICollectionView *collectionV;
@property (nonatomic,strong) UILabel *temperatureLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong)UISlider *temperatureSlider;
@property (nonatomic,strong)UISlider *timeSlider;
@property(nonatomic,strong)NSMutableArray *chooesArray;
@end

@implementation IjoouSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = @"Set up";
    self.leftBtn.hidden = YES;
    self.preBtn.hidden = NO;
    self.chooesArray = [NSMutableArray array];
    [self layoutSetUpView];
    [BCBluetoothManager shared].delegate = self;

}

- (void)goBack:(UIButton *)btn {
    if (self.popBlack) {
        self.popBlack(_dataArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)layoutSetUpView{
    CGFloat cellWithW;
    if (ISPaid) {
        cellWithW = (ScreenWidth - Adapter(50))/4;
    }else{
        cellWithW = (ScreenWidth - Adapter(40))/3;
    }
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(cellWithW , cellWithW);
    layout.sectionInset = UIEdgeInsetsMake(Adapter(10), Adapter(10), Adapter(10), Adapter(10));
    
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionV= [[UICollectionView alloc] initWithFrame:CGRectMake(0, kNavBarHeight , ScreenWidth, cellWithW + Adapter(30)) collectionViewLayout:layout];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.backgroundColor = [UIColor whiteColor];
    [self.collectionV registerClass:[IjoouSetCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.view addSubview:self.collectionV];
    
    UIButton *setAllBT = [UIButton buttonWithType:(UIButtonTypeCustom)];
    setAllBT.frame = CGRectMake(ScreenWidth - Adapter(150), self.collectionV.bottom + Adapter(20),  Adapter(150), Adapter(30));
    [setAllBT setTitle:@"set up all" forState:(UIControlStateNormal)];
    [setAllBT setTitleColor:RGB_TextGray forState:(UIControlStateNormal)];
    [setAllBT setImage:[[UIImage imageNamed:@"ijoou未选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateNormal)];
    [setAllBT addTarget:self action:@selector(setUpAll:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:setAllBT];
    UIView *nameView = [[UIView alloc]init];
    
    if (ISPaid) {
        nameView.frame = CGRectMake(ScreenWidth/2 - Adapter(60), self.collectionV.bottom + 70, Adapter(120), Adapter(120));
    }else{
        nameView.frame = CGRectMake(ScreenWidth/2 - Adapter(70), self.collectionV.bottom + Adapter(70), Adapter(140), Adapter(140));
    }
    
    nameView.backgroundColor = [UIColor whiteColor];
    nameView.layer.cornerRadius = nameView.width/2;
    [self.view addSubview:nameView];
    
    nameView.layer.shadowColor = RGB_ButtonBlue.CGColor;
    nameView.layer.shadowOffset = CGSizeMake(0,0);
    nameView.layer.shadowOpacity = 0.5;
    nameView.layer.shadowRadius = 5;
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, nameView.width, nameView.height)];
    nameLabel.text = @"";
    nameLabel.font = [UIFont systemFontOfSize:32/[UserShareOnce shareOnce].multipleFontSize];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.layer.cornerRadius = nameLabel.width/2;
    nameLabel.layer.masksToBounds = YES;
    nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.textColor = RGB_ButtonBlue;
    [nameView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
  
    NSArray *leftArray = @[@"Set up tempeauture",@"Set up time"];
     NSArray *rightArray = @[@"43℃",@"30min"];
    NSArray *buttonTitleArray = @[@"Disconnect",@"Confirm"];
    NSArray *buttonColor = @[RGB_TextGray,RGB_ButtonBlue];
    for (int i = 0 ; i < leftArray.count; i++) {
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(Adapter(30), nameView.bottom+30 + Adapter(60)*i, ScreenWidth - Adapter(180), Adapter(25))];
        leftLabel.text = leftArray[i];
        [self.view addSubview:leftLabel];
        
        UILabel *righLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - Adapter(150), nameView.bottom+30 + Adapter(70)*i, Adapter(120), Adapter(25))];
        righLabel.text = rightArray[i];
        righLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:righLabel];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(Adapter(30), leftLabel.bottom , ScreenWidth - Adapter(60), Adapter(35))];
        [slider setThumbImage:[[UIImage imageNamed:@"ijoou滑块"]transformWidth:Adapter(25) height:Adapter(25)] forState:UIControlStateHighlighted];
        [slider setThumbImage:[[UIImage imageNamed:@"ijoou滑块"]transformWidth:Adapter(25) height:Adapter(25)] forState:UIControlStateNormal];
        [slider setMinimumTrackTintColor:RGB_ButtonBlue];          //左边轨道的颜色
        [slider setMaximumTrackTintColor:RGB_ButtonBlue];
        [self.view addSubview:slider];
        slider.tag = 500 + i;
        [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        if (i == 0) {
            _temperatureLabel = righLabel;
            _temperatureSlider = slider;
            slider.minimumValue=40;
            slider.maximumValue=60;
        }else{
            _timeLabel = righLabel;
            _timeSlider = slider;
            slider.minimumValue=1;
            slider.maximumValue=60;
        }
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(ScreenWidth/2*i, ScreenHeight - kTabBarHeight + 44 - Adapter(45), ScreenWidth/2, Adapter(45));
        [button setTitle:buttonTitleArray[i] forState:(UIControlStateNormal)];
        [button setBackgroundColor:buttonColor[i]];
        [button addTarget:self action:@selector(bottomAction:) forControlEvents:(UIControlEventTouchUpInside)];
        button.tag = 400 + i;
        [self.view addSubview:button];
        
    }
    NSLog(@"%d",self.pushType);
    if (self.pushType == 100 ) {
        NSString *nameStr = [NSString string];
        for (int i= 0; i < _dataArray.count; i++) {
            BCDeviceModel *model = _dataArray[i];
            nameStr =  [nameStr stringByAppendingString:[NSString stringWithFormat:@"%@、",model.deviceName]];
        }
        nameStr = [nameStr substringToIndex:nameStr.length - 1];
        if (self.dataArray.count == 1) {
            BCDeviceModel *model = _dataArray[0];
            nameStr = model.deviceName;
        }
        
        for (int i = 0 ; i < _dataArray.count; i++) {
            [_chooesArray addObject:_dataArray[i]];
        }
        if (_dataArray.count  == 1) {
             BCDeviceModel *model = _dataArray[0];
            _temperatureSlider.value = model.temperature;
            _timeSlider.value = model.residueDuration;
        }else{
            _temperatureSlider.value = 40;
            _timeSlider.value = 1;
        }
        if (_chooesArray.count>2) {
            nameLabel.font = [UIFont systemFontOfSize:32/[UserShareOnce shareOnce].multipleFontSize/_chooesArray.count*2];
        }else{
            nameLabel.font = [UIFont systemFontOfSize:32/[UserShareOnce shareOnce].multipleFontSize];
        }
        nameLabel.text = nameStr;
        _temperatureLabel.text = [NSString stringWithFormat:@"%d℃",(int)(_temperatureSlider.value + 1)];
        _timeLabel.text = [NSString stringWithFormat:@"%dmin",(int)_timeSlider.value];
        setAllBT.selected = YES;
        [setAllBT setImage:[[UIImage imageNamed:@"ijoou选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateNormal)];
    }else{
        BCDeviceModel *model = _dataArray[self.pushType];
        [_chooesArray addObject:model];
        nameLabel.text = model.deviceName;
        _temperatureSlider.value = model.temperature;
        _timeSlider.value = model.residueDuration;
        _temperatureLabel.text = [NSString stringWithFormat:@"%d℃",(int)(_temperatureSlider.value + 1)];
        _timeLabel.text = [NSString stringWithFormat:@"%dmin",(int)_timeSlider.value];
        setAllBT.selected = NO;
        [setAllBT setImage:[[UIImage imageNamed:@"ijoou未选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateNormal)];
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"CloseBluetooth" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self.navigationController popViewControllerAnimated:YES];
//        UIAlertController *alerVC= [UIAlertController alertControllerWithTitle:nil message:@"the connection failed,please open the bluetooth and confirm that your ijoou devices is near you ..." preferredStyle:(UIAlertControllerStyleAlert)];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:nil];
//        [alerVC addAction:cancelAction];
//        [self presentViewController:alerVC animated:YES completion:nil];
    }];
    
}

-(void)sliderAction:(UISlider *)slider {
    if (slider.tag == 500) {
        _temperatureLabel.text = [NSString stringWithFormat:@"%d℃",(int)slider.value];
    }else{
        _timeLabel.text = [NSString stringWithFormat:@"%dmin",(int)slider.value];
    }
    
}
//底部按钮点击事件
-(void)bottomAction:(UIButton *)button {
    if (button.tag == 400) {
        
        UIAlertController *alerVC= [UIAlertController alertControllerWithTitle:nil message:@"Are you sure to disconnect ijoou?" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"Confirm" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            if (self.DisconnecBlack) {
                self.DisconnecBlack(self.chooesArray);
            }
             [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleDefault) handler:nil];
        [alerVC addAction:sureAction];
        [alerVC addAction:cancelAction];
        [self presentViewController:alerVC animated:YES completion:nil];
       
    }else{
        for (int i = 0; i < _chooesArray.count; i++) {
            BCDeviceModel *model = _chooesArray[i];
            int i =  (int)_temperatureSlider.value;
            if (i<45) {
                i = i + 8;
            }else if (i>44&&i<48){
                i = i + 9;
            }else if (i>47&&i<51){
                i = i + 10;
            }else if (i>50&&i<54){
                i = i + 11;
            }else if (i>53&&i<57){
                i = i + 12;
            }else if (i>56&&i<60){
                i = i + 13;
            }else{
                i = i + 14;
            }
            [[BCBluetoothManager shared] setDeviceTempreture:i withDevice:model];
            [[BCBluetoothManager shared] setDeviceTime:_timeSlider.value withDevice:model];
        }
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.popBlack) {
        self.popBlack(_dataArray);
    }
}
-(void)setUpAll:(UIButton *)button {
    [_chooesArray removeAllObjects];
    button.selected = !button.selected;
    if (button.isSelected) {
        [button setImage:[[UIImage imageNamed:@"ijoou选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateNormal)];
        
        for (int i = 0 ; i < _dataArray.count; i++) {
            [_chooesArray addObject:_dataArray[i]];
        }
        if (_chooesArray.count == 1) {
            BCDeviceModel *model = _chooesArray[0];
            _temperatureSlider.value = model.temperature;
            _timeSlider.value = model.residueDuration;
        }else{
            _temperatureSlider.value = 40;
            _timeSlider.value = 1;
        }
    }else{
        [button setImage:[[UIImage imageNamed:@"ijoou未选中"]transformWidth:Adapter(20) height:Adapter(20)] forState:(UIControlStateNormal)];
        BCDeviceModel *model = _dataArray[0];
        [_chooesArray addObject: model];
        _temperatureSlider.value = model.temperature;
        _timeSlider.value = model.residueDuration;
        
    }
    
    
    
    NSString *nameStr = [NSString string];
    for (int i= 0; i < _chooesArray.count; i++) {
        BCDeviceModel *model = _chooesArray[i];
        nameStr =  [nameStr stringByAppendingString:[NSString stringWithFormat:@"%@、",model.deviceName]];
    }
    
    if (_chooesArray.count>2) {
        _nameLabel.font = [UIFont systemFontOfSize:32/[UserShareOnce shareOnce].multipleFontSize/_chooesArray.count*2];
    }else{
        _nameLabel.font = [UIFont systemFontOfSize:32/[UserShareOnce shareOnce].multipleFontSize];
    }
    nameStr = [nameStr substringToIndex:nameStr.length - 1];
    _nameLabel.text = nameStr;
    _temperatureLabel.text = [NSString stringWithFormat:@"%d℃",(int)_temperatureSlider.value];
    _timeLabel.text = [NSString stringWithFormat:@"%dmin",(int)_timeSlider.value];
    [self.collectionV reloadData];
}

- (void)didUpdateDatasWithDevice:(BCDeviceModel *)device statusCode:(BCBluetoothOperatestatusCode)code feedBackType:(BCBluetoothOperateFeedbackType)type
{
   
    switch (type) {
            //获取设备基本信息
        case BCBluetoothOperateFeedbackTypeInfo:
            if (code == BCBluetoothOperatestatusCodeSuccess) {
                for (int i = 0; i < self.dataArray.count; i++) {
                    BCDeviceModel *model = self.dataArray[i];
                    if ([model.macAddress isEqualToString:device.macAddress]) {
                        model.temperature = device.temperature;
                        model.residueDuration = device.residueDuration;
                    }
                    [self.collectionV reloadData];
                }
              NSLog(@"获取设备基本信息成功");
                }
            break;
            
        case BCBluetoothOperateFeedbackTypeSetTempreture:
            if (code == BCBluetoothOperatestatusCodeSuccess) {
                NSLog(@"设置温度成功");
            }
            break;
            //读取温度
        case BCBluetoothOperateFeedbackTypeReadTempreture:
            if (code == BCBluetoothOperatestatusCodeSuccess) {
                NSLog(@"读取温度成功");
            }
            break;
            //设置时间
        case BCBluetoothOperateFeedbackTypeSetTime:
                if (code == BCBluetoothOperatestatusCodeSuccess) {
                    NSLog(@"设置时间成功");
            }
            break;
            //读取设备时间
        case BCBluetoothOperateFeedbackTypeReadTime:
            if (code == BCBluetoothOperatestatusCodeSuccess) {
                NSLog(@"读取设备时间成功");
            }
            break;
     
        default:
            break;
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return Adapter(10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    IjoouSetCollectionViewCell *cell = (IjoouSetCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    BCDeviceModel *model =   _dataArray[indexPath.row];
    cell.titleLabel.text =model.deviceName;
    cell.timeLabel.text =  [NSString stringWithFormat:@"%ldmin",(long)model.residueDuration];
    cell.temperatureLabel.text =[NSString stringWithFormat:@"%ld℃",(long)(model.temperature+1)];
    cell.isChooes = NO;
    for (int i = 0; i<_chooesArray.count; i++) {
        BCDeviceModel *chooseModel =   _chooesArray[i];
        if ([chooseModel.macAddress isEqualToString:model.macAddress]) {
            cell.isChooes = YES;
        }
    }
    
    if (cell.isChooes) {
        cell.imageV.image = [UIImage imageNamed:@"ijoou设置"];
        cell.selectImageView.hidden = NO;
    }else{
        cell.imageV.image = [UIImage imageNamed:@"ijoou未选中背景"];
        cell.selectImageView.hidden = YES;
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IjoouSetCollectionViewCell * cell = (IjoouSetCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if (_chooesArray.count  == 1 &&cell.isChooes == YES) {
        return;
    }
    if (!cell.isChooes) {
        cell.imageV.image = [UIImage imageNamed:@"ijoou设置"];
        cell.selectImageView.hidden = NO;
        cell.isChooes = YES;
        [_chooesArray addObject:_dataArray[indexPath.row]];
    }else{
        cell.imageV.image = [UIImage imageNamed:@"ijoou未选中背景"];
        cell.selectImageView.hidden = YES;
        cell.isChooes = NO;
        [_chooesArray removeObject:_dataArray[indexPath.row]];
    }
    NSString *nameStr = @"";
    for (int i= 0; i < _chooesArray.count; i++) {
        BCDeviceModel *model = _chooesArray[i];
        nameStr =  [nameStr stringByAppendingString:[NSString stringWithFormat:@"%@、",model.deviceName]];
    }
    if (_chooesArray.count>2) {
        _nameLabel.font = [UIFont systemFontOfSize:32/[UserShareOnce shareOnce].multipleFontSize/_chooesArray.count*2];
    }else{
        _nameLabel.font = [UIFont systemFontOfSize:32/[UserShareOnce shareOnce].multipleFontSize];
    }
    nameStr = [nameStr substringToIndex:nameStr.length - 1];
    _nameLabel.text = nameStr;
}


@end
