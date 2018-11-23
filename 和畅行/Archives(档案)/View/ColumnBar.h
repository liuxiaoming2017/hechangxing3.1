//
//  ColumnBar.h
//  ColumnBarDemo
//
//  Created by chenfei on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColumnBarDataSource;
@protocol ColumnBarDelegate;

@interface ColumnBar : UIImageView <UIScrollViewDelegate> {
    UIScrollView    *scrollView;
    UIImageView     *leftCap;
    UIImageView     *rightCap;
    UIImageView     *moreCap;
    int             selectedIndex;
    int             lastSelectIndex;
    
    id<ColumnBarDataSource> dataSource;
    id<ColumnBarDelegate>   delegate;
}

@property(nonatomic, retain) UIScrollView               *scrollView;

@property(nonatomic, assign) int                        selectedIndex;

@property(nonatomic, retain) id<ColumnBarDataSource>    dataSource;
@property(nonatomic, retain) id<ColumnBarDelegate>      delegate;

@property(nonatomic, assign) BOOL enabled;
@property(nonatomic, retain) NSString *columnName;
@property(nonatomic, retain) UIImageView *bottomTag;

- (id)initWithFrame:(CGRect)frame withIsFirstNewsVC:(BOOL)isFirstNewsVC;
- (void)reloadData:(NSString *)parentColumn;
- (void)selectTabAtIndex:(int)index;
-(void)setColumnBarY:(CGFloat)y;
@end

@protocol ColumnBarDataSource <NSObject>

- (NSString *)columnBar:(ColumnBar *)columnBar titleForTabAtIndex:(int)index;

@optional
- (int)numberOfTabsInColumnBar:(ColumnBar *)columnBar;
- (int)parentIdOfTabsInColumnBar;
- (int)IdOfTabsInColumnBar:(int)index;
- (NSString*)ColumnOfTabsInColumnBar:(int)index;
- (void)UpdateTabsInColumnBar:(NSMutableArray*)msArray;


@end

@protocol ColumnBarDelegate <NSObject>

- (void)columnBar:(ColumnBar *)columnBar didSelectedTabAtIndex:(int)index;

@optional
- (void)moreClick;

@end
