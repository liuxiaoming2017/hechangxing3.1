//
//  RemindRegAlertView.h
//  
//
//  Created by wangdong on 16/3/3.
//
//

#import <UIKit/UIKit.h>

@protocol RemindRegDelegate;

@interface RemindRegAlertView : UIViewController

@property (nonatomic, weak) id <RemindRegDelegate> clickDelegate;
@property (strong, nonatomic) NSString *password;
@property (assign, nonatomic) int type;

- (void)setBlurView:(UIViewController*)blueView;

@end

@protocol RemindRegDelegate <NSObject>
@optional
- (void)RemindRegOnClickBtn:(NSString*)btnMsg;

@end