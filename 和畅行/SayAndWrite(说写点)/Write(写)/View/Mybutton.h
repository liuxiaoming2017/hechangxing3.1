//
//  Mybutton.h
//  Voicediagno
//
//  Created by Mymac on 15/11/16.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Mybutton : UIButton

@property (nonatomic,assign) NSInteger row;


- (id)initWithFrame:(CGRect)frame row:(NSInteger)row tag:(NSInteger)tag;
@end
