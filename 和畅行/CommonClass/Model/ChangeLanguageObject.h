//
//  ChangeLanguageObject.h
//  和畅行
//
//  Created by 刘晓明 on 2019/1/24.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeLanguageObject : NSObject

+ (NSBundle *)bundle;//获取当前资源文件

+ (void)initUserLanguage;//初始化语言文件

+ (NSString *)userLanguage;//获取应用当前语言

+ (void)setUserLanguage:(NSString *)language;//设置当前语言

@end

NS_ASSUME_NONNULL_END
