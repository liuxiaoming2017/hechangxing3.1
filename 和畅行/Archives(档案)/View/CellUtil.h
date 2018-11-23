//
//  CellUtil.h
//  和畅行
//
//  Created by 刘晓明 on 2018/7/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ArchiveModel;
@class ArchivesCell;
@interface CellUtil : NSObject


+(CGFloat)getArchiveCellHeight:(ArchiveModel *)archive;
+(ArchivesCell *)getArchiveCell:(ArchiveModel *)archive in:(UITableView *)tableView;
@end
