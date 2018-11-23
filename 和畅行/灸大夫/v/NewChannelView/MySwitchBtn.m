//
//  MySwitchBtn.m
//  MoxaYS
//
//  Created by xuzengjun on 16/12/30.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import "MySwitchBtn.h"

@interface MySwitchBtn()
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@end

@implementation MySwitchBtn

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MySwitch" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UIView class]])
        {
            return nil;
        }
        self = [arrayOfViews objectAtIndex:0];
        _switchBtn = (UISwitch *)[[arrayOfViews objectAtIndex:0] viewWithTag:14];
        _switchBtn.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [_switchBtn setUserInteractionEnabled:NO];
        self.frame = frame;
    }
    return self;
}

-(void)setSwitch:(BOOL)flag{
    [_switchBtn setOn:flag];
}

-(BOOL)getSwitchOn{
    return _switchBtn.on;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
