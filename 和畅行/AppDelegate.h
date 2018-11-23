//
//  AppDelegate.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIBackgroundTaskIdentifier _bgTaskId;

}
@property (strong, nonatomic) UIWindow *window;

- (void)loadFasterStart;
-(void)returnMainPage;
- (UITabBarController *)tabBar;
@end

