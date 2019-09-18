//
//  HCYSlider.h
//  和畅行
//
//  Created by 刘晓明 on 2019/9/12.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HCYSlider;

@protocol HCYSliderDelegate <NSObject>

- (void)HCYSliderButtonAction:(NSString *)str;

@end


@interface HCYSlider : UIView

/**
 *  当前数值
 */
@property (nonatomic) CGFloat currentSliderValue;

/**
 *  当前数值颜色
 */
@property (nonatomic) UIColor *currentValueColor;

/**
 *  滑块最大取值
 */
@property (nonatomic) CGFloat maxValue;

@property (nonatomic,weak) id <HCYSliderDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
