//
//  PWTableModel.h
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import "PWListNode.h"
#import <UIKit/UIkit.h>
#import "PWListProtocol.h"


@class PWTableSection;
@class PWTableItem;


NS_ASSUME_NONNULL_BEGIN

@interface PWTableAdapter : PWListNode

- (instancetype)initWithTableView:(UITableView *)tableView NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, weak, readonly) UITableView *tableView;


@property (nonatomic, weak) id<PWTableAdapterDataSource> dataSource;
@property (nonatomic, weak) id<UITableViewDataSource> tableDataSource;
@property (nonatomic, weak) id<UITableViewDelegate> tableDelegate;



- (void)addSection:(void (^)(PWTableSection *section))block;
- (void)insertSection:(void (^)(PWTableSection *section))block atIndex:(NSUInteger)index;

- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSectionsAtIndexSet:(NSIndexSet *)indexSet;
- (void)removeSection:(PWTableSection *)section;

- (void)clearAllSections;

- (PWTableItem *)itemAtIndexPath:(NSIndexPath *)indexPath;
- (PWTableSection *)sectionAtIndex:(NSUInteger)index;
- (PWTableSection *)sectionWithTag:(NSString *)tag;


- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)heightForHeaderInSection:(NSInteger)section;
- (CGFloat)heightForFooterInSection:(NSInteger)section;

- (void)reloadTableView;
- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

@end

NS_ASSUME_NONNULL_END
