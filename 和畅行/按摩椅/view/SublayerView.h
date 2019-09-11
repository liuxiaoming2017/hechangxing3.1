//
//  SublayerView.h
//  和畅行
//
//  Created by 刘晓明 on 2019/9/9.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SublayerView : UIView

-(void)insertSublayerFromeView:(UIView *)view;

- (void)setImageV:(NSString *)imageV withTitleLabel:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
