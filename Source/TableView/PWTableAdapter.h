//
//  PWTableModel.h
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIkit.h>
#import "PWListNode.h"
#import "PWListMacros.h"

NS_ASSUME_NONNULL_BEGIN

@class PWTableSection;
@class PWTableRow;
@class PWTableAdapter;


@protocol PWTableAdapterDataSource <NSObject>

@optional

/// 如果不需要，则返回nil即可。
- (nullable UIView *)emptyViewForTableAdapter:(PWTableAdapter *)adapter;

/// 判断是否需要显示emptyView，默认实现逻辑是判断列表的数据是否为空。
- (BOOL)shouldHideEmptyViewForTableAdapter:(PWTableAdapter *)adapter;

@end


@protocol PWTableAdapterDelegate <NSObject>

@optional

@end




/// Table adapter是table view的适配器，实现了`UITableViewDataSource`和`UITableViewDelegate`的部分方法。
/// 一个table view对应一个adapter，目的是简化使用table view的成本，去掉胶水代码。代理实现的方法如下：
/// UITableViewDataSource
///     `tableView:cellForRowAtIndexPath:
///     `tableView:numberOfRowsInSection:`
///     `numberOfSectionsInTableView:`
/// UITableViewDelegate
///     `tableView:heightForRowAtIndexPath:`
///     `tableView:heightForHeaderInSection:`
///     `tableView:heightForFooterInSection:`
///     `tableView:viewForHeaderInSection:`
///     `tableView:viewForFooterInSection:`
/// 使用方即使实现了这些方法，也不会调用，本类底层已经强制实现，并做了方法转发。
PWLK_SUBCLASSING_RESTRICTED
@interface PWTableAdapter : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, weak, readonly) UITableView *tableView;

@property (nonatomic, weak, nullable) id<PWTableAdapterDataSource> dataSource;
@property (nonatomic, weak, nullable) id<PWTableAdapterDelegate> delegate;
@property (nonatomic, weak, nullable) id<UITableViewDataSource> tableDataSource;
@property (nonatomic, weak, nullable) id<UITableViewDelegate> tableDelegate;

#pragma mark - 数据操作

- (void)addSection:(void (^)(PWTableSection *section))block;
- (void)insertSection:(void (^)(PWTableSection *section))block atIndex:(NSUInteger)index;

- (void)removeSectionAtIndex:(NSUInteger)index;
- (void)removeSection:(PWTableSection *)section;
- (void)clearAllSections;

- (PWTableRow *)rowAtIndexPath:(NSIndexPath *)indexPath;
- (PWTableSection *)sectionAtIndex:(NSUInteger)index;

- (void)moveSectionFrom:(NSUInteger)from to:(NSUInteger)to;


/// 根据自定义的tag来索引对应的section

- (nullable PWTableSection *)sectionWithTag:(NSString *)tag;

#pragma mark - 更新table view
/// 以下方法除了更新tableView，还会判断是否显示emptyView。
- (void)reloadTableView;
- (void)reloadTableViewWithCompletion:(nullable void(^)(void))completion;
- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadTableWithBlock:(nullable void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
