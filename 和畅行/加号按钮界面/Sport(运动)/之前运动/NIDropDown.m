//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;

@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;
@synthesize YD_Type_Neirong=_YD_Type_Neirong;
- (id)showDropDown:(UIButton *)b:(CGFloat *)height:(NSArray *)arr :(SportViewController *)tabview{
    
    return nil;
    
    /*
    btnSender = b;
    self = [super init];
    if (self) {
        // Initialization code
        _YD_Type_Neirong=[[NSMutableArray alloc] init];
        [_YD_Type_Neirong addObject:@"   "];
        [_YD_Type_Neirong addObject:@"   "];
        [_YD_Type_Neirong addObject:@"起式"];
        [_YD_Type_Neirong addObject:@"剑指后仰式"];
        [_YD_Type_Neirong addObject:@"俯身下探式"];
        [_YD_Type_Neirong addObject:@"左右扭转式"];
        [_YD_Type_Neirong addObject:@"体侧弯腰式"];
        [_YD_Type_Neirong addObject:@"俯身下探加强式"];
        [_YD_Type_Neirong addObject:@"婴儿环抱式"];
        [_YD_Type_Neirong addObject:@"收式"];
       // CGRect btn = b.frame;
        
        self.frame = CGRectMake(0, 70, 198.0f, 0);
        self.list = [NSArray arrayWithArray:arr];
        
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 198.0f, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = [UIColor whiteColor];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.separatorColor = [UIColor grayColor];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.frame = CGRectMake(0, 70, 236.0f, *height);
        table.frame = CGRectMake(0, 0, 236.0f, *height-19);
        [UIView commitAnimations];
        
        [tabview addSubview:self];
        [self addSubview:table];
    }
    return self;
     */
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectMake(0, 70, 236.0f, 0);
    table.frame = CGRectMake(0, 0, 236.0f, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell11111";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = 1;
    }
    
    UILabel* NameType=[[UILabel alloc] init];
    NameType.frame=CGRectMake(31, (cell.frame.size.height-21)/2, 70, 21);
    NameType.text=[list objectAtIndex:indexPath.row];
    NameType.font=[UIFont systemFontOfSize:13.0f];
    NameType.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    [cell addSubview:NameType];
    
    
    UILabel* NameType_neirong=[[UILabel alloc] init];
    NameType_neirong.frame=CGRectMake(NameType.frame.origin.x+NameType.frame.size.width+32, (cell.frame.size.height-21)/2, 90, 21);
    NameType_neirong.text=[_YD_Type_Neirong objectAtIndex:indexPath.row];
    NameType_neirong.font=[UIFont systemFontOfSize:13.0f];
    NameType_neirong.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    [cell addSubview:NameType_neirong];
    
    UIImageView* LineBG=[[UIImageView alloc] init];
    LineBG.frame=CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 1);
    LineBG.backgroundColor=[UtilityFunc colorWithHexString:@"#d8d8d8"];
    [cell addSubview:LineBG];
    
    // [cell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"left_gongfa_list_bg.png"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    
    //UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    //    if (btnSender.tag==10002) {
    //         [btnSender setTitle:[list objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    //    }
    
    //[btnSender setTitle:c.textLabel.text forState:UIControlStateNormal];
    [self myDelegate:indexPath.row];
    NSDictionary * dic = @{@"Color":[UIColor redColor]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangeColor" object:self userInfo:dic];
}

- (void) myDelegate:(NSInteger)index {
    
    [self.delegate niDropDownDelegateMethod:self:index];
}

-(void)dealloc {
    
}

@end
