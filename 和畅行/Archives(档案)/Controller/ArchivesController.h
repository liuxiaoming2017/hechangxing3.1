//
//  ArchivesController.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/2.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "NavBarViewController.h"

@interface ArchivesController : NavBarViewController

@property (nonatomic,copy) NSString *memberId;
@property (nonatomic,assign) NSInteger currentIndex;


- (void)requestNetworkWithIndex:(NSInteger)index;
- (void)selectIndexWithString:(NSString *)str;
@end
