//
//  CellUtil.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "CellUtil.h"
#import "ArchiveModel.h"
#import "ArchivesCell.h"

@implementation CellUtil

+(ArchivesCell *)getArchiveCell:(ArchiveModel *)archive in:(UITableView *)tableView
{
    ArchivesCell *cell = nil;
    if(archive.cellType == cellType_new || archive.cellType == cellType_jingLuo || archive.cellType == cellType_tiZhi||archive.cellType == cellType_zangFu || archive.cellType == cellType_xinlv){
        cell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];
        if(!cell){
            cell = [[ArchivesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newCell"];
        }
        cell.archiveModel = archive;
        if(archive.cellType == cellType_new){
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        if(archive.cellType == cellType_zangFu){
            [cell configZangFuCellWithArchive:archive];
        }else if(archive.cellType == cellType_xinlv){
            [cell configXinLvCellWithArchive:archive];
        }else{
            [cell configMiddleCellWithArchive:archive];
        }
       
    }
    return cell;
}

+(CGFloat)getArchiveCellHeight:(ArchiveModel *)archive
{
    if(archive.cellType == cellType_new || archive.cellType == cellType_jingLuo){
        return 50.0;
    }else if (archive.cellType == cellType_zangFu){
        return 60;
    }else if(archive.cellType == cellType_xinlv){
        return 80;
    }else{
        return 0;
    }
    return 0;
}

@end
