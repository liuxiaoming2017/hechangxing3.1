//
//  QuestionCell.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/16.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    CGFloat width = self.width;
    
    _title1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, width-30, 40)];
    _title1.numberOfLines = 0;
    _title1.font = [UIFont systemFontOfSize:15];
    _title1.textAlignment = NSTextAlignmentLeft;
    _title1.textColor = [UIColor blackColor];
    [self addSubview:_title1];
    
    NSArray *anwerArr = [NSArray arrayWithObjects:ModuleZW(@"没有（根本不)"),ModuleZW(@"很少（有一点)"),ModuleZW(@"有时（有些)"),ModuleZW(@"经常（相当)"),ModuleZW(@"总是（非常)"), nil];
    NSArray *imageArr = [NSArray arrayWithObjects:@"option01",@"option02",@"option03",@"option04",@"option05", nil];
    NSArray *imageSelectArr = [NSArray arrayWithObjects:@"option01_press",@"option02_press",@"option03_press",@"option04_press",@"option05_press", nil];
    for(NSInteger i=0;i<5;i++){
        UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        optionBtn.frame = CGRectMake(35, self.title1.bottom+2+35*i, 200, 30);
        [optionBtn setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]] forState:UIControlStateNormal];
        [optionBtn setImage:[UIImage imageNamed:[imageSelectArr objectAtIndex:i]] forState:UIControlStateSelected];
        [optionBtn setTitle:[anwerArr objectAtIndex:i] forState:UIControlStateNormal];
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [optionBtn setTitleColor:[Tools colorWithHexString:@"#aaa"] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[Tools colorWithHexString:@"#0282bf"] forState:UIControlStateSelected];
        optionBtn.adjustsImageWhenHighlighted = NO;
        optionBtn.tag = 100+i;
        optionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        optionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        optionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [optionBtn addTarget:self action:@selector(optionButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:optionBtn];
    }
    
    UIButton *btn = (UIButton *)[self viewWithTag:104];
    _title2 = [[UILabel alloc] initWithFrame:CGRectMake(15, btn.bottom+30, width-30, 40)];
    _title2.numberOfLines = 0;
    _title2.font = [UIFont systemFontOfSize:15];
    _title2.textAlignment = NSTextAlignmentLeft;
    _title2.textColor = [UIColor blackColor];
    [self addSubview:_title2];
    
    for(NSInteger i=0;i<5;i++){
        UIButton *optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        optionBtn.frame = CGRectMake(35, self.title2.bottom+2+35*i, 200, 30);
        [optionBtn setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]] forState:UIControlStateNormal];
        [optionBtn setImage:[UIImage imageNamed:[imageSelectArr objectAtIndex:i]] forState:UIControlStateSelected];
        [optionBtn setTitle:[anwerArr objectAtIndex:i] forState:UIControlStateNormal];
        optionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [optionBtn setTitleColor:[Tools colorWithHexString:@"#aaa"] forState:UIControlStateNormal];
        [optionBtn setTitleColor:[Tools colorWithHexString:@"#0282bf"] forState:UIControlStateSelected];
        optionBtn.adjustsImageWhenHighlighted = NO;
        optionBtn.tag = 200+i;
        optionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        optionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        optionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [optionBtn addTarget:self action:@selector(optionButtonSelect2:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:optionBtn];
    }
    
    
}

- (void)hideBottomQuestion
{
    _title2.hidden = YES;
    for (int i=0; i<5; i++) {
        UIButton *otherBtn = (UIButton *)[self viewWithTag:200+i];
        otherBtn.hidden = YES;
    }
    
}

- (void)updateButtonStateWithGrade1:(NSInteger )grade withTag:(NSInteger)tag
{
    _title2.hidden = NO;
    if(tag == 100){
        if(grade == 0){
            for (int i=0; i<5; i++) {
                UIButton *Btn = (UIButton *)[self viewWithTag:100+i];
                Btn.selected = NO;
                Btn.userInteractionEnabled = YES;
            }
        }else{
            for (int i=0; i<5; i++) {
                UIButton *Btn = (UIButton *)[self viewWithTag:100+i];
                if(Btn.tag == 99+grade){
                    Btn.selected = YES;
                    Btn.userInteractionEnabled = NO;
                }else{
                    Btn.selected = NO;
                    Btn.userInteractionEnabled = YES;
                }
            }
        }
        
    }else{
        if(grade == 0){
            for (int i=0; i<5; i++) {
                UIButton *Btn = (UIButton *)[self viewWithTag:200+i];
                Btn.hidden = NO;
                Btn.selected = NO;
                Btn.userInteractionEnabled = YES;
            }
        }else{
            for (int i=0; i<5; i++) {
                UIButton *Btn = (UIButton *)[self viewWithTag:200+i];
                Btn.hidden = NO;
                if(Btn.tag == 199+grade){
                    Btn.selected = YES;
                    Btn.userInteractionEnabled = NO;
                }else{
                    Btn.selected = NO;
                    Btn.userInteractionEnabled = YES;
                }
            }
        }
    }
}

- (void)setTitle1:(UILabel *)title1
{
    if(_title1 != title1){
        _title1 = title1;
    }
    CGSize strSize = [title1.text boundingRectWithSize:CGSizeMake(title1.width, 1200) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:[[UIFont systemFontOfSize:1] fontName] size:16]} context:nil].size;
    title1.height = strSize.height;
}

- (void)optionButtonSelect:(UIButton *)button
{
    [button setSelected:YES];
    button.userInteractionEnabled = NO;
    for (int i=0; i<5; i++) {
        UIButton *otherBtn = (UIButton *)[self viewWithTag:100+i];
        if (button.tag == otherBtn.tag) {
            [otherBtn setSelected:YES];
            otherBtn.userInteractionEnabled = NO;
        }else{
            
            [otherBtn setSelected:NO];
            otherBtn.userInteractionEnabled = YES;
            
        }
    }
    
    if([self.delegate respondsToSelector:@selector(selectAnswerWithNumber:)]){
        [self.delegate selectAnswerWithNumber:button.tag+1];
    }
}

- (void)optionButtonSelect2:(UIButton *)button
{
    [button setSelected:YES];
    button.userInteractionEnabled = NO;
    for (int i=0; i<5; i++) {
        UIButton *otherBtn = (UIButton *)[self viewWithTag:200+i];
        if (button.tag == otherBtn.tag) {
            [otherBtn setSelected:YES];
            otherBtn.userInteractionEnabled = NO;
        }else{
            
            [otherBtn setSelected:NO];
            otherBtn.userInteractionEnabled = YES;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(selectAnswerWithNumber:)]){
        [self.delegate selectAnswerWithNumber:button.tag+1];
    }
    
}
@end
