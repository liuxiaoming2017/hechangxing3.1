//
//  InformationCell.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "InformationCell.h"
#import "ArticleModel.h"
#import "UIImageView+WebCache.h"

#define kSWidth  [UIScreen mainScreen].bounds.size.width

@implementation InformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.frame = CGRectMake(0, 0, ScreenWidth, Adapter(100));
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(Adapter(10), Adapter(5), Adapter(100), Adapter(75))];
    self.imageV.layer.cornerRadius = 3;
    self.imageV.image = [UIImage imageNamed:@"sports01"];
    [self addSubview:self.imageV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageV.right + Adapter(10), self.imageV.top, ScreenWidth - self.imageV.right - Adapter(20), Adapter(60))];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel sizeToFit];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    
//    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 10, self.titleLabel.width, 20)];
//    self.descriptionLabel.font = [UIFont systemFontOfSize:15];
//    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
//    self.descriptionLabel.textColor = UIColorFromHex(0x7D7D7D);
//    [self addSubview:self.descriptionLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - Adapter(130), self.imageV.bottom - Adapter(14), Adapter(120), Adapter(14))];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = UIColorFromHex(0x7D7D7D);
    [self addSubview:self.timeLabel];
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, Adapter(84), ScreenWidth, 1)];
    lineImageV.alpha = 0.5;
    lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
    [self addSubview:lineImageV];
    
}

- (void)layoutSubviews
{
    [self.titleLabel sizeToFit];
}

- (void)drawRect:(CGRect)rect
{
    [self.titleLabel sizeToFit];
}

- (void)setDataWithModel:(ArticleModel *)model
{
    
    
    NSDictionary *dic = (NSDictionary *)model;
    NSString *title = [dic objectForKey:@"title"];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"默认4:3"]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    paragraphStyle.lineSpacing = 5;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy
                                 };
    if (!title) {
        title = @"";
    }else{
        title = [title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    NSAttributedString *atrStr = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    CGSize labelSize = [title boundingRectWithSize:CGSizeMake(self.titleLabel.width, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    self.titleLabel.attributedText = atrStr;
    self.titleLabel.frame = CGRectMake(self.imageV.right + 10, self.imageV.top, ScreenWidth - self.imageV.right - 20, labelSize.height > 41 ? 41 : labelSize.height);
    
    //self.titleLabel.text = model.title;
    //self.descriptionLabel.text = model.seoDescription;
    
    long createDate = [[dic objectForKey:@"createDate"] longValue];
    
    NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:createDate/1000.00];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    NSString *confromTimespStr = [formatter stringFromDate:data];
    //confromTimespStr = [[confromTimespStr componentsSeparatedByString:@" "] objectAtIndex:0];
    self.timeLabel.text = confromTimespStr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
