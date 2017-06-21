//
//  PWTableModel.h
//  Demo
//
//  Created by Huang Wei on 2017/2/27.
//  Copyright © 2017年 Parallel World. All rights reserved.
//

#import <UIKit/UIkit.h>
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
/// 一个table view对应一个adapter，目的是简化使用table view的成本，去掉胶水代码。类中实现的方法如下：
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
/// 调用方即使实现了这些方法，也不会调用，本类底层已经强制实现，并做了方法转发。
PWLK_SUBCLASSING_RESTRICTED
@interface PWTableAdapter : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// Adapter对应的table view
@property (nonatomic, weak, readonly) UITableView *tableView;

@property (nonatomic, weak, nullable) id<PWTableAdapterDataSource> dataSource;
@property (nonatomic, weak, nullable) id<PWTableAdapterDelegate> delegate;
@property (nonatomic, weak, nullable) id<UITableViewDataSource> tableDataSource;
@property (nonatomic, weak, nullable) id<UITableViewDelegate> tableDelegate;

////////////////////////////////////////////////////////////////////////////////
#pragma mark - 数据操作

// 增
- (void)addSection:(void (^)(PWTableSection *s))block;
- (void)insertSection:(void (^)(PWTableSection *s))block atIndex:(NSUInteger)idx;

// 删
- (void)removeSectionAtIndex:(NSUInteger)idx;
- (void)removeSection:(PWTableSection *)s;
- (void)clearAllSections;

// 改
- (void)moveSectionFrom:(NSUInteger)from to:(NSUInteger)to;
- (void)updateSectionAtIndex:(NSUInteger)idx withBlock:(void (^)(PWTableSection *__nullable s))block;

// 查
- (nullable PWTableRow *)rowAtIndexPath:(NSIndexPath *)indexPath;
- (nullable PWTableSection *)sectionAtIndex:(NSUInteger)idx;
/// 找到特定tag的section数组，并返回第一个。
- (nullable PWTableSection *)sectionWithTag:(NSString *)tag;
/// 找到特定tag的section数组
- (nullable NSArray<PWTableSection *> *)sectionsWithTag:(NSString *)tag;

////////////////////////////////////////////////////////////////////////////////

#pragma mark - 更新table view
/// 以下方法除了更新tableView，还会判断是否显示emptyView。
- (void)reloadTableView;
- (void)reloadTableViewWithCompletion:(nullable void(^)(void))completion;
- (void)reloadRowAtIndexPath:(NSIndexPath *)indexPath withRowAnimation:(UITableViewRowAnimation)animation;
- (void)reloadSectionAtIndex:(NSUInteger)index withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadTableWithBlock:(nullable void(^)(void))block;


/// 使用diff的方式更新table view，而不是简单粗暴的调用的`reloadTableView`方法。
/// @param actions 相关的数据操作
/// @param animation row动画枚举
/// @param completion table view动画完成后的completion回调
- (void)updateTableViewWithActions:(nullable void (^)(PWTableAdapter *adapter))actions
                         animation:(UITableViewRowAnimation)animation
                        completion:(nullable void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
