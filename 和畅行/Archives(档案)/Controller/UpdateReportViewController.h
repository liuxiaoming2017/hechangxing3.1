//
//  UpdateReportViewController.h
//  和畅行
//
//  Created by Wei Zhao on 2019/9/30.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "NavBarViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^ReturnTextBlock)(void);
@interface UpdateReportViewController : NavBarViewController
@property (nonatomic, copy) ReturnTextBlock returnTextBlock;
@end

NS_ASSUME_NONNULL_END
