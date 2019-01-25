//
//  ChangeLanguageObject.m
//  和畅行
//
//  Created by 刘晓明 on 2019/1/24.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ChangeLanguageObject.h"

@implementation ChangeLanguageObject

static NSBundle *bundle = nil;
+ (NSBundle *)bundle {
    return bundle;
}

//首次加载时检测语言是否存在
+ (void)initUserLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [def valueForKey:@"appLanguage"];
    if (!currLanguage) {
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        currLanguage = preferredLanguages[0];
        if ([currLanguage hasPrefix:@"en"]) {
            currLanguage = @"en";
        }else if ([currLanguage hasPrefix:@"zh-Hans"]) {
            currLanguage = @"zh-Hans";
        }else if ([currLanguage hasPrefix:@"zh-HK"] || [currLanguage hasPrefix:@"zh-Hant"]) {
            currLanguage = @"zh-Hant";
        }else {
            currLanguage = @"zh-Hant";
        }
        [def setValue:currLanguage forKey:@"appLanguage"];
        [def synchronize];
    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:currLanguage ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

//获取当前语言
+ (NSString *)userLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"appLanguage"];
    return language;
}

//设置语言
+ (void)setUserLanguage:(NSString *)language {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *currLanguage = [userDefaults valueForKey:@"appLanguage"];
    if ([currLanguage isEqualToString:language]) {
        return;
    }
    [userDefaults setValue:language forKey:@"appLanguage"];
    [userDefaults synchronize];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}


@end
