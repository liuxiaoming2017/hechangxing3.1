//
//  ConsumptionController.m
//  和畅行
//
//  Created by Wei Zhao on 2019/10/31.
//  Copyright © 2019 刘晓明. All rights reserved.
//

#import "ConsumptionController.h"
#import "HCY_ConsumptionListCell.h"
#import "AllServiceCell.h"
@interface ConsumptionController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *listTableView;
@end

@implementation ConsumptionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitleLabel.text = ModuleZW(@"消费记录");
    [self layoutConSumption];
}

-(void)layoutConSumption {

        
    self.listTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navTitleLabel.bottom , ScreenWidth ,ScreenHeight - kNavBarHeight) style:UITableViewStylePlain];
    self.listTableView.backgroundColor = UIColorFromHex(0Xffffff);
    self.listTableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.listTableView.layer.cornerRadius = 8;
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.estimatedRowHeight = Adapter(90);
    [self.view addSubview:self.listTableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AllServiceCell * cell =[tableView dequeueReusableCellWithIdentifier:@"AllServiceCell"];
    if(cell==nil){
        cell = [[AllServiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AllServiceCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.dataArr.count>indexPath.row){
            NSDictionary *dic = [self.dataArr objectAtIndex:indexPath.row];
            cell.typeLabel.text = [dic objectForKey:@"name"];
            NSString *timeStr =[NSString stringWithFormat:@"%@", [dic objectForKey:@"createDate"]];
            if (![GlobalCommon stringEqualNull:timeStr]) {
                cell.numberLabel.text = [timeStr substringToIndex:10];
            }
        }
        return cell;
    
};
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
