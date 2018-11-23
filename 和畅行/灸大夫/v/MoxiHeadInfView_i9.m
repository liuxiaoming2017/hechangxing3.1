//
//  MoxiHeadInfView_i9.m
//  MoxaYS
//
//  Created by xuzengjun on 17/6/3.
//  Copyright © 2017年 jiudaifu. All rights reserved.
//

#import "MoxiHeadInfView_i9.h"

@implementation MoxiHeadInfView_i9
@synthesize mSwitch = _mSwitch;
@synthesize mChoosePlanBtn = _mChoosePlanBtn;
@synthesize mMoxaRecode = _mMoxaRecode;
@synthesize delegate = _delegate;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MoxiHeadInfView_i9" owner:self options:nil];
        
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
        _mSwitch = (UIButton *)[[arrayOfViews objectAtIndex:0] viewWithTag:1];
        _mChoosePlanBtn = (UIButton *)[[arrayOfViews objectAtIndex:0] viewWithTag:2];
        _mChoosePlanBtn.hidden = YES;
        _mMoxaRecode = (UIButton *)[[arrayOfViews objectAtIndex:0] viewWithTag:3];
        _mMoxaRecode.hidden = YES;
        self.frame = frame;
    }
    return self;
}

- (IBAction)SwichBtnOnlink:(id)sender {
    if(_delegate != nil){
        [_delegate SwitchBtnOnclink:sender];
    }
}

- (IBAction)choosPlanBtnOnlcik:(id)sender {
    if(_delegate != nil){
        [_delegate choosePlanBtnOnclink:sender];
    }
}

- (IBAction)recodeBtnOnclink:(id)sender {
    if(_delegate != nil){
        [_delegate moxaRecodeOnclink:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
