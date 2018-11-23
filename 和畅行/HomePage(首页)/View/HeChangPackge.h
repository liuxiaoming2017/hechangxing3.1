//
//  HeChangPackge.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/9.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeChangPackge : UIView

@property(nonatomic,strong) UILabel *contentLabel;

- (void)changePackgeTypeWithStatus:(NSInteger)status;

@end
