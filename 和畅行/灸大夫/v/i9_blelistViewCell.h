//
//  i9_blelistViewCell.h
//  MoxaYS
//
//  Created by xuzengjun on 16/9/19.
//  Copyright © 2016年 jiudaifu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectBtn.h"

@protocol i9_blelistCellDelegate <NSObject>

-(void)ConnectOnclink:(id)sender;

@end

@interface i9_blelistViewCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIButton *mChanelView;
@property (weak, nonatomic) IBOutlet UILabel *mMechineName;
//@property (weak, nonatomic) IBOutlet UILabel *mContectState;
//@property (weak, nonatomic) IBOutlet UIButton *mContectBtn;
@property (weak, nonatomic) IBOutlet ConnectBtn *mContectBtn;
@property (weak,nonatomic) id <i9_blelistCellDelegate> delegate;
@end
