//
//  MuisicNoraml.h
//  hechangyi
//
//  Created by Longma on 16/11/3.
//  Copyright © 2016年 Longma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MuscicNoramlDeleaget <NSObject>
/**
 *  增加  强度
 */

- (void)volumeWithIncreaseAndReduce:(NSString *)number;
/**
 *  减少 强度
 */
- (void)volumeWithReduce:(NSString *)number;

/**
 *  开始 停止命令
 */

- (void)commandWithONandOFF:(NSInteger)command;

/**
 *  暂停 恢复 命令
 */
- (void)commandWithSuspendedAndRestore:(NSInteger)command;



@end

@interface MuisicNoraml : UIView

@property (nonatomic,weak)id <MuscicNoramlDeleaget>delegate;
/**
 *  蓝牙背景图片
 */
@property (nonatomic,strong) UIImageView *bluetoothBg;

/**
 *  蓝牙开始 暂停命令
*/
@property (nonatomic,strong) UISwitch *bluetoothStateSw;

/**
 *  调结强度大小背景
 */
@property (nonatomic,strong) UIImageView *strengthBg;

/**
 *  增加强度
 */
@property (nonatomic,strong) UIButton *addbutton;

/**
 *  减小强度
 */
@property (nonatomic,strong) UIButton *downButton;

/**
 *  耳机强度指示值
 */
@property (nonatomic,strong) UILabel *accordLabel;


/**
 开关按钮
 */
@property (nonatomic,strong) UIButton *switchBtn;


/**
 控制开关状态的Bool值
 */
@property (nonatomic,assign) BOOL isStatus;
@end
