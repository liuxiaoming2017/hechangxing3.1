//
//  JWProgressView.h
//  CycleProgressBar
//
//  Created by 刘晓明 on 2019/11/26.
//  Copyright © 2019 zhouyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JWProgressView;

@protocol JWProgressViewDelegate <NSObject>

-(void)progressViewOver:(JWProgressView *)progressView;

@end

@interface JWProgressView : UIView

//进度值0-1.0之间
@property (nonatomic,assign)CGFloat progressValue;


//内部label文字
@property(nonatomic,strong)NSString *contentText;

//value等于1的时候的代理
@property(nonatomic,weak)id<JWProgressViewDelegate>delegate;

@end
