//
//  ZKIndxView.h
//  hechangyi
//
//  Created by Longma on 16/10/19.
//  Copyright © 2016年 Longma. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZKIndexViewDelegate <NSObject>

/**
 *  点击按钮
 */

- (void)indexClickWitbNumber:(NSInteger)tag;

/**
 *  界面消失
 */
- (void)indexDissmiss;

@end



@interface ZKIndxView : UIView
@property (nonatomic,weak)id <ZKIndexViewDelegate>delegate;

@end
