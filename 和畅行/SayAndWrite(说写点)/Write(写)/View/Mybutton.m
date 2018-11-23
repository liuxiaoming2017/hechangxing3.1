//
//  Mybutton.m
//  Voicediagno
//
//  Created by Mymac on 15/11/16.
//  Copyright (c) 2015年 Mymac. All rights reserved.
//

#import "Mybutton.h"

@implementation Mybutton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame row:(NSInteger)row tag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = tag;
        self.row = row;
    }
    return self;
}



@end
